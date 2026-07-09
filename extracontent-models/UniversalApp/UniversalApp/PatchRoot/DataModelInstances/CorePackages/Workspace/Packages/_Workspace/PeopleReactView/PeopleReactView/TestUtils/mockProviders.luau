local ParentParent = script.Parent.Parent.Parent
local UnitTestHelpers = require(ParentParent.Dev.UnitTestHelpers)

return function(p1, t1: {[any]: any}?) -- line: 9
	-- upvalues: UnitTestHelpers (copy)
	return UnitTestHelpers.mockProviders(p1, {
		mockFoundation = t1 and not t1.mockFoundation
	})
end
