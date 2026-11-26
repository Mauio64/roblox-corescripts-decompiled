local function normalizeType(p2, p3)
	if type(p2) == p3 then
		return p2
	end

	return nil, `Type {p3} required, got {type(p2)}.`
end

local function prepareValuesForError(list)
	local v5 = {}

	for k, item in list do
		table.insert(v5, (tostring(item)))
	end

	return table.concat(v5, ", ")
end

local function normalizeValue(p2, list)
	if table.find(list, p2) then
		return p2
	end

	return nil, `Expected value to be one of {prepareValuesForError(list)}, got {p2}.`
end

local function normalizeString(p2)
	return normalizeType(p2, "string")
end

local function normalizeTable(p2, items)
	local v5 = {}

	if type(p2) ~= "table" then
		return nil, `Type table required, got {type(p2)}.`
	end

	local result = {}

	for k, fn in items do
		local v6 = type(fn) == "table" and fn.required

		if type(fn) == "table" then
			fn = fn.fn
		end

		local v7 = p2[k]

		if not (type(v7) ~= "nil" or v6) then
			continue
		end

		local v8, v9 = fn(v7)

		if v9 then
			table.insert(v5, `{k} normalization failed with: {v9}`)
		end

		if v9 and v6 then
			return nil, table.concat(v5, " ")
		end

		result[k] = v8
	end

	local v6 = if next(v5) then table.concat(v5, " ") else nil

	return result, v6
end

local function normalizeList(items, callback)
	if type(items) ~= "table" then
		return nil, `Type table required, got {type(items)}.`
	end

	local v5 = {}
	local result = {}

	for k, item in items do
		local v6, v7 = callback(item)

		if v7 then
			table.insert(v5, `{k} normalization failed with: {v7}`)
		end

		if v6 then
			table.insert(result, v6)
		end
	end

	local v6 = if next(v5) then table.concat(v5, " ") else nil

	return result, v6
end

local function normalizeUnion(p2, items)
	for k, item in items do
		local v5, v6 = item(p2)

		if v5 then
			return v5
		end
	end

	return nil, "Value did not match any union."
end

return {
	normalizeType = normalizeType,
	normalizeValue = normalizeValue,
	normalizeBoolean = function(p2)
		return normalizeType(p2, "boolean")
	end,
	normalizeString = normalizeString,
	normalizeNumber = function(p2)
		return normalizeType(p2, "number")
	end,
	normalizeTable = normalizeTable,
	normalizeList = normalizeList,
	normalizeUnion = normalizeUnion,
	normalizeStringToBoolean = function(p2)
		if p2 then
			return p2 == "true"
		end

		return nil, "value is nil"
	end,
	makeNormalizeTableFn = function(p2)
		return function(p3)
			return normalizeTable(p3, p2)
		end
	end,
	makeNormalizeListFn = function(p2)
		return function(p3)
			return normalizeList(p3, p2)
		end
	end,
	makeNormalizeUnionFn = function(p2)
		return function(p3)
			return normalizeUnion(p3, p2)
		end
	end,
	makeNormalizeValueFn = function(p2)
		return function(p3)
			return normalizeValue(p3, p2)
		end
	end,
	makeRequired = function(p2)
		return { fn = p2, required = true }
	end,
	normalizeNotEmptyString = function(p2)
		if p2 == nil or p2 == "" then
			return nil, nil
		end

		return normalizeString(p2)
	end
}
