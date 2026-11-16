local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceModel")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceLineContent")
local SelectableCardRowContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/SelectableItemCardRow/SelectableCardRowContainer")

local v5 = { isShopContext = true }

local function SelectableItemCardList(props)
	local rows = props.rows
	local priceStatusLabels = props.priceStatusLabels
	local itemSubTypeLabels = props.itemSubTypeLabels
	local itemCardWidth = props.itemCardWidth
	local onSelectionChanged = props.onSelectionChanged
	local priceOptions = props.priceOptions or v5

	local v6 = React.useMemo(function()
		local children = {}

		for k, row in rows do
			local isEquipped = row.isEquipped
			local v7

			if not (itemSubTypeLabels == nil or row.itemData.itemType == nil) then
				v7 = itemSubTypeLabels[row.itemData.itemType]
			end

			local v8 = {
				itemData = row.itemData,
				priceStatusLabels = priceStatusLabels,
				itemSubTypeLabel = 0,
				LayoutOrder = 0,
				itemCardWidth = 0,
				isSelectionEnabled = true,
				isSelected = 0,
				onSelectionChanged = 0,
				onItemCardActivated = 0,
				priceOptions = 0
			}

			local v9 = if v7 ~= nil and row.itemData.itemSubType ~= nil then v7[tostring(row.itemData.itemSubType)] else nil
			v8.itemSubTypeLabel = v9

			v8.LayoutOrder = k
			v8.itemCardWidth = itemCardWidth

			v8.isSelected = isEquipped
			v8.onSelectionChanged = onSelectionChanged
			function v8.onItemCardActivated(p2)
				onSelectionChanged(p2, not isEquipped)
			end
			v8.priceOptions = priceOptions
			local v10

			if row.itemData and row.itemData.id ~= nil and row.itemData.itemType ~= nil then
				v10 = "Row_" .. tostring(row.itemData.id) .. "-" .. tostring(row.itemData.itemType)
			else
				v10 = "Row_" .. tostring(k)
			end

			children[v10] = React.createElement(SelectableCardRowContainer, v8)
		end

		return children
	end, {
		rows,
		priceStatusLabels,
		itemSubTypeLabels,
		itemCardWidth,
		onSelectionChanged,
		priceOptions
	})

	return React.createElement(
		Foundation.View,
		{
			tag = "col gap-medium size-full-0 auto-y",
			testId = "SelectableItemCardList",
			LayoutOrder = props.LayoutOrder
		},
		v6
	)
end

return SelectableItemCardList
