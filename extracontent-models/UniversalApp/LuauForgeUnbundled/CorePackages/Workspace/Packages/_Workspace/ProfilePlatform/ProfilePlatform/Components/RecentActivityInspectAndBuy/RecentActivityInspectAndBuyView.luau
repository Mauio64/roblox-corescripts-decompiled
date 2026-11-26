local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Dash")

local buyActionBar = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceInspectAndBuy").Components.BuyActionBar

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local InspectAvatarUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/InspectAvatarUtils")
local ItemDisplayHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/ItemDisplayHelpers")
local CatalogItemRowCardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/CatalogItemRowCardContainer")

local RecentActivityPurchaseConfirmationDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/RecentActivityInspectAndBuy/RecentActivityPurchaseConfirmationDialog")
local RecentActivityInsufficientRobuxDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/RecentActivityInspectAndBuy/RecentActivityInsufficientRobuxDialog")

local sheet = Foundation.Sheet
local view = Foundation.View
local text = Foundation.Text
local skeleton = Foundation.Skeleton
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant

local isItemPurchasable = InspectAvatarUtils.isItemPurchasable

local function RecentActivityInspectAndBuyView(props)
	local v5 = useLocalization({
		title = "Feature.Catalog.Label.BuyItems",
		buyHeader = {
			"Feature.Profile.Header.InspectAndBuy.BuySection",
			numberOfSelectedItems = props.purchaseSummary.count,
			totalNumberOfItems = #props.displayItems
		},
		buyWholeLook = "Feature.Profile.Header.BuyWholeLook",
		bundle = "Feature.Catalog.Label.Bundle"
	})

	local v6 = useLocalization(ItemDisplayHelpers.PRICE_STATUS_LOCALIZATION_KEYS)
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

	local v10 = React.useMemo(function()
		local children2 = {}

		for i = 1, 4 do
			children2[`Shimmer{i}`] = React.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, 72),
				LayoutOrder = i
			})
		end

		return children2
	end, {})

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local root = sheet.Root
	local v13 = {
		onClose = props.onClose,
		snapPoints = { 1 },
		size = dialogSize.Large
	}
	local children2 = {
		Header = React.createElement(sheet.Header, { hasCloseAffordance = true }, {
			HeaderTitle = React.createElement(text, {
				tag = "size-full-0 auto-y text-title-large text-align-x-center",
				Text = v5.title
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement3 = React.createElement
	local content = sheet.Content
	local v16 = if not props.isLoading then React.createElement(
		view,
		{
			tag = "col gap-large size-full-0 auto-y padding-bottom-large padding-top-medium"
		},
		children
	) else nil

	local v17 = if props.isLoading then React.createElement(view, {
		tag = "col size-full-0 auto-y"
	}, v10) else nil
	children2.Content = createElement3(content, nil, {
		ItemList = v16,
		LoadingShimmer = v17
	})

	children2.Actions = React.createElement(sheet.Actions, nil, {
		ActionBar = React.createElement(view, { tag = "size-full-2500" }, {
			BuyBar = React.createElement(buyActionBar, {
				priceLabel = {
					leftLabel = v5.buyHeader,
					priceInRobux = tostring(props.purchaseSummary.totalPrice)
				},
				purchaseButtonProps = {
					purchaseButtonText = v5.buyWholeLook,
					onPurchase = props.onBuyAll,
					isDisabled = props.isLoading or props.purchaseSummary.count == 0,
					variant = buttonVariant.Emphasis
				}
			})
		})
	})
	local v12 = {
		SheetRoot = createElement2(root, v13, children2),
		PurchaseConfirmation = 0,
		InsufficientRobux = 0
	}

	local v18 = if props.isConfirmingPurchase then React.createElement(RecentActivityPurchaseConfirmationDialog, {
		totalPrice = props.purchaseSummary.totalPrice,
		isPurchasing = props.isPurchasing,
		onConfirm = props.onConfirmPurchase,
		onCancel = props.onCancelPurchase
	}) else nil
	v12.PurchaseConfirmation = v18

	local v19 = if props.isShowingInsufficientRobux then React.createElement(RecentActivityInsufficientRobuxDialog, {
		totalPrice = props.purchaseSummary.totalPrice,
		robuxBalance = props.robuxBalance,
		onClose = props.onDismissInsufficientRobux
	}) else nil
	v12.InsufficientRobux = v19
	return createElement(fragment, nil, v12)
end

return RecentActivityInspectAndBuyView
