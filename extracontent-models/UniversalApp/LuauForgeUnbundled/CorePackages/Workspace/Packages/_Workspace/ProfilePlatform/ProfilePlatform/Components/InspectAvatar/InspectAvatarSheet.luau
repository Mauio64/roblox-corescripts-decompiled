local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")

local displayBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/EditProfileBackground").DisplayBackground

local buyActionBar = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceInspectAndBuy").Components.BuyActionBar
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Dash")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FocusNavigationUtils")
local appFocusRoot = FocusNavigationUtils.AppFocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/InputHandlers")

local fFlagSocialEnableProfileInspectAndBuyConsoleFocusNav = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav
local FFlagProfileInspectAvatarBuyAll = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileInspectAvatarBuyAll")
local FFlagProfileInspectAvatarBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileInspectAvatarBackground")

local view = Foundation.View
local image = Foundation.Image
local text = Foundation.Text
local iconButton = Foundation.IconButton
local divider = Foundation.Divider
local skeleton = Foundation.Skeleton
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local buttonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local ItemDisplayHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/ItemDisplayHelpers")
local InspectAvatarUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/InspectAvatarUtils")
local CatalogItemRowCardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/CatalogItemRowCardContainer")

local isItemPurchasable = InspectAvatarUtils.isItemPurchasable

local function InspectAvatarSheet(props)
	local v5 = useLocalization({
		title = {
			"Feature.Profile.Header.InspectAndBuy",
			username = props.username
		},
		buyHeader = {
			"Feature.Profile.Header.InspectAndBuy.BuySection",
			numberOfSelectedItems = props.purchaseSummary.count,
			totalNumberOfItems = #props.displayItems
		},
		buyItems = "Feature.Catalog.Label.BuyItems",
		buyWholeLook = "Feature.Profile.Header.BuyWholeLook",
		bundle = "Feature.Catalog.Label.Bundle"
	})

	local v6 = useLocalization(ItemDisplayHelpers.PRICE_STATUS_LOCALIZATION_KEYS)

	local xLarge = if FFlagProfileInspectAvatarBackground then useTokens().Padding.XLarge else nil

	local v7 = useLocalization(ItemDisplayHelpers.ASSET_TYPE_LOCALIZATION_KEYS)
	local v8 = useLocalization(ItemDisplayHelpers.BUNDLE_TYPE_LOCALIZATION_KEYS)

	local v9 = React.useMemo(function()
		return {
			bundle = v5.bundle,
			bundleParts = nil,
			assetTypeNames = Dash.join(v7, v8)
		}
	end, { v5.bundle, v7, v8 })

	local children = {}

	for k, displayItem in props.displayItems do
		local id = displayItem.id
		children[`item_{id}`] = React.createElement(CatalogItemRowCardContainer, {
			asset = displayItem,
			index = k,
			isChecked = props.selectedItems[id] == true,
			isPurchasable = isItemPurchasable(displayItem),
			rowHeight = 72,
			localizedStrings = v9,
			priceStatusLocalized = v6,
			onToggleItem = props.onToggleItem,
			openItemDetails = props.openItemDetails
		})
	end

	local v10

	if fFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then
		v10 = React.useMemo(function()
			return InputHandlers.onRelease(function(object)
				object:cancel()
				props.onClose()
			end)
		end, { props.onClose })
	end

	local children2 = {
		Scrim = React.createElement("TextButton", {
			Size = UDim2.new(1, -props.cardWidth, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			Selectable = if fFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then false else nil,
			[React.Event.Activated] = props.onDismiss
		}),
		Sheet = 0
	}

	local createElement2 = React.createElement
	local v14 = {
		tag = "col position-top-right anchor-top-right margin-bottom-small padding-x-xlarge bg-surface-0",
		Size = UDim2.new(0, props.cardWidth, 1, 0)
	}

	local v15 = if props.topOffset > 0 then React.createElement(view, {
		tag = "bg-surface-0",
		Size = UDim2.new(1, 0, 0, props.topOffset),
		LayoutOrder = 0
	}) else nil

	local createElement3 = React.createElement
	local v17 = {
		Size = UDim2.new(1, 0, 0, props.avatarViewportHeight),
		LayoutOrder = 1
	}

	local v18 = if FFlagProfileInspectAvatarBackground and props.avatarBackgroundImage ~= nil then React.createElement(view, {
		ClipsDescendants = true,
		Size = UDim2.new(1, xLarge * 2, 1, 0),
		Position = UDim2.new(0, -xLarge, 0, 0),
		ZIndex = 1
	}, {
		BackgroundImage = React.createElement(image, {
			Size = UDim2.fromScale(1.35, 1.35),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = props.avatarBackgroundImage,
			ScaleType = Enum.ScaleType.Crop
		})
	}) else nil
	local children4 = {
		BackgroundClipper = v18,
		Background = React.createElement(displayBackground, {
			height = props.avatarViewportHeight,
			userId = tonumber(props.profileId),
			userThumbnail = props.avatarThumbnail
		}),
		TopBar = 0
	}

	local createElement4 = React.createElement
	local v20 = {
		tag = {
			["row align-y-center"] = FFlagProfileInspectAvatarBackground,
			["row align-y-center size-full-0 auto-y padding-small"] = not FFlagProfileInspectAvatarBackground
		},
		Size = 0,
		Position = 0,
		ZIndex = 2
	}

	local v21 = if FFlagProfileInspectAvatarBackground then UDim2.new(1, 0, 0, 56) else nil
	v20.Size = v21

	local v22 = if FFlagProfileInspectAvatarBackground then UDim2.new(0, 10 - xLarge, 0, 0) else nil
	v20.Position = v22

	local v24 = if FFlagProfileInspectAvatarBackground then React.createElement(
		view,
		{ tag = "radius-circle bg-over-media-0", Size = UDim2.fromOffset(36, 36) },
		{
			BackButton = React.createElement(iconButton, {
				icon = iconName.ChevronLargeLeft,
				size = iconSize.Small,
				variant = buttonVariant.Utility,
				onActivated = props.onClose,
				isCircular = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		}
	) else nil

	local v25 = if not FFlagProfileInspectAvatarBackground then React.createElement(iconButton, {
		icon = iconName.ChevronLargeLeft,
		size = iconSize.Medium,
		variant = buttonVariant.Utility,
		onActivated = props.onClose,
		isCircular = true
	}) else nil
	children4.TopBar = createElement4(view, v20, {
		BackButtonCircle = v24,
		BackButton = v25
	})
	local children3 = {
		StatusBarSpacer = v15,
		AvatarViewport = createElement3(view, v17, children4),
		Title = React.createElement(text, {
			tag = "size-full-0 auto-y padding-y-small text-heading-small text-align-x-left",
			Text = v5.title,
			LayoutOrder = 2
		}),
		ScrollWrapper = 0,
		FooterDivider = 0,
		Footer = 0
	}

	local createElement5 = React.createElement

	local v28 = { ScrollContent = 0 }
	local createElement6 = React.createElement
	local v30 = {
		Size = UDim2.fromScale(1, 1),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v32 = if not props.isLoading then React.createElement(
		view,
		{
			tag = "col gap-large size-full-0 auto-y padding-bottom-large padding-top-medium"
		},
		children
	) else nil
	local v31 = { ItemList = v32, LoadingShimmer = 0 }
	local v33

	if props.isLoading then
		local createElement7 = React.createElement

		local children5 = {}

		for i = 1, 4 do
			children5[`Shimmer{i}`] = React.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, 72),
				LayoutOrder = i
			})
		end

		v33 = createElement7(view, { tag = "col size-full-0 auto-y" }, children5)
	end

	v31.LoadingShimmer = v33
	v28.ScrollContent = createElement6("ScrollingFrame", v30, v31)
	children3.ScrollWrapper = createElement5(view, {
		tag = "fill size-full-0",
		LayoutOrder = 3
	}, v28)

	children3.FooterDivider = React.createElement(divider, {
		Size = UDim2.new(1, 0, 0, 1),
		LayoutOrder = 4
	})

	local createElement7 = React.createElement

	local createElement8 = React.createElement
	local v38 = {
		priceLabel = {
			leftLabel = v5.buyHeader,
			priceInRobux = tostring(props.purchaseSummary.totalPrice)
		},
		purchaseButtonProps = 0
	}

	local v40 = if FFlagProfileInspectAvatarBuyAll then v5.buyWholeLook else v5.buyItems
	v38.purchaseButtonProps = {
		purchaseButtonText = v40,
		onPurchase = props.onBuyAll,
		isDisabled = props.isLoading or props.purchaseSummary.count == 0,
		variant = buttonVariant.Emphasis
	}
	children3.Footer = createElement7(view, {
		tag = "size-full-2500 bg-surface-0",
		LayoutOrder = 5
	}, {
		ActionBar = createElement8(buyActionBar, v38)
	})
	children2.Sheet = createElement2(view, v14, children3)

	if not fFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then
		return React.createElement(view, { Size = UDim2.fromScale(1, 1) }, children2)
	end

	return React.createElement(appFocusRoot, {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		isIsolated = true,
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = { handler = v10 }
		}
	}, children2)
end

return InspectAvatarSheet
