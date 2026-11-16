local Query = {}
local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

require(parent.core)

require(script.Parent.types)

local hooks = require(script.Parent.Parent.hooks)
local useQuery = hooks.useQuery

function Query.Query(p)
	local children = p.children
	local v = useQuery(p.query, (Object.assign({}, p, {
		children = Object.None,
		query = Object.None
	})))

	if Boolean.toJSBoolean(v) then
		return children(v)
	end

	return nil
end

return Query
