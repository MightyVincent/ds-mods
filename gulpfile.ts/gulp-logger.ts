import VFile from 'vinyl'
import through2 from 'through2';
import log from "gulplog";
import * as stream from "stream";

export default function (messageSupplier: (file: VFile) => string): stream.Transform {
  'use strict';

  return through2.obj(function (chunk: VFile, enc, callback) {
    if (typeof messageSupplier == 'function') {
      log.info(messageSupplier(chunk))
    }
    callback(null, chunk);
  })
};
