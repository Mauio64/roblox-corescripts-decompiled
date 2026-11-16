local parent = script.Parent.Parent.Parent
local Promise = require(parent.Promise)

return {
	isPromise = function(p)
		return Promise.is(p)
	end
}
