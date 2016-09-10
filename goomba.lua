local class = require "middleclass"
local Collision = require "collision"
local Goomba = class("Goomba")

function Goomba:initialize(x, y, w, h)
	self.x, self.y = x, y
	self.w, self.h = w, h
	self.vy = 0
	self.yDir = -1
	self.spd = 100

	self.dead = false
end

function Goomba:collide(o)
	if not self.dead then
		local col = Collision:aabb(self, o)
		if col then
			local nx, ny = Collision:getSide(self, o)
			local x, y, vx, vy = Collision:solve(nx, ny, self, o)
			self.x, self.y = x, y
			self.vy = vy

			if nx < 0 then
				self.yDir = -1
			elseif nx > 0 then
				self.yDir = 1
			end
		end
	end
end

function Goomba:update(dt)
	self.y = self.y + self.vy * dt

	if self.yDir > 0 then
		self.x = self.x + self.spd * dt
	else
		self.x = self.x - self.spd * dt
	end
end

function Goomba:draw()
	love.graphics.setColor(223,0,96)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return Goomba