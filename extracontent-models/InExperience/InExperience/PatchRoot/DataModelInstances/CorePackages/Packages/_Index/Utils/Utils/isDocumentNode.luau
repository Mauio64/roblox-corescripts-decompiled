local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)

local Boolean = LuauPolyfill.Boolean

local GraphQL = require(parent.GraphQL)

local Kind = GraphQL.Kind
return {
	isDocumentNode = function(p)
		local v = Boolean.toJSBoolean(p)

		if v then
			if typeof(p) == "table" then
				return Boolean.toJSBoolean(p.kind) and p.kind == Kind.DOCUMENT
			end

			return false
		end

		return v
	end
}
