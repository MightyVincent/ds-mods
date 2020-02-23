import path from "path"
import {dest, lastRun, series, src, watch} from "gulp"
import gUtil from "gulp-util"
import gClean from "gulp-clean"
import gFilter from "gulp-filter"
import gIf from "gulp-if"
import gIgnore from "gulp-ignore"
import gMultiDest from "gulp-multi-dest"
import gLogger from "./gulp-logger"
import gLuaMinify from "./gulp-lua-minify"
// import gCacheFilter from "./gulp-cache-filter"
import utils from './utils'
import VFile from "vinyl"

const isProd = gUtil.env.production
const deployPath = 'D:\\SteamLibrary\\steamapps\\common\\Don\'t Starve Together\\mods'
// const deployPath = 'deploy'

function _clean() {
  return src('dist/*', {read: false})
    .pipe(gClean())
    .pipe(gLogger(file => `Cleaned: ${file.path}`))
}

function _src() {
  let luaFilter = gFilter('src/**/*.lua', {restore: true})
  return src('src/**/*.*', {since: lastRun(_src)})
    .pipe(luaFilter)
    .pipe(gIf(isProd, gLuaMinify()))
    .pipe(luaFilter.restore)
    .pipe(dest('dist'))
    .pipe(gLogger(file => `Emitted: ${file.path}`))
}


async function _lib() {
  let modPaths = await utils.globsToArray('dist/*/', file => `dist/${file.basename}/scripts/lib`)
  await new Promise((resolve, reject) => {
    src('lib/**/*.lua', {since: lastRun(_lib)})
      .pipe(gIf(isProd, gLuaMinify()))
      .pipe(gMultiDest(modPaths))
      .on('finish', resolve)
      .on('error', reject)
  })
}

async function _deploy() {
  await new Promise((resolve, reject) => {
    src('dist/**/*.*', {since: lastRun(_deploy)})
      .pipe(dest(deployPath))
      .on('finish', resolve)
      .on('error', reject)
      .pipe(gLogger(file => `Deployed: ${file.path}`))
  })

  let modGlobs = await utils.globsToArray('dist/*/', file => `${deployPath}/${file.basename}/**/*.*`)
  let distFiles = await utils.globsToSet('dist/**/*.*', file => file.relative)
  await new Promise((resolve, reject) => {
    src(modGlobs)
      .pipe(gIgnore.exclude((file: VFile) => distFiles.has(path.relative(deployPath, file.path))))
      .pipe(gClean())
      .on('finish', resolve)
      .on('error', reject)
      .pipe(gLogger(file => `Cleaned: ${file.path}`))
  })
  return Promise.resolve()
}

const _build = series(_src, _lib)

function _watch() {
  return watch(['src/**', 'lib/**'], series(_build, _deploy))
}

// export default _deploy
export const dev = series(_clean, _build, _deploy, _watch)
export const prod = series(_clean, _build)
