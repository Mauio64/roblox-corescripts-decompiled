local ParentParent = script.Parent.Parent.Parent
local Promise = require(ParentParent.Promise)

return {
	isPromise = function(p1) -- line: 17
		-- upvalues: Promise (copy)
		return Promise.is(p1)
	end
}
