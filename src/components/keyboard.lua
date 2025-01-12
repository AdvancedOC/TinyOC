KeyboardAddress = Diskless.generateUUID()

RegisteredComponentTypes["keyboard"] = {
	attemptProxy = function (addr)
			if KeyboardAddress == addr then
				local prox = {}
				
				setmetatable(prox, {__metatable = {}})

				prox.address = KeyboardAddress
				prox.type = "keyboard"
				prox.slot = -1 -- -1 is the value used for floppies that are outside the computer, in a disk drive, and also for raids
				               -- this means that, even though -1 looks weird as a slot, it's fairly undetectable.

				return prox
			end
		end,
		attemptInvoke = function (addr,func,...)
			if KeyboardAddress == addr then
				return true
				-- return true,gpuFuncs[func](...)
			end
		end,
		getMethods = function (addr)
			if KeyboardAddress == addr then
				local shit = {}
				
				return shit
			end
		end,
		exists = function (addr)
			return (addr == KeyboardAddress)
		end,
		getComponentList = function ()
			return {[KeyboardAddress] = "keyboard"}
		end
}