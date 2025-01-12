-- TODO: if adding more screen support, we gotta do some multi-gpu at some point too probably lol

local boundscreen = nil
local screenUUID = Diskless.generateUUID() -- me when diskless
local gpuUUID = Diskless.generateUUID()
local bgclr = 0x000000
local fgclr = 0xffffff

local gpuFuncs = {}

function gpuFuncs.bind(addr)
	boundscreen = addr
end

function gpuFuncs.getScreen()
	return boundscreen
end

function gpuFuncs.getBackground()
	if boundscreen ~= screenUUID then return end
	return bgclr
end

function gpuFuncs.getForeground()
	if boundscreen ~= screenUUID then return end
	return fgclr
end

function gpuFuncs.setBackground(new)
	if boundscreen ~= screenUUID then return end
	if type(new) ~= "number" then return end
	bgclr = new
end

function gpuFuncs.setForeground(new)
	if boundscreen ~= screenUUID then return end
	if type(new) ~= "number" then return end
	fgclr = new
end

function gpuFuncs.getPaletteColor(idx)
	if boundscreen ~= screenUUID then return end
	return 0x000000 -- UNIMPLEMENTED
end

function gpuFuncs.setPaletteColor(idx,val)
	if boundscreen ~= screenUUID then return end
	-- UNIMPLEMENTED
end

function gpuFuncs.maxDepth()
	if boundscreen ~= screenUUID then return end
	return 8
end

function gpuFuncs.getDepth()
	if boundscreen ~= screenUUID then return end
	return 8
end

function gpuFuncs.setDepth()
	if boundscreen ~= screenUUID then return end
	-- no.
end

function gpuFuncs.maxResolution()
	if boundscreen ~= screenUUID then return end
	return Screen.w, Screen.h
end

function gpuFuncs.getResolution()
	if boundscreen ~= screenUUID then return end
	return Screen.w, Screen.h
end

function gpuFuncs.setResolution()
	if boundscreen ~= screenUUID then return end
	-- no.
end

function gpuFuncs.getViewport()
	if boundscreen ~= screenUUID then return end
	return Screen.w, Screen.h
end

function gpuFuncs.setViewport()
	-- no thanks
end

local unpack = unpack or table.unpack

function gpuFuncs.get(x,y)
	if boundscreen ~= screenUUID then return end
	if x >= 1 and x <= Screen.w and y >= 1 and y <= Screen.h then
		return unpack(Screen.data[x][y])
	else
		return " ", 0xffffff, 0x000000 -- undocumented behavior. TODO: check if ok
	end
end

function gpuFuncs.set(x,y,str,vertical)
	if boundscreen ~= screenUUID then return end
	if x >= 1 and x <= Screen.w and y >= 1 and y <= Screen.h then
		for i = 1,utf8.len(str) do
			local st = utf8.offset(str, i)
			local en = utf8.offset(str,i+1)-1
			local ch = str:sub(st,en) -- i love utf8!!!
			
			if x >= 1 and x <= Screen.w and y >= 1 and y <= Screen.h then
				Screen.data[x][y] = {ch, fgclr, bgclr}
			end
			
			if vertical then
				y = y + 1
			else
				x = x + 1
			end
		end
	else
		return false
	end
end

function gpuFuncs.copy(x,y,w,h,tx,ty)
	if boundscreen ~= screenUUID then return end
	local temp = {}
	if w <= 0 or h <= 0 then return end -- very bad but good enough for now safety checks
	if x <= 0 or x > Screen.w or y <= 0 or y > Screen.h then return end
	for cx = x,x+w-1 do
		temp[cx] = {}
		for cy = y,y+h-1 do
			temp[cx][cy] = Screen.data[cx][cy] -- gonna assume it's fine
		end
	end

	for cx = x+tx,x+w-1+tx do
		for cy = y+ty,y+h-1+ty do
			if cx >= 1 and cx <= Screen.w and cy >= 1 and cy <= Screen.h then
				Screen.data[cx][cy] = {temp[cx-tx][cy-ty][1], temp[cx-tx][cy-ty][2], temp[cx-tx][cy-ty][3]}
			end
		end
	end
end

function gpuFuncs.fill(x,y,w,h,ch)
	if not w then w = 1 end
	if not h then h = 1 end
	if boundscreen ~= screenUUID then return end
	x,y = math.floor(x),math.floor(y)
	for cx = x,x+w-1 do
		for cy = y,y+h-1 do
			if cx >= 1 and cx <= Screen.w and cy >= 1 and cy <= Screen.h then
				Screen.data[cx][cy] = {ch, fgclr, bgclr}
			end
		end
	end
end

RegisteredComponentTypes["gpu"] = {
	attemptProxy = function (addr)
		if gpuUUID == addr then
			local prox = {}

			for k,v in pairs(gpuFuncs) do
				prox[k] = setmetatable({},
					{
						__tostring = function (t)
							return "no documentation available"
						end,
						__call = function (t, ...)
							return gpuFuncs[k](...)
						end
					}
				)
			end
			
			setmetatable(prox, {__metatable = {}})

			prox.address = gpuUUID
			prox.type = "gpu"
			prox.slot = -1 -- -1 is the value used for floppies that are outside the computer, in a disk drive, and also for raids
			               -- this means that, even though -1 looks weird as a slot, it's fairly undetectable.

			return prox
		end
	end,
	attemptInvoke = function (addr,func,...)
		if gpuUUID == addr then
			return true,gpuFuncs[func](...)
		end
	end,
	getMethods = function (addr)
		if gpuUUID == addr then
			local shit = {}
			
			for k,v in pairs(gpuFuncs) do
				shit[k] = true
			end
			
			return shit
		end
	end,
	exists = function (addr)
		return (addr == gpuUUID)
	end,
	getComponentList = function ()
		return {[gpuUUID] = "gpu"}
	end
}

local screenFuncs = {}

function screenFuncs.isOn()
	return true
end

function screenFuncs.turnOn()
	return true, true
end

function screenFuncs.turnOff()
	return true, true
end

function screenFuncs.getAspectRatio()
	return 1,1
end

function screenFuncs.getKeyboards()
	return {KeyboardAddress}
end

function screenFuncs.setPrecise(val)
	return false
end

function screenFuncs.isPrecise()
	return false
end

function screenFuncs.setTouchModeInverted()
	return false -- no thanks
end

function screenFuncs.isTouchModeInverted()
	return false
end

RegisteredComponentTypes["screen"] = {
	attemptProxy = function (addr)
			if screenUUID == addr then
				local prox = {}
				
				for k,v in pairs(screenFuncs) do
					prox[k] = setmetatable({},
						{
							__tostring = function (t)
								return "no documentation available"
							end,
							__call = function (t, ...)
								return screenFuncs[k](...)
							end
						}
					)
				end
				
				setmetatable(prox, {__metatable = {}})

				prox.address = screenUUID
				prox.type = "screen"
				prox.slot = -1 -- -1 is the value used for floppies that are outside the computer, in a disk drive, and also for raids
				               -- this means that, even though -1 looks weird as a slot, it's fairly undetectable.

				return prox
			end
		end,
		attemptInvoke = function (addr,func,...)
			if screenUUID == addr then
				-- return true
				return true,screenFuncs[func](...)
			end
		end,
		getMethods = function (addr)
			if screenUUID == addr then
				local shit = {}
				
				for k,v in pairs(screenFuncs) do
					shit[k] = true
				end
				
				return shit
			end
		end,
		exists = function (addr)
			return (addr == screenUUID)
		end,
		getComponentList = function ()
			return {[screenUUID] = "screen"}
		end
}