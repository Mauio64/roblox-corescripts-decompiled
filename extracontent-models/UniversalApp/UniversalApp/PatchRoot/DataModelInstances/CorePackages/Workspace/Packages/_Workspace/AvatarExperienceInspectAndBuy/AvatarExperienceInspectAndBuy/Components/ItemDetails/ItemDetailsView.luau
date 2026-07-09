local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local LocalizationService = game:GetService("LocalizationService")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local Foundation = require(AvatarExperienceInspectAndBuyParent.Foundation)
local BundleAssetsList = require(AvatarExperienceInspectAndBuy.Components.ItemDetails.BundleAssetsList)
local Enums = Foundation.Enums
local ItemHeader = require(AvatarExperienceInspectAndBuy.Components.Common.ItemHeader)
local useConvertedItemData = require(AvatarExperienceInspectAndBuy.Hooks.useConvertedItemData)
local useItemExperienceInfo = require(AvatarExperienceInspectAndBuy.Hooks.useItemExperienceInfo)
local ControlBar = require(AvatarExperienceInspectAndBuy.Components.ItemDetails.ControlBar)
local ResellableInstancesLabel = require(AvatarExperienceInspectAndBuy.Components.ItemDetails.ResellableInstancesLabel)
local ItemInfoLabels = require(AvatarExperienceInspectAndBuy.Components.ItemDetails.ItemInfoLabels)
local NumberLocalization = require(AvatarExperienceInspectAndBuyParent.Localization).NumberLocalization
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

local function v33(p1, p2) -- line: 70
	-- upvalues: ViewType (copy)
	if p1 == ViewType.WideLandscape then
		return {
			PaddingTop = UDim.new(0, p2.Padding.XSmall),
			PaddingLeft = UDim.new(0, p2.Padding.Medium),
			PaddingRight = UDim.new(0, p2.Padding.Medium),
			PaddingBottom = UDim.new(0, p2.Padding.XXLarge)
		}
	end

	if p1 == ViewType.Wide then
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
local function v34(p3, p4) -- line: 100
	-- upvalues: ViewType (copy)
	if p3 == ViewType.WideLandscape then
		return {
			left = UDim.new(0, p4.Padding.Large),
			right = UDim.new(0, p4.Padding.Large),
			bottom = UDim.new(0, p4.Padding.XXLarge)
		}
	end

	return {
		bottom = UDim.new(0, p4.Padding.XXLarge)
	}
end
local function v35(p5, t1: {[any]: any}, p6) -- line: 120
	-- upvalues: ViewType (copy)
	if p5 == ViewType.Compact then
		return UDim2.new(1, 0, 1, -t1.buyActionBarOffset - t1.backButtonOffset - p6.Padding.Small)
	end

	return UDim2.new(1, 0, 1, -t1.backButtonOffset - p6.Padding.Small)
end
local function ItemDetailsView(t2: {[any]: any}) -- line: 140
	-- upvalues: useTokens (copy), useConvertedItemData (copy), useItemExperienceInfo (copy), getPriceStatus (copy), ViewType (copy), useItemStatusLocalization (copy), v33 (copy), isCollectible (copy), getQuantitySold (copy), getOriginalPrice (copy), isTradeable (copy), isInExperienceCreationPlayable (copy), React (copy), Foundation (copy), Enums (copy), BackButton (copy), v35 (copy), ViewportLayout (copy), getItemThumbnailUrl (copy), ItemHeader (copy), v34 (copy), SubheaderLabelPrice (copy), getCreatorName (copy), formatNumber (copy), getPriceInRobux (copy), ControlBar (copy), NumberLocalization (copy), LocalizationService (copy), isItemAvailableForTryOn (copy), ResellableInstancesLabel (copy), ItemInfoLabels (copy), BundleAssetsList (copy)
	local v46 = useTokens()
	local v47 = useConvertedItemData(t2.item)
	local v48 = if not v47 then nil else v47.creatingUniverseId
	local v49 = useItemExperienceInfo(v48)
	local v50 = getPriceStatus(v47)
	local v51 = t2.view == ViewType.WideLandscape
	local v52 = t2.view == ViewType.Compact
	local v53 = t2.view == ViewType.Wide
	local v54 = useItemStatusLocalization(v47)
	local v55 = v33(t2.view, v46)
	local v56 = t2.buyActionBarOffset or 0
	local Size_1000 = v46.Size.Size_1000
	local t3 = {
		{
			key = "Category",
			isVisible = true,
			labelProps = {
				leftLabel = v54.category,
				rightLabel = not v47 and "" or v54[v47.itemSubType]
			}
		},
		{
			key = "QuantitySold",
			isVisible = isCollectible(v47),
			labelProps = {
				leftLabel = v54.quantitySold,
				rightLabel = getQuantitySold(v47, t2.formatNumber)
			}
		},
		{
			key = "OriginalPrice",
			isVisible = isCollectible(v47),
			labelProps = {
				leftLabel = v54.originalPrice,
				rightLabel = getOriginalPrice(v47, v54.na, t2.formatNumber)
			}
		},
		{
			key = "Tradeable",
			isVisible = isCollectible(v47),
			labelProps = {
				leftLabel = v54.tradeable,
				rightLabel = if not isTradeable(v47) then v54.no else v54.yes
			}
		}
	}

	table.insert(t3, {
		key = "MadeIn",
		isVisible = isInExperienceCreationPlayable(v49),
		labelProps = {
			leftLabel = v54.madein,
			rightLabel = React.createElement(Foundation.View, {
				LayoutOrder = 2,
				tag = "auto-xy",
				onActivated = function() -- line: 197
					-- upvalues: t2 (copy), v49 (copy)
					if t2.openAttributionOverlay then
						t2.openAttributionOverlay(v49)
					end
				end
			}, {
				AttributionLabel = React.createElement(Foundation.View, {
					tag = "auto-xy row gap-small align-y-center"
				}, {
					ExperienceName = v49 and React.createElement(Foundation.Text, {
						LayoutOrder = 1,
						tag = "auto-xy text-title-medium content-default",
						Text = v49.name
					}) or nil,
					ArrowIcon = v49 and React.createElement(Foundation.Icon, {
						LayoutOrder = 2,
						name = Enums.IconName.ArrowSmallRight,
						variant = Enums.IconVariant.Filled,
						size = Enums.IconSize.Medium,
						style = v46.Color.Content.Default
					}) or nil
				})
			})
		}
	})

	return React.createElement(Foundation.View, {
		tag = "size-full"
	}, {
		ButtonContainer = React.createElement(Foundation.View, {}, {
			BackButton = React.createElement(BackButton, {
				onBackButtonClick = t2.onItemDetailsClosed,
				Size = UDim2.new(0, Size_1000, 1, 0),
				Position = UDim2.new(0, v46.Padding.Small, 0, v46.Padding.Small)
			})
		}),
		ScrollingFrame = React.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			ScrollBarThickness = 0,
			BorderSizePixel = 0,
			Size = v35(t2.view, {
				buyActionBarOffset = v56,
				backButtonOffset = Size_1000
			}, v46),
			Position = UDim2.new(0, 0, 0, Size_1000 + v46.Padding.Medium),
			CanvasSize = UDim2.new(1, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y
		}, {
			UIPadding = React.createElement("UIPadding", v55),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, v46.Padding.Small)
			}),
			ViewportLayout = if not v52 and not v53 then nil else React.createElement(ViewportLayout, {
				LayoutOrder = 1,
				view = t2.view,
				thumbnailUrl = getItemThumbnailUrl(t2.item) or "",
				viewportProps = {
					Size = UDim2.new(0, v46.Size.Size_3000 * (t2.view ~= ViewType.Wide and 2 or 2.5), 0, v46.Size.Size_3000 * (t2.view ~= ViewType.Wide and 2 or 2.5))
				},
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				renderTryOnViewport = t2.renderTryOnViewport,
				tryOnState = t2.tryOnState
			}),
			Header = React.createElement(ItemHeader, {
				LayoutOrder = 1,
				headerHeight = v46.Size.Size_1300,
				purchaseButtonProps = t2.purchaseButtonProps,
				padding = v34(t2.view, v46),
				header = React.createElement(Foundation.Text, {
					LayoutOrder = 1,
					tag = "auto-xy text-heading-small content-emphasis text-truncate-end",
					Text = v47 and v47.name or ""
				}),
				subheader = if not v53 then React.createElement(Foundation.Text, {
					LayoutOrder = 2,
					tag = "auto-xy text-body-large content-emphasis text-truncate-end",
					Text = getCreatorName(v47)
				}) else React.createElement(SubheaderLabelPrice, {
					LayoutOrder = 2,
					subheaderText = {
						leftSlotLabel = getCreatorName(v47),
						rightSlotPrice = formatNumber(getPriceInRobux(v47, v50))
					},
					priceStatus = v50
				})
			}),
			DetailsContainer = React.createElement(Foundation.View, {
				tag = "auto-xy col align-x-left align-y-top gap-small",
				LayoutOrder = 2
			}, {
				UIPadding = if not v51 then nil else React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v46.Padding.Large),
					PaddingRight = UDim.new(0, v46.Padding.Large)
				}),
				ControlBar = React.createElement(ControlBar, {
					LayoutOrder = 1,
					favoritesBadge = {
						LayoutOrder = 1,
						text = if not v47 or (not v47.favoritesDetails or not v47.favoritesDetails.numFavorites) then nil else NumberLocalization.abbreviate(v47.favoritesDetails.numFavorites, LocalizationService.RobloxLocaleId),
						iconVariant = if not v47 or (not v47.favoritesDetails or not v47.favoritesDetails.isFavorited) then Enums.IconVariant.Regular else Enums.IconVariant.Filled,
						onActivated = function() -- line: 325
							-- upvalues: v47 (copy), t2 (copy)
							if v47 and v47.favoritesDetails then
								t2.onToggleFavorite(t2.item, v47.favoritesDetails.isFavorited or false)
							end
						end
					},
					tryOnBadge = if not v47 or not isItemAvailableForTryOn(t2.localPlayerModel, v47) then nil else {
						LayoutOrder = 2,
						text = v54.tryOn,
						iconVariant = if not t2.tryOnState.isTryOnEnabled then Enums.IconVariant.Regular else Enums.IconVariant.Filled,
						onActivated = function() -- line: 338
							-- upvalues: v47 (copy), t2 (copy)
							if v47 then
								t2.onToggleTryOn({
									itemId = v47.id,
									itemType = v47.itemType,
									itemSubType = v47.itemSubType,
									assetsInBundle = v47.assetsInBundle
								})
							end
						end
					}
				}),
				DescriptionLabel = React.createElement(Foundation.Text, {
					LayoutOrder = 3,
					tag = "auto-xy text-body-medium content-emphasis text-truncate-end text-align-x-left text-wrap padding-bottom-large padding-top-large",
					Text = not v47 and "" or v47.description
				}),
				ResellableInstancesLabel = if not isCollectible(v47) or (not v47 or (not v47.collectibleItemDetails or not (v47.collectibleItemDetails.resellableCount > 0))) then nil else React.createElement(ResellableInstancesLabel, {
					LayoutOrder = 3,
					ownedItemsLabel = v54.ownedItems,
					padding = {
						top = UDim.new(0, v46.Padding.Large)
					}
				}),
				ItemInfoLabels = React.createElement(ItemInfoLabels, {
					LayoutOrder = 5,
					itemInfoLabels = t3
				}),
				BundleAssetsList = if not v47 or (not v47.assetsInBundle or not (#v47.assetsInBundle > 0)) then nil else React.createElement(BundleAssetsList, {
					LayoutOrder = 6,
					itemData = v47,
					headerLabel = v54.includedParts,
					view = t2.view
				})
			})
		})
	})
end

return ItemDetailsView
