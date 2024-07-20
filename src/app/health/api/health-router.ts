import express from "express";

import { ConsoleLogger } from "@/shared/logger/console-logger.ts";

import { HealthController } from "./health-controller";

const healthRouter = express.Router();

const logger = new ConsoleLogger();
const healthController = new HealthController({
  logger,
});

healthRouter.get("/", healthController.run.bind(healthController));

export { healthRouter };
