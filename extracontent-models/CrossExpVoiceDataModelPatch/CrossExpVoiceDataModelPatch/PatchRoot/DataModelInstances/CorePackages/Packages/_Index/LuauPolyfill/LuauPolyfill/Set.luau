local parent = script.Parent

local isArray = require(parent.Array.isArray)
local fromString = require(parent.Array.from.fromString)
local forEach = require(parent.Array.forEach)
require(parent.types)

local inspect = require(parent.util.inspect)

local Set = {
	__iter = function(p)
		return next, p._array
	end,
	__tostring = function(p)
		local v = "Set "

		if #p._array > 0 then
			v ..= "(" .. tostring(#p._array) .. ") "
		end

		return v .. inspect(p._array)
	end
}

Set.__index = Set

function Set.new(value)
	local set = {}
	local array

	if value == nil then
		array = {}
	else
		local v = nil

		if typeof(value) == "table" then
			if isArray(value) then
				v = table.clone(value)
			else
				local metatable = getmetatable(value)

				if metatable and rawget(metatable, "__iter") then
					v = value
				elseif _G.__DEV__ then
					error("cannot create array from an object-like table")
				end
			end
		elseif typeof(value) == "string" then
			v = fromString(value)
		else
			error(("cannot create array from value of type `%s`"):format((typeof(value))))
		end

		if v then
			array = table.create(#v)

			for _, v2 in v do
				if set[v2] then
					continue
				end

				set[v2] = true
				table.insert(array, v2)
			end
		else
			array = {}
		end
	end

	return (setmetatable({
		size = #array,
		_map = set,
		_array = array
	}, Set))
end

function Set:add(p)
	if not self._map[p] then
		self.size += 1
		self._map[p] = true
		table.insert(self._array, p)
	end

	return self
end

function Set:clear()
	self.size = 0
	table.clear(self._map)
	table.clear(self._array)
end

function Set:delete(p): boolean
	if not self._map[p] then
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

function Set:forEach(callback, p)
	if typeof(callback) ~= "function" then
		error("callback is not a function")
	end

	forEach(self._array, function(p2)
		if p == nil then
			callback(p2, p2, self)
		else
			callback(p, p2, p2, self)
		end
	end)
end

function Set:has(p): boolean
	return self._map[p] ~= nil
end

function Set:ipairs()
	if _G.__DEV__ then
		warn(debug.traceback(
			"`for _,_ in mySet:ipairs() do` is deprecated and will be removed in a future release, please use `for _,_ in mySet do` instead\n",
			2
		))
	end

	return ipairs(self._array)
end

return Set
