-- A solid is a square that collides with Player
-- and returns a collision response
local Solids = { solids={} }
local tileSize = _G.tileSize

function Solids:newSolid(x, y, w, h, tileType, open)
	self.solids[#self.solids+1] = {
		x = x,
		y = y,
		w = w,
		h = h
	}
end

function Solids:checkSolidPosition(x, y)
	for i = 1, #self.solids do
		local solid = self.solids[i]
		if solid.x < x and solid.x + solid.w > x and
		solid.y < y and solid.y + solid.h > y then
			return true
		end
	end
	return false
end

function Solids:generateSolids(map, width, height)
	if #self.solids > 0 then
		for i = #self.solids, 1, -1 do
			self.solids[i] = nil
		end
	end

	for y = height, 1, -1 do
		for x = width, 1, -1 do
			local n = map[y][x]
			local min, max = 1, 2
			local tileType, open
			if n >= min and n < max then
				local mx, my = tileSize * (x-1), tileSize * (y-1)

				self:newSolid(mx, my, tileSize, tileSize)
			end
		end
	end
end

function Solids:draw()
	love.graphics.setColor(0,0,0)
	for i = 1, #self.solids do
		local solid = self.solids[i]
		love.graphics.rectangle("fill", solid.x, solid.y, solid.w, solid.h)
	end
end

return Solids