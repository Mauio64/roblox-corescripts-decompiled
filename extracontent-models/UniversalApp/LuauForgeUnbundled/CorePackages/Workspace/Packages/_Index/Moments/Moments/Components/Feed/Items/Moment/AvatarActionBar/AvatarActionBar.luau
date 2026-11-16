local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local button = Foundation.Button
local icon = Foundation.Icon
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local ImageWithSkeleton = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/ImageWithSkeleton")

local function AvatarActionBar(props)
	local v5 = useTokens()
	local size_1000 = v5.Size.Size_1000

	if props.isLoading then
		return React.createElement(
			view,
			{
				LayoutOrder = props.LayoutOrder,
				tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y",
				testId = "moments-avatar-action-bar-skeleton"
			},
			{
				Thumbnail = React.createElement(skeleton, {
					LayoutOrder = 1,
					Size = UDim2.fromOffset(size_1000, size_1000),
					radius = radius.Medium
				}),
				Lines = React.createElement(
					view,
					{
						LayoutOrder = 2,
						tag = "col align-x-left align-y-center gap-xsmall auto-xy"
					},
					{
						Price = React.createElement(skeleton, {
							LayoutOrder = 1,
							Size = UDim2.fromOffset(64, v5.Size.Size_400)
						}),
						ItemCount = React.createElement(skeleton, {
							LayoutOrder = 2,
							Size = UDim2.fromOffset(112, v5.Size.Size_300)
						})
					}
				)
			}
		)
	end

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y",
		testId = "moments-avatar-action-bar"
	}

	local v8 = {
		Thumbnail = React.createElement(ImageWithSkeleton, {
			LayoutOrder = 1,
			Image = props.thumbnailImage,
			Size = UDim2.fromOffset(size_1000, size_1000),
			radius = radius.Medium,
			backgroundStyle = v5.Color.Shift.Shift_300
		}),
		Totals = 0,
		ShopButton = 0
	}

	local createElement2 = React.createElement

	local v12 = if props.priceText then React.createElement(
		view,
		{ LayoutOrder = 1, tag = "row align-x-left align-y-center gap-xsmall auto-xy" },
		{
			RobuxIcon = React.createElement(icon, {
				LayoutOrder = 1,
				name = iconName.Robux,
				size = iconSize.Small
			}),
			Amount = React.createElement(text, {
				LayoutOrder = 2,
				tag = "auto-xy text-title-medium text-align-x-left content-emphasis",
				Text = props.priceText,
				testId = "moments-look-price"
			})
		}
	) else nil
	v8.Totals = createElement2(
		view,
		{
			LayoutOrder = 2,
			tag = "col align-x-left align-y-center grow gap-xsmall auto-y"
		},
		{
			Price = v12,
			ItemCount = React.createElement(text, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-medium text-align-x-left content-default",
				Text = props.itemCountText,
				testId = "moments-look-item-count"
			})
		}
	)

	local v13 = if props.showShopButton then React.createElement(button, {
		LayoutOrder = 3,
		isDisabled = props.isShopDisabled,
		onActivated = props.onShop,
		size = Foundation.Enums.InputSize.Medium,
		text = props.shopText,
		testId = "moments-shop-cta",
		variant = Foundation.Enums.ButtonVariant.Emphasis
	}) else nil
	v8.ShopButton = v13
	return createElement(view, v7, v8)
end

return AvatarActionBar
