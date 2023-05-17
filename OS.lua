local bootFilesystemProxy = component.proxy(component.proxy(component.list("eeprom")()).getData())

function dofile(path)
    local stream, reason = bootFilesystemProxy.open(path, "r")
    if stream then
        local data, chunk = ""
        while true do
            chunk = bootFilesystemProxy.read(stream, math.huge)
            if chunk then
                data = data .. chunk
            else
                break
            end
        end
        bootFilesystemProxy.close(stream)

        local result, reason = load(data, "=" .. path)
        if result then
            return result()
        else
            error(reason)
        end
    else
        error(reason)
    end
end

package = {
	paths = {
		["/Libraries/"] = true
  },
  loaded = {}
  loading = {}
}

local function requireExists(path)
  return bootFilesystemProxy.exists(path)
end

function require(module)
  local lowerModule = unicode.lower(module)
  
  if package.loaded[lowerModule] them
    return package.loaded[lowerModule]
  elseif package.loading[lowerModule] then
    error("recursive require() call found: library \"" .. module .. "\" is trying to require another library that requires it\n" .. debug.traceback())
  else
    local errors = {}
    local function checkVariant(variant)
      if requireExistst(variant) then
        return variant
      else 
        table.insert(errors, " variant \"" .. variant .. "\" not exists")
