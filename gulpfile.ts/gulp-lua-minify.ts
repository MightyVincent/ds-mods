import * as stream from "stream";
import through from 'through2';
import luamin from "luamin";
import VFile from "vinyl";

export default function (): stream.Transform {
  'use strict';

  return through.obj(function (chunk: VFile, enc, callback) {
    if (chunk.isBuffer()) {
      const code = luamin.minify(chunk.contents.toString())
      chunk.contents = Buffer.from(code)
    }
    callback(null, chunk);
  })
};
