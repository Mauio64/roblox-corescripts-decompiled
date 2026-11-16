local Action = require(script.Parent.Parent.Action)

return Action("SetDevConsoleVisibility", function(isVisible)
	return { isVisible = isVisible }
end)
