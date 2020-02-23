import VFile from 'vinyl'
import through from 'through2';
import log from "gulplog";

export default function (messageMapper: (file: VFile) => string) {
  'use strict';

  return through.obj(function (chunk: VFile, enc, callback) {
    if (typeof messageMapper == 'function') {
      log.info(messageMapper(chunk))
    }
    callback(null, chunk);
  })
};
