local FloatVector = {}

function FloatVector.new(...)
	local self = setmetatable({}, FloatVector)
	self.data = {}

	local v = { ... }

	if #v == 1 and typeof(v[1]) == "table" then
		if getmetatable(v[1]) == FloatVector then
			v = v[1].data
		else
			v = v[1]
		end
	end

	for _, v2 in v do
		if typeof(v2) == "number" then
			table.insert(self.data, v2)
		else
			error("arg to FloatVector.new() not a number")
		end
	end

	return self
end

function FloatVector.getSize(p)
	return #p.data
end

function FloatVector.checkCompatible(p, p2): boolean
	if typeof(p) ~= typeof(FloatVector) or typeof(p2) ~= typeof(FloatVector) then
		error("vector operation on non-vector type")
		return false
	end

	if #p.data == #p2.data then
		return true
	end

	error("operating on vectors of different dimension")
	return false
end

function FloatVector.__index(p, value)
	if typeof(value) == "number" then
		return p.data[value]
	end

	return FloatVector[value]
end

function FloatVector.__newindex(p, value, p2)
	if typeof(value) == "number" then
		p.data[value] = p2
	else
		rawset(p, value, p2)
	end
end

function FloatVector.__add(p, p2)
	FloatVector.checkCompatible(p, p2)
	local v = {}

	for i = 1, #p.data do
		table.insert(v, p.data[i] + p2.data[i])
	end

	return FloatVector.new(v)
end

function FloatVector.__sub(p, p2)
	FloatVector.checkCompatible(p, p2)
	local v = {}

	for i = 1, #p.data do
		table.insert(v, p.data[i] - p2.data[i])
	end

	return FloatVector.new(v)
end

function FloatVector.__mul(p, value)
	if typeof(p) == typeof(FloatVector) and typeof(value) == "number" then
		local v = {}

		for _, v2 in p.data do
			table.insert(v, v2 * value)
		end

		return FloatVector.new(v)
	else
		FloatVector.checkCompatible(p, value)
		local v = {}

		for i = 1, #p.data do
			table.insert(v, p.data[i] * value.data[i])
		end

		return FloatVector.new(v)
	end
end

function FloatVector.__div(p, value)
	if typeof(p) == typeof(FloatVector) and typeof(value) == "number" then
		local v = {}

		for _, v2 in p.data do
			table.insert(v, v2 / value)
		end

		return FloatVector.new(v)
	else
		FloatVector.checkCompatible(p, value)
		local v = {}

		for i = 1, #p.data do
			table.insert(v, p.data[i] / value.data[i])
		end

		return FloatVector.new(v)
	end
end

function FloatVector.dot(p, p2)
	FloatVector.checkCompatible(p, p2)
	local total = 0

	for i = 1, #p.data do
		total += p.data[i] * p2.data[i]
	end

	return total
end

function FloatVector.cross(p, p2)
	FloatVector.checkCompatible(p, p2)

	if #p.data == 3 and #p2.data == 3 then
		return FloatVector.new(
			p.data[2] * p2.data[3] - p.data[3] * p2.data[2],
			p.data[3] * p2.data[1] - p.data[1] * p2.data[3],
			p.data[1] * p2.data[2] - p.data[2] * p2.data[1]
		)
	end

	error("cross product is only defined for two 3 dimensional vectors")
	return nil
end

function FloatVector.magnitude(p)
	local total = 0

	for _, v in p.data do
		total += v ^ 2
	end

	return (math.sqrt(total))
end

function FloatVector.fuzzyEq(p, p2, value: number): boolean
	if not FloatVector.checkCompatible(p, p2) then
		return false
	end

	local v = value or 0.00001

	for i = 1, #p.data do
		if v < math.abs(p.data[i] - p2.data[i]) then
			return false
		end
	end

	return true
end

return FloatVector
