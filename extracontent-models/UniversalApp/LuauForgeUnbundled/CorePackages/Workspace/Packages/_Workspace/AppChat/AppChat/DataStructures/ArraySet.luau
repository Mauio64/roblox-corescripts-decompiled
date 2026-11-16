local class = {}

function class:__index(value)
	if type(value) == "number" then
		return self:at(value)
	end

	return class[value]
end

function class:__len()
	return self:size()
end

function class:__newindex(p3, p4)
	self._indexToValue[p3] = p4
end

function class:__iter()
	local count = 0
	return function()
		count += 1

		if count <= self._size then
			return self._indexToValue[count]
		end

		return nil
	end
end

function class:add(p2): boolean
	if self._valueToIndex[p2] then
		return false
	end

	local v5 = self._size + 1
	self._valueToIndex[p2] = v5
	self._indexToValue[v5] = p2
	self._size = v5

	return true
end

function class:prependAll(items): boolean
	local set = {}
	local v5 = {}

	for k, item in items do
		if self._valueToIndex[item] or set[item] then
			continue
		end

		set[item] = true
		table.insert(v5, item)
	end

	if #v5 == 0 then
		return false
	end

	local count = #v5

	for i = self._size, 1, -1 do
		local v6 = self._indexToValue[i]
		self._indexToValue[i + count] = v6
		self._valueToIndex[v6] = i + count
	end

	for k, v6 in v5 do
		self._indexToValue[k] = v6
		self._valueToIndex[v6] = k
	end

	self._size += count
	return true
end

function class:remove(p2): boolean
	if not self._valueToIndex[p2] then
		return false
	end

	local v5 = self._valueToIndex[p2]

	self._valueToIndex[p2] = nil

	for i = v5 + 1, self._size do
		local v6 = self._indexToValue[i]
		self._indexToValue[i - 1] = v6
		self._valueToIndex[v6] = i - 1
	end

	self._indexToValue[self._size] = nil
	self._size -= 1

	return true
end

function class:has(p3): boolean
	return self._valueToIndex[p3] ~= nil
end

function class:clear()
	self._valueToIndex = {}
	self._indexToValue = {}
	self._size = 0
end

function class:size()
	return self._size
end

function class:at(p3)
	if p3 < 1 or self._size < p3 then
		return nil
	end

	return self._indexToValue[p3]
end

function class:indexOf(p3)
	return self._valueToIndex[p3]
end

function class:toArray()
	return table.clone(self._indexToValue)
end

function class:values()
	return self._indexToValue
end

function class:clone()
	return class.new(self._indexToValue)
end

function class.new(items)
	local object = setmetatable({ _valueToIndex = {}, _indexToValue = {}, _size = 0 }, class)

	if items then
		for k, item in items do
			object:add(item)
		end
	end

	return object
end

return class
