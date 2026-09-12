import type { APIRoute } from 'astro';
import { SITE } from '../config';

const SOCIAL_LABELS: Record<string, string> = {
  linkedin: 'LinkedIn',
  github: 'GitHub',
};

export const GET: APIRoute = () => {
  const contentLines = SITE.pages.map(
    (p) => `- [${p.title}](${SITE.url}${p.path}): ${p.description}`
  );

  const socialLines = Object.entries(SITE.social).map(
    ([key, url]) => `- [${SOCIAL_LABELS[key] ?? key}](${url})`
  );

  const body = [
    `# ${SITE.title}`,
    ``,
    `> ${SITE.description}`,
    ``,
    `## Content`,
    ``,
    ...contentLines,
    ``,
    `## Social`,
    ``,
    ...socialLines,
    ``
  ].join('\n');

  return new Response(body, {
    headers: { 'Content-Type': 'text/plain; charset=utf-8' },
  });
};
