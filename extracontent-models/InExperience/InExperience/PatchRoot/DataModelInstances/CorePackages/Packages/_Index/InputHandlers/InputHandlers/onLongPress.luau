local parent = script.Parent.Parent
require(parent.FocusNavigation)

local handleInput = require(script.Parent.handleInput)

local function onLongPress(durationSeconds: number, onComplete, onStep)
	return handleInput({
		hold = { durationSeconds = durationSeconds, onComplete = onComplete, onStep = onStep }
	})
end

return onLongPress
