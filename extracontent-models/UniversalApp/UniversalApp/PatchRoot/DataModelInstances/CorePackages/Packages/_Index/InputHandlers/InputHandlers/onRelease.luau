local parent = script.Parent.Parent
require(parent.FocusNavigation)

local handleInput = require(script.Parent.handleInput)

local function onRelease(onRelease2)
	return handleInput({ onRelease = onRelease2 })
end

return onRelease
