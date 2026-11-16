local parent = script.Parent.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local GraphQL = require(parent.GraphQL)
local Print = GraphQL.print

require(script.Parent.Parent.core.types)

local headersToLowerCase
local SelectHttpOptionsAndBody = {
	fallbackHttpConfig = {
		http = { includeQuery = true, includeExtensions = false },
		headers = { accept = "*/*", ["content-type"] = "application/json" },
		options = { method = "POST" }
	},
	selectHttpOptionsAndBody = function(data, data2, ...)
		local options = Object.assign({}, data2.options, {
			headers = data2.headers,
			credentials = data2.credentials
		})

		local v = data2.http == nil and {} or data2.http
		Array.forEach({ ... }, function(data3)
			options = Object.assign({}, options, data3.options, {
				headers = Object.assign({}, options.headers, headersToLowerCase(data3.headers))
			})

			if Boolean.toJSBoolean(data3.credentials) then
				options.credentials = data3.credentials
			end

			v = Object.assign({}, v, data3.http)
		end)

		local operationName = data.operationName
		local extensions = data.extensions
		local variables = data.variables
		local query = data.query
		local body = { operationName = operationName, variables = variables }

		if v.includeExtensions then
			body.extensions = extensions
		end

		if v.includeQuery then
			body.query = Print(query)
		end

		return { options = options, body = body }
	end
}

headersToLowerCase = function(headers)
	if headers == nil then
		return headers
	end

	local v = {}
	Array.forEach(Object.keys(headers), function(value: string)
		v[string.lower(value)] = headers[value]
	end)
	return v
end

return SelectHttpOptionsAndBody
