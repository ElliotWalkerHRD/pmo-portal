import { chromium } from 'playwright';
import { fileURLToPath } from 'url';
import path from 'path';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const browser = await chromium.launch();
const page = await browser.newPage();
await page.setViewportSize({ width: 1440, height: 900 });
await page.goto('file:///' + path.join(__dirname, 'index.html').replace(/\\/g, '/'));
await page.waitForTimeout(1500);
await page.screenshot({ path: path.join(__dirname, 'preview.png'), fullPage: false });
await browser.close();
console.log('Screenshot saved to preview.png');
