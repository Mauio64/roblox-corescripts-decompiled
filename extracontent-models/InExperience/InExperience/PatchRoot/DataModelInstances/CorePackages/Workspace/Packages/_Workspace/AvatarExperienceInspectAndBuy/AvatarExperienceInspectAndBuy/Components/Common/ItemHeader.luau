local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local Foundation = require(AvatarExperienceInspectAndBuyParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local BackButton = require(AvatarExperienceInspectAndBuy.Components.Common.BackButton)

require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)
require(AvatarExperienceInspectAndBuy.Types)

local function ItemHeader(t1: {[any]: any}) -- line: 39
	-- upvalues: useTokens (copy), React (copy), Foundation (copy), BackButton (copy)
	local v9 = useTokens()

	return React.createElement(Foundation.View, {
		tag = "auto-xy size-full-0",
		LayoutOrder = t1.LayoutOrder
	}, {
		UIPadding = if not t1.padding then nil else React.createElement("UIPadding", {
			PaddingLeft = t1.padding.left,
			PaddingRight = t1.padding.right,
			PaddingTop = t1.padding.top,
			PaddingBottom = t1.padding.bottom
		}),
		UIListLayout = if not t1.purchaseButtonProps then nil else React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
		}),
		InnerFrame = React.createElement(Foundation.View, {
			tag = "auto-xy col align-y-center",
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			BackButton = if not t1.onBackButtonClick then nil else React.createElement(BackButton, {
				LayoutOrder = 1,
				onBackButtonClick = t1.onBackButtonClick
			}),
			HeaderAndSubheader = React.createElement(Foundation.View, {
				tag = "auto-xy col",
				LayoutOrder = 2
			}, {
				UIPadding = if not t1.onBackButtonClick then nil else React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v9.Padding.Large)
				}),
				Header = if not t1.header then nil else t1.header,
				Subheader = if not t1.subheader then nil else t1.subheader
			})
		}),
		BuyButton = if not t1.purchaseButtonProps then nil else React.createElement(Foundation.Button, {
			LayoutOrder = 2,
			size = Foundation.Enums.InputSize.Medium,
			width = UDim.new(0, v9.Size.Size_3000),
			text = t1.purchaseButtonProps.purchaseButtonText,
			variant = t1.purchaseButtonProps.variant,
			isDisabled = t1.purchaseButtonProps.isDisabled,
			onActivated = t1.purchaseButtonProps.onPurchase
		})
	})
end

return ItemHeader
