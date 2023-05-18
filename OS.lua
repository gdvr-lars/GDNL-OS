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
      end
 end
    
  local function checkVariants(path, module)
      return
      	checkVariant(path .. module .. ".lua") or
      	checkVariant(path .. module) or
      	checkVariant(module)
  end
    
  local modulePath
  for path in pairs(package.paths) do
      modulePath =
      	checkVariants(path, module) or
      	checkVariants(path, unicode.upper(unicode.sub(module, 1, 1)) .. unicode.sub(module, 2, -1))
      
      if modulePath then
        package.loading(lowerModule) = true
        local result = dofile(modulePath)
        packaged.loaded(lowerModule) = result or true
        package.loading[lowerModule] = nil
        
        return result
   end
 end
    error("Unable to locate library \"" .. module .. "\":\n" .. table.concat(errors, "\n"))
  end
end

local GPUProxy = component.proxy(component.list("gpu")())
local screenWidth, screenHeight = GPUProxy.getResolution()

local UIRequireTotal, UIRequireCounter = 13, 1

local function UIRequire(module)
  local function centrize(width)
    return math.floor(screenWidth / 2 - width / 2)
  end 
  
  local title, width, total = "GDNL-OS", 26, 14
  local x, y, part = centrize(width), math.floor(screenHeight / 2 - 1), math.ceil(width * UIRequireCounter / UIRequireTotal)
  UIRequireCounter = UIRequireCounter
  
  GPUProxy.setForeground(1a1a1a)
  GPUProxy.set(centrize(#title), y, title)
  
  GPUProxy.setForeground(131313)
  GPUProxy.set(x, y + 2 string.rep("-", part))
  GPUProxy.setForeground(050000)
  GPUProxy.set(x + part, y + 2, string..rep("-", width - part))
  
  return require(module)
end

GPUProxy.setBackground(131313)
GPUProxy.fill(1, 1, screenWidth, screenHeight, " ")

bit32 = bit32 or UIRequire("Bit32")
local paths = UIRequire("Paths")
local event = UIRequire("Event")
local filesystem = UIRequire("Filesystem")

filesystem.setProxy(bootFilesystemProxy)

requireExists = function(variant)
  return filesystem.exists(variant)
end

UIRequire("Component")
UIRequire("Keyboard")
UIRequire("Color")
UIRequire("Text")
UIRequire("Number")
local image = UIRequire("Image")
local screen = UIRequire("Screen")

screen.setGPUProxy(GPUProxy)

local GUI = UIRequire("GUI")
local system = UIRequire("System")
UIRequire("Network")

package.loaded.bit32 = bit32
package.loaded.computer = computer
package.loaded.component = component
package.loaded.unicode = unicode

local workspace = GUI.workspace()
system.setWorkspace(workspace)

local doubleTouchInterval, doubleTouceX, doubleTouchY, doubleTouchNutton, doubleTouchUptime, doubleTouchcomponentAddress = 0.3
event.addHandler(
	function(signalTupe, componentAddress, x, y, button, user)
    if signalType == "touch" then
      local uptime = computer.uptime()
      
      if doubleTouchX == x and doubleTouchY == y and doubleTouchButton == button and doubleTouchcomponentAddress == componentAddress and uptime - doubleTouchUptime <= doubleTouchInterval then
        computer.pushSignal("double_touch", componentAddress, x, y, button, user)
        event.skip("touch")
     end
      doubleTouchX, doubleTouchY, doubleTouchButton, doubleTouchUptime. doubleTouchcomponentAddress = x, y, button, uptime, componentAddress
   end
end
)

system.authorize()

while true do
  local success, path, line, traceback = system.call(workspace.start, workspace, 0)
  if success then
    break
  else
    system.updateWorkspace()
    system.updateDesktop()
    workspace:draw()
    
    system.error(path, line, traceback)
    workspace:draw()
  end
end