local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

require(ParentParent.core)
require(script.Parent.types)

local useQuery = require(script.Parent.Parent.hooks).useQuery

function t1.Query(p1) -- line: 27
	-- upvalues: Object (copy), useQuery (copy), Boolean (copy)
	local children = p1.children
	local query = p1.query
	local v11 = Object.assign({}, p1, {
		children = Object.None,
		query = Object.None
	})
	local v12 = useQuery(query, v11)

	if Boolean.toJSBoolean(v12) then
		return children(v12)
	end

	return nil
end

return t1
