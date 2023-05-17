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