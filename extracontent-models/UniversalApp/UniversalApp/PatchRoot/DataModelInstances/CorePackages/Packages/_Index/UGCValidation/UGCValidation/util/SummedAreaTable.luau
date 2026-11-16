local class = {}
class.__index = class

function class:ReadPixel(p: number, p2: number)
	if self.size.X <= p or self.size.Y <= p2 or p < 0 or p2 < 0 then
		return Color3.fromRGB(0, 0, 0)
	end

	local v = (p + p2 * self.size.X) * 4
	return Color3.fromRGB(
		buffer.readu8(self.buffer, v),
		buffer.readu8(self.buffer, v + 1),
		(buffer.readu8(self.buffer, v + 2))
	)
end

function class.new(object)
	local object2 = setmetatable({}, class)
	object2.buffer = object:ReadPixelsBuffer(Vector2.new(0, 0), object.Size)
	object2.size = object.Size
	return object2
end

local SummedAreaTable = {}
SummedAreaTable.__index = SummedAreaTable

function SummedAreaTable.new(size: Vector2, calculateWeightFromColor)
	local object = setmetatable({}, SummedAreaTable)
	object.size = size
	object.calculateWeightFromColor3 = calculateWeightFromColor
	object.buffer = buffer.create(size.X * size.Y * 4)
	return object
end

function SummedAreaTable:ReadValue(p: number, p2: number)
	if p < 0 or p2 < 0 then
		return 0
	end

	local v = math.min(p, self.size.X - 1) + math.min(p2, self.size.Y - 1) * self.size.X
	return (buffer.readu32(self.buffer, v * 4))
end

function SummedAreaTable:WriteValue(p: number, p2: number, value)
	local v = p < self.size.X and p2 < self.size.Y and p >= 0 and p2 >= 0
	assert(v)

	local v2 = p + p2 * self.size.X
	buffer.writeu32(self.buffer, v2 * 4, value)
end

function SummedAreaTable:BuildSummedAreaTable(p)
	local v = class.new(p)

	assert(v.size == self.size)

	for i = 0, self.size.Y - 1 do
		for j = 0, self.size.X - 1 do
			local weightFromColor3 = self.calculateWeightFromColor3(v:ReadPixel(j, i))
			local value = self:ReadValue(j - 1, i)
			local value2 = self:ReadValue(j, i - 1)
			local value3 = self:ReadValue(j - 1, i - 1)
			self:WriteValue(j, i, weightFromColor3 + value + value2 - value3)
		end
	end
end

function SummedAreaTable:GetAreaDensity(vector2: Vector2, vector2_2: Vector2)
	local v = vector2 - Vector2.one
	local v2 = vector2 + vector2_2 - Vector2.one
	local vector2_3 = Vector2.new(v2.X, v.Y)
	local vector2_4 = Vector2.new(v.X, v2.Y)

	return self:ReadValue(v2.X, v2.Y) - self:ReadValue(vector2_3.X, vector2_3.Y) - self:ReadValue(vector2_4.X, vector2_4.Y) + self:ReadValue(v.X, v.Y)
end

function SummedAreaTable:GetAreaDensityContinuous(vector2: Vector2, vector2_2: Vector2)
	local v = 0

	local v2 = vector2 + vector2_2

	local ceil = vector2:Ceil()
	local floor = v2:Floor()
	local v3 = floor - ceil

	if v3.X > 0 and v3.Y > 0 then
		v += self:GetAreaDensity(ceil, v3)
	end

	local v4 = ceil - vector2
	local v5 = v2 - floor

	if v3.Y > 0 then
		local vector2_3 = Vector2.new(1, v3.Y)

		if math.floor(vector2.X) < math.floor(v2.X) then
			local v6 = ceil + Vector2.new(-1, 0)
			local x = v4.X
			local v7 = v + self:GetAreaDensity(v6, vector2_3) * x
			local v8 = ceil + Vector2.new(v3.X, 0)
			local x2 = v5.X
			v = v7 + self:GetAreaDensity(v8, vector2_3) * x2
		else
			local v6 = v2.X - vector2.X
			v += self:GetAreaDensity(ceil + Vector2.new(-1, 0), vector2_3) * v6
		end
	end

	if v3.X > 0 then
		local vector2_3 = Vector2.new(v3.X, 1)

		if math.floor(vector2.Y) < math.floor(v2.Y) then
			local v6 = ceil + Vector2.new(0, -1)
			local y = v4.Y
			local v7 = v + self:GetAreaDensity(v6, vector2_3) * y
			local v8 = ceil + Vector2.new(0, v3.Y)
			local y2 = v5.Y
			v = v7 + self:GetAreaDensity(v8, vector2_3) * y2
		else
			local v6 = v2.Y - vector2.Y
			v += self:GetAreaDensity(ceil + Vector2.new(0, -1), vector2_3) * v6
		end
	end

	local v6 = math.min(ceil.X, v2.X) - vector2.X
	local v7 = math.min(ceil.Y, v2.Y) - vector2.Y
	local areaDensityContinuous = v + self:GetAreaDensity(vector2:Floor(), Vector2.new(1, 1)) * v6 * v7

	if math.floor(vector2.X) < math.floor(v2.X) then
		local x = v5.X
		areaDensityContinuous += self:GetAreaDensity(Vector2.new(v2.X, vector2.Y):Floor(), Vector2.new(1, 1)) * x * v7

		if math.floor(vector2.Y) < math.floor(v2.Y) then
			areaDensityContinuous += self:GetAreaDensity(v2:Floor(), Vector2.new(1, 1)) * v5.X * v5.Y
		end
	end

	if math.floor(vector2.Y) < math.floor(v2.Y) then
		local y = v5.Y
		areaDensityContinuous += self:GetAreaDensity(Vector2.new(vector2.X, v2.Y):Floor(), Vector2.new(1, 1)) * v6 * y
	end

	return areaDensityContinuous
end

return SummedAreaTable
