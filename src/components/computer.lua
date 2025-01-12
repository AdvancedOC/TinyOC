local computerFuncs = {}

function computerFuncs.start()
	return false -- already running, how else would you call it?
end

function computerFuncs.stop()
	return false -- failed.
end

function computerFuncs.isRunning()
	return true -- yeah.
end

function computerFuncs.beep()
	return -- unsupported
end

function computerFuncs.getDeviceInfo()
	return
end

function computerFuncs.crash()
	-- no
end

function computerFuncs.getArchitecture()
	return "Lua 5.1" -- technically not a valid architecture in OC but did i ask
end

function computerFuncs.isRobot()
	return false
end

RegisteredComponentTypes["computer"] = {
	attemptProxy = function (addr)
			if ComputerAddr == addr then
				local prox = {}
				
				for k,v in pairs(computerFuncs) do
					prox[k] = setmetatable({},
						{
							__tostring = function (t)
								return "no documentation available"
							end,
							__call = function (t, ...)
								return computerFuncs[k](...)
							end
						}
					)
				end

				setmetatable(prox, {__metatable = {}})
				
				prox.address = ComputerAddr
				prox.type = "computer"
				prox.slot = -1 -- -1 is the value used for floppies that are outside the computer, in a disk drive, and also for raids
				               -- this means that, even though -1 looks weird as a slot, it's fairly undetectable.

				return prox
			end
		end,
		attemptInvoke = function (addr,func,...)
			if ComputerAddr == addr then
				return true,computerFuncs[func](...)
			end
		end,
		getMethods = function (addr)
			if ComputerAddr == addr then
				local shit = {}
				
				for k,v in pairs(computerFuncs) do
					shit[k] = true
				end
				
				return shit
			end
		end,
		exists = function (addr)
			return (addr == ComputerAddr)
		end,
		getComponentList = function ()
			return {[ComputerAddr] = "computer"}
		end
}