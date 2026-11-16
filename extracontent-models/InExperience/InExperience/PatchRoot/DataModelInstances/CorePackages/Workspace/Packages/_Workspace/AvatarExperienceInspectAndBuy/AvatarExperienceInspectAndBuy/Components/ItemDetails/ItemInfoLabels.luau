local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local TwoPanelLabelWithDivider = require(AvatarExperienceInspectAndBuy.Components.Common.TwoPanelLabelWithDivider)

local function ItemInfoLabels(p)
	local children = {}

	for k, itemInfoLabel in p.itemInfoLabels do
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
		LayoutOrder = p.LayoutOrder or 4
	}, children)
end

return ItemInfoLabels
