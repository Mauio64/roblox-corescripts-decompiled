local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local Foundation = require(AvatarExperienceInspectAndBuyParent.Foundation)
local ItemsViewHeader = require(AvatarExperienceInspectAndBuy.Components.ItemsView.ItemsViewHeader)
local AvatarItemsView = require(AvatarExperienceInspectAndBuy.Components.ItemsView.AvatarItemsView)
local BuyActionBarLayout = require(AvatarExperienceInspectAndBuy.Components.ItemsView.BuyActionBarLayout)

require(AvatarExperienceInspectAndBuy.Components.Common.SubheaderLabelPrice)
require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)
require(AvatarExperienceInspectAndBuy.Types)

local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)
local useTokens = Foundation.Hooks.useTokens

local function v10(p1, p2) -- line: 64
	-- upvalues: ViewType (copy)
	if p1 == ViewType.Compact then
		return {
			left = UDim.new(0, p2.Padding.Medium),
			right = UDim.new(0, p2.Padding.Medium)
		}
	end

	if p1 == ViewType.Wide then
		return {
			top = UDim.new(0, p2.Padding.XLarge),
			left = UDim.new(0, p2.Margin.Large * 2),
			right = UDim.new(0, p2.Margin.Large * 2),
			bottom = UDim.new(0, p2.Padding.XLarge)
		}
	end

	if p1 == ViewType.WideLandscape then
		return {
			left = UDim.new(0, p2.Padding.Small),
			right = UDim.new(0, p2.Padding.Medium),
			top = UDim.new(0, p2.Padding.XSmall)
		}
	end

	return nil
end

return (React.forwardRef(function(t1: {[any]: any}, p3) -- line: 89
	-- upvalues: useTokens (copy), ViewType (copy), React (copy), ItemsViewHeader (copy), v10 (copy), AvatarItemsView (copy), BuyActionBarLayout (copy)
	local view = t1.view
	local v16 = useTokens()
	local items = t1.items
	local onInspectMenuClosed = t1.onInspectMenuClosed
	local v19 = t1.view == ViewType.Compact

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Header = React.createElement(ItemsViewHeader, {
			view = view,
			headerHeight = v16.Size.Size_1300,
			padding = v10(view, v16),
			headerText = t1.headerText,
			subheaderText = t1.subheaderText,
			onBackButtonClick = function() -- line: 107
				-- upvalues: onInspectMenuClosed (copy)
				onInspectMenuClosed()
			end,
			purchaseButtonProps = t1.buyActionBarProps.purchaseButtonProps
		}),
		List = React.createElement(AvatarItemsView, {
			items = items,
			view = view,
			headerHeightOffset = v16.Size.Size_1300,
			actionBarHeightOffset = v16.Size.Size_2700,
			onItemCardActivated = t1.onItemCardActivated,
			ref = p3
		}),
		BuyActionBarLayout = if not v19 then nil else React.createElement(BuyActionBarLayout, {
			enableTopBorder = true,
			ZIndex = 2,
			buyActionBarProps = t1.buyActionBarProps,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			padding = UDim.new(0, v16.Padding.Medium),
			Size = UDim2.new(1, 0, 0, v16.Size.Size_2700)
		})
	})
end))
