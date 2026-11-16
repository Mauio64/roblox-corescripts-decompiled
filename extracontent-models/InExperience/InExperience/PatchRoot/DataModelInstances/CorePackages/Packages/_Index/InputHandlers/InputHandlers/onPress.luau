local parent = script.Parent.Parent
require(parent.FocusNavigation)

local handleInput = require(script.Parent.handleInput)

local function onPress(onPress2)
	return handleInput({ onPress = onPress2 })
end

return onPress
