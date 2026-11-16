local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local EditProfileBackground = require(parent.EditProfileBackground)
local DisplayBackground = EditProfileBackground.DisplayBackground

local AvatarExperienceInspectAndBuy = require(parent.AvatarExperienceInspectAndBuy)
local BuyActionBar = AvatarExperienceInspectAndBuy.Components.BuyActionBar
local Dash = require(parent.Dash)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(parent.InputHandlers)

local SharedFlags = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav = SharedFlags.FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav
local FFlagProfileInspectAvatarBuyAll = require(ProfilePlatform.Flags.FFlagProfileInspectAvatarBuyAll)
local FFlagProfileInspectAvatarBackground = require(ProfilePlatform.Flags.FFlagProfileInspectAvatarBackground)

local View = Foundation.View
local Image = Foundation.Image
local Text = Foundation.Text
local IconButton = Foundation.IconButton
local Divider = Foundation.Divider
local Skeleton = Foundation.Skeleton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(ProfilePlatform.Common.Types)
local ItemDisplayHelpers = require(script.Parent.ItemDisplayHelpers)
local InspectAvatarUtils = require(script.Parent.InspectAvatarUtils)
local CatalogItemRowCardContainer = require(script.Parent.CatalogItemRowCardContainer)

local isItemPurchasable = InspectAvatarUtils.isItemPurchasable

local function InspectAvatarSheet(props)
	local v = useLocalization({
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

	local priceStatusLocalized = useLocalization(ItemDisplayHelpers.PRICE_STATUS_LOCALIZATION_KEYS)
	local xLarge

	if FFlagProfileInspectAvatarBackground then
		xLarge = useTokens().Padding.XLarge
	end

	local v2 = useLocalization(ItemDisplayHelpers.ASSET_TYPE_LOCALIZATION_KEYS)
	local v3 = useLocalization(ItemDisplayHelpers.BUNDLE_TYPE_LOCALIZATION_KEYS)

	local localizedStrings = React.useMemo(function()
		return { bundle = v.bundle, bundleParts = nil, assetTypeNames = Dash.join(v2, v3) }
	end, { v.bundle, v2, v3 })

	local children = {}

	for k, displayItem in props.displayItems do
		local id = displayItem.id
		children[`item_{id}`] = React.createElement(CatalogItemRowCardContainer, {
			asset = displayItem,
			index = k,
			isChecked = props.selectedItems[id] == true,
			isPurchasable = isItemPurchasable(displayItem),
			rowHeight = 72,
			localizedStrings = localizedStrings,
			priceStatusLocalized = priceStatusLocalized,
			onToggleItem = props.onToggleItem,
			openItemDetails = props.openItemDetails
		})
	end

	local handler

	if FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then
		handler = React.useMemo(function()
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
			Selectable = not FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav and nil,
			[React.Event.Activated] = props.onDismiss
		}),
		Sheet = 0
	}

	local createElement = React.createElement
	local v4 = {
		tag = "col position-top-right anchor-top-right margin-bottom-small padding-x-xlarge bg-surface-0",
		Size = UDim2.new(0, props.cardWidth, 1, 0)
	}
	local statusBarSpacer

	if props.topOffset > 0 then
		statusBarSpacer = React.createElement(View, {
			tag = "bg-surface-0",
			Size = UDim2.new(1, 0, 0, props.topOffset),
			LayoutOrder = 0
		})
	end

	local createElement2 = React.createElement
	local v5 = {
		Size = UDim2.new(1, 0, 0, props.avatarViewportHeight),
		LayoutOrder = 1
	}
	local backgroundClipper

	if FFlagProfileInspectAvatarBackground and props.avatarBackgroundImage ~= nil then
		backgroundClipper = React.createElement(View, {
			ClipsDescendants = true,
			Size = UDim2.new(1, xLarge * 2, 1, 0),
			Position = UDim2.new(0, -xLarge, 0, 0),
			ZIndex = 1
		}, {
			BackgroundImage = React.createElement(Image, {
				Size = UDim2.fromScale(1.35, 1.35),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = props.avatarBackgroundImage,
				ScaleType = Enum.ScaleType.Crop
			})
		})
	end

	local children4 = {
		BackgroundClipper = backgroundClipper,
		Background = React.createElement(DisplayBackground, {
			height = props.avatarViewportHeight,
			userId = tonumber(props.profileId),
			userThumbnail = props.avatarThumbnail
		}),
		TopBar = 0
	}

	local createElement3 = React.createElement
	local v6 = {
		tag = {
			["row align-y-center"] = FFlagProfileInspectAvatarBackground,
			["row align-y-center size-full-0 auto-y padding-small"] = not FFlagProfileInspectAvatarBackground
		},
		Size = 0,
		Position = 0,
		ZIndex = 2
	}
	local size

	if FFlagProfileInspectAvatarBackground then
		size = UDim2.new(1, 0, 0, 56)
	end

	v6.Size = size
	local position

	if FFlagProfileInspectAvatarBackground then
		position = UDim2.new(0, 10 - xLarge, 0, 0)
	end

	v6.Position = position
	local backButtonCircle

	if FFlagProfileInspectAvatarBackground then
		backButtonCircle = React.createElement(
			View,
			{ tag = "radius-circle bg-over-media-0", Size = UDim2.fromOffset(36, 36) },
			{
				BackButton = React.createElement(IconButton, {
					icon = IconName.ChevronLargeLeft,
					size = IconSize.Small,
					variant = ButtonVariant.Utility,
					onActivated = props.onClose,
					isCircular = true,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			}
		)
	end

	local backButton

	if not FFlagProfileInspectAvatarBackground then
		backButton = React.createElement(IconButton, {
			icon = IconName.ChevronLargeLeft,
			size = IconSize.Medium,
			variant = ButtonVariant.Utility,
			onActivated = props.onClose,
			isCircular = true
		})
	end

	children4.TopBar = createElement3(View, v6, {
		BackButtonCircle = backButtonCircle,
		BackButton = backButton
	})
	local children3 = {
		StatusBarSpacer = statusBarSpacer,
		AvatarViewport = createElement2(View, v5, children4),
		Title = React.createElement(Text, {
			tag = "size-full-0 auto-y padding-y-small text-heading-small text-align-x-left",
			Text = v.title,
			LayoutOrder = 2
		}),
		ScrollWrapper = 0,
		FooterDivider = 0,
		Footer = 0
	}

	local createElement4 = React.createElement

	local v7 = { ScrollContent = 0 }
	local createElement5 = React.createElement
	local v8 = {
		Size = UDim2.fromScale(1, 1),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}
	local itemList

	if not props.isLoading then
		itemList = React.createElement(
			View,
			{ tag = "col gap-large size-full-0 auto-y padding-bottom-large padding-top-medium" },
			children
		)
	end

	local v9 = { ItemList = itemList, LoadingShimmer = 0 }
	local loadingShimmer

	if props.isLoading then
		local createElement6 = React.createElement

		local children5 = {}

		for i = 1, 4 do
			children5[`Shimmer{i}`] = React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, 72),
				LayoutOrder = i
			})
		end

		loadingShimmer = createElement6(View, { tag = "col size-full-0 auto-y" }, children5)
	end

	v9.LoadingShimmer = loadingShimmer
	v7.ScrollContent = createElement5("ScrollingFrame", v8, v9)
	children3.ScrollWrapper = createElement4(View, { tag = "fill size-full-0", LayoutOrder = 3 }, v7)

	children3.FooterDivider = React.createElement(Divider, {
		Size = UDim2.new(1, 0, 0, 1),
		LayoutOrder = 4
	})

	local createElement6 = React.createElement

	local createElement7 = React.createElement
	local v10 = {
		priceLabel = {
			leftLabel = v.buyHeader,
			priceInRobux = tostring(props.purchaseSummary.totalPrice)
		},
		purchaseButtonProps = 0
	}
	local purchaseButtonText

	if FFlagProfileInspectAvatarBuyAll then
		purchaseButtonText = v.buyWholeLook
	else
		purchaseButtonText = v.buyItems
	end

	v10.purchaseButtonProps = {
		purchaseButtonText = purchaseButtonText,
		onPurchase = props.onBuyAll,
		isDisabled = props.isLoading or props.purchaseSummary.count == 0,
		variant = ButtonVariant.Emphasis
	}
	children3.Footer = createElement6(View, { tag = "size-full-2500 bg-surface-0", LayoutOrder = 5 }, {
		ActionBar = createElement7(BuyActionBar, v10)
	})
	children2.Sheet = createElement(View, v4, children3)

	if not FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then
		return React.createElement(View, { Size = UDim2.fromScale(1, 1) }, children2)
	end

	return React.createElement(AppFocusRoot, {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		isIsolated = true,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = { handler = handler }
		}
	}, children2)
end

return InspectAvatarSheet
