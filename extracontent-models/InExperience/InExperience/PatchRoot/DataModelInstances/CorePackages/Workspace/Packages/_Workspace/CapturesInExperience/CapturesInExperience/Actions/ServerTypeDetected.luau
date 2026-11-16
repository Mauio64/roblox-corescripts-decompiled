local parent = script.Parent.Parent.Parent

local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(serverType)
	return { serverType = serverType }
end)
