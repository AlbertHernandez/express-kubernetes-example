import { Attributes, SpanKind } from "@opentelemetry/api";
import { OTLPTraceExporter } from "@opentelemetry/exporter-trace-otlp-proto";
import { registerInstrumentations } from "@opentelemetry/instrumentation";
import { ExpressInstrumentation } from "@opentelemetry/instrumentation-express";
import { HttpInstrumentation } from "@opentelemetry/instrumentation-http";
import { Resource } from "@opentelemetry/resources";
import {
  AlwaysOnSampler,
  Sampler,
  SamplingDecision,
  SimpleSpanProcessor,
} from "@opentelemetry/sdk-trace-base";
import { NodeTracerProvider } from "@opentelemetry/sdk-trace-node";
import {
  SEMATTRS_HTTP_ROUTE,
  SEMRESATTRS_SERVICE_NAME,
} from "@opentelemetry/semantic-conventions";

const SERVICE_NAME = "express-kubernetes-example";

const provider = new NodeTracerProvider({
  resource: new Resource({
    [SEMRESATTRS_SERVICE_NAME]: SERVICE_NAME,
  }),
  sampler: filterSampler(ignoreHealthCheck, new AlwaysOnSampler()),
});
registerInstrumentations({
  tracerProvider: provider,
  instrumentations: [new HttpInstrumentation(), new ExpressInstrumentation()],
});

const exporter = new OTLPTraceExporter();

provider.addSpanProcessor(new SimpleSpanProcessor(exporter));

provider.register();

type FilterFunction = (
  spanName: string,
  spanKind: SpanKind,
  attributes: Attributes,
) => boolean;

function filterSampler(filterFn: FilterFunction, parent: Sampler): Sampler {
  return {
    shouldSample(ctx, tid, spanName, spanKind, attr, links) {
      if (!filterFn(spanName, spanKind, attr)) {
        return { decision: SamplingDecision.NOT_RECORD };
      }
      return parent.shouldSample(ctx, tid, spanName, spanKind, attr, links);
    },
    toString() {
      return `FilterSampler(${parent.toString()})`;
    },
  };
}

function ignoreHealthCheck(
  spanName: string,
  spanKind: SpanKind,
  attributes: Attributes,
) {
  return (
    spanKind !== SpanKind.SERVER ||
    attributes[SEMATTRS_HTTP_ROUTE] !== "/api/health"
  );
}
