local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local AvatarExperienceUIKit = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceUIKit")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Responsive")

local itemCardComponents = AvatarExperienceUIKit.ItemCardComponents
local itemCardFooter = itemCardComponents.ItemCardFooter
local itemCardHeader = itemCardComponents.ItemCardHeader
local itemCard = itemCardComponents.ItemCard
local itemCardBadge = itemCardComponents.ItemCardBadge
local itemCardStatus = itemCardComponents.ItemCardStatus
local itemCardHeaderCornersOverlay = itemCardComponents.ItemCardHeaderCornersOverlay
local itemCardPriceLine = itemCardComponents.ItemCardPriceLine
local itemCardIcon = itemCardComponents.ItemCardIcon
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local useTokens = Foundation.Hooks.useTokens
local badgeSize = Foundation.Enums.BadgeSize
local iconSize = Foundation.Enums.IconSize
local icon = Foundation.Icon

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/RoactUtils").Hooks.RoactRodux.useSelector

local IndicatorStack = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/IndicatorStack/IndicatorStack")
local shouldRenderIndicatorStack = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/shouldRenderIndicatorStack")
local LicensingBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/LicensingBadge/LicensingBadge")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/CatalogItemCardItemTypeEnum")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/CatalogItemCardItemInfoEnum")
local CatalogItemCardStatusIconTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/CatalogItemCardStatusIconTypeEnum")
local ItemStatusTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/ItemStatusTypeEnum")
local CatalogItemCardBadgeMaps = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/CatalogItemCardBadgeMaps")

local CatalogItemCardSelectedOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/CatalogItemCardSelectedOverlay")
local useSelectedOverlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/useSelectedOverlayButton")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local fFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local fFlagAXFixBadgeStatusConfigOptions = AvatarExperienceFlags.FFlagAXFixBadgeStatusConfigOptions
local fFlagAXRemoveDynamicHeadBadge = AvatarExperienceFlags.FFlagAXRemoveDynamicHeadBadge
local fFlagAXMarketplaceItemCardIndicatorStack = AvatarExperienceFlags.FFlagAXMarketplaceItemCardIndicatorStack
local fFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel")

local DURABLE_ICON = CatalogItemCardBadgeMaps.DURABLE_ICON
local FAE_ICON = CatalogItemCardBadgeMaps.FAE_ICON

local itemTypeToContentMap = CatalogItemCardBadgeMaps.itemTypeToContentMap
local itemInfoIconMap = CatalogItemCardBadgeMaps.itemInfoIconMap
local itemStatusIconTypeToIconMap = CatalogItemCardBadgeMaps.itemStatusIconTypeToIconMap

local function selectIsPortrait(p2): boolean
	return p2.DeviceOrientation == Responsive.Keys.Portrait
end

local function buildBadgeStatusContent(p2, text)
	local badgeStatusContent = {
		{ type = "icon", icon = p2 }
	}

	if text then
		table.insert(badgeStatusContent, { type = "text", text = text })
	end

	return badgeStatusContent
end

local function buildItemStatusContent(itemStatus, p2, expirationTime, isSelected)
	if itemStatus then
		local v5

		if itemStatus.type == ItemStatusTypeEnum.Badge then
			if fFlagAXFixBadgeStatusConfigOptions or fFlagAXShowFaeUpsell then
				v5 = buildBadgeStatusContent(p2, itemStatus.text)
			else
				v5 = {
					{ type = "icon", icon = p2 },
					{ type = "text", text = itemStatus.text }
				}
			end
		end

		if itemStatus.type == ItemStatusTypeEnum.Text and itemStatus.text then
			return { type = "text", text = itemStatus.text }
		end

		if itemStatus.type == ItemStatusTypeEnum.Badge and v5 then
			return { type = "badge", content = v5, displayBorder = true }
		end

		if p2 then
			return { type = "icon", icon = p2 }
		end

		if not isSelected or itemStatus.iconType == CatalogItemCardStatusIconTypeEnum.Moderated then
			return nil
		end
	end

	if fFlagAXInventoryDurablesSupport and expirationTime then
		return {
			type = "badge",
			content = {
				{ type = "icon", icon = DURABLE_ICON },
				{ type = "text", text = expirationTime }
			},
			displayBorder = true
		}
	end

	return nil
end

local function buildSelectedOverlayBadge(itemStatus, p2, expirationTime)
	local iconType = itemStatus and itemStatus.iconType
	local text = itemStatus and itemStatus.text

	if fFlagAXShowFaeUpsell and iconType == CatalogItemCardStatusIconTypeEnum.FAE then
		return { icon = FAE_ICON }
	end

	if p2 and text then
		return { icon = p2, text = text }
	end

	if fFlagAXInventoryDurablesSupport and expirationTime and iconType ~= CatalogItemCardStatusIconTypeEnum.Moderated then
		return { icon = DURABLE_ICON, text = expirationTime }
	end

	return nil
end

local function SelectedIndicatorCorners(props)
	local v5 = useSelectedOverlayButton(props.hasOverlayButton)

	local createElement = React.createElement
	local v8 = if fFlagAXMarketplaceLicensingItemCards then props.topLeftSlot else nil
	local v7 = {
		topLeftSlot = v8,
		bottomRightSlot = props.bottomRightSlot,
		bottomInset = 0,
		constrainTopLeftSlot = 0
	}
	local v9 = if v5.isVisible then v5.occupiedHeight else nil
	v7.bottomInset = v9
	v7.constrainTopLeftSlot = fFlagAXMarketplaceLicensingItemCards and props.topLeftSlot ~= nil
	return createElement(itemCardHeaderCornersOverlay, v7)
end

return (React.forwardRef(function(props, p2)
	local v5

	if fFlagAXModeratedItemIconUpdates or fFlagAXMarketplaceLicensingItemCards then
		v5 = useTokens()
	else
		v5 = nil
	end

	local state, v6, v7

	if fFlagAXMarketplaceLicensingItemCards then
		local size_3000 = v5.Size.Size_3000
		local setState
		state, setState = React.useState(false)

		local ref = React.useRef(state)
		v6 = React.useRef(nil)

		React.useImperativeHandle(p2, function()
			return v6.current
		end, {})
		v7 = React.useCallback(function(p3)
			local x = p3.AbsoluteSize.X

			if x == 0 then
				return
			end

			local v8 = x <= size_3000

			if v8 ~= ref.current then
				ref.current = v8
				setState(v8)
			end
		end, { size_3000 })

		React.useLayoutEffect(function()
			if v6.current then
				v7(v6.current)
			end
		end, { v7 })
	else
		v6 = p2
		state = false
		v7 = nil
	end

	local title = props.title or props.creator or props.priceLineContent
	local v8 = if props.itemInfo then itemInfoIconMap[props.itemInfo] else nil
	local v9 = if props.itemType then itemTypeToContentMap[props.itemType] else nil

	local v10 = if fFlagAXModeratedItemIconUpdates then useSelector(selectIsPortrait) else nil
	local v11

	if
		props.itemStatus
		and (props.itemStatus.type == ItemStatusTypeEnum.Icon or props.itemStatus.type == ItemStatusTypeEnum.Badge)
		and props.itemStatus.iconType
	then
		v11 = itemStatusIconTypeToIconMap[props.itemStatus.iconType]
	end

	local backgroundLayers = props.backgroundLayers

	local v12 = not (backgroundLayers == nil) and #backgroundLayers > 0
	local v13

	if fFlagAXMarketplaceLicensingItemCards and props.itemLicensingInfo then
		local createElement = React.createElement
		local v15 = {
			itemLicensingInfo = props.itemLicensingInfo,
			isInteractive = false,
			passiveSize = 0
		}

		local v16 = if state then badgeSize.XSmall else badgeSize.Small
		v15.passiveSize = v16
		v13 = createElement(LicensingBadge, v15)
	end

	local v14

	if fFlagAXMarketplaceItemCardIndicatorStack then
		local itemStatusContent = buildItemStatusContent(
			props.itemStatus,
			v11,
			props.expirationTime,
			props.isSelected
		)

		if shouldRenderIndicatorStack(itemStatusContent, v9) then
			v14 = React.createElement(IndicatorStack, {
				statusContent = itemStatusContent,
				itemTypeContent = v9
			})
		end
	end

	local function renderPresentationSlot()
		if not props.itemStatus or props.itemStatus.type ~= ItemStatusTypeEnum.Placeholder then
			return props.presentationSlot
		end

		if not props.itemStatus.iconType then
			return nil
		end

		local createElement = React.createElement
		local view = Foundation.View

		local v17 = if fFlagAXModeratedItemIconUpdates then React.createElement(icon, {
			name = itemStatusIconTypeToIconMap[props.itemStatus.iconType],
			style = v5.Color.Content.Muted,
			size = not v10 and 40 or iconSize.Large
		}) else React.createElement(Foundation.Image, {
			Image = itemStatusIconTypeToIconMap[props.itemStatus.iconType],
			Size = UDim2.fromScale(0.33, 0.33)
		})
		return createElement(
			view,
			{ tag = "size-full clip radius-medium row align-x-center align-y-center" },
			{ icon = v17 }
		)
	end

	local createElement = React.createElement
	local v16 = {
		onActivated = props.onActivated,
		isDisabled = props.isDisabled,
		ref = v6,
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,
		LayoutOrder = props.LayoutOrder,
		tag = props.tag,
		Selectable = props.Selectable,
		showSelectionBorderWithBackground = props.isSelected,
		backgroundLayers = backgroundLayers,
		imageScaleType = props.imageScaleType,
		onAbsoluteSizeChanged = v7,
		headerSlot = 0,
		footerSlot = 0
	}

	local createElement2 = React.createElement
	local v18 = {
		aspectRatio = props.headerAspectRatio,
		overlaySlot = 0,
		BackgroundTransparency = 0,
		Size = 0
	}
	local v19

	if fFlagAXMarketplaceItemCardIndicatorStack then
		local createElement3 = React.createElement
		local fragment = React.Fragment
		local v22

		if props.isSelected and v14 then
			v22 = React.createElement(SelectedIndicatorCorners, {
				topLeftSlot = v13,
				bottomRightSlot = v14,
				hasOverlayButton = props.onOverlayButtonActivated ~= nil and props.overlayButtonText ~= nil
			})
		else
			v22 = React.createElement(itemCardHeaderCornersOverlay, {
				topLeftSlot = v13,
				bottomRightSlot = v14,
				constrainTopLeftSlot = v13 ~= nil
			})
		end

		local v23 = if props.isSelected then React.createElement(
			CatalogItemCardSelectedOverlay,
			props.onOverlayButtonActivated and props.overlayButtonText and {
				onActivated = props.onOverlayButtonActivated,
				buttonText = props.overlayButtonText,
				suppressBorder = v12
			} or v12 and { suppressBorder = true } or nil
		) else nil
		v19 = createElement3(fragment, nil, {
			CatalogItemCardCorners = v22,
			CatalogItemCardSelection = v23
		})
	elseif props.isSelected then
		local createElement3 = React.createElement
		local v21

		if props.onOverlayButtonActivated and props.overlayButtonText then
			v21 = {
				onActivated = props.onOverlayButtonActivated,
				buttonText = props.overlayButtonText,
				suppressBorder = v12,
				badge = 0
			}
			local v22

			if fFlagAXFixBadgeStatusConfigOptions then
				v22 = buildSelectedOverlayBadge(props.itemStatus, v11, props.expirationTime)
			elseif
				fFlagAXShowFaeUpsell
				and props.itemStatus
				and props.itemStatus.iconType == CatalogItemCardStatusIconTypeEnum.FAE
			then
				v22 = { icon = FAE_ICON }
			elseif v11 and props.itemStatus and props.itemStatus.text then
				v22 = { icon = v11, text = props.itemStatus.text }
			else
				v22 = fFlagAXInventoryDurablesSupport
					and props.expirationTime
					and (not props.itemStatus or props.itemStatus.iconType ~= CatalogItemCardStatusIconTypeEnum.Moderated)
					and { icon = DURABLE_ICON, text = props.expirationTime }
					or nil
			end

			v21.badge = v22
		else
			v21 = fFlagAXInventoryDurablesSupport
				and v11
				and { itemStatusIcon = v11, suppressBorder = v12 }
				or v12 and { suppressBorder = true }
				or nil
		end

		v19 = createElement3(CatalogItemCardSelectedOverlay, v21)
	else
		local createElement3 = React.createElement
		local v22

		if props.itemStatus then
			if props.itemStatus.type == ItemStatusTypeEnum.Text and props.itemStatus.text then
				v22 = React.createElement(itemCardStatus, {
					text = props.itemStatus.text
				})
			elseif props.itemStatus.type == ItemStatusTypeEnum.Badge then
				local createElement4 = React.createElement

				local v25 = if fFlagAXFixBadgeStatusConfigOptions or fFlagAXShowFaeUpsell then buildBadgeStatusContent(v11, props.itemStatus.text) else {
					{ type = "icon", icon = v11 },
					{ type = "text", text = props.itemStatus.text }
				}
				v22 = createElement4(itemCardBadge, {
					content = v25,
					displayBorder = true
				})
			elseif v11 then
				v22 = React.createElement(itemCardIcon, { icon = v11 })
			end
		elseif fFlagAXInventoryDurablesSupport and props.expirationTime then
			v22 = React.createElement(itemCardBadge, {
				content = {
					{ type = "icon", icon = DURABLE_ICON },
					{ type = "text", text = props.expirationTime }
				},
				displayBorder = true
			})
		elseif v9 then
			v22 = React.createElement(itemCardBadge, { content = v9 })
		end

		local v23 = if not (fFlagAXRemoveDynamicHeadBadge or not v8) then React.createElement(itemCardBadge, {
			content = {
				{ type = "icon", icon = v8 }
			}
		}) else nil
		v19 = createElement3(itemCardHeaderCornersOverlay, {
			topLeftSlot = v22,
			bottomRightSlot = v23
		})
	end

	v18.overlaySlot = v19

	v18.BackgroundTransparency = backgroundLayers and 1 or nil
	v18.Size = props.headerSize
	v16.headerSlot = createElement2(itemCardHeader, v18, renderPresentationSlot())
	local v20

	if title then
		local createElement3 = React.createElement
		local v22 = {
			title = props.title,
			creatorName = 0,
			creatorHasVerifiedBadge = 0,
			priceLineContent = 0,
			titleTextSize = 0,
			LayoutOrder = 2
		}
		local v23 = if props.creator then props.creator.name else nil
		v22.creatorName = v23
		local v24 = if props.creator then props.creator.verified else nil
		v22.creatorHasVerifiedBadge = v24
		v22.priceLineContent = props.priceLineContent
		v22.titleTextSize = props.titleTextSize
		v20 = createElement3(itemCardFooter, v22)
	end

	v16.footerSlot = v20
	return createElement(itemCard, v16)
end))
