local Compress = {}

-- lz4, zlib, gzip, deflate
local FORMAT = "lz4"

function Compress.compress(data)
  return love.data.compress("string", FORMAT, data)
end

function Compress.decompress(data, n)
  return love.data.decompress("string", FORMAT, data)
end

return Compress
