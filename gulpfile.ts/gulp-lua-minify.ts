import * as stream from "stream";
import through2 from 'through2';
import luamin from "luamin";
import VFile from "vinyl";

export default function (): stream.Transform {
  'use strict';

  return through2.obj(function (chunk: VFile, enc, callback) {
    if (chunk.isBuffer()) {
      const code = luamin.minify(chunk.contents.toString())
      chunk.contents = Buffer.from(code)
    }
    callback(null, chunk);
  })
};
