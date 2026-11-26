local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation").Hooks.useTokens
local itemCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceUIKit").ItemCardComponents.ItemCardThumbnail

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local PriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")
local getItemThumbnailUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getItemThumbnailUrl")
local getCatalogCardItemType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getCatalogCardItemType")
local getPriceLineContent = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceLineContent")
local getPriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/SelectableItemCardRow/SelectableItemCardRowView")

local function useSelectableRowViewModel(props)
	local v5 = useTokens()
	local itemData = props.itemData
	local v6

	if props.isSelectionEnabled then
		v6 = props.itemCardWidth - (v5.Size.Size_400 + v5.Gap.Medium)
	else
		v6 = props.itemCardWidth
	end

	local v7 = React.useMemo(function(): boolean
		return getPriceStatus(itemData) == PriceStatus.Owned
	end, { itemData })

	local v8 = React.useMemo(function()
		if itemData.id == nil or itemData.itemType == nil then
			return nil
		end

		return getItemThumbnailUrl({ id = itemData.id, itemType = itemData.itemType })
	end, { itemData })

	local onItemCardActivated = props.onItemCardActivated
	local v9 = React.useCallback(function()
		onItemCardActivated(itemData)
	end, { itemData, onItemCardActivated })

	local isSelected = props.isSelected
	local onSelectionChanged = props.onSelectionChanged

	local v10 = React.useCallback(function()
		onSelectionChanged(itemData, not isSelected)
	end, { itemData, isSelected, onSelectionChanged })

	local v12 = {
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

	local v13 = if v8 then React.createElement(itemCardThumbnail, { url = v8 }) else nil
	v12.presentationSlot = v13

	v12.itemSubType = props.itemSubTypeLabel
	v12.itemType = getCatalogCardItemType(itemData.itemRestrictions)
	v12.creator = itemData.creator and {
		name = itemData.creator.creatorName or "",
		verified = itemData.creator.creatorHasVerifiedBadge
	} or nil

	v12.priceLineContent = getPriceLineContent(itemData, v5, props.priceStatusLabels, props.priceOptions)

	v12.isOwned = v7
	v12.onActivated = v9
	v12.headerSize = UDim2.fromOffset(v6, v6)
	v12.footerAutomaticSize = Enum.AutomaticSize.XY
	v12.AutomaticSize = Enum.AutomaticSize.XY
	return {
		cardProps = v12,
		isSelectionEnabled = props.isSelectionEnabled,
		isSelected = isSelected,
		onSelectionToggled = v10,
		isSelectionDisabled = props.isSelectionDisabled,
		checkboxSize = props.checkboxSize,
		LayoutOrder = props.LayoutOrder
	}
end

return useSelectableRowViewModel
