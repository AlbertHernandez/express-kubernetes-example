import pino from "pino";

import { Logger } from "./logger";

export class PinoLogger implements Logger {
  private readonly logger;

  constructor() {
    this.logger = pino();
  }

  info(message: string, attributes: unknown = {}) {
    const msg = {
      message,
      attributes,
    };

    this.logger.info(msg);
  }
}
