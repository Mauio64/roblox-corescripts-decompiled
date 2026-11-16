local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent
local React = require(parent.React)
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local Responsive = require(parent.Responsive)

local ItemCardComponents = AvatarExperienceUIKit.ItemCardComponents
local ItemCardFooter = ItemCardComponents.ItemCardFooter
local ItemCardHeader = ItemCardComponents.ItemCardHeader
local ItemCard = ItemCardComponents.ItemCard
local ItemCardBadge = ItemCardComponents.ItemCardBadge
local ItemCardStatus = ItemCardComponents.ItemCardStatus
local ItemCardHeaderCornersOverlay = ItemCardComponents.ItemCardHeaderCornersOverlay
local ItemCardPriceLine = ItemCardComponents.ItemCardPriceLine
local ItemCardIcon = ItemCardComponents.ItemCardIcon
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local BadgeSize = Foundation.Enums.BadgeSize
local IconSize = Foundation.Enums.IconSize
local Icon = Foundation.Icon

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local IndicatorStack = require(AvatarExperienceCommon.Components.IndicatorStack.IndicatorStack)
local shouldRenderIndicatorStack = require(AvatarExperienceCommon.Utils.shouldRenderIndicatorStack)
local LicensingBadge = require(AvatarExperienceCommon.Components.LicensingBadge.LicensingBadge)
require(script.Parent.Enums.CatalogItemCardItemTypeEnum)
require(script.Parent.Enums.CatalogItemCardItemInfoEnum)
local CatalogItemCardStatusIconTypeEnum = require(script.Parent.Enums.CatalogItemCardStatusIconTypeEnum)
local ItemStatusTypeEnum = require(script.Parent.Enums.ItemStatusTypeEnum)
local CatalogItemCardBadgeMaps = require(script.Parent.CatalogItemCardBadgeMaps)

local CatalogItemCardSelectedOverlay = require(script.Parent.CatalogItemCardSelectedOverlay)
local useSelectedOverlayButton = require(script.Parent.useSelectedOverlayButton)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local FFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local FFlagAXFixBadgeStatusConfigOptions = AvatarExperienceFlags.FFlagAXFixBadgeStatusConfigOptions
local FFlagAXRemoveDynamicHeadBadge = AvatarExperienceFlags.FFlagAXRemoveDynamicHeadBadge
local FFlagAXMarketplaceItemCardIndicatorStack = AvatarExperienceFlags.FFlagAXMarketplaceItemCardIndicatorStack
local FFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards

require(parent.AvatarExperienceModel)

local DURABLE_ICON = CatalogItemCardBadgeMaps.DURABLE_ICON
local FAE_ICON = CatalogItemCardBadgeMaps.FAE_ICON

local itemTypeToContentMap = CatalogItemCardBadgeMaps.itemTypeToContentMap
local itemInfoIconMap = CatalogItemCardBadgeMaps.itemInfoIconMap
local itemStatusIconTypeToIconMap = CatalogItemCardBadgeMaps.itemStatusIconTypeToIconMap

local function selectIsPortrait(p): boolean
	return p.DeviceOrientation == Responsive.Keys.Portrait
end

local function buildBadgeStatusContent(icon: string?, text: string?)
	local badgeStatusContent = {
		{ type = "icon", icon = icon }
	}

	if text then
		table.insert(badgeStatusContent, { type = "text", text = text })
	end

	return badgeStatusContent
end

local function buildItemStatusContent(itemStatus, icon: string?, expirationTime: string?, isSelected: boolean?)
	if itemStatus then
		local content

		if itemStatus.type == ItemStatusTypeEnum.Badge then
			if FFlagAXFixBadgeStatusConfigOptions or FFlagAXShowFaeUpsell then
				content = buildBadgeStatusContent(icon, itemStatus.text)
			else
				content = {
					{ type = "icon", icon = icon },
					{ type = "text", text = itemStatus.text }
				}
			end
		end

		if itemStatus.type == ItemStatusTypeEnum.Text and itemStatus.text then
			return { type = "text", text = itemStatus.text }
		end

		if itemStatus.type == ItemStatusTypeEnum.Badge and content then
			return { type = "badge", content = content, displayBorder = true }
		end

		if icon then
			return { type = "icon", icon = icon }
		end

		if not isSelected or itemStatus.iconType == CatalogItemCardStatusIconTypeEnum.Moderated then
			return nil
		end
	end

	if FFlagAXInventoryDurablesSupport and expirationTime then
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

local function buildSelectedOverlayBadge(itemStatus, icon: string?, expirationTime: string?)
	local iconType = itemStatus and itemStatus.iconType
	local text = itemStatus and itemStatus.text

	if FFlagAXShowFaeUpsell and iconType == CatalogItemCardStatusIconTypeEnum.FAE then
		return { icon = FAE_ICON }
	end

	if icon and text then
		return { icon = icon, text = text }
	end

	if
		FFlagAXInventoryDurablesSupport
		and expirationTime
		and iconType ~= CatalogItemCardStatusIconTypeEnum.Moderated
	then
		return { icon = DURABLE_ICON, text = expirationTime }
	end

	return nil
end

local function SelectedIndicatorCorners(props)
	local v = useSelectedOverlayButton(props.hasOverlayButton)

	local createElement = React.createElement
	local topLeftSlot

	if FFlagAXMarketplaceLicensingItemCards then
		topLeftSlot = props.topLeftSlot
	end

	local v2 = {
		topLeftSlot = topLeftSlot,
		bottomRightSlot = props.bottomRightSlot,
		bottomInset = 0,
		constrainTopLeftSlot = 0
	}
	local bottomInset

	if v.isVisible then
		bottomInset = v.occupiedHeight
	end

	v2.bottomInset = bottomInset
	v2.constrainTopLeftSlot = FFlagAXMarketplaceLicensingItemCards and props.topLeftSlot ~= nil
	return createElement(ItemCardHeaderCornersOverlay, v2)
end

return (React.forwardRef(function(props, p)
	local v

	if FFlagAXModeratedItemIconUpdates or FFlagAXMarketplaceLicensingItemCards then
		v = useTokens()
	else
		v = nil
	end

	local state, ref2, onAbsoluteSizeChanged

	if FFlagAXMarketplaceLicensingItemCards then
		local size_3000 = v.Size.Size_3000
		local setState
		state, setState = React.useState(false)

		local ref = React.useRef(state)
		ref2 = React.useRef(nil)

		React.useImperativeHandle(p, function()
			return ref2.current
		end, {})
		onAbsoluteSizeChanged = React.useCallback(function(p2)
			local x = p2.AbsoluteSize.X

			if x == 0 then
				return
			end

			local current = x <= size_3000

			if current ~= ref.current then
				ref.current = current
				setState(current)
			end
		end, { size_3000 })

		React.useLayoutEffect(function()
			if ref2.current then
				onAbsoluteSizeChanged(ref2.current)
			end
		end, { onAbsoluteSizeChanged })
	else
		ref2 = p
		state = false
		onAbsoluteSizeChanged = nil
	end

	local title = props.title or props.creator or props.priceLineContent
	local icon

	if props.itemInfo then
		icon = itemInfoIconMap[props.itemInfo]
	end

	local v2

	if props.itemType then
		v2 = itemTypeToContentMap[props.itemType]
	end

	local v3

	if FFlagAXModeratedItemIconUpdates then
		v3 = useSelector(selectIsPortrait)
	else
		v3 = nil
	end

	local v4

	if
		props.itemStatus
		and (props.itemStatus.type == ItemStatusTypeEnum.Icon or props.itemStatus.type == ItemStatusTypeEnum.Badge)
		and props.itemStatus.iconType
	then
		v4 = itemStatusIconTypeToIconMap[props.itemStatus.iconType]
	end

	local backgroundLayers = props.backgroundLayers
	local suppressBorder

	if backgroundLayers == nil then
		suppressBorder = false
	else
		suppressBorder = #backgroundLayers > 0
	end

	local topLeftSlot

	if FFlagAXMarketplaceLicensingItemCards and props.itemLicensingInfo then
		local createElement = React.createElement
		local v5 = {
			itemLicensingInfo = props.itemLicensingInfo,
			isInteractive = false,
			passiveSize = 0
		}
		local passiveSize

		if state then
			passiveSize = BadgeSize.XSmall
		else
			passiveSize = BadgeSize.Small
		end

		v5.passiveSize = passiveSize
		topLeftSlot = createElement(LicensingBadge, v5)
	end

	local bottomRightSlot

	if FFlagAXMarketplaceItemCardIndicatorStack then
		local itemStatusContent = buildItemStatusContent(props.itemStatus, v4, props.expirationTime, props.isSelected)

		if shouldRenderIndicatorStack(itemStatusContent, v2) then
			bottomRightSlot = React.createElement(IndicatorStack, {
				statusContent = itemStatusContent,
				itemTypeContent = v2
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
		local icon2

		if FFlagAXModeratedItemIconUpdates then
			icon2 = React.createElement(Icon, {
				name = itemStatusIconTypeToIconMap[props.itemStatus.iconType],
				style = v.Color.Content.Muted,
				size = not v3 and 40 or IconSize.Large
			})
		else
			icon2 = React.createElement(Foundation.Image, {
				Image = itemStatusIconTypeToIconMap[props.itemStatus.iconType],
				Size = UDim2.fromScale(0.33, 0.33)
			})
		end

		return createElement(view, {
			tag = "size-full clip radius-medium row align-x-center align-y-center"
		}, {
			icon = icon2
		})
	end

	local createElement = React.createElement
	local v5 = {
		onActivated = props.onActivated,
		isDisabled = props.isDisabled,
		ref = ref2,
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,
		LayoutOrder = props.LayoutOrder,
		tag = props.tag,
		Selectable = props.Selectable,
		showSelectionBorderWithBackground = props.isSelected,
		backgroundLayers = backgroundLayers,
		imageScaleType = props.imageScaleType,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		headerSlot = 0,
		footerSlot = 0
	}

	local createElement2 = React.createElement
	local v6 = {
		aspectRatio = props.headerAspectRatio,
		overlaySlot = 0,
		BackgroundTransparency = 0,
		Size = 0
	}
	local overlaySlot

	if FFlagAXMarketplaceItemCardIndicatorStack then
		local createElement3 = React.createElement
		local fragment = React.Fragment
		local catalogItemCardCorners

		if props.isSelected and bottomRightSlot then
			catalogItemCardCorners = React.createElement(SelectedIndicatorCorners, {
				topLeftSlot = topLeftSlot,
				bottomRightSlot = bottomRightSlot,
				hasOverlayButton = props.onOverlayButtonActivated ~= nil and props.overlayButtonText ~= nil
			})
		else
			catalogItemCardCorners = React.createElement(ItemCardHeaderCornersOverlay, {
				topLeftSlot = topLeftSlot,
				bottomRightSlot = bottomRightSlot,
				constrainTopLeftSlot = topLeftSlot ~= nil
			})
		end

		local catalogItemCardSelection

		if props.isSelected then
			catalogItemCardSelection = React.createElement(
				CatalogItemCardSelectedOverlay,
				props.onOverlayButtonActivated and props.overlayButtonText and {
					onActivated = props.onOverlayButtonActivated,
					buttonText = props.overlayButtonText,
					suppressBorder = suppressBorder
				} or suppressBorder and { suppressBorder = true } or nil
			)
		end

		overlaySlot = createElement3(fragment, nil, {
			CatalogItemCardCorners = catalogItemCardCorners,
			CatalogItemCardSelection = catalogItemCardSelection
		})
	elseif props.isSelected then
		local createElement3 = React.createElement
		local v7

		if props.onOverlayButtonActivated and props.overlayButtonText then
			v7 = {
				onActivated = props.onOverlayButtonActivated,
				buttonText = props.overlayButtonText,
				suppressBorder = suppressBorder,
				badge = 0
			}
			local badge

			if FFlagAXFixBadgeStatusConfigOptions then
				badge = buildSelectedOverlayBadge(props.itemStatus, v4, props.expirationTime)
			elseif
				FFlagAXShowFaeUpsell
				and props.itemStatus
				and props.itemStatus.iconType == CatalogItemCardStatusIconTypeEnum.FAE
			then
				badge = { icon = FAE_ICON }
			elseif v4 and props.itemStatus and props.itemStatus.text then
				badge = { icon = v4, text = props.itemStatus.text }
			else
				badge = FFlagAXInventoryDurablesSupport
					and props.expirationTime
					and (not props.itemStatus or props.itemStatus.iconType ~= CatalogItemCardStatusIconTypeEnum.Moderated)
					and { icon = DURABLE_ICON, text = props.expirationTime }
					or nil
			end

			v7.badge = badge
		else
			v7 = FFlagAXInventoryDurablesSupport and v4 and {
					itemStatusIcon = v4,
					suppressBorder = suppressBorder
				}
				or suppressBorder and { suppressBorder = true }
				or nil
		end

		overlaySlot = createElement3(CatalogItemCardSelectedOverlay, v7)
	else
		local createElement3 = React.createElement
		local topLeftSlot2

		if props.itemStatus then
			if props.itemStatus.type == ItemStatusTypeEnum.Text and props.itemStatus.text then
				topLeftSlot2 = React.createElement(ItemCardStatus, { text = props.itemStatus.text })
			elseif props.itemStatus.type == ItemStatusTypeEnum.Badge then
				local createElement4 = React.createElement
				local content

				if FFlagAXFixBadgeStatusConfigOptions or FFlagAXShowFaeUpsell then
					content = buildBadgeStatusContent(v4, props.itemStatus.text)
				else
					content = {
						{ type = "icon", icon = v4 },
						{ type = "text", text = props.itemStatus.text }
					}
				end

				topLeftSlot2 = createElement4(ItemCardBadge, {
					content = content,
					displayBorder = true
				})
			elseif v4 then
				topLeftSlot2 = React.createElement(ItemCardIcon, { icon = v4 })
			end
		elseif FFlagAXInventoryDurablesSupport and props.expirationTime then
			topLeftSlot2 = React.createElement(ItemCardBadge, {
				content = {
					{ type = "icon", icon = DURABLE_ICON },
					{ type = "text", text = props.expirationTime }
				},
				displayBorder = true
			})
		elseif v2 then
			topLeftSlot2 = React.createElement(ItemCardBadge, { content = v2 })
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
			bottomRightSlot = bottomRightSlot2
		})
	end

	v6.overlaySlot = overlaySlot

	v6.BackgroundTransparency = backgroundLayers and 1 or nil
	v6.Size = props.headerSize
	v5.headerSlot = createElement2(ItemCardHeader, v6, renderPresentationSlot())
	local footerSlot

	if title then
		local createElement3 = React.createElement
		local v7 = {
			title = props.title,
			creatorName = 0,
			creatorHasVerifiedBadge = 0,
			priceLineContent = 0,
			titleTextSize = 0,
			LayoutOrder = 2
		}
		local creatorName

		if props.creator then
			creatorName = props.creator.name
		end

		v7.creatorName = creatorName
		local creatorHasVerifiedBadge

		if props.creator then
			creatorHasVerifiedBadge = props.creator.verified
		end

		v7.creatorHasVerifiedBadge = creatorHasVerifiedBadge
		v7.priceLineContent = props.priceLineContent
		v7.titleTextSize = props.titleTextSize
		footerSlot = createElement3(ItemCardFooter, v7)
	end

	v5.footerSlot = footerSlot
	return createElement(ItemCard, v5)
end))
