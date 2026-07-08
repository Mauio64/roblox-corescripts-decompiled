local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local instanceof = LuauPolyfill.instanceof
local Error = LuauPolyfill.Error
local t1 = {}
local formatValue = nil
local formatObjectValue = nil
local formatArray = nil
local isJSONable = nil
local formatObject = nil
local getObjectTag = nil
local GraphQLError = require(ParentParent.GraphQL).GraphQLError
local isAggregateError = require(script.Parent.AggregateError).isAggregateError

function t1.inspect(p1) -- line: 40
	-- upvalues: formatValue (ref)
	return formatValue(p1, {})
end
function formatValue(p2, p3) -- line: 46
	-- upvalues: Boolean (copy), formatObjectValue (ref)
	local v21 = typeof(p2)

	if v21 == "string" then
		return "\"" .. p2 .. "\""
	end

	if v21 == "function" then
		local v22 = debug.info(p2, "n")

		if Boolean.toJSBoolean(v22) then
			return (("[function %s]"):format(v22))
		end

		return "[function]"
	end

	if v21 == "table" then
		return formatObjectValue(p2, p3)
	end

	return (tostring(p2))
end

local function formatError(p4) -- line: 75
	-- upvalues: instanceof (copy), GraphQLError (copy)
	if instanceof(p4, GraphQLError) then
		return (tostring(p4))
	end

	return ("%s: %s;\n %s"):format(tostring(p4.name), tostring(p4.message), (tostring(p4.stack)))
end

function formatObjectValue(p5, p6) -- line: 83
	-- upvalues: instanceof (copy), Error (copy), isAggregateError (copy), GraphQLError (copy), formatArray (ref), formatError (copy), Boolean (copy), Array (copy), isJSONable (ref), formatValue (ref), formatObject (ref)
	if p5 == nil then
		return "null"
	end

	if instanceof(p5, Error) then
		if isAggregateError(p5) then
			return ((if not instanceof(p5, GraphQLError) then ("%s: %s;\n %s"):format(tostring(p5.name), tostring(p5.message), (tostring(p5.stack))) else tostring(p5))) .. "\n" .. formatArray(p5.errors, p6)
		end

		return formatError(p5)
	end

	if Boolean.toJSBoolean(Array.includes(p6, p5)) then
		return "[Circular]"
	end

	local v26 = Array.concat({}, p6, { p5 })

	if Boolean.toJSBoolean(isJSONable(p5)) then
		local v27 = p5:toJSON()

		if v27 ~= p5 then
			if typeof(v27) == "string" then
				return v27
			end

			return (formatValue(v27, v26))
		end
	elseif Boolean.toJSBoolean(Array.isArray(p5)) then
		return formatArray(p5, v26)
	end

	return formatObject(p5, v26)
end
function isJSONable(p7) -- line: 139
	return typeof(p7.toJSON) == "function"
end
function formatObject(p8, p9) -- line: 147
	-- upvalues: Object (copy), getObjectTag (ref), Array (copy), formatValue (ref)
	local v31 = Object.entries(p8)

	if #v31 == 0 then
		return "{}"
	end

	if #p9 > 3 then
		return "[" .. tostring(getObjectTag(p8)) .. "]"
	end

	local v32 = Array.map(v31, function(p10) -- line: 165
		-- upvalues: formatValue (ref), p9 (copy)
		local v41, v42 = table.unpack(p10, 1, 2)

		return tostring(v41) .. ": " .. tostring(formatValue(v42, p9))
	end)

	return "{ " .. tostring(Array.join(v32, ", ")) .. " }"
end
function formatArray(p11, p12) -- line: 175
	-- upvalues: formatValue (ref), Array (copy)
	if #p11 == 0 then
		return "[]"
	end

	if #p12 > 3 then
		return "[Array]"
	end

	local v35 = #p11
	local v36 = #p11
	local t2 = {}
	local n1 = 1

	while n1 <= v35 do
		table.insert(t2, formatValue(p11[n1], p12))
		n1 += 1
	end

	if v36 == 1 then
		table.insert(t2, "... 1 more item")
	elseif v36 > 1 then
		table.insert(t2, ("... %s more items"):format((tostring(v36))))
	end

	return "[" .. tostring(Array.join(t2, ", ")) .. "]"
end
function getObjectTag(_) -- line: 230
	return "Object"
end

return t1
