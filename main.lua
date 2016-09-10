local tileSize = 32
local gravity = 600
_G.tileSize = tileSize
_G.gravity = gravity

local LevelEditor = require "leveleditor"
local World = require "world"

function love.load()
	love.graphics.setBackgroundColor(255,255,255)
	LevelEditor:initialize()
	World:initialize()
end

function love.update(dt)
	if World.state == "play" then
		World:update(dt)
	elseif World.state == "create" then
		LevelEditor:update()
	end
end

function love.draw()
	if World.state == "play" then
		World:draw()
	elseif World.state == "create" then
		LevelEditor:draw()
	end
end

function love.keypressed(key)
	if World.state == "play" then
		World:keypressed(key)
	elseif World.state == "create" and key == "p" then
		print(true)
		World.state = "play"

		World:initializeMap()
		World:initializeSolids()
		World:initializePlayer()
		World:initializeGoombas()
	end

	if World.state == "create" then
		LevelEditor:placeBlocks(key)
	end

	if World.state == "play" and key == "r" then
		World:resetPhysicsBodies()
		World:initializePlayer()
		World:initializeGoombas()
	end
	

	local quit = love.event.quit
	if key == "escape" then
		quit()
	end
end