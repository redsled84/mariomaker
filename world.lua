local tileSize = _G.tileSize
local gravity = _G.gravity

local Goomba = require "goomba"
local LevelEditor = require "leveleditor"
local Player = require "player"
local Solids = require "solids"

local World = {}

function World:initialize()
	self.physicsBodies = {}
	self.map = {}
	self.state = "create"
end

function World:initializeMap()
	self.map = LevelEditor:getMap()
end

function World:initializeSolids()
	Solids:generateSolids(self.map, LevelEditor.mapwidth, LevelEditor.mapheight)
	print(#Solids.solids)
end

function World:resetPhysicsBodies()
	for i = #self.physicsBodies, 1, -1 do
		self.physicsBodies[i] = nil
	end
end

function World:initializePlayer()
	local map = self.map
	local mapwidth, mapheight = LevelEditor.mapwidth, LevelEditor.mapheight
	for y = 1, mapheight do
		for x = 1, mapwidth do
			if map[y][x] == 3 then
				Player:new((x - 1) * tileSize, (y - 2) * tileSize, (4 / 5) * tileSize, (4 / 5) * tileSize)
				self.physicsBodies[#self.physicsBodies+1] = Player
				break
			end
		end
	end
end

function World:initializeGoombas()
	local map = self.map
	local mapwidth, mapheight = LevelEditor.mapwidth, LevelEditor.mapheight
	for y = 1, mapheight do
		for x = 1, mapwidth do
			if map[y][x] == 2 then
				self.physicsBodies[#self.physicsBodies+1] = Goomba:new((x - 1) * tileSize,
					(y - 1) * tileSize, tileSize / 2, tileSize / 2)
			end
		end
	end
end

function World:update(dt)
	for i = 1, #self.physicsBodies do
		local body = self.physicsBodies[i]
		body:update(dt)
		for j = 1, #Solids.solids do
			local solid = Solids.solids[j]
			body:collide(solid)
		end
		if self.physicsBodies[i] ~= Player then
			Player:collideWithEnemy(self.physicsBodies[i])
		end
	end

	self:applyGravity(dt)
end

function World:applyGravity(dt)
	for i = 1, #self.physicsBodies do
		local body = self.physicsBodies[i]
		body.vy = body.vy + gravity * dt
		if body.vy > gravity then
			body.vy = gravity
		end
	end
end

function World:draw()
	Player:draw()
	Solids:draw()

	for i = 1, #self.physicsBodies do
		if self.physicsBodies[i] ~= Player then
			self.physicsBodies[i]:draw()
		end
	end
end

function World:keypressed(key)
	Player:jump(key)
end

return World