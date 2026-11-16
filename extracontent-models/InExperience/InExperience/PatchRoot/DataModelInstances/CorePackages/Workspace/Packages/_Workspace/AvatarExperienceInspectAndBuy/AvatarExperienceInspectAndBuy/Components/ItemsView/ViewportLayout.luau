local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local BackButton = require(AvatarExperienceInspectAndBuy.Components.Common.BackButton)
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)
local BuyActionBarLayout = require(AvatarExperienceInspectAndBuy.Components.ItemsView.BuyActionBarLayout)
require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)
require(AvatarExperienceInspectAndBuy.Types)
local getTryOnBackgroundImage = require(AvatarExperienceInspectAndBuy.Utils.getTryOnBackgroundImage)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXInspectAndBuyAvatarBackground = AvatarExperienceFlags.FFlagAXInspectAndBuyAvatarBackground

local function ViewportLayout(props)
	local v = props.view == ViewType.WideLandscape
	local onBackButtonClick = props.backButtonProps and props.backButtonProps.onBackButtonClick
	local v2 = useTokens()
	local backgroundImageUrl

	if FFlagAXInspectAndBuyAvatarBackground then
		backgroundImageUrl = props.backgroundImageUrl
	end

	local createElement = React.createElement
	local v3 = {
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,
		BackgroundTransparency = 1
	}
	local backButton

	if not (v or not props.backButtonProps) then
		backButton = React.createElement(BackButton, {
			onBackButtonClick = onBackButtonClick,
			Position = props.backButtonProps and props.backButtonProps.Position or UDim2.new(0, v2.Padding.Small, 0, v2.Padding.Small)
		})
	end

	local createElement2 = React.createElement
	local view = Foundation.View
	local v4 = { Size = UDim2.new(1, 0, 1, 0) }

	local createElement3 = React.createElement
	local v5 = {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalFlex = 0
	}
	local verticalFlex

	if v then
		verticalFlex = Enum.UIFlexAlignment.SpaceBetween
	end

	v5.VerticalFlex = verticalFlex
	local children = {
		UIListLayout = createElement3("UIListLayout", v5),
		Thumbnail = 0,
		ViewportContainer = 0,
		BuyActionBarLayout = 0
	}
	local thumbnail

	if not props.tryOnState.isTryOnEnabled then
		local createElement4 = React.createElement
		local view2 = Foundation.View
		local v6 = {
			Size = props.viewportProps and props.viewportProps.Size or UDim2.new(0, 200, 0, 200),
			LayoutOrder = 1
		}
		local background

		if backgroundImageUrl then
			background = React.createElement(Foundation.Image, {
				Image = backgroundImageUrl,
				ScaleType = Enum.ScaleType.Crop,
				tag = "size-full radius-medium",
				ZIndex = 1,
				testId = "inspect-and-buy-viewport-background"
			})
		end

		local children2 = {
			Background = background,
			ImageLabel = React.createElement("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Image = props.thumbnailUrl,
				ScaleType = props.viewportProps and props.viewportProps.ScaleType or Enum.ScaleType.Fit,
				ZIndex = backgroundImageUrl and 2 or nil
			}),
			UIFlexItem = 0,
			UIAspectRatioConstraint = 0,
			UIPadding = 0
		}
		local uiFlexItem

		if v then
			uiFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
		end

		children2.UIFlexItem = uiFlexItem

		children2.UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = props.viewportProps and props.viewportProps.AspectRatio or 1
		})
		local uiPadding

		if props.thumbnailPadding then
			uiPadding = React.createElement("UIPadding", {
				PaddingLeft = props.thumbnailPadding.left,
				PaddingRight = props.thumbnailPadding.right,
				PaddingTop = props.thumbnailPadding.top,
				PaddingBottom = props.thumbnailPadding.bottom
			})
		end

		children2.UIPadding = uiPadding
		thumbnail = createElement4(view2, v6, children2)
	end

	children.Thumbnail = thumbnail

	local createElement4 = React.createElement
	local view2 = Foundation.View
	local v6 = {
		tag = "padding-top-medium",
		Size = props.viewportProps and props.viewportProps.Size or UDim2.new(0, 200, 0, 200),
		LayoutOrder = 1,
		Visible = props.tryOnState.isTryOnEnabled
	}
	local uiFlexItem

	if v then
		uiFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
	end

	local v7 = {
		UIFlexItem = uiFlexItem,
		UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = props.viewportProps and props.viewportProps.AspectRatio or 1
		}),
		TryOnBackground = 0,
		Viewport = 0
	}
	local tryOnBackground

	if FFlagAXInspectAndBuyAvatarBackground and props.tryOnState.isTryOnEnabled then
		tryOnBackground = React.createElement(Foundation.Image, {
			Image = getTryOnBackgroundImage(props.tryOnState.tryOnItem),
			ScaleType = Enum.ScaleType.Crop,
			tag = "size-full radius-medium",
			ZIndex = 0,
			testId = "inspect-and-buy-try-on-background"
		})
	end

	v7.TryOnBackground = tryOnBackground

	v7.Viewport = props.renderTryOnViewport(props.tryOnState.tryOnItem)
	children.ViewportContainer = createElement4(view2, v6, v7)
	local buyActionBarLayout

	if v and props.buyActionBarProps then
		buyActionBarLayout = React.createElement(BuyActionBarLayout, {
			enableTopBorder = true,
			Size = UDim2.new(1, 0, 0, v2.Size.Size_1900),
			buyActionBarProps = props.buyActionBarProps,
			purchaseButtonProps = props.buyActionBarProps.purchaseButtonProps
		})
	end

	children.BuyActionBarLayout = buyActionBarLayout
	return createElement("Frame", v3, {
		BackButton = backButton,
		InnerView = createElement2(view, v4, children)
	})
end

return ViewportLayout
