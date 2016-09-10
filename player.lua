local Collision = require "collision"
local Player = {}

local frc, acc, dec, top, low = 700, 500, 6000, 350, 50

function Player:new(x, y, w, h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.vy = 0
	self.vx = 0
	self.jumpSpd = -300
	self.jumpCounter = 0
	self.onGround = false
	self.maxJumps = 2

	self.dead = false
end

function Player:collide(o)
	if not self.dead then
		local col = Collision:aabb(self, o)
		if col then
			local nx, ny = Collision:getSide(self, o)

			if nx > 0 then
				self.x = o.x + o.w
				self.vx = 0
			elseif nx < 0 then
				self.x = o.x - self.w
				self.vx = 0
			end
			if ny > 0 then
				self.y = o.y + o.h
				self.vy = 0
			elseif ny < 0 then
				self.y = o.y - self.h
				if self.vy > 0 then
					self.vy = 0
				end
				self.jumpCounter = 0
			end
		end

		if self.vy <= 1 and self.vy >= -1 then
			self.onGround = true
		else
			self.onGround = false
		end
	end
end

function Player:collideWithEnemy(enemy)
	local col = Collision:aabb(self, enemy)
	if col then
		local nx, ny = Collision:getSide(self, enemy)
		self.x, self.y, self.vx, self.vy = Collision:solve(nx, ny, self, enemy)
		if ny == -1 then
			enemy.dead = true
			self.vy = -200
		end
		if nx ~= 0 then
			self.dead = true
		end
	end
end

function Player:movement(dt)
	local lk = love.keyboard
    local vx = self.vx

    if lk.isDown('d') then
        if vx < 0 then
            vx = vx + dec * dt
        elseif vx < top then
            vx = vx + acc * dt
        end
    elseif lk.isDown('a') then
        if vx > 0 then
            vx = vx - dec * dt
        elseif vx > -top then
            vx = vx - acc * dt
        end
    else
        if math.abs(vx) < low then
            vx = 0
        elseif vx > 0 then
            vx = vx - frc * dt
        elseif vx < 0 then
            vx = vx + frc * dt
        end
    end

    self.vx = vx
end

function Player:update(dt)
	if not self.dead then
		self:movement(dt)
	end

	self.x = self.x + self.vx * dt
	self.y = self.y + self.vy * dt
end

function Player:draw()
	love.graphics.setColor(64,224,208)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Player:jump(key)
	if not self.dead then
		if key == "w" and self.jumpCounter < self.maxJumps and self.onGround then
			self.vy = self.jumpSpd
			self.jumpCounter = self.jumpCounter + 1
		end
	end
end

return Player