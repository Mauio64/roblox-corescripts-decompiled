local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local encodeURIComponent = require(parent.luaUtils.encodeURIComponent)

local RewriteURIForGET = {}

local serializeFetchParameter = require(script.Parent.serializeFetchParameter)
local serializeFetchParameter2 = serializeFetchParameter.serializeFetchParameter
require(script.Parent.selectHttpOptionsAndBody)

function RewriteURIForGET.rewriteURIForGET(value: string, data)
	local v = {}
	local function addQueryParam(p: string, p2: string) -- 4 equivalent calls inferred from this helper
		table.insert(v, ("%s=%s"):format(p, encodeURIComponent(p2)))
	end

	if Array.indexOf(Object.keys(data), "query") ~= -1 then
		addQueryParam("query", data.query) -- inferred equivalent call
	end

	if Boolean.toJSBoolean(data.operationName) then
		addQueryParam("operationName", data.operationName) -- inferred equivalent call
	end

	if Boolean.toJSBoolean(data.variables) then
		local v2 = nil
		local success, result = pcall(function()
			v2 = serializeFetchParameter2(data.variables, "Variables map", true)
		end)

		if not success then
			return { parseError = result }
		end

		addQueryParam("variables", v2) -- inferred equivalent call
	end

	if Boolean.toJSBoolean(data.extensions) then
		local v2 = nil
		local success, result = pcall(function()
			v2 = serializeFetchParameter2(data.extensions, "Extensions map")
		end)

		if not success then
			return { parseError = result }
		end

		addQueryParam("extensions", v2) -- inferred equivalent call
	end

	local v2 = string.find(value, "#")
	local v3

	if v2 == nil then
		v3 = ""
	else
		v3 = string.sub(value, v2)
		value = string.sub(value, 1, v2 - 1)
	end

	return {
		newURI = value .. (string.find(value, "?") == nil and "?" or "&") .. Array.join(v, "&") .. v3
	}
end

return RewriteURIForGET
