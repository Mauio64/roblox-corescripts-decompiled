local Action = require(script.Parent.Parent.Action)

return Action("SetDevConsolePosition", function(position)
	return { position = position }
end)
