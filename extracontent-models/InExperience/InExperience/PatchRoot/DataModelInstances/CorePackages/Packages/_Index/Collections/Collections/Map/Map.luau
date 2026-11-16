local __DEV__ = _G.__DEV__
local parent = script.Parent.Parent
local parent2 = parent.Parent

local forEach = require(parent.Array.forEach)
local map = require(parent.Array.map)
local isArray = require(parent.Array.isArray)
local InstanceOf = require(parent2.InstanceOf)
require(parent2.ES7Types)

local Map = {}

function Map:new()
	local array = nil
	local map2 = nil

	if self == nil then
		array = {}
		map2 = {}
	elseif isArray(self) then
		if __DEV__ and #self > 0 and typeof(self[1]) ~= "table" then
			error("Value `" .. typeof(self[1]) .. "` is not an entry object.\n Cannot create Map from {K, V} form, it must be { {K, V}... }")
		end

		array = table.create(#self)
		map2 = {}

		for _, v in self do
			local v2 = v[1]

			if __DEV__ and v2 == nil then
				error("cannot create Map from a table that isn't an array.")
			end

			local v3 = v[2]

			if map2[v2] == nil then
				table.insert(array, v2)
			end

			map2[v2] = v3
		end
	elseif InstanceOf(self, Map) then
		array = table.clone(self._array)
		map2 = table.clone(self._map)
	else
		error(("`%s` `%s` is not iterable, cannot make Map using it"):format(typeof(self), (tostring(self))))
	end

	return (setmetatable({
		size = #array,
		_map = map2,
		_array = array
	}, Map))
end

function Map:set(p, p2)
	if self._map[p] == nil then
		self.size += 1
		table.insert(self._array, p)
	end

	self._map[p] = p2
	return self
end

function Map:get(p)
	return self._map[p]
end

function Map:clear()
	local table = table
	self.size = 0
	table.clear(self._map)
	table.clear(self._array)
end

function Map:delete(p): boolean
	if self._map[p] == nil then
		return false
	end

	self.size -= 1
	self._map[p] = nil
	local index = table.find(self._array, p)

	if index then
		table.remove(self._array, index)
	end

	return true
end

function Map:forEach(callback, p)
	if __DEV__ and typeof(callback) ~= "function" then
		error("callback is not a function")
	end

	forEach(self._array, function(p2)
		local v = self._map[p2]

		if p == nil then
			callback(v, p2, self)
		else
			callback(p, v, p2, self)
		end
	end)
end

function Map:has(p): boolean
	return self._map[p] ~= nil
end

function Map:keys()
	return self._array
end

function Map:values()
	return map(self._array, function(p)
		return self._map[p]
	end)
end

function Map:entries()
	return map(self._array, function(p)
		return { p, self._map[p] }
	end)
end

function Map:ipairs()
	if __DEV__ then
		warn(debug.traceback(
			"`for _,_ in myMap:ipairs() do` is deprecated and will be removed in a future release, please use `for _,_ in myMap do` instead\n",
			2
		))
	end

	return ipairs(self:entries())
end

function Map:__iter()
	return next, self:entries()
end

function Map.__index(p, p2)
	local v = rawget(Map, p2)

	if v ~= nil then
		return v
	end

	if __DEV__ then
		assert(
			rawget(p, "_map"),
			"Map has been corrupted, and is missing private state! Did you accidentally call table.clear() instead of map:clear()?"
		)
	end

	return Map.get(p, p2)
end

function Map:__newindex(p, p2)
	self:set(p, p2)
end

return Map
