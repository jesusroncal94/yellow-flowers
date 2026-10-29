// Syntax-checks every inline <script> block of the exported pages.
const fs = require('fs');
const vm = require('vm');

const pages = ['index.html', 'docs/index.html', 'docs/flores-amarillas-offline.html'];
let failed = false;

for (const page of pages) {
  const html = fs.readFileSync(`/repo/${page}`, 'utf8');
  const blocks = [...html.matchAll(/<script>([\s\S]*?)<\/script>/g)];
  if (blocks.length === 0) {
    console.error(`${page}: no inline script found`);
    failed = true;
    continue;
  }
  blocks.forEach((block, i) => {
    try {
      new vm.Script(block[1], { filename: `${page}#${i + 1}` });
    } catch (error) {
      console.error(`${page}#${i + 1}: ${error.message}`);
      failed = true;
    }
  });
  console.log(`${page}: ${blocks.length} inline script block(s) parse`);
}

process.exit(failed ? 1 : 0);
