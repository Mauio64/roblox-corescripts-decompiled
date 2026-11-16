local Action = require(script.Parent.Parent.Action)

return Action("SetActiveTab", function(newTabIndex, isClientView)
	return { newTabIndex = newTabIndex, isClientView = isClientView }
end)
