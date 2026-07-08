local t1 = {}

t1.__index = t1

function t1.ReadPixel(p1, n1: number, n2: number) -- line: 21
	if n1 >= p1.size.X or (n2 >= p1.size.Y or n1 < 0 or n2 < 0) then
		return Color3.fromRGB(0, 0, 0)
	end

	local v6 = (n1 + n2 * p1.size.X) * 4

	return Color3.fromRGB(buffer.readu8(p1.buffer, v6), buffer.readu8(p1.buffer, v6 + 1), (buffer.readu8(p1.buffer, v6 + 2)))
end
function t1.new(p2) -- line: 35
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.buffer = p2:ReadPixelsBuffer(Vector2.new(0, 0), p2.Size)
	self.size = p2.Size

	return self
end

local t2 = {}

t2.__index = t2

function t2.new(vector2: Vector2, p3: ((...any) -> ...any)) -- line: 51
	-- upvalues: t2 (copy)
	local self = setmetatable({}, t2)

	self.size = vector2
	self.calculateWeightFromColor3 = p3
	self.buffer = buffer.create(vector2.X * vector2.Y * 4)

	return self
end
function t2.ReadValue(p4, n3: number, n4: number) -- line: 60
	if n3 < 0 or n4 < 0 then
		return 0
	end

	local v15 = math.min(n3, p4.size.X - 1) + math.min(n4, p4.size.Y - 1) * p4.size.X

	return (buffer.readu32(p4.buffer, v15 * 4))
end
function t2.WriteValue(p5, n5: number, n6: number, p6) -- line: 71
	assert(n5 < p5.size.X and (n6 < p5.size.Y and (n5 >= 0 and n6 >= 0)))

	local v20 = n5 + n6 * p5.size.X

	buffer.writeu32(p5.buffer, v20 * 4, p6)
end
function t2.BuildSummedAreaTable(p7, p8) -- line: 78
	-- upvalues: t1 (copy)
	local v23 = t1.new(p8)

	assert(v23.size == p7.size)

	for i = 0, p7.size.Y - 1 do
		for j = 0, p7.size.X - 1 do
			local v26 = p7.calculateWeightFromColor3(v23:ReadPixel(j, i))
			local v27 = p7:ReadValue(j - 1, i)
			local v28 = p7:ReadValue(j, i - 1)
			local v29 = p7:ReadValue(j - 1, i - 1)

			p7:WriteValue(j, i, v26 + v27 + v28 - v29)
		end
	end
end
function t2.GetAreaDensity(p9, vector2: Vector2, vector2_2: Vector2) -- line: 96
	local v33 = vector2 - Vector2.one
	local v34 = vector2 + vector2_2 - Vector2.one
	local vector2_3 = Vector2.new(v34.X, v33.Y)
	local vector2_4 = Vector2.new(v33.X, v34.Y)

	return p9:ReadValue(v34.X, v34.Y) - p9:ReadValue(vector2_3.X, vector2_3.Y) - p9:ReadValue(vector2_4.X, vector2_4.Y) + p9:ReadValue(v33.X, v33.Y)
end
function t2.GetAreaDensityContinuous(t3: {[any]: any}, vector2: Vector2, vector2_5: Vector2) -- line: 115
	local n7 = 0
	local v41 = vector2 + vector2_5
	local v42 = vector2:Ceil()
	local v43 = v41:Floor()
	local v44 = v43 - v42

	if v44.X > 0 and v44.Y > 0 then
		n7 += t3:GetAreaDensity(v42, v44)
	end

	local v45 = v42 - vector2
	local v46 = v41 - v43

	if v44.Y > 0 then
		local vector2_6 = Vector2.new(1, v44.Y)

		if math.floor(vector2.X) < math.floor(v41.X) then
			local v48 = v42 + Vector2.new(-1, 0)
			local X = v45.X
			local v50 = n7 + t3:GetAreaDensity(v48, vector2_6) * X
			local v51 = v42 + Vector2.new(v44.X, 0)
			local X2 = v46.X

			n7 = v50 + t3:GetAreaDensity(v51, vector2_6) * X2
		else
			local v53 = v41.X - vector2.X

			n7 += t3:GetAreaDensity(v42 + Vector2.new(-1, 0), vector2_6) * v53
		end
	end

	if v44.X > 0 then
		local vector2_7 = Vector2.new(v44.X, 1)

		if math.floor(vector2.Y) < math.floor(v41.Y) then
			local v55 = v42 + Vector2.new(0, -1)
			local Y = v45.Y
			local v57 = n7 + t3:GetAreaDensity(v55, vector2_7) * Y
			local v58 = v42 + Vector2.new(0, v44.Y)
			local Y2 = v46.Y

			n7 = v57 + t3:GetAreaDensity(v58, vector2_7) * Y2
		else
			local v60 = v41.Y - vector2.Y

			n7 += t3:GetAreaDensity(v42 + Vector2.new(0, -1), vector2_7) * v60
		end
	end

	local v61 = math.min(v42.X, v41.X) - vector2.X
	local v62 = math.min(v42.Y, v41.Y) - vector2.Y
	local v63 = n7 + t3:GetAreaDensity(vector2:Floor(), Vector2.new(1, 1)) * v61 * v62

	if math.floor(vector2.X) < math.floor(v41.X) then
		local X = v46.X

		v63 += t3:GetAreaDensity(Vector2.new(v41.X, vector2.Y):Floor(), Vector2.new(1, 1)) * X * v62

		if math.floor(vector2.Y) < math.floor(v41.Y) then
			v63 += t3:GetAreaDensity(v41:Floor(), Vector2.new(1, 1)) * v46.X * v46.Y
		end
	end

	if math.floor(vector2.Y) < math.floor(v41.Y) then
		local Y = v46.Y

		v63 += t3:GetAreaDensity(Vector2.new(vector2.X, v41.Y):Floor(), Vector2.new(1, 1)) * v61 * Y
	end

	return v63
end

return t2
