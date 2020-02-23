import * as VFile from "vinyl";
import {src} from "gulp";

function srcAsync(globs, consumer: (file: VFile) => void) {
  return new Promise((resolve, reject) => {
    src(globs, {read: true})
      .on('data', consumer)
      .on('end', resolve)
      .on('error', reject)
  });
}

async function globsTo<R>(globs, result: R, consumer: (file: VFile, result: R) => void): Promise<R> {
  if (typeof consumer !== 'function') {
    return Promise.reject('undefined mapper')
  }
  await srcAsync(globs, (file) => {
    consumer(file, result)
  })
  return Promise.resolve(result)
}

async function globsToArray<T>(globs, mapper: (file: VFile) => T): Promise<T[]> {
  if (typeof mapper !== 'function') {
    return Promise.reject('undefined mapper')
  }
  return globsTo(globs, new Array<T>(), (file, result) => result.push(mapper(file)))
}

async function globsToSet<T>(globs, mapper: (file: VFile) => T): Promise<Set<T>> {
  if (typeof mapper !== 'function') {
    return Promise.reject('undefined mapper')
  }
  return globsTo(globs, new Set<T>(), (file, result) => result.add(mapper(file)))
}

async function globsToMap<K, V>(globs, keyMapper: (file: VFile) => K, valueMapper: (file: VFile) => V): Promise<Map<K, V>> {
  if (typeof keyMapper !== 'function' || typeof valueMapper !== 'function') {
    return Promise.reject('undefined mapper')
  }
  return globsTo(globs, new Map<K, V>(), (file, result) => result.set(keyMapper(file), valueMapper(file)))
}

export default {
  globsTo,
  globsToArray,
  globsToSet,
  globsToMap
}
