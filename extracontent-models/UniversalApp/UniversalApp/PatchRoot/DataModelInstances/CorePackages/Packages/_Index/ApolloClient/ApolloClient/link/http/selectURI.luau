local parent = script.Parent.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean

local SelectURI = {}

require(script.Parent.Parent.core.types)

function SelectURI.selectURI(object, callback)
	local uri = object:getContext().uri

	if Boolean.toJSBoolean(uri) then
		return uri
	end

	if typeof(callback) == "function" then
		return callback(object)
	end

	return Boolean.toJSBoolean(callback) and callback or "/graphql"
end

return SelectURI
