local class = {}

class.__index = class

function class.new(p2, p3, ...)
	local v5 = { keys = {}, values = {}, getId = p2, sortPredicate = p3 }

	setmetatable(v5, class)

	class._InsertInPlace(v5, ...)

	return v5
end

function class.Get(p2, p3)
	return p2.values[p3]
end

function class.GetByIndex(p2, p3)
	local key = p2.keys[p3]

	if key == nil then
		return nil
	end

	return p2.values[key]
end

function class.GetIds(p2)
	return p2.keys
end

function class.Length(p2)
	return #p2.keys
end

function class.Delete(data, ...)
	local v5 = class.new(data.getId, data.sortPredicate)

	local v6 = select("#", ...)

	for k, value in pairs(data.values) do
		v5.values[k] = value
	end

	for i = 1, v6 do
		local v7 = select(i, ...)

		v5.values[v7] = nil
	end

	for i, key in ipairs(data.keys) do
		if v5.values[key] ~= nil then
			v5.keys[#v5.keys + 1] = key
		end
	end

	return v5
end

function class:Insert(...)
	local copy = self:_Copy()

	class._InsertInPlace(copy, ...)

	return copy
end

function class:First()
	if self.keys[1] then
		return self:Get(self.keys[1])
	end

	return nil
end

function class:Last()
	local count = #self.keys

	if self.keys[count] then
		return self:Get(self.keys[count])
	end

	return nil
end

function class:CreateIterator()
	local count = 0
	local count2 = #self.keys

	return function()
		count += 1

		if count <= count2 then
			local key = self.keys[count]
			return key, self.values[key], count
		end

		return nil, nil, nil
	end
end

function class.CreateReverseIterator(p2)
	local v5 = #p2.keys + 1

	return function()
		v5 -= 1

		if v5 > 0 then
			local key = p2.keys[v5]
			return key, p2.values[key], v5
		end

		return nil, nil, nil
	end
end

function class:Map(callback)
	local v5 = class.new(self.getId, self.sortPredicate)

	for k, v6 in self:CreateIterator() do
		v5:_InsertInPlaceUnsorted(callback(v6, k))
	end

	v5:_Sort()

	return v5
end

function class:Merge(...)
	local v5 = nil

	for i = 1, select("#", ...) do
		local v6 = select(i, ...)

		if not (v6:Length() > 0) then
			continue
		end

		v5 = v5 or self:_Copy()

		for k, v7 in v6:CreateIterator() do
			v5:_InsertInPlaceUnsorted(v7)
		end
	end

	if not v5 then
		return self
	end

	v5:_Sort()

	return v5
end

function class:_Copy()
	local v5 = class.new(self.getId, self.sortPredicate)

	for i, key in ipairs(self.keys) do
		v5.keys[i] = key
	end

	for k, value in pairs(self.values) do
		v5.values[k] = value
	end

	return v5
end

function class:_InsertInPlaceUnsorted(...)
	for i = 1, select("#", ...) do
		local v5 = select(i, ...)
		local id = self.getId(v5)

		if not self.values[id] then
			table.insert(self.keys, id)
		end

		self.values[id] = v5
	end
end

function class:_Sort()
	table.sort(self.keys, function(a, b)
		local value = self.values[a]
		local value2 = self.values[b]

		return self.sortPredicate(value, value2)
	end)
end

function class:_InsertInPlace(...)
	self:_InsertInPlaceUnsorted(...)
	self:_Sort()
end

return class
