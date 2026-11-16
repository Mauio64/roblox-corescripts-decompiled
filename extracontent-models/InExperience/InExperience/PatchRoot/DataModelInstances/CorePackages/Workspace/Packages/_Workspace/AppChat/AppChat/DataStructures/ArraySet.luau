local ArraySet = {}

function ArraySet:__index(value)
	if type(value) == "number" then
		return self:at(value)
	end

	return ArraySet[value]
end

function ArraySet:__len()
	return self:size()
end

function ArraySet:__newindex(p, p2)
	self._indexToValue[p] = p2
end

function ArraySet:__iter()
	local count = 0
	return function()
		count += 1

		if count <= self._size then
			return self._indexToValue[count]
		end

		return nil
	end
end

function ArraySet:add(p): boolean
	if self._valueToIndex[p] then
		return false
	end

	local size = self._size + 1
	self._valueToIndex[p] = size
	self._indexToValue[size] = p
	self._size = size

	return true
end

function ArraySet:prependAll(items): boolean
	local set = {}
	local v = {}

	for _, item in items do
		if self._valueToIndex[item] or set[item] then
			continue
		end

		set[item] = true
		table.insert(v, item)
	end

	if #v == 0 then
		return false
	end

	local count = #v

	for i = self._size, 1, -1 do
		local v2 = self._indexToValue[i]
		self._indexToValue[i + count] = v2
		self._valueToIndex[v2] = i + count
	end

	for k, v2 in v do
		self._indexToValue[k] = v2
		self._valueToIndex[v2] = k
	end

	self._size += count
	return true
end

function ArraySet:remove(p): boolean
	if not self._valueToIndex[p] then
		return false
	end

	local v = self._valueToIndex[p]

	self._valueToIndex[p] = nil

	for i = v + 1, self._size do
		local v2 = self._indexToValue[i]
		self._indexToValue[i - 1] = v2
		self._valueToIndex[v2] = i - 1
	end

	self._indexToValue[self._size] = nil
	self._size -= 1

	return true
end

function ArraySet:has(p): boolean
	return self._valueToIndex[p] ~= nil
end

function ArraySet:clear()
	self._valueToIndex = {}
	self._indexToValue = {}
	self._size = 0
end

function ArraySet:size()
	return self._size
end

function ArraySet:at(p: number)
	if p < 1 or self._size < p then
		return nil
	end

	return self._indexToValue[p]
end

function ArraySet:indexOf(p)
	return self._valueToIndex[p]
end

function ArraySet:toArray()
	return table.clone(self._indexToValue)
end

function ArraySet:values()
	return self._indexToValue
end

function ArraySet:clone()
	return ArraySet.new(self._indexToValue)
end

function ArraySet.new(items)
	local self = setmetatable({ _valueToIndex = {}, _indexToValue = {}, _size = 0 }, ArraySet)

	if items then
		for _, item in items do
			self:add(item)
		end
	end

	return self
end

return ArraySet
