local ParentParent = script.Parent.Parent

require(ParentParent.FocusNavigation)

local handleInput = require(script.Parent.handleInput)

local function onPress(p1) -- line: 7
	-- upvalues: handleInput (copy)
	return handleInput({
		onPress = p1
	})
end

return onPress
