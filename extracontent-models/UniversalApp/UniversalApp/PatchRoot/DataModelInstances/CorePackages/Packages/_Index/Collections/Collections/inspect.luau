local HttpService = game:GetService("HttpService")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local isArray = require(scriptParent.Array.isArray)

require(scriptParentParent.ES7Types)

local formatValue = nil
local formatObjectValue = nil
local formatArray = nil
local formatObject = nil
local getObjectTag = nil

local function inspect(p1, t1: {[any]: any}?) -- line: 51
	-- upvalues: formatValue (ref)
	local v18 = t1 or {
		depth = 2
	}
	local v19 = v18.depth or 2

	v18.depth = not (v19 >= 0) and 2 or v19

	return formatValue(p1, {}, v18)
end
local function isIndexKey(p2, p3) -- line: 58
	return type(p2) == "number" and (p2 <= p3 and (p2 >= 1 and p2 == math.floor(p2)))
end
local function getTableLength(p4) -- line: 65
	local n1 = 1
	local v24 = rawget(p4, n1)

	while v24 ~= nil do
		n1 += 1
		v24 = rawget(p4, n1)
	end

	return n1 - 1
end
local function sortKeysForPrinting(p5, p6) -- line: 75
	local v27 = type(p5)
	local v28 = type(p6)

	if v27 == v28 and (v27 == "number" or v27 == "string") then
		return p5 < p6
	end

	return v27 < v28
end
local function rawpairs(p7) -- line: 88
	return next, p7, nil
end
local function getFragmentedKeys(p8) -- line: 92
	-- upvalues: sortKeysForPrinting (copy)
	local t2 = {}
	local n2 = 0
	local n3 = 1
	local v34 = rawget(p8, n3)

	while v34 ~= nil do
		n3 += 1
		v34 = rawget(p8, n3)
	end

	local v35 = n3 - 1

	for k, _ in next, p8 do
		if type(k) ~= "number" or (not (k <= v35) or (not (k >= 1) or k ~= math.floor(k))) then
			n2 += 1
			t2[n2] = k
		end
	end

	table.sort(t2, sortKeysForPrinting)

	return t2, n2, v35
end

function formatValue(p9, p10, t3: {[any]: any}) -- line: 106
	-- upvalues: HttpService (copy), formatObjectValue (ref)
	local v41 = typeof(p9)

	if v41 == "string" then
		return HttpService:JSONEncode(p9)
	end

	if v41 == "number" then
		if p9 ~= p9 then
			return "NaN"
		end

		if p9 == 1e999 then
			return "Infinity"
		end

		if p9 == -1e999 then
			return "-Infinity"
		end

		return (tostring(p9))
	end

	if v41 == "function" then
		local s1 = "[function"
		local v43 = debug.info(p9, "n")

		if v43 ~= nil and v43 ~= "" then
			s1 ..= " " .. v43
		end

		return s1 .. "]"
	end

	if v41 == "table" then
		return formatObjectValue(p9, p10, t3)
	end

	return (tostring(p9))
end
function formatObjectValue(p11, p12, t4: {[any]: any}) -- line: 139
	-- upvalues: formatValue (ref), isArray (copy), formatArray (ref), formatObject (ref)
	if table.find(p12, p11) ~= nil then
		return "[Circular]"
	end

	local t5 = { unpack(p12) }

	table.insert(t5, p11)

	if typeof(p11.toJSON) == "function" then
		local v48 = p11:toJSON(p11)

		if v48 ~= p11 then
			if typeof(v48) == "string" then
				return v48
			end

			return formatValue(v48, t5, t4)
		end
	elseif isArray(p11) then
		return formatArray(p11, t5, t4)
	end

	return formatObject(p11, t5, t4)
end
function formatObject(p13, p14, t6: {[any]: any}) -- line: 164
	-- upvalues: getFragmentedKeys (copy), getObjectTag (ref), formatValue (ref)
	local s2 = ""
	local mt = getmetatable(p13)

	if mt and rawget(mt, "__tostring") then
		return (tostring(p13))
	end

	local v54, v55, v56 = getFragmentedKeys(p13)

	if v56 == 0 and v55 == 0 then
		return s2 .. "{}"
	end

	if #p14 > t6.depth then
		return s2 .. "[" .. getObjectTag(p13) .. "]"
	end

	local t7 = {}

	for i = 1, v56 do
		table.insert(t7, (formatValue(p13[i], p14, t6)))
	end

	for i = 1, v55 do
		local v60 = v54[i]

		table.insert(t7, v60 .. ": " .. formatValue(p13[v60], p14, t6))
	end

	return s2 .. "{ " .. table.concat(t7, ", ") .. " }"
end
function formatArray(p15, p16, t8: {[any]: any}) -- line: 200
	-- upvalues: formatValue (ref)
	local v64 = #p15

	if v64 == 0 then
		return "[]"
	end

	if #p16 > t8.depth then
		return "[Array]"
	end

	local v65 = math.min(10, v64)
	local v66 = v64 - v65
	local t9 = {}

	for i = 1, v65 do
		t9[i] = formatValue(p15[i], p16, t8)
	end

	if v66 == 1 then
		table.insert(t9, "... 1 more item")
	elseif v66 > 1 then
		table.insert(t9, ("... %s more items"):format((tostring(v66))))
	end

	return "[" .. table.concat(t9, ", ") .. "]"
end
function getObjectTag(_) -- line: 226
	return "Object"
end

return inspect
