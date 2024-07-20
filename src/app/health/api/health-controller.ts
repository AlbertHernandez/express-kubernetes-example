import { Request, Response } from "express";
import { StatusCodes } from "http-status-codes";

import { Logger } from "@/shared/logger/logger.ts";

export class HealthController {
  private readonly logger;

  constructor(dependencies: { logger: Logger }) {
    this.logger = dependencies.logger;
  }

  run(req: Request, res: Response) {
    this.logger.info("Received request to check health");
    res.status(StatusCodes.OK).send();
  }
}
