import express from "express";

import { OpenTelemetryLogger } from "@/shared/logger/open-telemetry-logger";

import { UserController } from "./user-controller";

const userRouter = express.Router();

const logger = new OpenTelemetryLogger();
const userController = new UserController({ logger });

userRouter.get("/", userController.run.bind(userController));

export { userRouter };
