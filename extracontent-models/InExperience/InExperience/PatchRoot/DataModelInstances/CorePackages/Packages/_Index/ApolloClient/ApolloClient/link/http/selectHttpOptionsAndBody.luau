local ParentParent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local print = require(ParentParent.GraphQL).print

require(script.Parent.Parent.core.types)

local headersToLowerCase = nil
local t2 = {
	includeQuery = true,
	includeExtensions = false
}
local t3 = {
	accept = "*/*",
	["content-type"] = "application/json"
}
local t4 = {
	method = "POST"
}

t1.fallbackHttpConfig = {
	http = t2,
	headers = t3,
	options = t4
}

function t1.selectHttpOptionsAndBody(p1, t5: {[any]: any}, ...) -- line: 112
	-- upvalues: Object (copy), Array (copy), headersToLowerCase (ref), Boolean (copy), print (copy)
	local u14 = Object.assign({}, t5.options, {
		headers = t5.headers,
		credentials = t5.credentials
	})
	local u15 = if t5.http == nil then {} else t5.http

	Array.forEach({ ... }, function(p2) -- line: 131
		-- upvalues: u14 (ref), Object (copy), headersToLowerCase (ref), Boolean (copy), u15 (ref)
		u14 = Object.assign({}, u14, p2.options, {
			headers = Object.assign({}, u14.headers, headersToLowerCase(p2.headers))
		})

		if Boolean.toJSBoolean(p2.credentials) then
			u14.credentials = p2.credentials
		end

		u15 = Object.assign({}, u15, p2.http)
	end)

	local operationName = p1.operationName
	local extensions = p1.extensions
	local variables = p1.variables
	local query = p1.query
	local t6 = {
		operationName = operationName,
		variables = variables
	}

	if u15.includeExtensions then
		t6.extensions = extensions
	end

	if u15.includeQuery then
		t6.query = print(query)
	end

	return {
		options = u14,
		body = t6
	}
end
function headersToLowerCase(t7: {[any]: any}?) -- line: 163
	-- upvalues: Array (copy), Object (copy)
	if t7 ~= nil then
		local t8 = {}

		Array.forEach(Object.keys(t7), function(s1: string) -- line: 166
			-- upvalues: t8 (copy), t7 (copy)
			t8[string.lower(s1)] = t7[s1]
		end)

		return t8
	end

	return t7
end

return t1
