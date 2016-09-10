local tileSize = _G.tileSize
local LevelEditor = {}

function LevelEditor:initialize()
	self.map = {}
	self.mapwidth  = math.ceil(love.graphics.getWidth() / 32)
	self.mapheight = math.ceil(love.graphics.getHeight() / 32)

	for y = 1, self.mapheight do
		local temp = {}
		for x = 1, self.mapwidth do
			temp[x] = 0
		end
		self.map[y] = temp
	end

	self.cursor = {
		x = 0,
		y = 0
	}
end

function LevelEditor:update()
	for y = 1, self.mapheight do
		for x = 1, self.mapwidth do
			local mx, my = (x-1) * tileSize, (y-1) * tileSize
			if love.mouse.getX() > mx and love.mouse.getY() > my and 
			love.mouse.getX() < mx + tileSize and love.mouse.getY() < my + tileSize then
				self.cursor.x = x
				self.cursor.y = y
			end
		end
	end

	if love.mouse.isDown(1) and self.map[self.cursor.y][self.cursor.x] == 0 then
		self.map[self.cursor.y][self.cursor.x] = 1
	end
end

function LevelEditor:draw()
	for y = 1, self.mapheight do
		for x = 1, self.mapwidth do
			if self.map[y][x] == 1 then
				love.graphics.setColor(0,0,0)
				love.graphics.rectangle("fill", (x-1) * tileSize, (y-1) * tileSize, tileSize, tileSize)
			elseif self.map[y][x] == 2 then
				love.graphics.setColor(223,0,96)	
				love.graphics.rectangle("fill", (x-1) * tileSize, (y-1) * tileSize, tileSize, tileSize)
			elseif self.map[y][x] == 3 then
				love.graphics.setColor(64,224,208)
				love.graphics.rectangle("fill", (x-1) * tileSize, (y-1) * tileSize, tileSize, tileSize)
			end
		end
	end

	local cx, cy = self.cursor.x, self.cursor.y
	love.graphics.setColor(100,100,100,100)
	love.graphics.rectangle("line", (cx - 1) * tileSize, (cy - 1) * tileSize, tileSize, tileSize)
end

function LevelEditor:placeBlocks(key)
	if key == "1" then
		self.map[self.cursor.y][self.cursor.x] = 1
	elseif key == "2" then
		self.map[self.cursor.y][self.cursor.x] = 2
	elseif key == "3" then
		self.map[self.cursor.y][self.cursor.x] = 3
	elseif key == "backspace" then
		self.map[self.cursor.y][self.cursor.x] = 0
	end
end

function LevelEditor:getMap()
	return self.map
end

return LevelEditor