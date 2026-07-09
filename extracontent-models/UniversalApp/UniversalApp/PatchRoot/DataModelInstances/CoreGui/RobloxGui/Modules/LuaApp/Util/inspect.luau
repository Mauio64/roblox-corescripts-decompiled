local HttpService = game:GetService("HttpService")
local isArray = require(script.Parent.isArray)
local objectKeys = require(script.Parent.objectKeys)
local formatValue = nil
local formatObjectValue = nil
local formatArray = nil
local formatObject = nil
local getObjectTag = nil

local function find(p1, p2) -- line: 17
	for i = 1, #p1 do
		if p2 == p1[i] then
			return i
		end
	end

	return nil
end

function formatValue(p3, p4) -- line: 33
	-- upvalues: HttpService (copy), formatObjectValue (ref)
	local v16 = typeof(p3)

	if v16 == "string" then
		return HttpService:JSONEncode(p3)
	end

	if v16 == "number" then
		if p3 ~= p3 then
			return "NaN"
		end

		if p3 == 1e999 then
			return "Infinity"
		end

		if p3 == -1e999 then
			return "-Infinity"
		end

		return (tostring(p3))
	end

	if v16 == "function" then
		return "[function]"
	end

	if v16 == "table" then
		return formatObjectValue(p3, p4)
	end

	return (tostring(p3))
end
function formatObjectValue(p5, p6) -- line: 56
	-- upvalues: formatValue (ref), isArray (copy), formatArray (ref), formatObject (ref)
	local g21 = nil
	local v20 = nil

	for i = 1, #p6 do
		if p5 == p6[i] then
			v20 = i
			g21 = true
		end

		if g21 then
			break
		end
	end

	if not g21 then
		v20 = nil
	end

	g21 = false

	if v20 ~= nil then
		return "[Circular]"
	end

	local t1 = { unpack(p6) }

	table.insert(t1, p5)

	if typeof(p5.toJSON) == "function" then
		local v23 = p5:toJSON(p5)

		if v23 ~= p5 then
			if typeof(v23) == "string" then
				return v23
			end

			return formatValue(v23, t1)
		end
	elseif isArray(p5) then
		return formatArray(p5, t1)
	end

	return formatObject(p5, t1)
end
function formatObject(p7, p8) -- line: 81
	-- upvalues: objectKeys (copy), getObjectTag (ref), formatValue (ref)
	local v26 = objectKeys(p7)

	if #v26 == 0 then
		return "{}"
	end

	if #p8 > 3 then
		return "[" .. getObjectTag(p7) .. "]"
	end

	local t2 = {}

	for i = 1, #v26 do
		local v29 = v26[i]

		t2[i] = v29 .. ": " .. formatValue(p7[v29], p8)
	end

	return "{ " .. table.concat(t2, ", ") .. " }"
end
function formatArray(p9, p10) -- line: 102
	-- upvalues: formatValue (ref)
	local v32 = #p9

	if v32 == 0 then
		return "[]"
	end

	if #p10 > 3 then
		return "[Array]"
	end

	local v33 = math.min(3, v32)
	local v34 = v32 - v33
	local t3 = {}

	for i = 1, v33 do
		t3[i] = formatValue(p9[i], p10)
	end

	if v34 == 1 then
		table.insert(t3, "... 1 more item")
	elseif v34 > 1 then
		table.insert(t3, ("... %s more items"):format(v34))
	end

	return "[" .. table.concat(t3, ", ") .. "]"
end
function getObjectTag(_) -- line: 128
	return "Object"
end

return {
	inspect = function(p12) -- line: 29
		-- upvalues: formatValue (ref)
		return formatValue(p12, {})
	end
}
