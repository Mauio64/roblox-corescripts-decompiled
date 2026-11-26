local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local TwoPanelLabelWithDivider = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/TwoPanelLabelWithDivider")

local function ItemInfoLabels(p2)
	local children = {}

	for k, itemInfoLabel in p2.itemInfoLabels do
		if itemInfoLabel.isVisible then
			children[itemInfoLabel.key] = React.createElement(TwoPanelLabelWithDivider, {
				LayoutOrder = k,
				labelProps = itemInfoLabel.labelProps,
				showDivider = true
			})
		end
	end

	return React.createElement(Foundation.View, {
		tag = "auto-y size-full-0 padding-top-medium col align-x-left align-y-top gap-small",
		LayoutOrder = p2.LayoutOrder or 4
	}, children)
end

return ItemInfoLabels
