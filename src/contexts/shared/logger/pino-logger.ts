import { context, isSpanContextValid, trace } from "@opentelemetry/api";
import pino from "pino";

import { config } from "@/app/config/config";

import { Logger } from "./logger";

export type LoggerLevel =
  | "TRACE"
  | "DEBUG"
  | "INFO"
  | "WARN"
  | "ERROR"
  | "FATAL";

export const DEFAULT_LOGGER_LEVEL: LoggerLevel = "INFO";

export class PinoLogger implements Logger {
  private readonly logger;
  private readonly serviceName;

  constructor({
    level = DEFAULT_LOGGER_LEVEL,
    serviceName = config.serviceName,
  } = {}) {
    this.serviceName = serviceName;
    this.logger = pino({
      level: this.getGetPinoLevelFrom(level),
      messageKey: "body",
      formatters: {
        level: this.formatLevel.bind(this),
      },
      base: undefined,
    });
  }

  info(body: string, attributes: unknown = {}) {
    const msg = {
      body,
      attributes,
      ...this.getObservabilityContext(),
      ...this.getResources(),
    };

    this.logger.info(msg);
  }

  private getResources() {
    return {
      resource: {
        attributes: {
          "service.name": this.serviceName,
        },
      },
    };
  }

  private getObservabilityContext() {
    const now = Date.now();
    const observabilityContext: Record<string, string> = {
      readableTimestamp: new Date(now).toISOString(),
      timestamp: now.toString(),
    };

    const span = trace.getSpan(context.active());

    if (span) {
      const spanContext = span.spanContext();

      if (isSpanContextValid(spanContext)) {
        observabilityContext.traceId = spanContext.traceId;
        observabilityContext.spanId = spanContext.spanId;
        observabilityContext.traceFlags = `0${spanContext.traceFlags.toString(16)}`;
      }
    }

    return observabilityContext;
  }

  private getGetPinoLevelFrom(loggerLevel: LoggerLevel): pino.Level {
    const loggerLevelToPinoLevelMap: Record<LoggerLevel, pino.Level> = {
      TRACE: "trace",
      DEBUG: "debug",
      INFO: "info",
      WARN: "warn",
      ERROR: "error",
      FATAL: "fatal",
    };

    return loggerLevelToPinoLevelMap[loggerLevel];
  }

  private getSeverityLevel(label: string) {
    const pinoLevelToSeverityLookup: Record<pino.Level, string> = {
      trace: "debug",
      debug: "debug",
      info: "info",
      warn: "warning",
      error: "error",
      fatal: "critical",
    };

    return (
      pinoLevelToSeverityLookup[label as pino.Level] ||
      pinoLevelToSeverityLookup.info
    );
  }

  private getSeverityNumber(label: string): number {
    const pinoLevelToSeverityNumber: Record<pino.Level, number> = {
      trace: 1,
      debug: 5,
      info: 9,
      warn: 13,
      error: 17,
      fatal: 21,
    };
    return (
      pinoLevelToSeverityNumber[label as pino.Level] ||
      pinoLevelToSeverityNumber.info
    );
  }

  private formatLevel(label: string, level: number) {
    return {
      severityText: this.getSeverityLevel(label),
      severityNumber: this.getSeverityNumber(label),
      level,
    };
  }
}
