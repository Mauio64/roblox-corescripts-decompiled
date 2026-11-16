local Action = require(script.Parent.Parent.Action)

return Action("SetDevConsoleMinimized", function(isMinimized)
	return { isMinimized = isMinimized }
end)
