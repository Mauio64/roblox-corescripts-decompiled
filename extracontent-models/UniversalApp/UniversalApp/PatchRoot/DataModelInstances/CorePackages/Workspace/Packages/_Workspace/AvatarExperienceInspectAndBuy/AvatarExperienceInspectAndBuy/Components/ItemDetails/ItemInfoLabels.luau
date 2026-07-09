local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local Foundation = require(AvatarExperienceInspectAndBuyParent.Foundation)
local TwoPanelLabelWithDivider = require(AvatarExperienceInspectAndBuy.Components.Common.TwoPanelLabelWithDivider)
local FFlagAXFixIaBItemMap = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags).FFlagAXFixIaBItemMap

local function ItemInfoLabels(t1: {[any]: any}) -- line: 41
	-- upvalues: React (copy), TwoPanelLabelWithDivider (copy), Foundation (copy), FFlagAXFixIaBItemMap (copy)
	local t2 = {}

	for v10, v11 in t1.itemInfoLabels do
		if v11.isVisible then
			t2[v11.key] = React.createElement(TwoPanelLabelWithDivider, {
				showDivider = true,
				LayoutOrder = v10,
				labelProps = v11.labelProps
			})
		end
	end

	return React.createElement(Foundation.View, {
		tag = "auto-y size-full-0 padding-top-medium col align-x-left align-y-top gap-small",
		LayoutOrder = t1.LayoutOrder or 4
	}, if not FFlagAXFixIaBItemMap then { t2 } else t2)
end

return ItemInfoLabels
