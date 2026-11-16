local parent = script.Parent.Parent
local MagicMock = require(parent.MagicMock)

return function(p)
	local pass = MagicMock.is(p)
	return {
		pass = pass,
		message = pass and "Expected object to be anything but a MagicMock." or string.format(
			"Expected object to be a MagicMock. Got %q instead.",
			(tostring(p))
		)
	}
end
