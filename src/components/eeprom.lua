EEPROMAddress = Diskless.generateUUID()

local eepromfuncs = {}

local storedCode = [[
local init
do
  local component_invoke = component.invoke
  local function boot_invoke(address, method, ...)
    local result = table.pack(pcall(component_invoke, address, method, ...))
    if not result[1] then
      return nil, result[2]
    else
      return table.unpack(result, 2, result.n)
    end
  end

  -- backwards compatibility, may remove later
  local eeprom = component.list("eeprom")()
  computer.getBootAddress = function()
    return boot_invoke(eeprom, "getData")
  end
  computer.setBootAddress = function(address)
    return boot_invoke(eeprom, "setData", address)
  end

  do
    local screen = component.list("screen")()
    local gpu = component.list("gpu")()
    if gpu and screen then
      boot_invoke(gpu, "bind", screen)
    end
  end
  local function tryLoadFrom(address)
    local handle, reason = boot_invoke(address, "open", "/init.lua")
    if not handle then
      return nil, reason
    end
    local buffer = ""
    repeat
      local data, reason = boot_invoke(address, "read", handle, math.maxinteger or math.huge)
      if not data and reason then
        return nil, reason
      end
      buffer = buffer .. (data or "")
    until not data
    boot_invoke(address, "close", handle)
    return load(buffer, "=init")
  end
  local reason
  if computer.getBootAddress() then
    init, reason = tryLoadFrom(computer.getBootAddress())
  end
  if not init then
    computer.setBootAddress()
    for address in component.list("filesystem") do
      init, reason = tryLoadFrom(address)
      if init then
        computer.setBootAddress(address)
        break
      end
    end
  end
  if not init then
    error("no bootable medium found" .. (reason and (": " .. tostring(reason)) or ""), 0)
  end
  computer.beep(1000, 0.2)
end

return init()
]]

local storedData = ""

local eepromLabel = "EEPROMYES"

function eepromfuncs.get()
	return storedCode
end

function eepromfuncs.set(new)
	storedCode = new
end

function eepromfuncs.getLabel()
	return eepromLabel
end

function eepromfuncs.setLabel(new)
	eepromLabel = new
end

function eepromfuncs.getSize()
	return 99999999*1024 -- a lot.
end

function eepromfuncs.getDataSize()
	return 99999999*1024 -- a lot.
end

function eepromfuncs.getData()
	return storedData
end

function eepromfuncs.setData(new)
	storedData = new
end

function eepromfuncs.getChecksum()
	-- TODO: figure out what checksum this is supposed to be
	return "Hello from TinyOC!"
end

function eepromfuncs.makeReadonly(checksum)
	return false -- you don't
end

RegisteredComponentTypes["eeprom"] = {
	attemptProxy = function (addr)
			if EEPROMAddress == addr then
				local prox = {}
				
				for k,v in pairs(eepromfuncs) do
					prox[k] = setmetatable({},
						{
							__tostring = function (t)
								return "no documentation available"
							end,
							__call = function (t, ...)
								return eepromfuncs[k](...)
							end
						}
					)
				end
				
				setmetatable(prox, {__metatable = {}})

				prox.address = EEPROMAddress
				prox.type = "eeprom"
				prox.slot = -1 -- -1 is the value used for floppies that are outside the computer, in a disk drive, and also for raids
				               -- this means that, even though -1 looks weird as a slot, it's fairly undetectable.

				return prox
			end
		end,
		attemptInvoke = function (addr,func,...)
			if EEPROMAddress == addr then
				return true,eepromfuncs[func](...)
			end
		end,
		getMethods = function (addr)
			if EEPROMAddress == addr then
				local shit = {}
				
				for k,v in pairs(eepromfuncs) do
					shit[k] = true
				end
				
				return shit
			end
		end,
		exists = function (addr)
			return (addr == EEPROMAddress)
		end,
		getComponentList = function ()
			return {[EEPROMAddress] = "eeprom"}
		end
}