import express from "express";

import { PinoLogger } from "@/shared/logger/pino-logger";

import { UserController } from "./user-controller";

const userRouter = express.Router();

const logger = new PinoLogger();
const userController = new UserController({ logger });

userRouter.get("/", userController.run.bind(userController));

export { userRouter };
