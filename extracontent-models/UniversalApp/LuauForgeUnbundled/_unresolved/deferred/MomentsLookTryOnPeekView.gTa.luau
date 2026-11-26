local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local module = require("@luauforge/bundled/dCI")
local peekView = module.PeekView
local peekViewState = module.PeekViewState
local module2 = require("@luauforge/deferred/gTb")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

require("@luauforge/deferred/gTc")

local module4 = require("@luauforge/bundled/gxM")
local module5 = require("@luauforge/deferred/gQF")

local module6 = require("@luauforge/deferred/gTe")

local buyActionBar = module2.Components.BuyActionBar
local priceStatus = module2.Enums.PriceStatus
local fFlagAXMomentsLookTryOnOpaqueCloseButton = AvatarExperienceFlags.FFlagAXMomentsLookTryOnOpaqueCloseButton

local v5 = {
	[priceStatus.Owned] = "Feature.Catalog.Label.Owned",
	[priceStatus.Free] = "Feature.Catalog.LabelFree",
	[priceStatus.SoldOut] = "Feature.Catalog.Label.SoldOut",
	[priceStatus.OffSale] = "Feature.Catalog.LabelOffSale",
	[priceStatus.QuantityLimitReached] = "Feature.Catalog.Label.Checkout.LimitReached",
	[priceStatus.Unavailable] = "Feature.Catalog.Label.Checkout.Unavailable",
	[priceStatus.InExperienceOnly] = "Feature.Catalog.Label.InSingleExperience",
	[priceStatus.PurchaseFromRoblox] = "Feature.Catalog.Heading.BuyItem",
	[priceStatus.PurchaseFromResale] = "Feature.Catalog.Heading.BuyItem"
}

local function MomentsLookTryOnPeekView(props)
	local v6 = useTokens()
	local v7 = module4(v5)
	local v8 = v6.Size.Size_2500 + v6.Size.Size_400 + v6.Gap.Medium
	local udim = UDim.new(0, v6.Padding.Large)

	local v9, v10 = React.useBinding(0)

	local element = React.createElement(Foundation.View, {
		tag = "col size-full",
		backgroundStyle = {
			Color3 = v6.Color.Surface.Surface_100.Color3,
			Transparency = 0
		}
	}, {
		BuyActionBar = React.createElement(buyActionBar, {
			priceLabel = props.priceLabel,
			purchaseButtonProps = props.purchaseButtonProps
		})
	})

	local element2 = React.createElement(peekView, {
		stateOnMount = peekViewState.SuperBrief,
		peekViewState = props.peekViewState,
		viewStateChanged = props.onViewStateChanged,
		briefToFullTransitionPercent = v10,
		superBriefViewContentHeight = UDim.new(0, props.barHeight),
		briefViewContentHeight = UDim.new(0.5, 0),
		bottomDockedContainerHeight = props.barHeight,
		bottomDockedContainerContent = element,
		minimizeToSuperBrief = true,
		canDragFullViewToBrief = true,
		showDraggerInClosedState = false,
		peekHeaderClose = false,
		mountAnimation = true,
		showDropShadow = false,
		customBackground = v6.Color.Surface.Surface_100.Color3
	}, {
		Content = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, props.contentMinHeight),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = udim,
					PaddingRight = udim,
					PaddingTop = udim,
					PaddingBottom = udim
				}),
				Items = React.createElement(module6, {
					itemCardWidth = v8,
					priceStatusLabels = v7,
					LayoutOrder = 1
				})
			}
		)
	})

	local createElement = React.createElement
	local view = Foundation.View
	local v11 = {
		tag = "row align-y-center flex-x-between size-full-0 auto-y padding-large",
		backgroundStyle = props.isExpanded and {
			Color3 = v6.Color.Surface.Surface_100.Color3,
			Transparency = 0
		} or nil,
		ZIndex = 2
	}

	local createElement2 = React.createElement
	local iconButton = Foundation.IconButton
	local v13 = {
		testId = props.isExpanded and "MomentsLookTryOnMinimizeButton" or "MomentsLookTryOnCloseButton",
		icon = 0,
		size = 0,
		isCircular = 0,
		variant = 0,
		onActivated = 0
	}
	local v14 = if props.isExpanded then Foundation.Enums.IconName.ChevronLargeDown else Foundation.Enums.IconName.X
	v13.icon = v14
	v13.size = Foundation.Enums.InputSize.Small
	v13.isCircular = not props.isExpanded
	local v15

	if props.isExpanded then
		v15 = Foundation.Enums.ButtonVariant.Utility
	elseif fFlagAXMomentsLookTryOnOpaqueCloseButton then
		v15 = Foundation.Enums.ButtonVariant.OverMedia
	else
		v15 = Foundation.Enums.ButtonVariant.Standard
	end

	v13.variant = v15

	local v16 = if props.isExpanded then props.onMinimize else props.onClose
	v13.onActivated = v16
	local element3 = createElement(view, v11, {
		Button = createElement2(iconButton, v13)
	})

	local element4 = React.createElement("CanvasGroup", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		GroupTransparency = v9,
		Visible = not props.isExpanded,
		ZIndex = 2
	}, {
		Row = React.createElement(
			Foundation.View,
			{
				tag = "row align-x-right align-y-center size-full-0 auto-y padding-large"
			},
			{ RobuxBalance = React.createElement(module5) }
		)
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = props.panelSize,
		Position = props.panelPosition,
		AnchorPoint = props.panelAnchorPoint,
		ClipsDescendants = true
	}, { PeekView = element2, Balance = element4, TopBar = element3 })
end

return MomentsLookTryOnPeekView
