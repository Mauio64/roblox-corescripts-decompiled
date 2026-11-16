local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")

local useTokens = Foundation.Hooks.useTokens
local itemCardComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceUIKit").ItemCardComponents
local itemCardHeader = itemCardComponents.ItemCardHeader
local itemCardBadge = itemCardComponents.ItemCardBadge
local itemCardStatus = itemCardComponents.ItemCardStatus
local itemCardHeaderCornersOverlay = itemCardComponents.ItemCardHeaderCornersOverlay
local itemCardIcon = itemCardComponents.ItemCardIcon

local IndicatorStack = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/IndicatorStack/IndicatorStack")
local shouldRenderIndicatorStack = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/shouldRenderIndicatorStack")
local LicensingBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/LicensingBadge/LicensingBadge")
local CatalogRowItemCardFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogRowItemCard/CatalogRowItemCardFooter")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/CatalogItemCardItemTypeEnum")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/CatalogItemCardItemInfoEnum")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/CatalogItemCardStatusIconTypeEnum")
local CatalogItemCardBadgeMaps = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/CatalogItemCardBadgeMaps")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local fFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local fFlagAXMISOffersChip = AvatarExperienceFlags.FFlagAXMISOffersChip
local fFlagAXMarketplaceItemCardIndicatorStack = AvatarExperienceFlags.FFlagAXMarketplaceItemCardIndicatorStack
local fFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards
local fFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/TimedOptionType")

local fFlagAXEnableTimedOptionsForCatalogRowCard = AvatarExperienceFlags.FFlagAXEnableTimedOptionsForCatalogRowCard
local fFlagAXRemoveDynamicHeadBadge = AvatarExperienceFlags.FFlagAXRemoveDynamicHeadBadge

local itemTypeToContentMap = CatalogItemCardBadgeMaps.itemTypeToContentMap
local itemInfoIconMap = CatalogItemCardBadgeMaps.itemInfoIconMap
local v5

if fFlagAXMarketplaceItemCardIndicatorStack then
	v5 = CatalogItemCardBadgeMaps.itemStatusIconTypeToIconMap
else
	v5 = CatalogItemCardBadgeMaps.rowItemStatusIconTypeToIconMap
end

local function buildItemStatusContent(itemStatus, p2)
	if itemStatus.type == "text" then
		return { type = "text", text = itemStatus.text }
	end

	if itemStatus.type == "badge" then
		return {
			type = "badge",
			content = {
				{ type = "icon", icon = p2 },
				{ type = "text", text = itemStatus.text }
			}
		}
	end

	if p2 then
		return { type = "icon", icon = p2 }
	end

	return nil
end

return (React.forwardRef(function(props, ref)
	local v6 = useTokens()
	local v7 = if props.itemInfo then itemInfoIconMap[props.itemInfo] else nil

	local v8 = if props.itemType then itemTypeToContentMap[props.itemType] else nil
	local v9

	if
		props.itemStatus
		and props.itemStatus.type ~= "text"
		and (props.itemStatus.type == "icon" or fFlagAXMarketplaceItemCardIndicatorStack and props.itemStatus.type == "badge")
	then
		v9 = v5[props.itemStatus.iconType]
	end

	local v10

	if fFlagAXMarketplaceLicensingItemCards and props.itemLicensingInfo then
		v10 = React.createElement(LicensingBadge, {
			itemLicensingInfo = props.itemLicensingInfo,
			isInteractive = false,
			passiveSize = Foundation.Enums.BadgeSize.XSmall
		})
	end

	local v11

	if fFlagAXMarketplaceItemCardIndicatorStack then
		local v12 = if props.itemStatus then buildItemStatusContent(props.itemStatus, v9) else nil

		if shouldRenderIndicatorStack(v12, v8) then
			v11 = React.createElement(IndicatorStack, {
				statusContent = v12,
				itemTypeContent = v8
			})
		end
	end

	local createElement = React.createElement

	local activated = React.Event.Activated
	local v14 = if not props.isDisabled then props.onActivated else nil
	local v13 = {
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[activated] = v14,
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
			Padding = UDim.new(0, v6.Gap.Medium)
		}),
		Header = 0,
		Footer = 0
	}

	local createElement2 = React.createElement
	local v16 = {
		LayoutOrder = 1,
		aspectRatio = props.headerAspectRatio,
		Size = props.headerSize,
		overlaySlot = 0
	}
	local v17

	if fFlagAXMarketplaceItemCardIndicatorStack then
		v17 = React.createElement(itemCardHeaderCornersOverlay, {
			topLeftSlot = v10,
			bottomRightSlot = v11,
			constrainTopLeftSlot = v10 ~= nil
		})
	else
		local createElement3 = React.createElement
		local v20

		if props.itemStatus and props.itemStatus.type == "badge" then
			v20 = React.createElement(itemCardBadge, {
				content = {
					{ type = "icon", icon = v5[props.itemStatus.iconType] },
					{ type = "text", text = props.itemStatus.text }
				}
			})
		elseif props.itemStatus then
			if props.itemStatus.type == "text" then
				v20 = React.createElement(itemCardStatus, {
					text = props.itemStatus.text
				})
			elseif v9 then
				v20 = React.createElement(itemCardIcon, { icon = v9 })
			end
		end

		local v21 = if v8 then React.createElement(itemCardBadge, { content = v8 }) else nil

		local v22 = if not (fFlagAXRemoveDynamicHeadBadge or not v7) then React.createElement(itemCardBadge, {
			content = {
				{ type = "icon", icon = v7 }
			}
		}) else nil
		v17 = createElement3(itemCardHeaderCornersOverlay, {
			topLeftSlot = v20,
			bottomLeftSlot = v21,
			bottomRightSlot = v22
		})
	end

	v16.overlaySlot = v17
	children.Header = createElement2(itemCardHeader, v16, props.presentationSlot)

	local createElement3 = React.createElement

	local v19 = {
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
	local v20 = if props.creator then props.creator.name else nil
	v19.creatorName = v20
	v19.bundlePartsText = props.bundlePartsText
	v19.itemSubType = props.itemSubType
	local v21 = if props.creator then props.creator.verified else nil
	v19.creatorHasVerifiedBadge = v21
	v19.priceLineContent = props.priceLineContent
	local v22 = if fFlagAXDurables2Option then props.itemStatusInCheckout else nil
	v19.itemStatusInCheckout = v22

	local v23 = if fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard then props.expirationTime else nil
	v19.expirationTime = v23

	local v24 = if fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard then props.isOwned else nil
	v19.isOwned = v24

	local v25 = if fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard then props.timedOptions else nil
	v19.timedOptions = v25

	local v26 = if fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard then props.onTimedOptionPriceChanged else nil
	v19.onTimedOptionPriceChanged = v26

	local v27 = if fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard then props.selectedTimedOptionPrice else nil
	v19.selectedTimedOptionPrice = v27

	local v28 = if fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard then props.setSelectedTimedOptionPrice else nil
	v19.setSelectedTimedOptionPrice = v28

	local v29 = if fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard then props.selectedTimedOptionIndexInReducer else nil
	v19.selectedTimedOptionIndexInReducer = v29

	local v30 = if fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard then props.wearTimeSelectedOptionInList else nil
	v19.wearTimeSelectedOptionInList = v30

	local v31 = if fFlagAXDurables2Option then props.onRemove else nil
	v19.onRemove = v31
	local v32 = if fFlagAXGifting then props.giftButton else nil
	v19.giftButton = v32
	local v33 = if fFlagAXDurables2Option then props.hideTimedOptionSelections else nil
	v19.hideTimedOptionSelections = v33

	v19.Size = props.footerSize
	local v34 = if props.footerAutomaticSize then props.footerAutomaticSize else Enum.AutomaticSize.Y
	v19.AutomaticSize = v34
	local v35 = if fFlagAXMISOffersChip then props.offersLocalized else nil
	v19.offersLocalized = v35
	local v36 = if fFlagAXMISOffersChip then props.offerApplied else nil
	v19.offerApplied = v36
	local v37 = if fFlagAXDurables2Option then props.showOfferPillTooltip else nil
	v19.showOfferPillTooltip = v37
	children.Footer = createElement3(CatalogRowItemCardFooter, v19)
	return createElement("TextButton", v13, children)
end))
