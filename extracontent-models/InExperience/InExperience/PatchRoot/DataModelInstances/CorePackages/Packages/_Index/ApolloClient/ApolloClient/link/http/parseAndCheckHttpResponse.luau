local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error

require(ParentParent.luaUtils.Response)

local HttpService = game:GetService("HttpService")
local t1 = {}

require(script.Parent.Parent.core.types)

local throwServerError = require(script.Parent.Parent.utils).throwServerError
local hasOwnProperty = require(ParentParent.luaUtils.hasOwnProperty)

function t1.parseAndCheckHttpResponse(p1) -- line: 34
	-- upvalues: HttpService (copy), Error (copy), throwServerError (copy), Array (copy), hasOwnProperty (copy)
	return function(p2) -- line: 35
		-- upvalues: HttpService (copy), Error (copy), throwServerError (copy), Array (copy), hasOwnProperty (copy), p1 (copy)
		return p2:text():andThen(function(s1: string) -- line: 38
			-- upvalues: HttpService (copy), Error (copy), p2 (copy)
			local ok, result = pcall(function() -- line: 39
				-- upvalues: HttpService (copy), s1 (copy)
				return HttpService:JSONDecode(s1), true
			end)

			if not ok then
				local v15 = Error.new(result)

				v15.name = "ServerParseError"
				v15.response = p2
				v15.statusCode = p2.status
				v15.bodyText = s1
				error(v15)
			end

			return result
		end):andThen(function(p3) -- line: 54
			-- upvalues: p2 (copy), throwServerError (copy), Array (copy), hasOwnProperty (copy), p1 (copy)
			if p2.status ~= nil and p2.status >= 300 then
				throwServerError(p2, p3, ("Response not successful: Received status code %s"):format((tostring(p2.status))))
			end

			if not Array.isArray(p3) and not hasOwnProperty(p3, "data") and not hasOwnProperty(p3, "errors") then
				throwServerError(p2, p3, ("Server response was missing for query '%s'."):format(Array.isArray(p1) and Array.join(Array.map(p1, function(p4) -- line: 77
					return p4.operationName
				end), ", ") or p1.operationName))
			end

			return p3
		end)
	end
end

return t1
