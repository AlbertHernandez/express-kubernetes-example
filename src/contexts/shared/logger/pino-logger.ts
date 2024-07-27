import { context, isSpanContextValid, trace } from "@opentelemetry/api";
import pino from "pino";

import { Logger } from "./logger";

export class PinoLogger implements Logger {
  private readonly logger;

  constructor() {
    this.logger = pino({
      mixin: () => {
        const properties: Record<string, string> = {};

        const span = trace.getSpan(context.active());

        if (span) {
          const spanContext = span.spanContext();

          if (isSpanContextValid(spanContext)) {
            properties.trace_id = spanContext.traceId;
            properties.span_id = spanContext.spanId;
          }
        }

        return properties;
      },
    });
  }

  info(message: string, attributes: unknown = {}) {
    const msg = {
      message,
      attributes,
    };

    this.logger.info(msg);
  }
}
