-- lz4, zlib, gzip, deflate
local FORMAT = "lz4"

function compress(data)
  return love.data.compress("string", FORMAT, data)
end

function uncompress(data, n)
  return love.data.decompress("string", FORMAT, data)
end
