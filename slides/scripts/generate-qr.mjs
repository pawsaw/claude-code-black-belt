// Generates QR SVGs: one per task (pointing at its tasks/NN-*.md file in the
// repo, so participants can open the full spec on a second screen without
// typing) plus a small set of standalone ones (e.g. the presenter's
// LinkedIn). Runs as predev/prebuild — see package.json.
import { mkdir, readdir } from 'node:fs/promises'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'
import QRCode from 'qrcode'

const __dirname = dirname(fileURLToPath(import.meta.url))
const REPO_URL = 'https://github.com/pawsaw/claude-code-black-belt'
const TASKS_DIR = join(__dirname, '..', '..', 'tasks')
const OUT_DIR = join(__dirname, '..', 'public', 'diagrams', 'qr')

const STANDALONE_QRS = {
  linkedin: 'https://www.linkedin.com/in/sawickipawel/',
}

async function writeQr(slug, url) {
  const outPath = join(OUT_DIR, `${slug}.svg`)
  await QRCode.toFile(outPath, url, {
    type: 'svg',
    margin: 1,
    color: { dark: '#18181b', light: '#fafafa' },
  })
}

async function main() {
  await mkdir(OUT_DIR, { recursive: true })

  for (const [slug, url] of Object.entries(STANDALONE_QRS)) {
    await writeQr(slug, url)
  }
  console.log(`[generate-qr] wrote ${Object.keys(STANDALONE_QRS).length} standalone QR code(s) to ${OUT_DIR}`)

  let taskFiles
  try {
    taskFiles = await readdir(TASKS_DIR)
  } catch (err) {
    if (err.code === 'ENOENT') {
      // Expected when only slides/ is deployed standalone (e.g. to Vercel)
      // without the parent repo's tasks/ directory alongside it. The
      // per-task QR SVGs already committed under public/diagrams/qr/ still
      // ship as static assets in that case — this just skips regenerating
      // them from a tasks/ directory that isn't present in this build.
      console.warn(`[generate-qr] ${TASKS_DIR} not found — skipping per-task QR regeneration`)
      return
    }
    throw err
  }

  const files = taskFiles.filter(
    (f) => /^\d{2}-.*\.md$/.test(f) && f !== 'README.md',
  )

  if (files.length === 0) {
    console.warn(`[generate-qr] no task files found in ${TASKS_DIR} yet — skipping`)
    return
  }

  for (const file of files) {
    const slug = file.replace(/\.md$/, '')
    const url = `${REPO_URL}/blob/main/tasks/${file}`
    await writeQr(slug, url)
  }

  console.log(`[generate-qr] wrote ${files.length} QR codes to ${OUT_DIR}`)
}

main().catch((err) => {
  console.error('[generate-qr] failed:', err)
  process.exit(1)
})
