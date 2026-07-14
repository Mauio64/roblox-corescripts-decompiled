local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local React = require(AvatarExperienceCommonParent.React)
local Foundation = require(AvatarExperienceCommonParent.Foundation)
local BuilderIcons = require(AvatarExperienceCommonParent.BuilderIcons)
local useTokens = Foundation.Hooks.useTokens
local ItemCardComponents = require(AvatarExperienceCommonParent.AvatarExperienceUIKit).ItemCardComponents
local ItemCardHeader = ItemCardComponents.ItemCardHeader
local ItemCardBadge = ItemCardComponents.ItemCardBadge
local ItemCardStatus = ItemCardComponents.ItemCardStatus
local ItemCardHeaderCornersOverlay = ItemCardComponents.ItemCardHeaderCornersOverlay
local ItemCardIcon = ItemCardComponents.ItemCardIcon
local CatalogRowItemCardFooter = require(script.Parent.CatalogRowItemCardFooter)
local CatalogItemCardItemTypeEnum = require(script.Parent.Parent.CatalogItemCard.Enums.CatalogItemCardItemTypeEnum)
local CatalogItemCardItemInfoEnum = require(script.Parent.Parent.CatalogItemCard.Enums.CatalogItemCardItemInfoEnum)
local CatalogItemCardStatusIconTypeEnum = require(script.Parent.Parent.CatalogItemCard.Enums.CatalogItemCardStatusIconTypeEnum)
local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local FFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates

require(AvatarExperienceCommon.Types.TimedOptionType)

local FFlagAXEnableTimedOptionsForCatalogRowCard = AvatarExperienceFlags.FFlagAXEnableTimedOptionsForCatalogRowCard
local t1 = {
	DYNAMIC_HEAD = "icons/menu/clothing/dynamicHead",
	LIMITED = "icons/status/item/limited",
	MODERATED = not FFlagAXModeratedItemIconUpdates and "icons/actions/info_small" or BuilderIcons.Icon.CircleI,
	PENDING_MODERATION = not FFlagAXModeratedItemIconUpdates and "icons/status/pending_small" or BuilderIcons.Icon.ClockDashed,
	UNAVAILABLE = not FFlagAXModeratedItemIconUpdates and "icons/status/warning_small" or BuilderIcons.Icon.CircleI,
	DURABLE = not FFlagAXModeratedItemIconUpdates and "icons/status/pending_small" or BuilderIcons.Icon.Clock
}
local t2 = {
	[CatalogItemCardStatusIconTypeEnum.Moderated] = t1.MODERATED,
	[CatalogItemCardStatusIconTypeEnum.PendingModeration] = t1.PENDING_MODERATION,
	[CatalogItemCardStatusIconTypeEnum.Unavailable] = t1.UNAVAILABLE,
	[CatalogItemCardStatusIconTypeEnum.Durable] = t1.DURABLE
}
local t3 = {
	[CatalogItemCardItemTypeEnum.Limited] = {{
		type = "icon",
		icon = t1.LIMITED
	}},
	[CatalogItemCardItemTypeEnum.Collectible] = {
		{
			type = "icon",
			icon = t1.LIMITED
		},
		{
			type = "text",
			text = "#"
		}
	}
}
local t4 = {
	[CatalogItemCardItemInfoEnum.DynamicHead] = t1.DYNAMIC_HEAD
}

return (React.forwardRef(function(t5: {[any]: any}, p1) -- line: 128
	-- upvalues: useTokens (copy), t4 (copy), t3 (copy), t2 (copy), React (copy), ItemCardHeader (copy), ItemCardHeaderCornersOverlay (copy), ItemCardBadge (copy), ItemCardStatus (copy), ItemCardIcon (copy), CatalogRowItemCardFooter (copy), FFlagAXDurables2Option (copy), FFlagAXDurablesForMIS (copy), FFlagAXEnableTimedOptionsForCatalogRowCard (copy)
	local v28 = useTokens()
	local v29 = if not t5.itemInfo then nil else t4[t5.itemInfo]
	local v30 = if not t5.itemType then nil else t3[t5.itemType]
	local v31 = if not t5.itemStatus or t5.itemStatus.type ~= "icon" then nil else t2[t5.itemStatus.iconType]

	return React.createElement("TextButton", {
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Event.Activated] = if not t5.isDisabled then t5.onActivated else nil,
		ref = p1,
		AutomaticSize = t5.AutomaticSize,
		LayoutOrder = t5.LayoutOrder,
		SelectionGroup = true,
		ClipsDescendants = false,
		[React.Tag] = t5.tag
	}, {
		HorizontalLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, v28.Gap.Medium)
		}),
		Header = React.createElement(ItemCardHeader, {
			LayoutOrder = 1,
			aspectRatio = t5.headerAspectRatio,
			Size = t5.headerSize,
			overlaySlot = React.createElement(ItemCardHeaderCornersOverlay, {
				topLeftSlot = if not t5.itemStatus or t5.itemStatus.type ~= "badge" then if not t5.itemStatus then nil else if t5.itemStatus.type ~= "text" then if not v31 then nil else React.createElement(ItemCardIcon, {
					icon = v31
				}) else React.createElement(ItemCardStatus, {
					text = t5.itemStatus.text
				}) else React.createElement(ItemCardBadge, {
					content = {
						{
							type = "icon",
							icon = t2[t5.itemStatus.iconType]
						},
						{
							type = "text",
							text = t5.itemStatus.text
						}
					}
				}),
				bottomLeftSlot = if not v30 then nil else React.createElement(ItemCardBadge, {
					content = v30
				}),
				bottomRightSlot = if not v29 then nil else React.createElement(ItemCardBadge, {
					content = {{
						type = "icon",
						icon = v29
					}}
				})
			})
		}, t5.presentationSlot),
		Footer = React.createElement(CatalogRowItemCardFooter, {
			LayoutOrder = 2,
			title = t5.title,
			creatorName = if not t5.creator then nil else t5.creator.name,
			bundlePartsText = t5.bundlePartsText,
			itemSubType = t5.itemSubType,
			creatorHasVerifiedBadge = if not t5.creator then nil else t5.creator.verified,
			priceLineContent = t5.priceLineContent,
			itemStatusInCheckout = if not FFlagAXDurables2Option then nil else t5.itemStatusInCheckout,
			expirationTime = if not FFlagAXDurablesForMIS and not FFlagAXEnableTimedOptionsForCatalogRowCard then nil else t5.expirationTime,
			isOwned = if not FFlagAXDurablesForMIS and not FFlagAXEnableTimedOptionsForCatalogRowCard then nil else t5.isOwned,
			timedOptions = if not FFlagAXDurablesForMIS and not FFlagAXEnableTimedOptionsForCatalogRowCard then nil else t5.timedOptions,
			onTimedOptionPriceChanged = if not FFlagAXDurablesForMIS and not FFlagAXEnableTimedOptionsForCatalogRowCard then nil else t5.onTimedOptionPriceChanged,
			selectedTimedOptionPrice = if not FFlagAXDurablesForMIS and not FFlagAXEnableTimedOptionsForCatalogRowCard then nil else t5.selectedTimedOptionPrice,
			setSelectedTimedOptionPrice = if not FFlagAXDurablesForMIS and not FFlagAXEnableTimedOptionsForCatalogRowCard then nil else t5.setSelectedTimedOptionPrice,
			selectedTimedOptionIndexInReducer = if not FFlagAXDurablesForMIS and not FFlagAXEnableTimedOptionsForCatalogRowCard then nil else t5.selectedTimedOptionIndexInReducer,
			wearTimeSelectedOptionInList = if not FFlagAXDurablesForMIS and not FFlagAXEnableTimedOptionsForCatalogRowCard then nil else t5.wearTimeSelectedOptionInList,
			onRemove = if not FFlagAXDurables2Option then nil else t5.onRemove,
			hideTimedOptionSelections = if not FFlagAXDurables2Option then nil else t5.hideTimedOptionSelections,
			Size = t5.footerSize,
			AutomaticSize = if not t5.footerAutomaticSize then Enum.AutomaticSize.Y else t5.footerAutomaticSize,
			offersLocalized = if not FFlagAXDurables2Option then nil else t5.offersLocalized,
			offerApplied = if not FFlagAXDurables2Option then nil else t5.offerApplied,
			showOfferPillTooltip = if not FFlagAXDurables2Option then nil else t5.showOfferPillTooltip
		})
	})
end))
