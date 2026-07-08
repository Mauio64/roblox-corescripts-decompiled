local function normalizeType(p1, p2) -- line: 3
	if p2 == type(p1) then
		return p1
	end

	return nil, `Type { p2 } required, got { type(p1) }.`
end
local function prepareValuesForError(t1: {[any]: any}) -- line: 10
	local t2 = {}

	for _, v13 in t1 do
		table.insert(t2, (tostring(v13)))
	end

	return table.concat(t2, ", ")
end
local function normalizeValue(p3, t3: {[any]: any}) -- line: 18
	-- upvalues: prepareValuesForError (copy)
	if table.find(t3, p3) then
		return p3
	end

	return nil, `Expected value to be one of { prepareValuesForError(t3) }, got { p3 }.`
end
local function normalizeString(p4) -- line: 29
	-- upvalues: normalizeType (copy)
	return normalizeType(p4, "string")
end
local function normalizeTable(p5, t4: {[any]: any}) -- line: 37
	local t5 = {}

	if type(p5) == "table" then
		local t6 = {}

		for v23, v24 in t4 do
			local v25 = type(v24) == "table" and v24.required
			local v26 = if type(v24) ~= "table" then v24 else v24.fn
			local v27 = p5[v23]

			if type(v27) == "nil" and not v25 then
				continue
			end

			local v28, v29 = v26(v27)

			if v29 then
				table.insert(t5, `{ v23 } normalization failed with: { v29 }`)
			end

			if v29 and v25 then
				return nil, table.concat(t5, " ")
			end

			t6[v23] = v28
		end

		local v30 = nil

		if next(t5) then
			v30 = table.concat(t5, " ")
		end

		return t6, v30
	end

	return nil, `Type table required, got { type(p5) }.`
end
local function normalizeList(p6, p7: ((...any) -> ...any)) -- line: 85
	if type(p6) == "table" then
		local t7 = {}
		local t8 = {}

		for v35, v36 in p6 do
			local v37, v38 = p7(v36)

			if v38 then
				table.insert(t7, `{ v35 } normalization failed with: { v38 }`)
			end

			if v37 then
				table.insert(t8, v37)
			end
		end

		local v39 = nil

		if next(t7) then
			v39 = table.concat(t7, " ")
		end

		return t8, v39
	end

	return nil, `Type table required, got { type(p6) }.`
end
local function normalizeUnion(p8, t9: {[any]: any}) -- line: 107
	for _, v43 in t9 do
		local v44, _ = v43(p8)

		if v44 then
			return v44
		end
	end

	return nil, "Value did not match any union."
end

return {
	normalizeType = normalizeType,
	normalizeValue = normalizeValue,
	normalizeBoolean = function(p9) -- line: 25
		-- upvalues: normalizeType (copy)
		return normalizeType(p9, "boolean")
	end,
	normalizeString = normalizeString,
	normalizeNumber = function(p10) -- line: 33
		-- upvalues: normalizeType (copy)
		return normalizeType(p10, "number")
	end,
	normalizeTable = normalizeTable,
	normalizeList = normalizeList,
	normalizeUnion = normalizeUnion,
	normalizeStringToBoolean = function(s1: string?) -- line: 118
		if s1 then
			return s1 == "true"
		end

		return nil, "value is nil"
	end,
	makeNormalizeTableFn = function(t10: {[any]: any}) -- line: 125
		-- upvalues: normalizeTable (copy)
		return function(p11) -- line: 128
			-- upvalues: normalizeTable (copy), t10 (copy)
			return normalizeTable(p11, t10)
		end
	end,
	makeNormalizeListFn = function(p12: ((...any) -> ...any)) -- line: 133
		-- upvalues: normalizeList (copy)
		return function(p13) -- line: 134
			-- upvalues: normalizeList (copy), p12 (copy)
			return normalizeList(p13, p12)
		end
	end,
	makeNormalizeUnionFn = function(t11: {[any]: any}) -- line: 139
		-- upvalues: normalizeUnion (copy)
		return function(p14) -- line: 140
			-- upvalues: normalizeUnion (copy), t11 (copy)
			return normalizeUnion(p14, t11)
		end
	end,
	makeNormalizeValueFn = function(p15) -- line: 145
		-- upvalues: normalizeValue (copy)
		return function(p16) -- line: 146
			-- upvalues: normalizeValue (copy), p15 (copy)
			return normalizeValue(p16, p15)
		end
	end,
	makeRequired = function(p17: ((...any) -> ...any)) -- line: 151
		return {
			required = true,
			fn = p17
		}
	end,
	normalizeNotEmptyString = function(p18) -- line: 156
		-- upvalues: normalizeString (copy)
		if p18 == nil or p18 == "" then
			return nil, nil
		end

		return normalizeString(p18)
	end
}
