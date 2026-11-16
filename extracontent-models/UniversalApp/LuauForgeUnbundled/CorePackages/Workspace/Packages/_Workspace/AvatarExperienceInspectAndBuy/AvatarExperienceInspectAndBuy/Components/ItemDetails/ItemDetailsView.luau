local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemDetails/BundleAssetsList")
local enums = Foundation.Enums
local ItemHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/ItemHeader")
local useConvertedItemData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Hooks/useConvertedItemData")
local useItemExperienceInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Hooks/useItemExperienceInfo")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemDetails/ControlBar")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemDetails/ResellableInstancesLabel")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemDetails/ItemInfoLabels")
local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Localization").NumberLocalization
local useItemStatusLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Hooks/useItemStatusLocalization")
local itemDetailsUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/itemDetailsUtils")
local isCollectible = itemDetailsUtils.isCollectible
local isInExperienceCreationPlayable = itemDetailsUtils.isInExperienceCreationPlayable
local isTradeable = itemDetailsUtils.isTradeable
local getCreatorName = itemDetailsUtils.getCreatorName
local getOriginalPrice = itemDetailsUtils.getOriginalPrice
local getQuantitySold = itemDetailsUtils.getQuantitySold
local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemsView/ViewportLayout")
local getItemThumbnailUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getItemThumbnailUrl")
local SubheaderLabelPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/SubheaderLabelPrice")
local getPriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceStatus")
local getPriceInRobux = itemDetailsUtils.getPriceInRobux
local isItemAvailableForTryOn = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/isItemAvailableForTryOn")
local module17 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BackButton")
local formatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/formatNumber")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local ViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")
local useTokens = Foundation.Hooks.useTokens
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BuyActionBar")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")

local function fn(view, p2)
	if view == ViewType.WideLandscape then
		return {
			PaddingTop = UDim.new(0, p2.Padding.XSmall),
			PaddingLeft = UDim.new(0, p2.Padding.Medium),
			PaddingRight = UDim.new(0, p2.Padding.Medium),
			PaddingBottom = UDim.new(0, p2.Padding.XXLarge)
		}
	end

	if view == ViewType.Wide then
		return {
			PaddingTop = UDim.new(0, p2.Padding.XSmall),
			PaddingBottom = UDim.new(0, p2.Padding.XLarge),
			PaddingLeft = UDim.new(0, p2.Margin.Large * 2),
			PaddingRight = UDim.new(0, p2.Margin.Large * 2)
		}
	end

	return {
		PaddingTop = UDim.new(0, p2.Padding.XSmall),
		PaddingBottom = UDim.new(0, p2.Padding.XLarge),
		PaddingLeft = UDim.new(0, p2.Padding.XXLarge),
		PaddingRight = UDim.new(0, p2.Padding.XXLarge)
	}
end

local function fn2(view, p2)
	if view == ViewType.WideLandscape then
		return {
			left = UDim.new(0, p2.Padding.Large),
			right = UDim.new(0, p2.Padding.Large),
			bottom = UDim.new(0, p2.Padding.XXLarge)
		}
	end

	return {
		bottom = UDim.new(0, p2.Padding.XXLarge)
	}
end

local function fn3(view, p2, p3)
	if view == ViewType.Compact then
		return UDim2.new(1, 0, 1, -p2.buyActionBarOffset - p2.backButtonOffset - p3.Padding.Small)
	end

	return UDim2.new(1, 0, 1, -p2.backButtonOffset - p3.Padding.Small)
end

local function ItemDetailsView(props)
	local v5 = useTokens()
	local v6 = useConvertedItemData(props.item)
	local v7 = if v6 then v6.creatingUniverseId else nil
	local v8 = useItemExperienceInfo(v7)
	local v9 = getPriceStatus(v6)
	local v10 = props.view == ViewType.WideLandscape
	local v11 = props.view == ViewType.Compact
	local v12 = props.view == ViewType.Wide
	local v13 = useItemStatusLocalization(v6)
	local v14 = fn(props.view, v5)
	local buyActionBarOffset = props.buyActionBarOffset or 0
	local size_1000 = v5.Size.Size_1000

	local v16 = {
		key = "Category",
		isVisible = true,
		labelProps = {
			leftLabel = v13.category,
			rightLabel = not v6 and "" or v13[v6.itemSubType]
		}
	}

	local v17 = {
		key = "QuantitySold",
		isVisible = isCollectible(v6),
		labelProps = {
			leftLabel = v13.quantitySold,
			rightLabel = getQuantitySold(v6, props.formatNumber)
		}
	}

	local v18 = {
		key = "OriginalPrice",
		isVisible = isCollectible(v6),
		labelProps = {
			leftLabel = v13.originalPrice,
			rightLabel = getOriginalPrice(v6, v13.na, props.formatNumber)
		}
	}

	local v19 = { key = "Tradeable", isVisible = isCollectible(v6), labelProps = 0 }
	local v20 = { leftLabel = v13.tradeable, rightLabel = 0 }
	local v21 = if isTradeable(v6) then v13.yes else v13.no
	v20.rightLabel = v21
	v19.labelProps = v20
	local v15 = { v16, v17, v18, v19 }

	local v22 = {
		key = "MadeIn",
		isVisible = isInExperienceCreationPlayable(v8),
		labelProps = 0
	}
	local v23 = { leftLabel = v13.madein, rightLabel = 0 }
	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v28 = if v8 then React.createElement(Foundation.Text, {
		LayoutOrder = 1,
		tag = "auto-xy text-title-medium content-default",
		Text = v8.name
	}) or nil else nil

	local v29 = if v8 then React.createElement(Foundation.Icon, {
		LayoutOrder = 2,
		name = enums.IconName.ArrowSmallRight,
		variant = enums.IconVariant.Filled,
		size = enums.IconSize.Medium,
		style = v5.Color.Content.Default
	}) or nil else nil
	v23.rightLabel = createElement(view, {
		LayoutOrder = 2,
		tag = "auto-xy",
		onActivated = function()
			if props.openAttributionOverlay then
				props.openAttributionOverlay(v8)
			end
		end
	}, {
		AttributionLabel = createElement2(view2, {
			tag = "auto-xy row gap-small align-y-center"
		}, {
			ExperienceName = v28,
			ArrowIcon = v29
		})
	})
	v22.labelProps = v23
	table.insert(v15, v22)

	local createElement3 = React.createElement
	local view3 = Foundation.View

	local v31 = {
		ButtonContainer = React.createElement(Foundation.View, {}, {
			BackButton = React.createElement(module17, {
				onBackButtonClick = props.onItemDetailsClosed,
				Size = UDim2.new(0, size_1000, 1, 0),
				Position = UDim2.new(0, v5.Padding.Small, 0, v5.Padding.Small)
			})
		}),
		ScrollingFrame = 0
	}

	local createElement4 = React.createElement
	local v33 = {
		Size = fn3(
			props.view,
			{ buyActionBarOffset = buyActionBarOffset, backButtonOffset = size_1000 },
			v5
		),
		Position = UDim2.new(0, 0, 0, size_1000 + v5.Padding.Medium),
		CanvasSize = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 0,
		BorderSizePixel = 0
	}

	local children = {
		UIPadding = React.createElement("UIPadding", v14),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, v5.Padding.Small)
		}),
		ViewportLayout = 0,
		Header = 0,
		DetailsContainer = 0
	}
	local v34 = if v11 or v12 then React.createElement(module12, {
		view = props.view,
		LayoutOrder = 1,
		thumbnailUrl = getItemThumbnailUrl(props.item) or "",
		viewportProps = {
			Size = UDim2.new(
				0,
				v5.Size.Size_3000 * (props.view == ViewType.Wide and 2.5 or 2),
				0,
				v5.Size.Size_3000 * (props.view == ViewType.Wide and 2.5 or 2)
			)
		},
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		renderTryOnViewport = props.renderTryOnViewport,
		tryOnState = props.tryOnState
	}) else nil
	children.ViewportLayout = v34

	local createElement5 = React.createElement
	local v36 = {
		LayoutOrder = 1,
		headerHeight = v5.Size.Size_1300,
		purchaseButtonProps = props.purchaseButtonProps,
		padding = fn2(props.view, v5),
		header = React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			tag = "auto-xy text-heading-small content-emphasis text-truncate-end",
			Text = v6 and v6.name or ""
		}),
		subheader = 0
	}

	local v37 = if v12 then React.createElement(SubheaderLabelPrice, {
		subheaderText = {
			leftSlotLabel = getCreatorName(v6),
			rightSlotPrice = formatNumber(getPriceInRobux(v6, v9))
		},
		priceStatus = v9,
		LayoutOrder = 2
	}) else React.createElement(Foundation.Text, {
		LayoutOrder = 2,
		tag = "auto-xy text-body-large content-emphasis text-truncate-end",
		Text = getCreatorName(v6)
	})
	v36.subheader = v37
	children.Header = createElement5(ItemHeader, v36)

	local createElement6 = React.createElement
	local view4 = Foundation.View

	local v39 = if v10 then React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, v5.Padding.Large),
		PaddingRight = UDim.new(0, v5.Padding.Large)
	}) else nil

	local createElement7 = React.createElement

	local v43 = if v6 and v6.favoritesDetails and v6.favoritesDetails.numFavorites then numberLocalization.abbreviate(
		v6.favoritesDetails.numFavorites,
		LocalizationService.RobloxLocaleId
	) else nil

	local v44 = if v6 and v6.favoritesDetails and v6.favoritesDetails.isFavorited then enums.IconVariant.Filled else enums.IconVariant.Regular
	local v41 = {
		LayoutOrder = 1,
		favoritesBadge = {
			text = v43,
			iconVariant = v44,
			onActivated = function()
				if v6 and v6.favoritesDetails then
					props.onToggleFavorite(props.item, v6.favoritesDetails.isFavorited or false)
				end
			end,
			LayoutOrder = 1
		},
		tryOnBadge = 0
	}
	local v45

	if v6 and isItemAvailableForTryOn(props.localPlayerModel, v6) then
		v45 = { text = v13.tryOn, iconVariant = 0, onActivated = 0, LayoutOrder = 2 }
		local v46 = if props.tryOnState.isTryOnEnabled then enums.IconVariant.Filled else enums.IconVariant.Regular
		v45.iconVariant = v46

		function v45.onActivated()
			if v6 then
				props.onToggleTryOn({
					itemId = v6.id,
					itemType = v6.itemType,
					itemSubType = v6.itemSubType,
					assetsInBundle = v6.assetsInBundle
				})
			end
		end
	end

	v41.tryOnBadge = v45
	local children2 = {
		UIPadding = v39,
		ControlBar = createElement7(module7, v41),
		DescriptionLabel = React.createElement(Foundation.Text, {
			LayoutOrder = 3,
			tag = "auto-xy text-body-medium content-emphasis text-truncate-end text-align-x-left text-wrap padding-bottom-large padding-top-large",
			Text = not v6 and "" or v6.description
		}),
		ResellableInstancesLabel = 0,
		ItemInfoLabels = 0,
		BundleAssetsList = 0
	}

	local v46 = if isCollectible(v6) and v6 and v6.collectibleItemDetails and v6.collectibleItemDetails.resellableCount > 0 then React.createElement(module8, {
		ownedItemsLabel = v13.ownedItems,
		padding = { top = UDim.new(0, v5.Padding.Large) },
		LayoutOrder = 3
	}) else nil
	children2.ResellableInstancesLabel = v46

	children2.ItemInfoLabels = React.createElement(module9, {
		LayoutOrder = 5,
		itemInfoLabels = v15
	})

	local v47 = if v6 and v6.assetsInBundle and #v6.assetsInBundle > 0 then React.createElement(module3, {
		itemData = v6,
		headerLabel = v13.includedParts,
		view = props.view,
		LayoutOrder = 6
	}) else nil
	children2.BundleAssetsList = v47
	children.DetailsContainer = createElement6(
		view4,
		{ tag = "auto-xy col align-x-left align-y-top gap-small", LayoutOrder = 2 },
		children2
	)
	v31.ScrollingFrame = createElement4("ScrollingFrame", v33, children)
	return createElement3(view3, { tag = "size-full" }, v31)
end

return ItemDetailsView
