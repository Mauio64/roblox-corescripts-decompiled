local function strict(t1: {[any]: any}, s1: string?) -- line: 2
	local v6 = s1 or tostring(t1)

	return (setmetatable(t1, {
		__index = function(_, p2) -- line: 6
			-- upvalues: v6 (copy)
			local v27 = ("%q (%s) is not a valid member of %s"):format(tostring(p2), typeof(p2), v6)

			error(v27, 2)
		end,
		__newindex = function(_, p4, _) -- line: 12
			-- upvalues: v6 (copy)
			local v31 = ("%q (%s) is not a valid member of %s"):format(tostring(p4), typeof(p4), v6)

			error(v31, 2)
		end
	}))
end
local function addEnumValue(p6, p7, p8, p9, p10) -- line: 20
	-- upvalues: strict (copy)
	local v12 = typeof(p9) == "string"

	assert(v12, "Only string names are supported for enums!")

	if v12 then
		assert(p9 ~= "fromRawValue", "fromRawValue is reserved")
		assert(p9 ~= "isEnumValue", "isEnumValue is reserved")
		assert(p9 ~= "allValues", "allValues is reserved")
	end

	assert(p6[p9] == nil, "Enum value names can only be used once!")
	assert(p7[p9] == nil, "Enum values can only be used once!")

	local v13 = newproxy(true)
	local mt = getmetatable(v13)

	function mt.__tostring() -- line: 34
		-- upvalues: p8 (copy), p9 (copy)
		return ("%s.%s"):format(p8, p9)
	end

	mt.__index = strict({
		rawValue = function() -- line: 39
			-- upvalues: p10 (copy)
			return p10
		end
	})
	p6[p9] = v13
	p7[p10] = v13
end
local function enumerate(p11, t2: {[any]: any}) -- line: 51
	-- upvalues: addEnumValue (copy), strict (copy)
	assert(typeof(p11) == "string", "Bad argument #1 - enums must be created using a string name!")
	assert(typeof(t2) == "table", "Bad argument #2 - enums must be created using a table!")

	local t3 = {}
	local t4 = {}

	if t2[1] ~= nil then
		for _, v in ipairs(t2) do
			addEnumValue(t3, t4, p11, v, v)
		end
	else
		for k, v in pairs(t2) do
			addEnumValue(t3, t4, p11, k, v)
		end
	end

	function t3.fromRawValue(p12) -- line: 69
		-- upvalues: t4 (copy)
		return t4[p12]
	end
	function t3.isEnumValue(p13) -- line: 73
		-- upvalues: t3 (copy)
		if typeof(p13) ~= "userdata" then
			return false
		end

		for _, v in pairs(t3) do
			if v == p13 then
				return true
			end
		end

		return false
	end
	function t3.allValues() -- line: 87
		-- upvalues: t4 (copy)
		local t5 = {}

		for _, v in pairs(t4) do
			table.insert(t5, v)
		end

		return t5
	end

	local v23 = newproxy(true)
	local mt = getmetatable(v23)

	mt.__index = strict(t3, p11)

	function mt.__tostring() -- line: 100
		-- upvalues: p11 (copy)
		return p11
	end

	return v23
end

return enumerate
