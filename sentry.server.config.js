import * as Sentry from '@sentry/nextjs';

const { env } = process;
const {
  SENTRY_DSN,
  NODE_ENV,
  SENTRY_DISABLE,
} = env;

if (NODE_ENV === 'production' && SENTRY_DISABLE !== 'true') {
  Sentry.init({
    dsn: SENTRY_DSN,
    // We recommend adjusting this value in production, or using tracesSampler
    // for finer control
    tracesSampleRate: 1.0,
  // ...
  // Note: if you want to override the automatic release value, do not set a
  // `release` value here - use the environment variable `SENTRY_RELEASE`, so
  // that it will also get attached to your source maps
  });
}
