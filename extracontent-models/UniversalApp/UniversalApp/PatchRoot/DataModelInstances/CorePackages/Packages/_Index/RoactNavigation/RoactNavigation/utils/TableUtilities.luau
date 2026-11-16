local TableUtilities = {}
local v = {}

local function makeKeyString(value) -- 3 equivalent calls inferred from this helper
	if type(value) == "string" then
		return string.format("%s", value)
	end

	return string.format("[%s]", (tostring(value)))
end

local function makeValueString(p)
	local typeName = type(p)

	if typeName == "string" then
		return string.format("%q", p)
	end

	if typeName == "function" or typeName == "table" then
		return string.format("<%s>", (tostring(p)))
	end

	return string.format("%s", (tostring(p)))
end

local function printKeypair(value, item, p, p2)
	local keyString = makeKeyString(value) -- inferred equivalent call
	local valueString = makeValueString(item)

	local v2 = not p2 and "" or string.format(" -- %s", p2)
	print(string.format("%s%s = %s,%s", p, keyString, valueString, v2))
end

function TableUtilities.ShallowEqual(items, items2, p): boolean
	if not (items and items2) then
		return false
	end

	if items == items2 then
		return true
	end

	local v2 = p or v

	for k, item in items do
		if items2[k] ~= item and not v2[k] then
			return false
		end
	end

	for k, item in items2 do
		if items[k] ~= item and not v2[k] then
			return false
		end
	end

	return true
end

local function formatDeepEqualMessage(value, value2)
	if value2 == 0 then
		return value:gsub("{1}", "first"):gsub("{2}", "second")
	end

	return value
end

function TableUtilities.DeepEqual(items, items2, value)
	value = value or 0

	if items == items2 then
		return true
	end

	if typeof(items) ~= typeof(items2) then
		return
			false,
			formatDeepEqualMessage(
				("{1} is of type %s, but {2} is of type %s"):format(typeof(items), (typeof(items2))),
				value
			)
	end

	if typeof(items) ~= "table" then
		return false, formatDeepEqualMessage("{1} ~= {2}", value)
	end

	local set = {}

	for k, item in items do
		set[k] = true

		local deepEqual, v2 = TableUtilities.DeepEqual(item, items2[k], value + 1)

		if not deepEqual then
			return
				false,
				formatDeepEqualMessage(
					v2:gsub("{1}", ("{1}[%s]"):format((tostring(k)))):gsub("{2}", ("{2}[%s]"):format((tostring(k)))),
					value
				)
		end
	end

	for k, item in items2 do
		if set[k] then
			continue
		end

		local deepEqual, v2 = TableUtilities.DeepEqual(items[k], item, value + 1)

		if not deepEqual then
			return
				false,
				formatDeepEqualMessage(
					v2:gsub("{1}", ("{1}[%s]"):format((tostring(k)))):gsub("{2}", ("{2}[%s]"):format((tostring(k)))),
					value
				)
		end
	end

	return true
end

function TableUtilities.EqualKey(p, p2, p3): boolean
	if p and p2 and p3 and p3 ~= "" and p[p3] and p2[p3] and p[p3] == p2[p3] then
		return true
	end

	return false
end

function TableUtilities.TableDifference(items, p)
	local result = {}

	for k, item in items do
		if p[k] ~= items[k] then
			result[k] = item
		end
	end

	return result
end

local function membershipTable(list) -- 2 equivalent calls inferred from this helper
	local result = {}

	for i = 1, #list do
		result[list[i]] = true
	end

	return result
end

local function listOfKeys(items) -- 1 equivalent call inferred from this helper
	local result = {}

	for k, _ in items do
		table.insert(result, k)
	end

	return result
end

function TableUtilities.ListDifference(list, list2)
	return listOfKeys(TableUtilities.TableDifference(membershipTable(list), membershipTable(list2))) -- inferred equivalent call
end

function TableUtilities.CheckListConsistency(items)
	local v2 = 1
	local v3 = false
	local flag = false
	local v4 = true

	for k, _ in items do
		if type(k) == "string" then
			v3 = true
		else
			if type(k) ~= "number" then
				return false
			end

			if v2 ~= k then
				v4 = false
			end

			flag = true
		end

		if v3 and flag then
			return false
		end

		v2 += 1
	end

	return not flag or v4
end

function TableUtilities.RecursiveToString(items, value)
	local v2 = value or ""

	if type(items) ~= "table" then
		return (tostring(items))
	end

	local v3 = ""

	if not TableUtilities.CheckListConsistency(items) then
		v3 ..= "-- WARNING: this table fails the list consistency test\n"
	end

	local v4 = v3 .. "{\n"

	for k, item in items do
		if type(k) == "string" then
			v4 ..= "  " .. v2 .. tostring(k) .. " = " .. TableUtilities.RecursiveToString(item, "  " .. v2) .. ";\n"
		end

		if type(k) == "number" then
			v4 ..= "  " .. v2 .. TableUtilities.RecursiveToString(item, "  " .. v2) .. ",\n"
		end
	end

	return v4 .. v2 .. "}"
end

function TableUtilities.Print(p, value)
	local v2 = value or "  "

	if type(p) ~= "table" then
		error("TableUtilities.Print must be passed a table", 2)
	end

	local itemsSet = {}
	local function recurse(items, value2, p2)
		itemsSet[items] = true

		local v3 = string.rep(v2, p2)
		local v4 = string.rep(v2, p2 + 1)

		if value2 then
			print(string.format("%s%s = %s {", v3, makeKeyString(value2), makeValueString(items))) -- inferred equivalent call
		else
			print(string.format("%s%s {", v3, makeValueString(items)))
		end

		for k, item in items do
			if type(item) == "table" then
				if itemsSet[item] then
					printKeypair(k, item, v4, "Possible cycle")
				else
					recurse(item, k, p2 + 1)
				end
			else
				local keyString = makeKeyString(k) -- inferred equivalent call
				local valueString = makeValueString(item)

				print(string.format("%s%s = %s,%s", v4, keyString, valueString, ""))
			end
		end

		print(string.format("%s}%s", v3, p2 > 0 and "," or ""))
	end

	recurse(p, nil, 0)
end

function TableUtilities.FieldCount(items)
	local count = 0

	for _ in items do
		count += 1
	end

	return count
end

return TableUtilities
