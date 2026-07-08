local ParentParent = script.Parent.Parent

require(ParentParent.types)

local HttpService = game:GetService("HttpService")
local isArray = require(ParentParent.Array.isArray)
local formatValue = nil
local formatObjectValue = nil
local formatArray = nil
local formatObject = nil
local getObjectTag = nil

local function inspect(p1, t1: {[any]: any}?) -- line: 35
	-- upvalues: formatValue (ref)
	local v17 = t1 or {
		depth = 2
	}
	local v18 = v17.depth or 2

	v17.depth = not (v18 >= 0) and 2 or v18

	return formatValue(p1, {}, v17)
end
local function isIndexKey(p2, p3) -- line: 42
	return type(p2) == "number" and (p2 <= p3 and (p2 >= 1 and p2 == math.floor(p2)))
end
local function getTableLength(p4) -- line: 49
	local n1 = 1
	local v23 = rawget(p4, n1)

	while v23 ~= nil do
		n1 += 1
		v23 = rawget(p4, n1)
	end

	return n1 - 1
end
local function sortKeysForPrinting(p5, p6) -- line: 59
	local v26 = type(p5)
	local v27 = type(p6)

	if v26 == v27 and (v26 == "number" or v26 == "string") then
		return p5 < p6
	end

	return v26 < v27
end
local function rawpairs(p7) -- line: 72
	return next, p7, nil
end
local function getFragmentedKeys(p8) -- line: 76
	-- upvalues: sortKeysForPrinting (copy)
	local t2 = {}
	local n2 = 0
	local n3 = 1
	local v33 = rawget(p8, n3)

	while v33 ~= nil do
		n3 += 1
		v33 = rawget(p8, n3)
	end

	local v34 = n3 - 1

	for k, _ in next, p8 do
		if type(k) ~= "number" or (not (k <= v34) or (not (k >= 1) or k ~= math.floor(k))) then
			n2 += 1
			t2[n2] = k
		end
	end

	table.sort(t2, sortKeysForPrinting)

	return t2, n2, v34
end

function formatValue(p9, p10, t3: {[any]: any}) -- line: 90
	-- upvalues: HttpService (copy), formatObjectValue (ref)
	local v40 = typeof(p9)

	if v40 == "string" then
		return HttpService:JSONEncode(p9)
	end

	if v40 == "number" then
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

	if v40 == "function" then
		local s1 = "[function"
		local v42 = debug.info(p9, "n")

		if v42 ~= nil and v42 ~= "" then
			s1 ..= " " .. v42
		end

		return s1 .. "]"
	end

	if v40 == "table" then
		return formatObjectValue(p9, p10, t3)
	end

	return (tostring(p9))
end
function formatObjectValue(p11, p12, t4: {[any]: any}) -- line: 123
	-- upvalues: formatValue (ref), isArray (copy), formatArray (ref), formatObject (ref)
	if table.find(p12, p11) ~= nil then
		return "[Circular]"
	end

	local t5 = { unpack(p12) }

	table.insert(t5, p11)

	if typeof(p11.toJSON) == "function" then
		local v47 = p11:toJSON(p11)

		if v47 ~= p11 then
			if typeof(v47) == "string" then
				return v47
			end

			return formatValue(v47, t5, t4)
		end
	elseif isArray(p11) then
		return formatArray(p11, t5, t4)
	end

	return formatObject(p11, t5, t4)
end
function formatObject(p13, p14, t6: {[any]: any}) -- line: 148
	-- upvalues: getFragmentedKeys (copy), getObjectTag (ref), formatValue (ref)
	local s2 = ""
	local mt = getmetatable(p13)

	if mt and rawget(mt, "__tostring") then
		return (tostring(p13))
	end

	local v53, v54, v55 = getFragmentedKeys(p13)

	if v55 == 0 and v54 == 0 then
		return s2 .. "{}"
	end

	if #p14 > t6.depth then
		return s2 .. "[" .. getObjectTag(p13) .. "]"
	end

	local t7 = {}

	for i = 1, v55 do
		table.insert(t7, (formatValue(p13[i], p14, t6)))
	end

	for i = 1, v54 do
		local v59 = v53[i]

		table.insert(t7, v59 .. ": " .. formatValue(p13[v59], p14, t6))
	end

	return s2 .. "{ " .. table.concat(t7, ", ") .. " }"
end
function formatArray(p15, p16, t8: {[any]: any}) -- line: 184
	-- upvalues: formatValue (ref)
	local v63 = #p15

	if v63 == 0 then
		return "[]"
	end

	if #p16 > t8.depth then
		return "[Array]"
	end

	local v64 = math.min(10, v63)
	local v65 = v63 - v64
	local t9 = {}

	for i = 1, v64 do
		t9[i] = formatValue(p15[i], p16, t8)
	end

	if v65 == 1 then
		table.insert(t9, "... 1 more item")
	elseif v65 > 1 then
		table.insert(t9, ("... %s more items"):format((tostring(v65))))
	end

	return "[" .. table.concat(t9, ", ") .. "]"
end
function getObjectTag(_) -- line: 210
	return "Object"
end

return inspect
