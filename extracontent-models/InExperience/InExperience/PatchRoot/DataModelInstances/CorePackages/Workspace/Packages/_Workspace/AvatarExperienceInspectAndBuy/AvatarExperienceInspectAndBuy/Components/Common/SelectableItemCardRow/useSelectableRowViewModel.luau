local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail

require(AvatarExperienceInspectAndBuy.Types)
local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local getItemThumbnailUrl = require(AvatarExperienceInspectAndBuy.Utils.getItemThumbnailUrl)
local getCatalogCardItemType = require(AvatarExperienceInspectAndBuy.Utils.getCatalogCardItemType)
local getPriceLineContent = require(AvatarExperienceInspectAndBuy.Utils.getPriceLineContent)
local getPriceStatus = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatus)
require(script.Parent.SelectableItemCardRowView)

local function useSelectableRowViewModel(props)
	local v = useTokens()
	local itemData = props.itemData
	local v2

	if props.isSelectionEnabled then
		v2 = props.itemCardWidth - (v.Size.Size_400 + v.Gap.Medium)
	else
		v2 = props.itemCardWidth
	end

	local isOwned = React.useMemo(function(): boolean
		return getPriceStatus(itemData) == PriceStatus.Owned
	end, { itemData })

	local url = React.useMemo(function()
		if itemData.id == nil or itemData.itemType == nil then
			return nil
		end

		return getItemThumbnailUrl({ id = itemData.id, itemType = itemData.itemType })
	end, { itemData })

	local onItemCardActivated = props.onItemCardActivated
	local onActivated = React.useCallback(function()
		onItemCardActivated(itemData)
	end, { itemData, onItemCardActivated })

	local isSelected = props.isSelected
	local onSelectionChanged = props.onSelectionChanged

	local onSelectionToggled = React.useCallback(function()
		onSelectionChanged(itemData, not isSelected)
	end, { itemData, isSelected, onSelectionChanged })

	local cardProps = {
		title = itemData.name,
		presentationSlot = 0,
		itemSubType = 0,
		itemType = 0,
		creator = 0,
		priceLineContent = 0,
		isOwned = 0,
		onActivated = 0,
		headerSize = 0,
		footerAutomaticSize = 0,
		AutomaticSize = 0,
		LayoutOrder = 2
	}
	local presentationSlot

	if url then
		presentationSlot = React.createElement(ItemCardThumbnail, { url = url })
	end

	cardProps.presentationSlot = presentationSlot

	cardProps.itemSubType = props.itemSubTypeLabel
	cardProps.itemType = getCatalogCardItemType(itemData.itemRestrictions)
	cardProps.creator = itemData.creator and {
		name = itemData.creator.creatorName or "",
		verified = itemData.creator.creatorHasVerifiedBadge
	} or nil

	cardProps.priceLineContent = getPriceLineContent(itemData, v, props.priceStatusLabels, props.priceOptions)

	cardProps.isOwned = isOwned
	cardProps.onActivated = onActivated
	cardProps.headerSize = UDim2.fromOffset(v2, v2)
	cardProps.footerAutomaticSize = Enum.AutomaticSize.XY
	cardProps.AutomaticSize = Enum.AutomaticSize.XY
	return {
		cardProps = cardProps,
		isSelectionEnabled = props.isSelectionEnabled,
		isSelected = isSelected,
		onSelectionToggled = onSelectionToggled,
		isSelectionDisabled = props.isSelectionDisabled,
		checkboxSize = props.checkboxSize,
		LayoutOrder = props.LayoutOrder
	}
end

return useSelectableRowViewModel
