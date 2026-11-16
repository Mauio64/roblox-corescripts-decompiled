local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local useTokens = Foundation.Hooks.useTokens
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardComponents = AvatarExperienceUIKit.ItemCardComponents
local ItemCardHeader = ItemCardComponents.ItemCardHeader
local ItemCardBadge = ItemCardComponents.ItemCardBadge
local ItemCardStatus = ItemCardComponents.ItemCardStatus
local ItemCardHeaderCornersOverlay = ItemCardComponents.ItemCardHeaderCornersOverlay
local ItemCardIcon = ItemCardComponents.ItemCardIcon

local IndicatorStack = require(AvatarExperienceCommon.Components.IndicatorStack.IndicatorStack)
local shouldRenderIndicatorStack = require(AvatarExperienceCommon.Utils.shouldRenderIndicatorStack)
local LicensingBadge = require(AvatarExperienceCommon.Components.LicensingBadge.LicensingBadge)
local CatalogRowItemCardFooter = require(script.Parent.CatalogRowItemCardFooter)
require(script.Parent.Parent.CatalogItemCard.Enums.CatalogItemCardItemTypeEnum)
require(script.Parent.Parent.CatalogItemCard.Enums.CatalogItemCardItemInfoEnum)

require(script.Parent.Parent.CatalogItemCard.Enums.CatalogItemCardStatusIconTypeEnum)
local CatalogItemCardBadgeMaps = require(script.Parent.Parent.CatalogItemCard.CatalogItemCardBadgeMaps)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local FFlagAXMISOffersChip = AvatarExperienceFlags.FFlagAXMISOffersChip
local FFlagAXMarketplaceItemCardIndicatorStack = AvatarExperienceFlags.FFlagAXMarketplaceItemCardIndicatorStack
local FFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards
local FFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting

require(parent.AvatarExperienceModel)

require(AvatarExperienceCommon.Types.TimedOptionType)

local FFlagAXEnableTimedOptionsForCatalogRowCard = AvatarExperienceFlags.FFlagAXEnableTimedOptionsForCatalogRowCard
local FFlagAXRemoveDynamicHeadBadge = AvatarExperienceFlags.FFlagAXRemoveDynamicHeadBadge

local itemTypeToContentMap = CatalogItemCardBadgeMaps.itemTypeToContentMap
local itemInfoIconMap = CatalogItemCardBadgeMaps.itemInfoIconMap
local v

if FFlagAXMarketplaceItemCardIndicatorStack then
	v = CatalogItemCardBadgeMaps.itemStatusIconTypeToIconMap
else
	v = CatalogItemCardBadgeMaps.rowItemStatusIconTypeToIconMap
end

local function buildItemStatusContent(itemStatus, icon: string?)
	if itemStatus.type == "text" then
		return { type = "text", text = itemStatus.text }
	end

	if itemStatus.type == "badge" then
		return {
			type = "badge",
			content = {
				{ type = "icon", icon = icon },
				{ type = "text", text = itemStatus.text }
			}
		}
	end

	if icon then
		return { type = "icon", icon = icon }
	end

	return nil
end

return (React.forwardRef(function(props, ref)
	local v2 = useTokens()
	local icon

	if props.itemInfo then
		icon = itemInfoIconMap[props.itemInfo]
	end

	local v3

	if props.itemType then
		v3 = itemTypeToContentMap[props.itemType]
	end

	local icon2

	if
		props.itemStatus
		and props.itemStatus.type ~= "text"
		and (props.itemStatus.type == "icon" or FFlagAXMarketplaceItemCardIndicatorStack and props.itemStatus.type == "badge")
	then
		icon2 = v[props.itemStatus.iconType]
	end

	local topLeftSlot

	if FFlagAXMarketplaceLicensingItemCards and props.itemLicensingInfo then
		topLeftSlot = React.createElement(LicensingBadge, {
			itemLicensingInfo = props.itemLicensingInfo,
			isInteractive = false,
			passiveSize = Foundation.Enums.BadgeSize.XSmall
		})
	end

	local bottomRightSlot

	if FFlagAXMarketplaceItemCardIndicatorStack then
		local statusContent

		if props.itemStatus then
			statusContent = buildItemStatusContent(props.itemStatus, icon2)
		end

		if shouldRenderIndicatorStack(statusContent, v3) then
			bottomRightSlot = React.createElement(IndicatorStack, {
				statusContent = statusContent,
				itemTypeContent = v3
			})
		end
	end

	local createElement = React.createElement

	local activated = React.Event.Activated
	local v4

	if not props.isDisabled then
		v4 = props.onActivated
	end

	local v5 = {
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[activated] = v4,
		ref = ref,
		AutomaticSize = props.AutomaticSize,
		LayoutOrder = props.LayoutOrder,
		SelectionGroup = true,
		ClipsDescendants = false,
		[React.Tag] = props.tag
	}
	local children = {
		HorizontalLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, v2.Gap.Medium)
		}),
		Header = 0,
		Footer = 0
	}

	local createElement2 = React.createElement
	local v6 = {
		LayoutOrder = 1,
		aspectRatio = props.headerAspectRatio,
		Size = props.headerSize,
		overlaySlot = 0
	}
	local overlaySlot

	if FFlagAXMarketplaceItemCardIndicatorStack then
		overlaySlot = React.createElement(ItemCardHeaderCornersOverlay, {
			topLeftSlot = topLeftSlot,
			bottomRightSlot = bottomRightSlot,
			constrainTopLeftSlot = topLeftSlot ~= nil
		})
	else
		local createElement3 = React.createElement
		local topLeftSlot2

		if props.itemStatus and props.itemStatus.type == "badge" then
			topLeftSlot2 = React.createElement(ItemCardBadge, {
				content = {
					{ type = "icon", icon = v[props.itemStatus.iconType] },
					{ type = "text", text = props.itemStatus.text }
				}
			})
		elseif props.itemStatus then
			if props.itemStatus.type == "text" then
				topLeftSlot2 = React.createElement(ItemCardStatus, { text = props.itemStatus.text })
			elseif icon2 then
				topLeftSlot2 = React.createElement(ItemCardIcon, { icon = icon2 })
			end
		end

		local bottomLeftSlot

		if v3 then
			bottomLeftSlot = React.createElement(ItemCardBadge, { content = v3 })
		end

		local bottomRightSlot2

		if not (FFlagAXRemoveDynamicHeadBadge or not icon) then
			bottomRightSlot2 = React.createElement(ItemCardBadge, {
				content = {
					{ type = "icon", icon = icon }
				}
			})
		end

		overlaySlot = createElement3(ItemCardHeaderCornersOverlay, {
			topLeftSlot = topLeftSlot2,
			bottomLeftSlot = bottomLeftSlot,
			bottomRightSlot = bottomRightSlot2
		})
	end

	v6.overlaySlot = overlaySlot
	children.Header = createElement2(ItemCardHeader, v6, props.presentationSlot)

	local createElement3 = React.createElement

	local v7 = {
		title = props.title,
		creatorName = 0,
		bundlePartsText = 0,
		itemSubType = 0,
		creatorHasVerifiedBadge = 0,
		priceLineContent = 0,
		itemStatusInCheckout = 0,
		expirationTime = 0,
		isOwned = 0,
		timedOptions = 0,
		onTimedOptionPriceChanged = 0,
		selectedTimedOptionPrice = 0,
		setSelectedTimedOptionPrice = 0,
		selectedTimedOptionIndexInReducer = 0,
		wearTimeSelectedOptionInList = 0,
		onRemove = 0,
		giftButton = 0,
		hideTimedOptionSelections = 0,
		LayoutOrder = 2,
		Size = 0,
		AutomaticSize = 0,
		offersLocalized = 0,
		offerApplied = 0,
		showOfferPillTooltip = 0
	}
	local creatorName

	if props.creator then
		creatorName = props.creator.name
	end

	v7.creatorName = creatorName
	v7.bundlePartsText = props.bundlePartsText
	v7.itemSubType = props.itemSubType
	local creatorHasVerifiedBadge

	if props.creator then
		creatorHasVerifiedBadge = props.creator.verified
	end

	v7.creatorHasVerifiedBadge = creatorHasVerifiedBadge
	v7.priceLineContent = props.priceLineContent
	local itemStatusInCheckout

	if FFlagAXDurables2Option then
		itemStatusInCheckout = props.itemStatusInCheckout
	end

	v7.itemStatusInCheckout = itemStatusInCheckout
	local expirationTime

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		expirationTime = props.expirationTime
	end

	v7.expirationTime = expirationTime
	local isOwned

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		isOwned = props.isOwned
	end

	v7.isOwned = isOwned
	local timedOptions

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		timedOptions = props.timedOptions
	end

	v7.timedOptions = timedOptions
	local onTimedOptionPriceChanged

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		onTimedOptionPriceChanged = props.onTimedOptionPriceChanged
	end

	v7.onTimedOptionPriceChanged = onTimedOptionPriceChanged
	local selectedTimedOptionPrice

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		selectedTimedOptionPrice = props.selectedTimedOptionPrice
	end

	v7.selectedTimedOptionPrice = selectedTimedOptionPrice
	local setSelectedTimedOptionPrice

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		setSelectedTimedOptionPrice = props.setSelectedTimedOptionPrice
	end

	v7.setSelectedTimedOptionPrice = setSelectedTimedOptionPrice
	local selectedTimedOptionIndexInReducer

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		selectedTimedOptionIndexInReducer = props.selectedTimedOptionIndexInReducer
	end

	v7.selectedTimedOptionIndexInReducer = selectedTimedOptionIndexInReducer
	local wearTimeSelectedOptionInList

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		wearTimeSelectedOptionInList = props.wearTimeSelectedOptionInList
	end

	v7.wearTimeSelectedOptionInList = wearTimeSelectedOptionInList
	local onRemove

	if FFlagAXDurables2Option then
		onRemove = props.onRemove
	end

	v7.onRemove = onRemove
	local giftButton

	if FFlagAXGifting then
		giftButton = props.giftButton
	end

	v7.giftButton = giftButton
	local hideTimedOptionSelections

	if FFlagAXDurables2Option then
		hideTimedOptionSelections = props.hideTimedOptionSelections
	end

	v7.hideTimedOptionSelections = hideTimedOptionSelections

	v7.Size = props.footerSize
	local automaticSize

	if props.footerAutomaticSize then
		automaticSize = props.footerAutomaticSize
	else
		automaticSize = Enum.AutomaticSize.Y
	end

	v7.AutomaticSize = automaticSize
	local offersLocalized

	if FFlagAXMISOffersChip then
		offersLocalized = props.offersLocalized
	end

	v7.offersLocalized = offersLocalized
	local offerApplied

	if FFlagAXMISOffersChip then
		offerApplied = props.offerApplied
	end

	v7.offerApplied = offerApplied
	local showOfferPillTooltip

	if FFlagAXDurables2Option then
		showOfferPillTooltip = props.showOfferPillTooltip
	end

	v7.showOfferPillTooltip = showOfferPillTooltip
	children.Footer = createElement3(CatalogRowItemCardFooter, v7)
	return createElement("TextButton", v5, children)
end))
