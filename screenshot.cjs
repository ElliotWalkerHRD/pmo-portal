const { chromium } = require('playwright');
const path = require('path');
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.setViewportSize({ width: 1440, height: 900 });
  const url = 'file:///' + path.join(__dirname, 'index.html').replace(/\\/g, '/');
  await page.goto(url);
  await page.waitForTimeout(1000);
  await page.screenshot({ path: path.join(__dirname, 'preview-home-full.png'), fullPage: true });
  await browser.close();
  console.log('Done');
})();
