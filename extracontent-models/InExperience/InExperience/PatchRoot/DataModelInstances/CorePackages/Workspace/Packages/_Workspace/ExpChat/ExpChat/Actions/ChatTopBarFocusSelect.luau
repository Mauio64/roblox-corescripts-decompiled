local parent = script.Parent
local ActionCreator = require(parent.ActionCreator)

return ActionCreator(script.Name, function(onSelectionLost, keybinds)
	return { onSelectionLost = onSelectionLost, keybinds = keybinds }
end)
