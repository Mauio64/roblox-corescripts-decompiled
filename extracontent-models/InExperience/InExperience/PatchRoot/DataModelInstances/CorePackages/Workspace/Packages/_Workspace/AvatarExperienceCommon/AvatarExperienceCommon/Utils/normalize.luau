local function normalizeType(p, p2)
	if type(p) == p2 then
		return p
	end

	return nil, `Type {p2} required, got {type(p)}.`
end

local function prepareValuesForError(list)
	local v = {}

	for _, item in list do
		table.insert(v, (tostring(item)))
	end

	return table.concat(v, ", ")
end

local function normalizeValue(p, list)
	if table.find(list, p) then
		return p
	end

	return nil, `Expected value to be one of {prepareValuesForError(list)}, got {p}.`
end

local function normalizeString(p)
	return normalizeType(p, "string")
end

local function normalizeTable(p, items)
	local v = {}

	if type(p) ~= "table" then
		return nil, `Type table required, got {type(p)}.`
	end

	local result = {}

	for k, fn in items do
		local v2 = type(fn) == "table" and fn.required

		if type(fn) == "table" then
			fn = fn.fn
		end

		local v3 = p[k]

		if not (type(v3) ~= "nil" or v2) then
			continue
		end

		local v4, v5 = fn(v3)

		if v5 then
			table.insert(v, `{k} normalization failed with: {v5}`)
		end

		if v5 and v2 then
			return nil, table.concat(v, " ")
		end

		result[k] = v4
	end

	local v2

	if next(v) then
		v2 = table.concat(v, " ")
	end

	return result, v2
end

local function normalizeList(items, callback)
	if type(items) ~= "table" then
		return nil, `Type table required, got {type(items)}.`
	end

	local v = {}
	local result = {}

	for k, item in items do
		local v2, v3 = callback(item)

		if v3 then
			table.insert(v, `{k} normalization failed with: {v3}`)
		end

		if v2 then
			table.insert(result, v2)
		end
	end

	local v2

	if next(v) then
		v2 = table.concat(v, " ")
	end

	return result, v2
end

local function normalizeUnion(p, items)
	for _, item in items do
		local v, _ = item(p)

		if v then
			return v
		end
	end

	return nil, "Value did not match any union."
end

local Normalize = {}
Normalize.normalizeType = normalizeType
Normalize.normalizeValue = normalizeValue

function Normalize.normalizeBoolean(p)
	return normalizeType(p, "boolean")
end

Normalize.normalizeString = normalizeString

function Normalize.normalizeNumber(p)
	return normalizeType(p, "number")
end

Normalize.normalizeTable = normalizeTable
Normalize.normalizeList = normalizeList
Normalize.normalizeUnion = normalizeUnion

function Normalize.normalizeStringToBoolean(p: string?)
	if p then
		return p == "true"
	end

	return nil, "value is nil"
end

function Normalize.makeNormalizeTableFn(p)
	return function(p2)
		return normalizeTable(p2, p)
	end
end

function Normalize.makeNormalizeListFn(callback)
	return function(p)
		return normalizeList(p, callback)
	end
end

function Normalize.makeNormalizeUnionFn(p)
	return function(p2)
		return normalizeUnion(p2, p)
	end
end

function Normalize.makeNormalizeValueFn(p)
	return function(p2)
		return normalizeValue(p2, p)
	end
end

function Normalize.makeRequired(fn)
	return { fn = fn, required = true }
end

function Normalize.normalizeNotEmptyString(p)
	if p == nil or p == "" then
		return nil, nil
	end

	return normalizeString(p)
end

return Normalize
