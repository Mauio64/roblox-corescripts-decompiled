local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.LuauPolyfill)

local Promise = require(ParentParentParent.Promise)

require(ParentParent.jsutils.PromiseOrValue)

return {
	coerceToPromise = function(p1) -- line: 10
		-- upvalues: Promise (copy)
		if Promise.is(p1) then
			return p1
		end

		return (Promise.resolve(p1))
	end
}
