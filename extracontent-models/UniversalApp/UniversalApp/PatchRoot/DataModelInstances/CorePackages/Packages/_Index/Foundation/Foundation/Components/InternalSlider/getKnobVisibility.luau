local Foundation = script:FindFirstAncestor("Foundation")

local ControlState = require(Foundation.Enums.ControlState)

local Visibility = require(Foundation.Enums.Visibility)

local function getKnobVisibility(data)
	if data.isDisabled then
		return false
	end

	if data.knobVisibility == Visibility.None then
		return data.isSelected
	end

	if data.knobVisibility == Visibility.Always then
		return true
	end

	return data.isDragging
		or data.isSelected
		or data.controlState == ControlState.Hover
		or data.controlState == ControlState.Pressed
end

return getKnobVisibility
