local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local encodeURIComponent = require(ParentParent.luaUtils.encodeURIComponent)
local t1 = {}
local serializeFetchParameter = require(script.Parent.serializeFetchParameter).serializeFetchParameter

require(script.Parent.selectHttpOptionsAndBody)

function t1.rewriteURIForGET(s1: string, p1) -- line: 29
	-- upvalues: encodeURIComponent (copy), Array (copy), Object (copy), Boolean (copy), serializeFetchParameter (copy)
	local t2 = {}

	local function addQueryParam(s2: string, s3: string) -- line: 39
		-- upvalues: t2 (copy), encodeURIComponent (copy)
		table.insert(t2, ("%s=%s"):format(s2, encodeURIComponent(s3)))
	end

	if Array.indexOf(Object.keys(p1), "query") ~= -1 then
		local query = p1.query

		table.insert(t2, ("%s=%s"):format("query", encodeURIComponent(query)))
	end

	if Boolean.toJSBoolean(p1.operationName) then
		local operationName = p1.operationName

		table.insert(t2, ("%s=%s"):format("operationName", encodeURIComponent(operationName)))
	end

	if Boolean.toJSBoolean(p1.variables) then
		local u16 = nil
		local ok, result = pcall(function() -- line: 51
			-- upvalues: u16 (ref), serializeFetchParameter (copy), p1 (copy)
			u16 = serializeFetchParameter(p1.variables, "Variables map", true)
		end)

		if not ok then
			return {
				parseError = result
			}
		end

		local v19 = u16

		table.insert(t2, ("%s=%s"):format("variables", encodeURIComponent(v19)))
	end

	if Boolean.toJSBoolean(p1.extensions) then
		local u20 = nil
		local ok, result = pcall(function() -- line: 62
			-- upvalues: u20 (ref), serializeFetchParameter (copy), p1 (copy)
			u20 = serializeFetchParameter(p1.extensions, "Extensions map")
		end)

		if not ok then
			return {
				parseError = result
			}
		end

		local v23 = u20

		table.insert(t2, ("%s=%s"):format("extensions", encodeURIComponent(v23)))
	end

	local s4 = ""
	local v25 = string.find(s1, "#")

	if v25 ~= nil then
		s4 = string.sub(s1, v25)
		s1 = string.sub(s1, 1, v25 - 1)
	end

	return {
		newURI = s1 .. (string.find(s1, "?") ~= nil and "&" or "?") .. Array.join(t2, "&") .. s4
	}
end

return t1
