local Extents = {}
Extents.__index = Extents

function Extents.new()
	local self = setmetatable({}, Extents)
	self.min = Vector3.new(1e999, 1e999, 1e999)
	self.max = Vector3.new(-1e999, -1e999, -1e999)
	return self
end

function Extents.fromMinMax(vector3: Vector3, vector3_2: Vector3)
	local v = Extents.new()

	local v2 = { X = vector3.X, Y = vector3.Y, Z = vector3.Z }
	local v3 = { X = vector3_2.X, Y = vector3_2.Y, Z = vector3_2.Z }

	for _, v4 in { "X", "Y", "Z" } do
		if not (v3[v4] ~= -1e999 and v2[v4] ~= 1e999 and v2[v4] > v3[v4]) then
			continue
		end

		local v5 = v2[v4]
		v2[v4] = v3[v4]
		v3[v4] = v5
	end

	v.min = Vector3.new(v2.X, v2.Y, v2.Z)
	v.max = Vector3.new(v3.X, v3.Y, v3.Z)
	return v
end

function Extents.unionExtents(p, p2)
	local v = Extents.new()
	v.min = p.min:Min(p2.min)
	v.max = p.max:Max(p2.max)
	return v
end

function Extents.intersectExtents(p, p2)
	local v = { X = 1e999, Y = 1e999, Z = 1e999 }
	local v2 = { X = -1e999, Y = -1e999, Z = -1e999 }

	for _, v3 in { "X", "Y", "Z" } do
		if p.max[v3] < p.min[v3] or p2.max[v3] < p2.min[v3] then
			continue
		end

		local v4 = math.max(p.min[v3], p2.min[v3])
		local v5 = math.min(p.max[v3], p2.max[v3])

		if not (v4 <= v5) then
			continue
		end

		v[v3] = v4
		v2[v3] = v5
	end

	local v3 = Extents.new()
	v3.min = Vector3.new(v.X, v.Y, v.Z)
	v3.max = Vector3.new(v2.X, v2.Y, v2.Z)
	return v3
end

function Extents.expandToInclude(p, vector3: Vector3)
	local v = Extents.new()
	v.min = p.min:Min(vector3)
	v.max = p.max:Max(vector3)
	return v
end

function Extents:isValid(): boolean
	for _, v in { "X", "Y", "Z" } do
		if self.max[v] < self.min[v] then
			return false
		end
	end

	return true
end

function Extents:size()
	if self:isValid() then
		return self.max - self.min
	end

	return nil
end

function Extents:center()
	if self:isValid() then
		return (self.max + self.min) / 2
	end

	return nil
end

return Extents
