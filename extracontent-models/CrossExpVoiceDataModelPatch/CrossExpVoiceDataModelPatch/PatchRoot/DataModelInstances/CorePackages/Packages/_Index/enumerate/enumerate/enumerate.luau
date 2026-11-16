local function strict(p, p2: string?)
	local v = p2 or tostring(p)

	return (setmetatable(p, {
		__index = function(_, p3)
			local formatted = ("%q (%s) is not a valid member of %s"):format(tostring(p3), typeof(p3), v)

			error(formatted, 2)
		end,
		__newindex = function(_, p3, _)
			local formatted = ("%q (%s) is not a valid member of %s"):format(tostring(p3), typeof(p3), v)

			error(formatted, 2)
		end
	}))
end

local function addEnumValue(p, p2, value, value2, item)
	local v = typeof(value2) == "string"
	assert(v, "Only string names are supported for enums!")

	if v then
		assert(value2 ~= "fromRawValue", "fromRawValue is reserved")
		assert(value2 ~= "isEnumValue", "isEnumValue is reserved")
		assert(value2 ~= "allValues", "allValues is reserved")
	end

	assert(p[value2] == nil, "Enum value names can only be used once!")
	assert(p2[value2] == nil, "Enum values can only be used once!")

	local v2 = newproxy(true)
	local metatable = getmetatable(v2)

	function metatable.__tostring()
		return ("%s.%s"):format(value, value2)
	end

	metatable.__index = strict({
		rawValue = function()
			return item
		end
	})

	p[value2] = v2
	p2[item] = v2
end

local function enumerate(value, list)
	assert(typeof(value) == "string", "Bad argument #1 - enums must be created using a string name!")
	assert(typeof(list) == "table", "Bad argument #2 - enums must be created using a table!")

	local v = {}
	local v2 = {}

	if list[1] == nil then
		for k, item in pairs(list) do
			addEnumValue(v, v2, value, k, item)
		end
	else
		for _, item in ipairs(list) do
			addEnumValue(v, v2, value, item, item)
		end
	end

	function v.fromRawValue(p)
		return v2[p]
	end

	function v.isEnumValue(p): boolean
		if typeof(p) ~= "userdata" then
			return false
		end

		for _, v3 in pairs(v) do
			if v3 == p then
				return true
			end
		end

		return false
	end

	function v.allValues()
		local result = {}

		for _, v3 in pairs(v2) do
			table.insert(result, v3)
		end

		return result
	end

	local v3 = newproxy(true)
	local metatable = getmetatable(v3)
	metatable.__index = strict(v, value)
	function metatable.__tostring()
		return value
	end

	return v3
end

return enumerate
