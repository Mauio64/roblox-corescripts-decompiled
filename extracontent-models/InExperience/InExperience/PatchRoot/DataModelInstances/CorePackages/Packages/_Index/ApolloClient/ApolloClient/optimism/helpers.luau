local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.LuauPolyfill)
require(script.Parent.helpers_types)

return {
	hasOwnProperty = require(ParentParent.luaUtils.hasOwnProperty),
	toArray = function(p1) -- line: 23
		if p1._array then
			return table.clone(p1._array)
		end

		local t1 = {}

		p1:forEach(function(p2) -- line: 31
			-- upvalues: t1 (copy)
			table.insert(t1, p2)
		end)

		return t1
	end,
	maybeUnsubscribe = function(p3) -- line: 41
		local unsubscribe = p3.unsubscribe

		if type(unsubscribe) == "function" then
			p3.unsubscribe = nil
			unsubscribe()
		end
	end
}
