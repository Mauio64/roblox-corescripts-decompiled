local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Dash = require(parent.Dash)

local AvatarExperienceInspectAndBuy = require(parent.AvatarExperienceInspectAndBuy)
local BuyActionBar = AvatarExperienceInspectAndBuy.Components.BuyActionBar

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(ProfilePlatform.Common.Types)
local InspectAvatarUtils = require(ProfilePlatform.Components.InspectAvatar.InspectAvatarUtils)
local ItemDisplayHelpers = require(ProfilePlatform.Components.InspectAvatar.ItemDisplayHelpers)
local CatalogItemRowCardContainer = require(ProfilePlatform.Components.InspectAvatar.CatalogItemRowCardContainer)

local RecentActivityPurchaseConfirmationDialog = require(script.Parent.RecentActivityPurchaseConfirmationDialog)
local RecentActivityInsufficientRobuxDialog = require(script.Parent.RecentActivityInsufficientRobuxDialog)

local Sheet = Foundation.Sheet
local View = Foundation.View
local Text = Foundation.Text
local Skeleton = Foundation.Skeleton
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local isItemPurchasable = InspectAvatarUtils.isItemPurchasable

local function RecentActivityInspectAndBuyView(props)
	local v = useLocalization({
		title = "Feature.Catalog.Label.BuyItems",
		buyHeader = {
			"Feature.Profile.Header.InspectAndBuy.BuySection",
			numberOfSelectedItems = props.purchaseSummary.count,
			totalNumberOfItems = #props.displayItems
		},
		buyWholeLook = "Feature.Profile.Header.BuyWholeLook",
		bundle = "Feature.Catalog.Label.Bundle"
	})

	local priceStatusLocalized = useLocalization(ItemDisplayHelpers.PRICE_STATUS_LOCALIZATION_KEYS)
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

	local v4 = React.useMemo(function()
		local children2 = {}

		for i = 1, 4 do
			children2[`Shimmer{i}`] = React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, 72),
				LayoutOrder = i
			})
		end

		return children2
	end, {})

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local root = Sheet.Root
	local v5 = {
		onClose = props.onClose,
		snapPoints = { 1 },
		size = DialogSize.Large
	}
	local children2 = {
		Header = React.createElement(Sheet.Header, { hasCloseAffordance = true }, {
			HeaderTitle = React.createElement(Text, {
				tag = "size-full-0 auto-y text-title-large text-align-x-center",
				Text = v.title
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement3 = React.createElement
	local content = Sheet.Content
	local itemList

	if not props.isLoading then
		itemList = React.createElement(
			View,
			{ tag = "col gap-large size-full-0 auto-y padding-bottom-large padding-top-medium" },
			children
		)
	end

	local loadingShimmer

	if props.isLoading then
		loadingShimmer = React.createElement(View, { tag = "col size-full-0 auto-y" }, v4)
	end

	children2.Content = createElement3(content, nil, {
		ItemList = itemList,
		LoadingShimmer = loadingShimmer
	})

	children2.Actions = React.createElement(Sheet.Actions, nil, {
		ActionBar = React.createElement(View, { tag = "size-full-2500" }, {
			BuyBar = React.createElement(BuyActionBar, {
				priceLabel = {
					leftLabel = v.buyHeader,
					priceInRobux = tostring(props.purchaseSummary.totalPrice)
				},
				purchaseButtonProps = {
					purchaseButtonText = v.buyWholeLook,
					onPurchase = props.onBuyAll,
					isDisabled = props.isLoading or props.purchaseSummary.count == 0,
					variant = ButtonVariant.Emphasis
				}
			})
		})
	})
	local v6 = {
		SheetRoot = createElement2(root, v5, children2),
		PurchaseConfirmation = 0,
		InsufficientRobux = 0
	}
	local purchaseConfirmation

	if props.isConfirmingPurchase then
		purchaseConfirmation = React.createElement(RecentActivityPurchaseConfirmationDialog, {
			totalPrice = props.purchaseSummary.totalPrice,
			isPurchasing = props.isPurchasing,
			onConfirm = props.onConfirmPurchase,
			onCancel = props.onCancelPurchase
		})
	end

	v6.PurchaseConfirmation = purchaseConfirmation
	local insufficientRobux

	if props.isShowingInsufficientRobux then
		insufficientRobux = React.createElement(RecentActivityInsufficientRobuxDialog, {
			totalPrice = props.purchaseSummary.totalPrice,
			robuxBalance = props.robuxBalance,
			onClose = props.onDismissInsufficientRobux
		})
	end

	v6.InsufficientRobux = insufficientRobux
	return createElement(fragment, nil, v6)
end

return RecentActivityInspectAndBuyView
