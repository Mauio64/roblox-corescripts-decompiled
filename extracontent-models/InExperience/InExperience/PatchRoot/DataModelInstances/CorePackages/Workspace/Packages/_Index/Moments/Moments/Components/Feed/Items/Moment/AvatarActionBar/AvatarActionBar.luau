local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Button = Foundation.Button
local Icon = Foundation.Icon
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local ImageWithSkeleton = require(Moments.Components.ImageWithSkeleton)

local function AvatarActionBar(props)
	local v = useTokens()
	local size_1000 = v.Size.Size_1000

	if props.isLoading then
		return React.createElement(
			View,
			{
				LayoutOrder = props.LayoutOrder,
				tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y",
				testId = "moments-avatar-action-bar-skeleton"
			},
			{
				Thumbnail = React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.fromOffset(size_1000, size_1000),
					radius = Radius.Medium
				}),
				Lines = React.createElement(
					View,
					{ LayoutOrder = 2, tag = "col align-x-left align-y-center gap-xsmall auto-xy" },
					{
						Price = React.createElement(Skeleton, {
							LayoutOrder = 1,
							Size = UDim2.fromOffset(64, v.Size.Size_400)
						}),
						ItemCount = React.createElement(Skeleton, {
							LayoutOrder = 2,
							Size = UDim2.fromOffset(112, v.Size.Size_300)
						})
					}
				)
			}
		)
	end

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y",
		testId = "moments-avatar-action-bar"
	}

	local v3 = {
		Thumbnail = React.createElement(ImageWithSkeleton, {
			LayoutOrder = 1,
			Image = props.thumbnailImage,
			Size = UDim2.fromOffset(size_1000, size_1000),
			radius = Radius.Medium,
			backgroundStyle = v.Color.Shift.Shift_300
		}),
		Totals = 0,
		ShopButton = 0
	}

	local createElement2 = React.createElement
	local price

	if props.priceText then
		price = React.createElement(
			View,
			{ LayoutOrder = 1, tag = "row align-x-left align-y-center gap-xsmall auto-xy" },
			{
				RobuxIcon = React.createElement(Icon, {
					LayoutOrder = 1,
					name = IconName.Robux,
					size = IconSize.Small
				}),
				Amount = React.createElement(Text, {
					LayoutOrder = 2,
					tag = "auto-xy text-title-medium text-align-x-left content-emphasis",
					Text = props.priceText,
					testId = "moments-look-price"
				})
			}
		)
	end

	v3.Totals = createElement2(
		View,
		{ LayoutOrder = 2, tag = "col align-x-left align-y-center grow gap-xsmall auto-y" },
		{
			Price = price,
			ItemCount = React.createElement(Text, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-medium text-align-x-left content-default",
				Text = props.itemCountText,
				testId = "moments-look-item-count"
			})
		}
	)
	local shopButton

	if props.showShopButton then
		shopButton = React.createElement(Button, {
			LayoutOrder = 3,
			isDisabled = props.isShopDisabled,
			onActivated = props.onShop,
			size = Foundation.Enums.InputSize.Medium,
			text = props.shopText,
			testId = "moments-shop-cta",
			variant = Foundation.Enums.ButtonVariant.Emphasis
		})
	end

	v3.ShopButton = shopButton
	return createElement(View, v2, v3)
end

return AvatarActionBar
