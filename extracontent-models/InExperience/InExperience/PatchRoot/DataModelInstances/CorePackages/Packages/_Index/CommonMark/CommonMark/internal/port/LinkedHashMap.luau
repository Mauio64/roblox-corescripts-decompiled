local LinkedHashMap = {}
LinkedHashMap.__index = LinkedHashMap

function LinkedHashMap.new()
	return (setmetatable({ _keys = {}, _present = {}, _values = {} }, LinkedHashMap))
end

function LinkedHashMap:newMap()
	local map = LinkedHashMap.new()

	for k, v in self:entrySet() do
		map:put(k, v)
	end

	return map
end

local frozen = table.freeze((setmetatable(
	{ _keys = table.freeze({}), _present = table.freeze({}), _values = table.freeze({}) },
	LinkedHashMap
)))

function LinkedHashMap.of()
	return frozen
end

function LinkedHashMap:put(p, p2)
	local value = self._values[p]

	if self._present[p] == nil then
		table.insert(self._keys, p)
		self._present[p] = true
	end

	self._values[p] = p2
	return value
end

function LinkedHashMap:remove(p)
	if self._present[p] == nil then
		return nil
	end

	local value = self._values[p]
	table.remove(self._keys, table.find(self._keys, p))
	self._present[p] = nil
	self._values[p] = nil
	return value
end

function LinkedHashMap:get(p)
	return self._values[p]
end

function LinkedHashMap:containsKey(p): boolean
	return self._present[p] ~= nil
end

function LinkedHashMap:size()
	return #self._keys
end

function LinkedHashMap:isEmpty(): boolean
	return #self._keys == 0
end

function LinkedHashMap:entrySet()
	local keys = self._keys
	local values = self._values
	local count = 0
	return function()
		count += 1
		local key = keys[count]

		if key == nil then
			return nil, nil
		end

		return key, values[key]
	end
end

return LinkedHashMap
