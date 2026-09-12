import { chromium, type ConsoleMessage } from "playwright";

interface Viewport {
  name: string;
  width: number;
  height: number;
}

const VIEWPORTS: Viewport[] = [
  { name: "desktop", width: 1280, height: 800 },
  { name: "mobile", width: 390, height: 844 },
];

interface ViewportResult {
  viewport: string;
  status: number | null;
  consoleErrors: string[];
  screenshotPath: string;
}

async function captureViewport(
  url: string,
  outPrefix: string,
  viewport: Viewport,
): Promise<ViewportResult> {
  const browser = await chromium.launch();
  try {
    const page = await browser.newPage({
      viewport: { width: viewport.width, height: viewport.height },
    });

    const consoleErrors: string[] = [];
    page.on("console", (msg: ConsoleMessage) => {
      if (msg.type() === "error") {
        consoleErrors.push(msg.text());
      }
    });

    const response = await page.goto(url, { waitUntil: "networkidle" });
    const screenshotPath = `${outPrefix}-${viewport.name}.png`;
    await page.screenshot({ path: screenshotPath, fullPage: true });

    return {
      viewport: viewport.name,
      status: response?.status() ?? null,
      consoleErrors,
      screenshotPath,
    };
  } finally {
    await browser.close();
  }
}

async function main(): Promise<void> {
  const [, , url, outPrefix] = process.argv;

  if (!url || !outPrefix) {
    console.error(
      "Usage: node scripts/screenshot_page.mts <url> <out-prefix>",
    );
    process.exit(1);
  }

  const results = await Promise.all(
    VIEWPORTS.map((viewport) => captureViewport(url, outPrefix, viewport)),
  );

  console.log(JSON.stringify({ url, results }, null, 2));
}

main().catch((error: unknown) => {
  console.error(error);
  process.exit(1);
});
