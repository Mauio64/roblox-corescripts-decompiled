local parent = script.Parent.Parent
local Spy = require(parent.Spy)

return function(p)
	local pass = Spy.is(p)
	return {
		pass = pass,
		message = pass and "Expected object to be anything but a Spy." or string.format(
			"Expected object to be a Spy. Got %q instead.",
			(tostring(p))
		)
	}
end
