// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import { withSentry } from '@sentry/nextjs';

// eslint-disable-next-line no-unused-vars
const handler = async (req, res) => {
  throw new Error('API throw error test');
  // res.status(200).json({ name: 'John Doe' });
};

const { env } = process;
const {
  NODE_ENV,
  SENTRY_DISABLE,
} = env;

export default NODE_ENV === 'production' && SENTRY_DISABLE !== 'true'
  ? withSentry(handler)
  : handler;
