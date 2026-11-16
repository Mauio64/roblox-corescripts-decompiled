local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error

require(parent.luaUtils.Response)

local HttpService = game:GetService("HttpService")

local ParseAndCheckHttpResponse = {}

require(script.Parent.Parent.core.types)

local utils = require(script.Parent.Parent.utils)
local throwServerError = utils.throwServerError
local hasOwnProperty = require(parent.luaUtils.hasOwnProperty)

function ParseAndCheckHttpResponse.parseAndCheckHttpResponse(p)
	return function(response)
		return response:text():andThen(function(bodyText: string)
			local success, result = pcall(function()
				return HttpService:JSONDecode(bodyText), true
			end)

			if success then
				return result
			end

			local v = Error.new(result)
			v.name = "ServerParseError"
			v.response = response
			v.statusCode = response.status
			v.bodyText = bodyText
			error(v)

			return result
		end):andThen(function(p2)
			if response.status ~= nil and response.status >= 300 then
				throwServerError(
					response,
					p2,
					("Response not successful: Received status code %s"):format((tostring(response.status)))
				)
			end

			if not (Array.isArray(p2) or hasOwnProperty(p2, "data") or hasOwnProperty(p2, "errors")) then
				throwServerError(
					response,
					p2,
					("Server response was missing for query '%s'."):format(Array.isArray(p) and Array.join(Array.map(p, function(p3)
						return p3.operationName
					end), ", ") or p.operationName)
				)
			end

			return p2
		end)
	end
end

return ParseAndCheckHttpResponse
