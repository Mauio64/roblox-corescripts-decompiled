local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local AvatarExperienceUIKit = require(Parent.AvatarExperienceUIKit)
local BuilderIcons = require(Parent.BuilderIcons)
local Responsive = require(Parent.Responsive)
local ItemCardComponents = AvatarExperienceUIKit.ItemCardComponents
local ItemCardFooter = ItemCardComponents.ItemCardFooter
local ItemCardHeader = ItemCardComponents.ItemCardHeader
local ItemCard = ItemCardComponents.ItemCard
local ItemCardBadge = ItemCardComponents.ItemCardBadge
local ItemCardStatus = ItemCardComponents.ItemCardStatus
local ItemCardHeaderCornersOverlay = ItemCardComponents.ItemCardHeaderCornersOverlay
local _ = ItemCardComponents.ItemCardPriceLine
local ItemCardIcon = ItemCardComponents.ItemCardIcon
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local IconSize = Foundation.Enums.IconSize
local Icon = Foundation.Icon
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local CatalogItemCardItemTypeEnum = require(script.Parent.Enums.CatalogItemCardItemTypeEnum)
local CatalogItemCardItemInfoEnum = require(script.Parent.Enums.CatalogItemCardItemInfoEnum)
local CatalogItemCardStatusIconTypeEnum = require(script.Parent.Enums.CatalogItemCardStatusIconTypeEnum)
local CatalogItemCardSelectedOverlay = require(script.Parent.CatalogItemCardSelectedOverlay)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local v25 = game:DefineFastFlag("MoveLimitedBadgeToTopLeft", false)
local FFlagAXRootSlotBasedEditorFlag = require(Parent.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local FFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local FFlagAXFixBadgeStatusConfigOptions = AvatarExperienceFlags.FFlagAXFixBadgeStatusConfigOptions
local FFlagAXSelectedBorderWrapsBackground = AvatarExperienceFlags.FFlagAXSelectedBorderWrapsBackground
local _ = {
	Text = "text",
	Icon = "icon",
	Badge = "badge",
	Placeholder = "placeholder"
}
local v34 = not FFlagAXModeratedItemIconUpdates and "icons/actions/info_small" or BuilderIcons.Icon.CircleI
local v35 = not FFlagAXModeratedItemIconUpdates and "icons/status/pending_small" or BuilderIcons.Icon.ClockDashed
local v36 = not FFlagAXModeratedItemIconUpdates and "icons/status/pending_small" or BuilderIcons.Icon.Clock
local v37 = not FFlagAXModeratedItemIconUpdates and "icons/actions/info_small" or BuilderIcons.Icon.CircleI
local v38 = if not FFlagAXShowFaeUpsell then nil else not FFlagAXModeratedItemIconUpdates and "icons/status/private" or BuilderIcons.Icon.LockClosed
local v39 = not FFlagAXModeratedItemIconUpdates and "icons/status/warning_small" or BuilderIcons.Icon.CircleI
local v40 = not FFlagAXModeratedItemIconUpdates and "icons/status/error_large" or BuilderIcons.Icon.TriangleExclamation
local t1 = {
	[CatalogItemCardStatusIconTypeEnum.Moderated] = v34,
	[CatalogItemCardStatusIconTypeEnum.PendingModeration] = v35,
	[CatalogItemCardStatusIconTypeEnum.Durable] = v36,
	[CatalogItemCardStatusIconTypeEnum.Info] = v37,
	[CatalogItemCardStatusIconTypeEnum.Unavailable] = v39,
	[CatalogItemCardStatusIconTypeEnum.Error] = v40,
	[CatalogItemCardStatusIconTypeEnum.FAE] = v38
}
local t2 = {
	[CatalogItemCardItemTypeEnum.Limited] = {{
		type = "icon",
		icon = "icons/status/item/limited"
	}},
	[CatalogItemCardItemTypeEnum.Collectible] = {
		{
			type = "icon",
			icon = "icons/status/item/limited"
		},
		{
			type = "text",
			text = "#"
		}
	}
}
local t3 = {
	[CatalogItemCardItemInfoEnum.DynamicHead] = "icons/menu/clothing/dynamicHead"
}

local function selectIsPortrait(p1) -- line: 137
	-- upvalues: Responsive (copy)
	return p1.DeviceOrientation == Responsive.Keys.Portrait
end
local function buildBadgeStatusContent(s1: string?, s2: string?) -- line: 141
	local t4 = {{
		type = "icon",
		icon = s1
	}}

	if s2 then
		table.insert(t4, {
			type = "text",
			text = s2
		})
	end

	return t4
end
local function buildSelectedOverlayBadge(t5: {[any]: any}?, s3: string?, s4: string?) -- line: 154
	-- upvalues: FFlagAXShowFaeUpsell (copy), CatalogItemCardStatusIconTypeEnum (copy), v38 (copy), FFlagAXInventoryDurablesSupport (copy), v36 (copy)
	local v54 = t5 and t5.iconType
	local v55 = t5 and t5.text

	if FFlagAXShowFaeUpsell and v54 == CatalogItemCardStatusIconTypeEnum.FAE then
		return {
			icon = v38
		}
	end

	if s3 and v55 then
		return {
			icon = s3,
			text = v55
		}
	end

	if FFlagAXInventoryDurablesSupport and s4 and v54 ~= CatalogItemCardStatusIconTypeEnum.Moderated then
		return {
			icon = v36,
			text = s4
		}
	end

	return nil
end

return (React.forwardRef(function(t6: {[any]: any}, p2) -- line: 178
	-- upvalues: FFlagAXModeratedItemIconUpdates (copy), useTokens (copy), t3 (copy), t2 (copy), useSelector (copy), selectIsPortrait (copy), t1 (copy), FFlagAXSelectedBorderWrapsBackground (copy), React (copy), Foundation (copy), Icon (copy), IconSize (copy), ItemCard (copy), FFlagAXMISEnableMultiShopping (copy), ItemCardHeader (copy), CatalogItemCardSelectedOverlay (copy), FFlagAXFixBadgeStatusConfigOptions (copy), buildSelectedOverlayBadge (copy), FFlagAXShowFaeUpsell (copy), CatalogItemCardStatusIconTypeEnum (copy), v38 (copy), FFlagAXInventoryDurablesSupport (copy), v36 (copy), ItemCardHeaderCornersOverlay (copy), ItemCardStatus (copy), ItemCardBadge (copy), buildBadgeStatusContent (copy), ItemCardIcon (copy), v25 (copy), ItemCardFooter (copy), FFlagAXRootSlotBasedEditorFlag (copy)
	local v58 = if not FFlagAXModeratedItemIconUpdates then nil else useTokens()
	local v59 = t6.title or (t6.creator or t6.priceLineContent)
	local v60 = if not t6.itemInfo then nil else t3[t6.itemInfo]
	local v61 = if not t6.itemType then nil else t2[t6.itemType]
	local v62 = if not FFlagAXModeratedItemIconUpdates then nil else useSelector(selectIsPortrait)
	local v63 = if not t6.itemStatus or (t6.itemStatus.type ~= "icon" and t6.itemStatus.type ~= "badge" or not t6.itemStatus.iconType) then nil else t1[t6.itemStatus.iconType]
	local backgroundLayers = t6.backgroundLayers
	local v65 = if not FFlagAXSelectedBorderWrapsBackground then nil else backgroundLayers ~= nil and #backgroundLayers > 0

	local function renderPresentationSlot() -- line: 198
		-- upvalues: t6 (copy), React (copy), Foundation (copy), FFlagAXModeratedItemIconUpdates (copy), Icon (copy), t1 (copy), v58 (copy), v62 (copy), IconSize (copy)
		if t6.itemStatus and t6.itemStatus.type == "placeholder" then
			if not t6.itemStatus.iconType then
				return nil
			end

			return React.createElement(Foundation.View, {
				tag = "size-full clip radius-medium row align-x-center align-y-center"
			}, {
				icon = if not FFlagAXModeratedItemIconUpdates then React.createElement(Foundation.Image, {
					Image = t1[t6.itemStatus.iconType],
					Size = UDim2.fromScale(0.33, 0.33)
				}) else React.createElement(Icon, {
					name = t1[t6.itemStatus.iconType],
					style = v58.Color.Content.Muted,
					size = not v62 and 40 or IconSize.Large
				})
			})
		end

		return t6.presentationSlot
	end

	return React.createElement(ItemCard, {
		onActivated = t6.onActivated,
		isDisabled = t6.isDisabled,
		ref = p2,
		Size = t6.Size,
		AutomaticSize = t6.AutomaticSize,
		LayoutOrder = t6.LayoutOrder,
		tag = t6.tag,
		Selectable = if not FFlagAXMISEnableMultiShopping then nil else t6.Selectable,
		showSelectionBorderWithBackground = if not FFlagAXSelectedBorderWrapsBackground then nil else t6.isSelected,
		backgroundLayers = backgroundLayers,
		imageScaleType = t6.imageScaleType,
		headerSlot = React.createElement(ItemCardHeader, {
			aspectRatio = t6.headerAspectRatio,
			overlaySlot = if not t6.isSelected then React.createElement(ItemCardHeaderCornersOverlay, {
				topLeftSlot = if not t6.itemStatus then if not FFlagAXInventoryDurablesSupport or not t6.expirationTime then if not v25 or not v61 then nil else React.createElement(ItemCardBadge, {
					content = v61
				}) else React.createElement(ItemCardBadge, {
					displayBorder = true,
					content = {
						{
							type = "icon",
							icon = v36
						},
						{
							type = "text",
							text = t6.expirationTime
						}
					}
				}) else if t6.itemStatus.type ~= "text" or not t6.itemStatus.text then if t6.itemStatus.type ~= "badge" then if not v63 then nil else React.createElement(ItemCardIcon, {
					icon = v63
				}) else React.createElement(ItemCardBadge, {
					displayBorder = true,
					content = if not FFlagAXFixBadgeStatusConfigOptions and not FFlagAXShowFaeUpsell then {
						{
							type = "icon",
							icon = v63
						},
						{
							type = "text",
							text = t6.itemStatus.text
						}
					} else buildBadgeStatusContent(v63, t6.itemStatus.text)
				}) else React.createElement(ItemCardStatus, {
					text = t6.itemStatus.text
				}),
				bottomLeftSlot = if v25 or not v61 then nil else React.createElement(ItemCardBadge, {
					content = v61
				}),
				bottomRightSlot = if not v60 then nil else React.createElement(ItemCardBadge, {
					content = {{
						type = "icon",
						icon = v60
					}}
				})
			}) else React.createElement(CatalogItemCardSelectedOverlay, if not t6.onOverlayButtonActivated or not t6.overlayButtonText then if not FFlagAXInventoryDurablesSupport or not v63 then if not FFlagAXSelectedBorderWrapsBackground or not v65 then nil else {
				suppressBorder = true
			} else {
				itemStatusIcon = v63,
				suppressBorder = if not FFlagAXSelectedBorderWrapsBackground then nil else v65
			} else {
				onActivated = t6.onOverlayButtonActivated,
				buttonText = t6.overlayButtonText,
				suppressBorder = if not FFlagAXSelectedBorderWrapsBackground then nil else v65,
				badge = if not FFlagAXFixBadgeStatusConfigOptions then if not FFlagAXShowFaeUpsell or (not t6.itemStatus or t6.itemStatus.iconType ~= CatalogItemCardStatusIconTypeEnum.FAE) then if not v63 or (not t6.itemStatus or not t6.itemStatus.text) then if not FFlagAXInventoryDurablesSupport or (not t6.expirationTime or not not t6.itemStatus and t6.itemStatus.iconType == CatalogItemCardStatusIconTypeEnum.Moderated) then nil else {
					icon = v36,
					text = t6.expirationTime
				} else {
					icon = v63,
					text = t6.itemStatus.text
				} else {
					icon = v38
				} else buildSelectedOverlayBadge(t6.itemStatus, v63, t6.expirationTime)
			}),
			BackgroundTransparency = if not backgroundLayers then nil else 1,
			Size = t6.headerSize
		}, renderPresentationSlot()),
		footerSlot = if not v59 then nil else React.createElement(ItemCardFooter, {
			LayoutOrder = 2,
			title = t6.title,
			creatorName = if not t6.creator then nil else t6.creator.name,
			creatorHasVerifiedBadge = if not t6.creator then nil else t6.creator.verified,
			priceLineContent = t6.priceLineContent,
			titleTextSize = if not FFlagAXRootSlotBasedEditorFlag then nil else t6.titleTextSize
		})
	})
end))
