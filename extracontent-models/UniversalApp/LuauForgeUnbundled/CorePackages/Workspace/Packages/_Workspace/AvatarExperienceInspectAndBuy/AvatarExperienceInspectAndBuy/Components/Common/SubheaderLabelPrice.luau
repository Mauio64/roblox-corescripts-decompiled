local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local text = Foundation.Text
local shouldShowPriceLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/itemDetailsUtils").shouldShowPriceLabel
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")

local function SubheaderLabelPrice(props)
	local v5 = React.useMemo(function()
		return shouldShowPriceLabel(props.priceStatus)
	end, { props.priceStatus })

	local createElement = React.createElement
	local view = Foundation.View
	local v6 = {
		tag = "auto-xy row align-y-center align-x-left gap-xxsmall",
		LayoutOrder = props.LayoutOrder
	}

	local v8 = if props.subheaderText.leftSlotLabel then React.createElement(text, {
		tag = "auto-xy text-align-x-left text-body-large content-default text-truncate-split",
		LayoutOrder = 1,
		Text = props.subheaderText.leftSlotLabel
	}) else nil

	local v9 = if v5 and props.subheaderText.leftSlotLabel and props.subheaderText.leftSlotLabel ~= "" then React.createElement(icon, {
		name = "icons/controls/keys/period",
		size = iconSize.Small,
		LayoutOrder = 2
	}) else nil

	local v10 = if v5 and props.subheaderText.rightSlotPrice then React.createElement(
		Foundation.View,
		{
			tag = "auto-xy row align-y-center align-x-left gap-xxsmall",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 3
		},
		{
			Icon = React.createElement(icon, {
				name = "icons/common/robux",
				size = iconSize.Small,
				LayoutOrder = 1
			}),
			RightSlotLabel = React.createElement(text, {
				tag = "auto-xy text-align-x-left text-body-large content-default text-truncate-split",
				LayoutOrder = 2,
				Text = props.subheaderText.rightSlotPrice
			})
		}
	) else nil
	return createElement(view, v6, {
		LeftSlotLabel = v8,
		Spacer = v9,
		RightSlotLabel = v10
	})
end

return SubheaderLabelPrice
