local OrderedMap = {}

OrderedMap.__index = OrderedMap

function OrderedMap.new(getId, sortPredicate, ...)
	local v = { keys = {}, values = {}, getId = getId, sortPredicate = sortPredicate }

	setmetatable(v, OrderedMap)

	OrderedMap._InsertInPlace(v, ...)

	return v
end

function OrderedMap:Get(p)
	return self.values[p]
end

function OrderedMap.GetByIndex(p, p2)
	local key = p.keys[p2]

	if key == nil then
		return nil
	end

	return p.values[key]
end

function OrderedMap.GetIds(p)
	return p.keys
end

function OrderedMap:Length()
	return #self.keys
end

function OrderedMap.Delete(data, ...)
	local v = OrderedMap.new(data.getId, data.sortPredicate)

	local v2 = select("#", ...)

	for k, value in pairs(data.values) do
		v.values[k] = value
	end

	for i = 1, v2 do
		local v3 = select(i, ...)

		v.values[v3] = nil
	end

	for _, key in ipairs(data.keys) do
		if v.values[key] ~= nil then
			v.keys[#v.keys + 1] = key
		end
	end

	return v
end

function OrderedMap:Insert(...)
	local copy = self:_Copy()

	OrderedMap._InsertInPlace(copy, ...)

	return copy
end

function OrderedMap:First()
	if self.keys[1] then
		return self:Get(self.keys[1])
	end

	return nil
end

function OrderedMap:Last()
	local count = #self.keys

	if self.keys[count] then
		return self:Get(self.keys[count])
	end

	return nil
end

function OrderedMap:CreateIterator()
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

function OrderedMap.CreateReverseIterator(p)
	local v = #p.keys + 1

	return function()
		v -= 1

		if v > 0 then
			local key = p.keys[v]
			return key, p.values[key], v
		end

		return nil, nil, nil
	end
end

function OrderedMap:Map(callback)
	local v = OrderedMap.new(self.getId, self.sortPredicate)

	for k, v2 in self:CreateIterator() do
		v:_InsertInPlaceUnsorted(callback(v2, k))
	end

	v:_Sort()

	return v
end

function OrderedMap:Merge(...)
	local v = nil

	for i = 1, select("#", ...) do
		local v2 = select(i, ...)

		if not (v2:Length() > 0) then
			continue
		end

		v = v or self:_Copy()

		for _, v3 in v2:CreateIterator() do
			v:_InsertInPlaceUnsorted(v3)
		end
	end

	if not v then
		return self
	end

	v:_Sort()

	return v
end

function OrderedMap:_Copy()
	local v = OrderedMap.new(self.getId, self.sortPredicate)

	for i, key in ipairs(self.keys) do
		v.keys[i] = key
	end

	for k, value in pairs(self.values) do
		v.values[k] = value
	end

	return v
end

function OrderedMap:_InsertInPlaceUnsorted(...)
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		local id = self.getId(v)

		if not self.values[id] then
			table.insert(self.keys, id)
		end

		self.values[id] = v
	end
end

function OrderedMap:_Sort()
	table.sort(self.keys, function(a, b)
		local value = self.values[a]
		local value2 = self.values[b]

		return self.sortPredicate(value, value2)
	end)
end

function OrderedMap:_InsertInPlace(...)
	self:_InsertInPlaceUnsorted(...)
	self:_Sort()
end

return OrderedMap
