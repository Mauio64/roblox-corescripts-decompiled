local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local iconButton = Foundation.IconButton

local useTextAlignmentButtonState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TextOverlay/useTextAlignmentButtonState")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local function TextAlignmentButton(p2)
	local v5 = useTextAlignmentButtonState(p2.controller)

	return React.createElement(iconButton, {
		LayoutOrder = p2.LayoutOrder,
		icon = v5.icon,
		onActivated = v5.onActivated,
		size = Foundation.Enums.InputSize.Medium
	})
end

return TextAlignmentButton
