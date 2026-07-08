local ParentParent = script.Parent.Parent

require(ParentParent.FocusNavigation)

local handleInput = require(script.Parent.handleInput)

local function onLongPress(n1: number, p1, p2) -- line: 7
	-- upvalues: handleInput (copy)
	return handleInput({
		hold = {
			durationSeconds = n1,
			onComplete = p1,
			onStep = p2
		}
	})
end

return onLongPress
