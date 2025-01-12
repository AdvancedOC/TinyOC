-- recreation of the component api.

-- TODO: optimize a fuck ton probably

RegisteredComponentTypes = {}

component = {}

function component.proxy(addr)
	for k,v in pairs(RegisteredComponentTypes) do
		local p = v.attemptProxy(addr)
		if p then return p end
	end
	
	-- doesn't exist. TODO: check if it should return some kind of error.
end

local unpack = unpack or table.unpack -- because lua versions

function component.invoke(addr, func, ...)
	for k,v in pairs(RegisteredComponentTypes) do
		local rets = {v.attemptInvoke(addr, func, ...)} -- attemptInvoke's first return should be if it succeeded
		if rets[1] then return select(2, unpack(rets)) end
	end
end

function component.doc(addr, func)
	return "no documentation available"
end

function component.methods(addr)
	for k,v in pairs(RegisteredComponentTypes) do
		local p = v.getMethods(addr)
		if p then return p end
	end
end

function component.slot(addr)
	return -1
end

function component.type(addr)
	for k,v in pairs(RegisteredComponentTypes) do
		local p = v.exists(addr)
		if p then return k end
	end
end

function component.list(type, exact)
	local comps = {}
	
	for k,v in pairs(RegisteredComponentTypes) do
		local l = v.getComponentList()
		for k,v in pairs(l) do
			if type and exact then
				if type == v then
					comps[k] = v
				end
			elseif type then
				if v:find(type, nil,  true) then -- ever since i found out about string.find having a "plain" option my life has been better
					comps[k] = v
				end
			else -- no check
				comps[k] = v
			end
		end
	end
	
	local k = nil
	setmetatable(comps, {__call = function () -- i have no clue if i did this correctly, and to be frank, i don't care much
		local nk, val = next(comps,k)
		k = nk
		return nk,val
	end})
	
	return comps
end