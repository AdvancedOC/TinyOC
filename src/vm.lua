local eepromdata = component.invoke(component.list("eeprom")(), "get")

local function copyTable(tab)
	local nt = {}
	
	for k,v in pairs(tab) do
		if type(v) == "table" then
			nt[k] = copyTable(v)
		else
			nt[k] = v
		end
	end
	
	return nt
end

local unpack = unpack or table.unpack

Virtual_G = {
	_VERSION = _VERSION,
	assert = assert,
	error = error,
	getmetatable = getmetatable,
	ipairs = ipairs,
	load = function (chunk,chunkname,mode,env)
		env = env or Virtual_G
	
		return load(chunk,chunkname,mode,env)
	end,
	next = next,
	pairs = pairs,
	pcall = pcall,
	rawequal = rawequal,
	rawget = rawget,
	rawlen = rawlen,
	rawset = rawset,
	select = select,
	setmetatable = setmetatable,
	tonumber = tonumber,
	tostring = tostring,
	type = type,
	xpcall = xpcall,
	
	coroutine = copyTable(coroutine),
	
	debug = {
		getinfo = debug.getinfo,
		traceback = debug.traceback,
		getlocal = debug.getlocal,
		getupvalue = debug.getupvalue
	},
	
	math = copyTable(math),
	
	os = {
		clock = os.clock,
		date = os.date,
		difftime = os.difftime,
		time = os.time
	},

	string = copyTable(string),
	
	table = copyTable(table),
	
	checkArg = function (n,value,...)
		local types = {...}
		
		local t = type(value)
		
		local valid = false
		for i = 1,#types do
			if types[i] == t then
				valid = true
			end
		end
		
		if not valid then
			error("bad argument #" .. tostring(n).. " (" .. tostring(types[1]) .. " expected, got " .. t .. ")")
		end
		
		-- TODO
	end,
	
	component = copyTable(component),
	computer = copyTable(computer),
	
	-- for this unicode "library", i assume nothing is wide.
	unicode = setmetatable({
		len = utf8.len,
		wlen = utf8.len, -- this can be very wrong.
		sub = function (str,a,b)
			if not b then b = utf8.len(str) end
			if not a then a = 1 end
			-- a = math.max(a,1)
			
			if a < 0 then
				-- negative
				
				a = utf8.len(str) + a + 1
			end
			
			if b < 0 then
				b = utf8.len(str) + b + 1
			end
			
			if a > b then return "" end
			
			if b >= utf8.len(str) then b = #str else b = utf8.offset(str,b+1)-1 end
			
			if a > utf8.len(str) then return "" end
			a = utf8.offset(str,a)
			
			return str:sub(a,b)
			-- return str:sub(a, b)
		end,
		char = utf8.char,
		wtrunc = function (str,space)
			space = space - 1
			return str:sub(1,(space >= utf8.len(str)) and (#str) or (utf8.offset(str,space+1)-1))
		end,
		upper = string.upper, -- these are accurate... sometimes
		lower = string.lower,
		isWide = function ()
			return false
		end
	}, { -- very real not fake trust
		__index = function (t,k)
			if rawget(t,k) then return rawget(t,k) end
			print("invalid utf8 instruction, ", k)
			return function() end
		end
	}),
	
	utf8 = copyTable(utf8),
	
	debugPrint = print
}

Virtual_G.table.unpack = unpack;
Virtual_G._G = Virtual_G;
Virtual_G._ENV = Virtual_G;

local fun = load(eepromdata, "=bios.lua", "bt", Virtual_G)

if type(fun) ~= "function" then error() end
Coroutine = coroutine.create(fun)

function RunVM()
	if AwaitEvent then
		if #SignalQueue > 0 then
			GatheredEvent = PullSignal()
			AwaitEvent = nil
		elseif os.clock() >= AwaitEvent then
			AwaitEvent = nil
		else
			return
		end
	end
	
	if coroutine.status(Coroutine) == "suspended" then
		local succ, err = coroutine.resume(Coroutine)
		if not succ then
			print(err)
		end
	else
		-- coroutine has died!
	end
end