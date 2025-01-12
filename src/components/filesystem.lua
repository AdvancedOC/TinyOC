TmpAddress = Diskless.makeRamFS(false, nil)

Diskless.funcs.setLabel(TmpAddress, "tmpfs")

MainFS = Diskless.makeRamFS(false, nil)

local function recurseFolder(path,callback)
	callback(path)
	for i,name in ipairs(love.filesystem.getDirectoryItems(path)) do
		if love.filesystem.getInfo(path .. "/" .. name, "directory") then
			recurseFolder(path .. "/" .. name, callback)
		else
			callback(path .. "/" .. name)
		end
	end
end

local loadfrom = OSLOAD
-- install OS to the main drive
recurseFolder(loadfrom, function (path)
	if path ~= loadfrom then -- fuck myself
		if path:sub(1,#loadfrom + 1) == loadfrom .. "/" then
			local spath = path:sub(#loadfrom + 2)

			if love.filesystem.getInfo(path, "directory") then
				Diskless.funcs.makeDirectory(MainFS,spath)
			else
				Diskless.forceWrite(MainFS, spath, love.filesystem.read(path))
			end
		end
	end
end)

print("loaded " .. loadfrom .. " to " .. MainFS)

Filesystems = {MainFS, TmpAddress}

RegisteredComponentTypes["filesystem"] = {
	attemptProxy = function (addr)
		local yes = false
		for i = 1,#Filesystems do
			if Filesystems[i] == addr then yes = true end
		end
		
		if yes then
			return Diskless.makeProxy(addr)
		end
	end,
	attemptInvoke = function (addr, func, ...)
		local yes = false
		for i = 1,#Filesystems do
			if Filesystems[i] == addr then yes = true end
		end
		
		if yes then
			return true, Diskless.funcs[func](addr, ...)
		end
	end,
	getMethods = function (addr)
		local yes = false
		for i = 1,#Filesystems do
			if Filesystems[i] == addr then yes = true end
		end
		
		if yes then
			local methods = {}
			
			for k,v in pairs(Diskless.funcs) do
				methods[k] = true
			end
			
			return methods
		end
	end,
	exists = function (addr)
		for i = 1,#Filesystems do
			if Filesystems[i] == addr then return true end
		end
		return false
	end,
	getComponentList = function ()
		local comps = {}
		for i = 1,#Filesystems do
			comps[Filesystems[i]] = "filesystem"
		end
		return comps
	end
}