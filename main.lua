utf8 = require("utf8")

OSLOAD = "OpenOS"

local i = 1
while i <= #arg do
	local str = arg[i]
	if str == "--load" then
		local toload = arg[i+1]
		OSLOAD = toload
		i = i + 1
	end
	i = i + 1
end

math.randomseed(os.time())

require("src.keyconvert")
require("src.screen")
Diskless = require("src.diskless")

require("src.apis.signal")
require("src.apis.component")
require("src.apis.computer")

require("src.components.filesystem")
require("src.components.gpu")
require("src.components.keyboard")
require("src.components.computer")
require("src.components.eeprom")

function love.draw()
	Screen.render()
end

require("src.vm")

love.keyboard.setKeyRepeat(true)

-- TODO: make it a queue
local lkey, lsc, lrep

function love.textinput(t)
	if lkey and lsc then
		-- make them into one event!
		-- (if t is more than 1 character i give up on life)
		-- todo: check if should convert lkey or lsc
		QueueSignal("key_down", KeyboardAddress, utf8.codepoint(t), KeyConversion[lkey] or 0x00, "USER")
		lkey,lsc,lrep = nil,nil,nil
	end
end

function love.keypressed(key,sc,rep)
	if not KeyConversion[key] then return end
	lkey,lsc,lrep = key,sc,rep
end

function love.keyreleased(key,sc)
	QueueSignal("key_up", KeyboardAddress, 0x00, KeyConversion[key] or 0x00, "USER")
end

function love.update(dt)
	if lkey and lsc then -- on its own
		QueueSignal("key_down", KeyboardAddress, 0x00, KeyConversion[lkey] or 0x00, "USER")
		lkey,lsc,lrep = nil,nil,nil
	end

	RunVM()
end
