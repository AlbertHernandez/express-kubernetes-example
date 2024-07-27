export const config = {
  serviceName: process.env.SERVICE_NAME ?? "express-kubernetes-example",
  server: {
    port: process.env.PORT || 3000,
  },
};
