local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ItemsViewHeader = require(AvatarExperienceInspectAndBuy.Components.ItemsView.ItemsViewHeader)
local AvatarItemsView = require(AvatarExperienceInspectAndBuy.Components.ItemsView.AvatarItemsView)
local BuyActionBarLayout = require(AvatarExperienceInspectAndBuy.Components.ItemsView.BuyActionBarLayout)
require(AvatarExperienceInspectAndBuy.Components.Common.SubheaderLabelPrice)

require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)

require(AvatarExperienceInspectAndBuy.Types)
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)
local useTokens = Foundation.Hooks.useTokens

local function fn(view, p)
	if view == ViewType.Compact then
		return { left = UDim.new(0, p.Padding.Medium), right = UDim.new(0, p.Padding.Medium) }
	end

	if view == ViewType.Wide then
		return {
			top = UDim.new(0, p.Padding.XLarge),
			left = UDim.new(0, p.Margin.Large * 2),
			right = UDim.new(0, p.Margin.Large * 2),
			bottom = UDim.new(0, p.Padding.XLarge)
		}
	end

	if view == ViewType.WideLandscape then
		return {
			left = UDim.new(0, p.Padding.Small),
			right = UDim.new(0, p.Padding.Medium),
			top = UDim.new(0, p.Padding.XSmall)
		}
	end

	return nil
end

return (React.forwardRef(function(props, ref)
	local view = props.view
	local v = useTokens()
	local items = props.items
	local onInspectMenuClosed = props.onInspectMenuClosed

	local v2 = props.view == ViewType.Compact

	local createElement = React.createElement
	local v3 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local v4 = {
		Header = React.createElement(ItemsViewHeader, {
			view = view,
			headerHeight = v.Size.Size_1300,
			padding = fn(view, v),
			headerText = props.headerText,
			subheaderText = props.subheaderText,
			onBackButtonClick = function()
				onInspectMenuClosed()
			end,
			purchaseButtonProps = props.buyActionBarProps.purchaseButtonProps
		}),
		List = React.createElement(AvatarItemsView, {
			items = items,
			view = view,
			headerHeightOffset = v.Size.Size_1300,
			actionBarHeightOffset = v.Size.Size_2700,
			onItemCardActivated = props.onItemCardActivated,
			ref = ref
		}),
		BuyActionBarLayout = 0
	}
	local buyActionBarLayout

	if v2 then
		buyActionBarLayout = React.createElement(BuyActionBarLayout, {
			buyActionBarProps = props.buyActionBarProps,
			enableTopBorder = true,
			ZIndex = 2,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			padding = UDim.new(0, v.Padding.Medium),
			Size = UDim2.new(1, 0, 0, v.Size.Size_2700)
		})
	end

	v4.BuyActionBarLayout = buyActionBarLayout
	return createElement("Frame", v3, v4)
end))
