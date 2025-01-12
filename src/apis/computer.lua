computer = {}

ComputerAddr = Diskless.generateUUID()

function computer.address()
	return ComputerAddr
end

function computer.tmpAddress()
	return TmpAddress
end

function computer.freeMemory()
	return computer.totalMemory() - collectgarbage("count") * 1024
end

function computer.totalMemory()
	return 2000000 * 1024
end

function computer.energy()
	return 99999999
end

function computer.maxEnergy()
	return 99999999
end

function computer.uptime()
	return os.clock()
end

function computer.shutdown()
	return -- fuck you actually
end

function computer.addUser()
	return
end

function computer.beep()
	return
end

-- Lua 5.1 is technically invalid, but don't care
function computer.getArchitectures()
	return {"Lua 5.1"}
end

function computer.getArchitecture()
	return "Lua 5.1"
end

function computer.setArchitecture()
	return
end

function computer.getDeviceInfo()
	return
end

-- i don't know why this is built into OC and not OpenOS but i gotta deal with it
function computer.getProgramLocations()
	return {
		{"dig", "dig"},
		{"oppm", "oppm"},
		{"md5sum", "data"},
		{"maze", "maze"},
		{"sha256sum", "data"},
		{"irc", "irc"},
		{"deflate", "data"},
		{"gpg", "data"},
		{"ifconfig", "network"},
		{"ping", "network"},
		{"base64", "data"},
		{"route", "network"},
		{"inflate", "data"},
		{"arp", "network"},
		{"opl-flash", "openloader"},
		{"build", "builder"},
		{"refuel", "generator"}
	}
end

function computer.isRobot()
	return false
end

AwaitEvent = nil
GatheredEvent = nil

local unpack = unpack or table.unpack

function computer.pullSignal(timeout)
	AwaitEvent = os.clock() + timeout
	coroutine.yield()
	
	if GatheredEvent then
		local ev = GatheredEvent
		GatheredEvent = nil
		return unpack(ev)
	end
end

function computer.pushSignal(...)
	QueueSignal(...)
end

function computer.removeUser()
	-- no
end

function computer.users()
	return {}
end