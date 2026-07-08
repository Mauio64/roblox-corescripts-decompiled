local ParentParent = script.Parent.Parent
local MagicMock = require(ParentParent.MagicMock)

return function(p1) -- line: 4
	-- upvalues: MagicMock (copy)
	local v4 = MagicMock.is(p1)

	return {
		pass = v4,
		message = if not v4 then string.format("Expected object to be a MagicMock. Got %q instead.", (tostring(p1))) else "Expected object to be anything but a MagicMock."
	}
end
