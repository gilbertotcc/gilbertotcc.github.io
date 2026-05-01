import { defineCollection } from 'astro:content';
import { z } from 'astro/zod';
import { glob } from 'astro/loaders';

const speaking = defineCollection({
  loader: glob({ pattern: 'speaking.yml', base: './src/data' }),
  schema: z.array(z.object({
    date: z.string(),
    event: z.string(),
    role: z.string(),
    topic: z.string(),
  })),
});

const reviews = defineCollection({
  loader: glob({ pattern: 'reviews.yml', base: './src/data' }),
  schema: z.array(z.object({
    year: z.number(),
    title: z.string(),
    link: z.string(),
    author: z.string(),
    published: z.string(),
  })),
});

const publications = defineCollection({
  loader: glob({ pattern: 'publications.yml', base: './src/data' }),
  schema: z.array(z.object({
    type: z.string(),
    id: z.string(),
    title: z.string(),
    author: z.string(),
    year: z.union([z.string(), z.number()]),
    editor: z.string().optional(),
    booktitle: z.string().optional(),
    pages: z.string().optional(),
    publisher: z.string().optional(),
    school: z.string().optional(),
    journal: z.string().optional(),
    organization: z.string().optional(),
  })),
});

export const collections = { speaking, reviews, publications };
