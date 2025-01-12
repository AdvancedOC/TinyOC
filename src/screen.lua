-- this is the code that renders the actual screen and manages it.
-- this does NOT provide the component.

-- TODO: maybe make this a crazier project and have optional multiple screens.

Screen = {
	w = math.floor(love.graphics.getWidth()/8),
	h = math.floor(love.graphics.getHeight()/16)
}

love.graphics.setDefaultFilter("nearest", "nearest")
Screen.font = love.graphics.newFont("unifont-16.0.01.otf",16)
love.graphics.setFont(Screen.font) -- assume nothing else will touch font (please)

Screen.charw = Screen.font:getWidth("W")
Screen.charh = Screen.font:getHeight()

Screen.data = {}

function Screen.clear()
	Screen.data = {}

	for x = 1,Screen.w do
		Screen.data[x] = {}
		for y = 1,Screen.h do
			Screen.data[x][y] = {" ", 0xffffff, 0x000000}
		end
	end
end

Screen.clear()

function Screen.setChar(x,y, char, fgclr, bgclr)
	if x >= 1 and x <= Screen.w and y >= 1 and y <= Screen.h then
		Screen.data[x][y][1] = char
		if fgclr then
			Screen.data[x][y][2] = fgclr
		end
		if bgclr then
			Screen.data[x][y][3] = bgclr
		end
	end
end

local function splitColor(clr)
	return math.floor(clr/256/256) % 256, math.floor(clr / 256) % 256, clr % 256
end

function Screen.render()
	local screenw = Screen.w * Screen.charw
	local screenh = Screen.h * Screen.charh
	
	local sw,sh = love.graphics.getDimensions()
	
	local scalefactor = math.min(sw/screenw, sh/screenh)
	
	local finalw = scalefactor * screenw
	local finalh = scalefactor * screenh
	
	local xoff = (sw - finalw) / 2
	local yoff = (sh - finalh) / 2
	
	for y = 1,Screen.h do
		for x = 1,Screen.w do
			local rx = (x-1) * scalefactor * Screen.charw + xoff
			local ry = (y-1) * scalefactor * Screen.charh + yoff
			
			-- print(scalefactor,xoff,yoff)
			
			local chardata = Screen.data[x][y]

			local char = chardata[1]
			local fgclr = chardata[2]
			local bgclr = chardata[3]
			
			local br,bg,bb = splitColor(bgclr)
			love.graphics.setColor(br/255,bg/255,bb/255)
			love.graphics.rectangle("fill",rx,ry, Screen.charw * scalefactor, Screen.charh * scalefactor)
			
			local fr,fg,fb = splitColor(fgclr)
			love.graphics.setColor(fr/255,fg/255,fb/255)
			love.graphics.print(char, rx,ry, 0, scalefactor, scalefactor)
		end
	end
end