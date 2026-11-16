local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local Text = Foundation.Text
local itemDetailsUtils = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils)
local shouldShowPriceLabel = itemDetailsUtils.shouldShowPriceLabel
require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)

local function SubheaderLabelPrice(props)
	local v = React.useMemo(function()
		return shouldShowPriceLabel(props.priceStatus)
	end, { props.priceStatus })

	local createElement = React.createElement
	local view = Foundation.View
	local v2 = {
		tag = "auto-xy row align-y-center align-x-left gap-xxsmall",
		LayoutOrder = props.LayoutOrder
	}
	local leftSlotLabel

	if props.subheaderText.leftSlotLabel then
		leftSlotLabel = React.createElement(Text, {
			tag = "auto-xy text-align-x-left text-body-large content-default text-truncate-split",
			LayoutOrder = 1,
			Text = props.subheaderText.leftSlotLabel
		})
	end

	local spacer

	if v and props.subheaderText.leftSlotLabel and props.subheaderText.leftSlotLabel ~= "" then
		spacer = React.createElement(Icon, {
			name = "icons/controls/keys/period",
			size = IconSize.Small,
			LayoutOrder = 2
		})
	end

	local rightSlotLabel

	if v and props.subheaderText.rightSlotPrice then
		rightSlotLabel = React.createElement(
			Foundation.View,
			{
				tag = "auto-xy row align-y-center align-x-left gap-xxsmall",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 3
			},
			{
				Icon = React.createElement(Icon, {
					name = "icons/common/robux",
					size = IconSize.Small,
					LayoutOrder = 1
				}),
				RightSlotLabel = React.createElement(Text, {
					tag = "auto-xy text-align-x-left text-body-large content-default text-truncate-split",
					LayoutOrder = 2,
					Text = props.subheaderText.rightSlotPrice
				})
			}
		)
	end

	return createElement(view, v2, {
		LeftSlotLabel = leftSlotLabel,
		Spacer = spacer,
		RightSlotLabel = rightSlotLabel
	})
end

return SubheaderLabelPrice
