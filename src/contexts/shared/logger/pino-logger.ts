import { context, isSpanContextValid, trace } from "@opentelemetry/api";
import pino from "pino";

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

  constructor({ level = DEFAULT_LOGGER_LEVEL } = {}) {
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
      ...this.getObservabilityInformation(),
    };

    this.logger.info(msg);
  }

  private getObservabilityInformation() {
    const timestamp = new Date(Date.now()).toISOString();
    const observabilityContext: Record<string, string> = {
      timestamp,
    };

    const span = trace.getSpan(context.active());

    if (span) {
      const spanContext = span.spanContext();

      if (isSpanContextValid(spanContext)) {
        observabilityContext.trace_id = spanContext.traceId;
        observabilityContext.span_id = spanContext.spanId;
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
      trace: "DEBUG",
      debug: "DEBUG",
      info: "INFO",
      warn: "WARNING",
      error: "ERROR",
      fatal: "CRITICAL",
    };

    return (
      pinoLevelToSeverityLookup[label as pino.Level] ||
      pinoLevelToSeverityLookup.info
    );
  }

  private formatLevel(label: string, level: number) {
    return {
      severity: this.getSeverityLevel(label),
      level,
    };
  }
}
