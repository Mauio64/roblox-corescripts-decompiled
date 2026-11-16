local Action = require(script.Parent.Parent.Action)

return Action(script.Name, function(isClientView: boolean)
	return { isClientView = isClientView }
end)
