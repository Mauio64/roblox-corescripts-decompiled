local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local BackButton = require(AvatarExperienceInspectAndBuy.Components.Common.BackButton)
require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)

require(AvatarExperienceInspectAndBuy.Types)

local function ItemHeader(props)
	local v = useTokens()
	local createElement = React.createElement
	local view = Foundation.View
	local v2 = { tag = "auto-xy size-full-0", LayoutOrder = props.LayoutOrder }
	local uiPadding

	if props.padding then
		uiPadding = React.createElement("UIPadding", {
			PaddingLeft = props.padding.left,
			PaddingRight = props.padding.right,
			PaddingTop = props.padding.top,
			PaddingBottom = props.padding.bottom
		})
	end

	local uiListLayout

	if props.purchaseButtonProps then
		uiListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
		})
	end

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v4 = { tag = "auto-xy col align-y-center", Size = UDim2.new(1, 0, 0, 0) }
	local backButton

	if props.onBackButtonClick then
		backButton = React.createElement(BackButton, {
			onBackButtonClick = props.onBackButtonClick,
			LayoutOrder = 1
		})
	end

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local uiPadding2

	if props.onBackButtonClick then
		uiPadding2 = React.createElement("UIPadding", { PaddingLeft = UDim.new(0, v.Padding.Large) })
	end

	local header

	if props.header then
		header = props.header
	end

	local subheader

	if props.subheader then
		subheader = props.subheader
	end

	local v3 = {
		UIPadding = uiPadding,
		UIListLayout = uiListLayout,
		InnerFrame = createElement2(view2, v4, {
			BackButton = backButton,
			HeaderAndSubheader = createElement3(view3, { tag = "auto-xy col", LayoutOrder = 2 }, {
				UIPadding = uiPadding2,
				Header = header,
				Subheader = subheader
			})
		}),
		BuyButton = 0
	}
	local buyButton

	if props.purchaseButtonProps then
		buyButton = React.createElement(Foundation.Button, {
			size = Foundation.Enums.InputSize.Medium,
			width = UDim.new(0, v.Size.Size_3000),
			text = props.purchaseButtonProps.purchaseButtonText,
			variant = props.purchaseButtonProps.variant,
			isDisabled = props.purchaseButtonProps.isDisabled,
			onActivated = props.purchaseButtonProps.onPurchase,
			LayoutOrder = 2
		})
	end

	v3.BuyButton = buyButton
	return createElement(view, v2, v3)
end

return ItemHeader
