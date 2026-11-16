local parent = script.Parent.Parent.Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(count)
	assert(type(count) == "number", "Request count must be a number")

	return {
		payload = { count = count }
	}
end)
