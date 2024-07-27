import { AnyValueMap, logs, SeverityNumber } from "@opentelemetry/api-logs";

import { config } from "@/app/config/config";

import { Logger } from "./logger";

export class OpenTelemetryLogger implements Logger {
  private readonly logger;

  constructor() {
    this.logger = logs.getLogger(config.serviceName);
  }

  info(body: string, attributes: AnyValueMap = {}) {
    this.logger.emit({
      severityNumber: SeverityNumber.INFO,
      severityText: "INFO",
      body: body,
      attributes,
    });
  }
}
