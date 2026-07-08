local HttpService = game:GetService("HttpService")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local ParentParent = scriptParent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local null = require(scriptParentParent.luaUtils.null)
local formatValue = nil
local formatObjectValue = nil
local formatArray = nil
local formatObject = nil
local getObjectTag = nil

function formatValue(p1, p2) -- line: 37
	-- upvalues: HttpService (copy), null (copy), formatObjectValue (ref)
	local v17 = typeof(p1)

	if v17 == "string" then
		return HttpService:JSONEncode(p1)
	end

	if v17 == "number" then
		if p1 ~= p1 then
			return "NaN"
		end

		if p1 == 1e999 then
			return "Infinity"
		end

		if p1 == -1e999 then
			return "-Infinity"
		end

		return (tostring(p1))
	end

	if v17 == "function" then
		return "[function]"
	end

	if v17 == "table" then
		if p1 == null then
			return "null"
		end

		return formatObjectValue(p1, p2)
	end

	return (tostring(p1))
end
function formatObjectValue(p3, p4) -- line: 65
	-- upvalues: formatValue (ref), Array (copy), formatArray (ref), formatObject (ref)
	if table.find(p4, p3) ~= nil then
		return "[Circular]"
	end

	local t1 = { unpack(p4) }

	table.insert(t1, p3)

	if typeof(p3.toJSON) == "function" then
		local v21 = p3:toJSON(p3)

		if v21 ~= p3 then
			if typeof(v21) == "string" then
				return v21
			end

			return formatValue(v21, t1)
		end
	elseif Array.isArray(p3) then
		return formatArray(p3, t1)
	end

	return formatObject(p3, t1)
end
function formatObject(p5, p6) -- line: 90
	-- upvalues: Object (copy), getObjectTag (ref), formatValue (ref)
	local v24 = Object.keys(p5)

	if #v24 == 0 then
		return "{}"
	end

	if #p6 > 2 then
		return "[" .. getObjectTag(p5) .. "]"
	end

	local t2 = {}

	for i = 1, #v24 do
		local v27 = v24[i]

		t2[i] = v27 .. ": " .. formatValue(p5[v27], p6)
	end

	return "{ " .. table.concat(t2, ", ") .. " }"
end
function formatArray(p7, p8) -- line: 111
	-- upvalues: formatValue (ref)
	local v30 = #p7

	if v30 == 0 then
		return "[]"
	end

	if #p8 > 2 then
		return "[Array]"
	end

	local v31 = math.min(10, v30)
	local v32 = v30 - v31
	local t3 = {}

	for i = 1, v31 do
		t3[i] = formatValue(p7[i], p8)
	end

	if v32 == 1 then
		table.insert(t3, "... 1 more item")
	elseif v32 > 1 then
		table.insert(t3, ("... %d more items"):format(v32))
	end

	return "[" .. table.concat(t3, ", ") .. "]"
end
function getObjectTag(_) -- line: 137
	return "Object"
end

return {
	inspect = function(p10) -- line: 33
		-- upvalues: formatValue (ref)
		return formatValue(p10, {})
	end
}
