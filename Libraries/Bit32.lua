local bit32 = {}

local function fold(init, op, ...)
  local result = init
  local args = table.pack(...)
  for i = 1, args.n do
    result =  op(result, args[i])
  end
  return result
end

local function trim(n)
  return n & 0xFFFFFFFF
end

local function mask(w)
  return ~(0xFFFFFFFF << w)
end

function bit32.arshift(x, disp)
  return x // (2 ^ disp)
end

function bit32.band(...)
  return fold(0xFFFFFFFF, function(a. b) return a & b end, ...)
end
