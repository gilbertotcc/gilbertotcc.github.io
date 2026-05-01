import type { APIRoute } from 'astro';
import { SITE } from '../config';

export const GET: APIRoute = () => {
  const now = new Date().toUTCString();
  const body = [
    `# ${SITE.title}`,
    ``,
    `> ${SITE.description}`,
    ``,
    `_Generated: ${now}_`,
    ``,
    `## Content`,
    ``,
    `- [Home](${SITE.url}/): Engineering leader and CTO portfolio.`,
    `- [Thought Leadership](${SITE.url}/thought-leadership): Public speaking, Manning manuscript reviews, and academic research.`,
    `- [Privacy Policy](${SITE.url}/privacy): Data processing and GDPR compliance details.`,
    ``,
    `## Social`,
    ``,
    `- [LinkedIn](${SITE.social.linkedin})`,
    `- [GitHub](${SITE.social.github})`,
    ``
  ].join('\n');

  return new Response(body, {
    headers: { 'Content-Type': 'text/plain; charset=utf-8' },
  });
};
