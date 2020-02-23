import through from 'through2';
import VFile from "vinyl";

export default function () {
  'use strict';

  const cache = {}
  return through.obj(function (chunk: VFile, enc, callback) {
    if (chunk.isBuffer() || chunk.isStream()) {
      let timestamp = cache[chunk.path];
      if (timestamp && timestamp === chunk.stat.mtimeMs) {
        callback()
      } else {
        cache[chunk.path] = chunk.stat.mtimeMs
        callback(null, chunk);
      }
    } else {
      callback()
    }
  })
};
