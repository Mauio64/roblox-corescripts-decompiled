local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local IconButton = Foundation.IconButton

local useTextAlignmentButtonState = require(MomentsCreation.Components.TextOverlay.useTextAlignmentButtonState)

require(MomentsCreation.Types.CreationFlowTypes)

local function TextAlignmentButton(p)
	local v = useTextAlignmentButtonState(p.controller)

	return React.createElement(IconButton, {
		LayoutOrder = p.LayoutOrder,
		icon = v.icon,
		onActivated = v.onActivated,
		size = Foundation.Enums.InputSize.Medium
	})
end

return TextAlignmentButton
