local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local LocalizationService = game:GetService("LocalizationService")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local BundleAssetsList = require(AvatarExperienceInspectAndBuy.Components.ItemDetails.BundleAssetsList)
local Enums = Foundation.Enums
local ItemHeader = require(AvatarExperienceInspectAndBuy.Components.Common.ItemHeader)
local useConvertedItemData = require(AvatarExperienceInspectAndBuy.Hooks.useConvertedItemData)
local useItemExperienceInfo = require(AvatarExperienceInspectAndBuy.Hooks.useItemExperienceInfo)
local ControlBar = require(AvatarExperienceInspectAndBuy.Components.ItemDetails.ControlBar)
local ResellableInstancesLabel = require(AvatarExperienceInspectAndBuy.Components.ItemDetails.ResellableInstancesLabel)
local ItemInfoLabels = require(AvatarExperienceInspectAndBuy.Components.ItemDetails.ItemInfoLabels)
local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization
local useItemStatusLocalization = require(AvatarExperienceInspectAndBuy.Hooks.useItemStatusLocalization)
local itemDetailsUtils = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils)
local isCollectible = itemDetailsUtils.isCollectible
local isInExperienceCreationPlayable = itemDetailsUtils.isInExperienceCreationPlayable
local isTradeable = itemDetailsUtils.isTradeable
local getCreatorName = itemDetailsUtils.getCreatorName
local getOriginalPrice = itemDetailsUtils.getOriginalPrice
local getQuantitySold = itemDetailsUtils.getQuantitySold
local ViewportLayout = require(AvatarExperienceInspectAndBuy.Components.ItemsView.ViewportLayout)
local getItemThumbnailUrl = require(AvatarExperienceInspectAndBuy.Utils.getItemThumbnailUrl)
local SubheaderLabelPrice = require(AvatarExperienceInspectAndBuy.Components.Common.SubheaderLabelPrice)
local getPriceStatus = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatus)
local getPriceInRobux = itemDetailsUtils.getPriceInRobux
local isItemAvailableForTryOn = require(AvatarExperienceInspectAndBuy.Utils.isItemAvailableForTryOn)
local BackButton = require(AvatarExperienceInspectAndBuy.Components.Common.BackButton)
local formatNumber = require(AvatarExperienceInspectAndBuy.Utils.formatNumber)

require(AvatarExperienceInspectAndBuy.Types)
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)
local useTokens = Foundation.Hooks.useTokens
require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)

require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)

local function fn(view, p)
	if view == ViewType.WideLandscape then
		return {
			PaddingTop = UDim.new(0, p.Padding.XSmall),
			PaddingLeft = UDim.new(0, p.Padding.Medium),
			PaddingRight = UDim.new(0, p.Padding.Medium),
			PaddingBottom = UDim.new(0, p.Padding.XXLarge)
		}
	end

	if view == ViewType.Wide then
		return {
			PaddingTop = UDim.new(0, p.Padding.XSmall),
			PaddingBottom = UDim.new(0, p.Padding.XLarge),
			PaddingLeft = UDim.new(0, p.Margin.Large * 2),
			PaddingRight = UDim.new(0, p.Margin.Large * 2)
		}
	end

	return {
		PaddingTop = UDim.new(0, p.Padding.XSmall),
		PaddingBottom = UDim.new(0, p.Padding.XLarge),
		PaddingLeft = UDim.new(0, p.Padding.XXLarge),
		PaddingRight = UDim.new(0, p.Padding.XXLarge)
	}
end

local function fn2(view, p)
	if view == ViewType.WideLandscape then
		return {
			left = UDim.new(0, p.Padding.Large),
			right = UDim.new(0, p.Padding.Large),
			bottom = UDim.new(0, p.Padding.XXLarge)
		}
	end

	return { bottom = UDim.new(0, p.Padding.XXLarge) }
end

local function fn3(view, p, p2)
	if view == ViewType.Compact then
		return UDim2.new(1, 0, 1, -p.buyActionBarOffset - p.backButtonOffset - p2.Padding.Small)
	end

	return UDim2.new(1, 0, 1, -p.backButtonOffset - p2.Padding.Small)
end

local function fn4(view): number -- 2 equivalent calls inferred from this helper
	return if view == ViewType.Wide then 2.5 else 2
end

local function ItemDetailsView(props)
	local v = useTokens()
	local itemData = useConvertedItemData(props.item)
	local v2

	if itemData then
		v2 = itemData.creatingUniverseId
	end

	local v3 = useItemExperienceInfo(v2)
	local priceStatus = getPriceStatus(itemData)
	local v4 = props.view == ViewType.WideLandscape
	local v5 = props.view == ViewType.Compact
	local v6 = props.view == ViewType.Wide
	local v7 = useItemStatusLocalization(itemData)
	local v8 = fn(props.view, v)
	local buyActionBarOffset = props.buyActionBarOffset or 0
	local size_1000 = v.Size.Size_1000

	local v9 = {
		key = "Category",
		isVisible = true,
		labelProps = {
			leftLabel = v7.category,
			rightLabel = not itemData and "" or v7[itemData.itemSubType]
		}
	}

	local v10 = {
		key = "QuantitySold",
		isVisible = isCollectible(itemData),
		labelProps = {
			leftLabel = v7.quantitySold,
			rightLabel = getQuantitySold(itemData, props.formatNumber)
		}
	}

	local v11 = {
		key = "OriginalPrice",
		isVisible = isCollectible(itemData),
		labelProps = {
			leftLabel = v7.originalPrice,
			rightLabel = getOriginalPrice(itemData, v7.na, props.formatNumber)
		}
	}

	local v12 = { key = "Tradeable", isVisible = isCollectible(itemData), labelProps = 0 }
	local labelProps = { leftLabel = v7.tradeable, rightLabel = 0 }
	local rightLabel = if isTradeable(itemData) then v7.yes else v7.no
	labelProps.rightLabel = rightLabel
	v12.labelProps = labelProps
	local itemInfoLabels = { v9, v10, v11, v12 }

	local v13 = {
		key = "MadeIn",
		isVisible = isInExperienceCreationPlayable(v3),
		labelProps = 0
	}
	local labelProps2 = { leftLabel = v7.madein, rightLabel = 0 }
	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local experienceName

	if v3 then
		experienceName = React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = "auto-xy text-title-medium content-default",
				Text = v3.name
			})
			or nil
	end

	local arrowIcon

	if v3 then
		arrowIcon = React.createElement(Foundation.Icon, {
			LayoutOrder = 2,
			name = Enums.IconName.ArrowSmallRight,
			variant = Enums.IconVariant.Filled,
			size = Enums.IconSize.Medium,
			style = v.Color.Content.Default
		}) or nil
	end

	labelProps2.rightLabel = createElement(view, {
		LayoutOrder = 2,
		tag = "auto-xy",
		onActivated = function()
			if props.openAttributionOverlay then
				props.openAttributionOverlay(v3)
			end
		end
	}, {
		AttributionLabel = createElement2(view2, { tag = "auto-xy row gap-small align-y-center" }, {
			ExperienceName = experienceName,
			ArrowIcon = arrowIcon
		})
	})
	v13.labelProps = labelProps2
	table.insert(itemInfoLabels, v13)

	local createElement3 = React.createElement
	local view3 = Foundation.View

	local v14 = {
		ButtonContainer = React.createElement(Foundation.View, {}, {
			BackButton = React.createElement(BackButton, {
				onBackButtonClick = props.onItemDetailsClosed,
				Size = UDim2.new(0, size_1000, 1, 0),
				Position = UDim2.new(0, v.Padding.Small, 0, v.Padding.Small)
			})
		}),
		ScrollingFrame = 0
	}

	local createElement4 = React.createElement
	local v15 = {
		Size = fn3(props.view, {
			buyActionBarOffset = buyActionBarOffset,
			backButtonOffset = size_1000
		}, v),
		Position = UDim2.new(0, 0, 0, size_1000 + v.Padding.Medium),
		CanvasSize = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 0,
		BorderSizePixel = 0
	}

	local children = {
		UIPadding = React.createElement("UIPadding", v8),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, v.Padding.Small)
		}),
		ViewportLayout = 0,
		Header = 0,
		DetailsContainer = 0
	}
	local viewportLayout

	if v5 or v6 then
		viewportLayout = React.createElement(ViewportLayout, {
			view = props.view,
			LayoutOrder = 1,
			thumbnailUrl = getItemThumbnailUrl(props.item) or "",
			viewportProps = {
				Size = UDim2.new(0, v.Size.Size_3000 * fn4(props.view), 0, v.Size.Size_3000 * fn4(props.view)) -- inferred equivalent call
			},
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			renderTryOnViewport = props.renderTryOnViewport,
			tryOnState = props.tryOnState
		})
	end

	children.ViewportLayout = viewportLayout

	local createElement5 = React.createElement
	local v16 = {
		LayoutOrder = 1,
		headerHeight = v.Size.Size_1300,
		purchaseButtonProps = props.purchaseButtonProps,
		padding = fn2(props.view, v),
		header = React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			tag = "auto-xy text-heading-small content-emphasis text-truncate-end",
			Text = itemData and itemData.name or ""
		}),
		subheader = 0
	}
	local subheader

	if v6 then
		subheader = React.createElement(SubheaderLabelPrice, {
			subheaderText = {
				leftSlotLabel = getCreatorName(itemData),
				rightSlotPrice = formatNumber(getPriceInRobux(itemData, priceStatus))
			},
			priceStatus = priceStatus,
			LayoutOrder = 2
		})
	else
		subheader = React.createElement(Foundation.Text, {
			LayoutOrder = 2,
			tag = "auto-xy text-body-large content-emphasis text-truncate-end",
			Text = getCreatorName(itemData)
		})
	end

	v16.subheader = subheader
	children.Header = createElement5(ItemHeader, v16)

	local createElement6 = React.createElement
	local view4 = Foundation.View
	local uiPadding

	if v4 then
		uiPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v.Padding.Large),
			PaddingRight = UDim.new(0, v.Padding.Large)
		})
	end

	local createElement7 = React.createElement
	local text

	if itemData and itemData.favoritesDetails and itemData.favoritesDetails.numFavorites then
		text = NumberLocalization.abbreviate(itemData.favoritesDetails.numFavorites, LocalizationService.RobloxLocaleId)
	end

	local iconVariant

	if itemData and itemData.favoritesDetails and itemData.favoritesDetails.isFavorited then
		iconVariant = Enums.IconVariant.Filled
	else
		iconVariant = Enums.IconVariant.Regular
	end

	local tryOnBadge

	if itemData and isItemAvailableForTryOn(props.localPlayerModel, itemData) then
		tryOnBadge = { text = v7.tryOn, iconVariant = 0, onActivated = 0, LayoutOrder = 2 }
		local iconVariant2

		if props.tryOnState.isTryOnEnabled then
			iconVariant2 = Enums.IconVariant.Filled
		else
			iconVariant2 = Enums.IconVariant.Regular
		end

		tryOnBadge.iconVariant = iconVariant2

		function tryOnBadge.onActivated()
			if itemData then
				props.onToggleTryOn({
					itemId = itemData.id,
					itemType = itemData.itemType,
					itemSubType = itemData.itemSubType,
					assetsInBundle = itemData.assetsInBundle
				})
			end
		end
	end

	local children2 = {
		UIPadding = uiPadding,
		ControlBar = createElement7(ControlBar, {
			LayoutOrder = 1,
			favoritesBadge = {
				text = text,
				iconVariant = iconVariant,
				onActivated = function()
					if itemData and itemData.favoritesDetails then
						props.onToggleFavorite(props.item, itemData.favoritesDetails.isFavorited or false)
					end
				end,
				LayoutOrder = 1
			},
			tryOnBadge = tryOnBadge
		}),
		DescriptionLabel = React.createElement(Foundation.Text, {
			LayoutOrder = 3,
			tag = "auto-xy text-body-medium content-emphasis text-truncate-end text-align-x-left text-wrap padding-bottom-large padding-top-large",
			Text = not itemData and "" or itemData.description
		}),
		ResellableInstancesLabel = 0,
		ItemInfoLabels = 0,
		BundleAssetsList = 0
	}
	local resellableInstancesLabel

	if
		isCollectible(itemData)
		and itemData
		and itemData.collectibleItemDetails
		and itemData.collectibleItemDetails.resellableCount > 0
	then
		resellableInstancesLabel = React.createElement(ResellableInstancesLabel, {
			ownedItemsLabel = v7.ownedItems,
			padding = { top = UDim.new(0, v.Padding.Large) },
			LayoutOrder = 3
		})
	end

	children2.ResellableInstancesLabel = resellableInstancesLabel

	children2.ItemInfoLabels = React.createElement(ItemInfoLabels, {
		LayoutOrder = 5,
		itemInfoLabels = itemInfoLabels
	})
	local bundleAssetsList

	if itemData and itemData.assetsInBundle and #itemData.assetsInBundle > 0 then
		bundleAssetsList = React.createElement(BundleAssetsList, {
			itemData = itemData,
			headerLabel = v7.includedParts,
			view = props.view,
			LayoutOrder = 6
		})
	end

	children2.BundleAssetsList = bundleAssetsList
	children.DetailsContainer = createElement6(
		view4,
		{ tag = "auto-xy col align-x-left align-y-top gap-small", LayoutOrder = 2 },
		children2
	)
	v14.ScrollingFrame = createElement4("ScrollingFrame", v15, children)
	return createElement3(view3, { tag = "size-full" }, v14)
end

return ItemDetailsView
