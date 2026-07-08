local ParentParent = script.Parent.Parent

require(ParentParent.FocusNavigation)

local handleInput = require(script.Parent.handleInput)

local function onRelease(p1) -- line: 7
	-- upvalues: handleInput (copy)
	return handleInput({
		onRelease = p1
	})
end

return onRelease
