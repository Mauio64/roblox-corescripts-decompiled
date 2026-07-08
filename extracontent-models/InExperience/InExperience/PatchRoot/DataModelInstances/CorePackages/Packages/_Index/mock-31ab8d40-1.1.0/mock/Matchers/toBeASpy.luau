local ParentParent = script.Parent.Parent
local Spy = require(ParentParent.Spy)

return function(p1) -- line: 4
	-- upvalues: Spy (copy)
	local v4 = Spy.is(p1)

	return {
		pass = v4,
		message = if not v4 then string.format("Expected object to be a Spy. Got %q instead.", (tostring(p1))) else "Expected object to be anything but a Spy."
	}
end
