local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.AvatarExperienceModel)

require(AvatarExperienceInspectAndBuy.Types)
require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
require(AvatarExperienceInspectAndBuy.Utils.getPriceLineContent)
local SelectableCardRowContainer = require(AvatarExperienceInspectAndBuy.Components.Common.SelectableItemCardRow.SelectableCardRowContainer)

local v = { isShopContext = true }

local function SelectableItemCardList(props)
	local rows = props.rows
	local priceStatusLabels = props.priceStatusLabels
	local itemSubTypeLabels = props.itemSubTypeLabels
	local itemCardWidth = props.itemCardWidth
	local onSelectionChanged = props.onSelectionChanged
	local priceOptions = props.priceOptions or v

	local v2 = React.useMemo(function()
		local children = {}

		for k, row in rows do
			local isEquipped = row.isEquipped
			local v2

			if not (itemSubTypeLabels == nil or row.itemData.itemType == nil) then
				v2 = itemSubTypeLabels[row.itemData.itemType]
			end

			local v3 = {
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
			local itemSubTypeLabel

			if not (v2 == nil or row.itemData.itemSubType == nil) then
				itemSubTypeLabel = v2[tostring(row.itemData.itemSubType)]
			end

			v3.itemSubTypeLabel = itemSubTypeLabel

			v3.LayoutOrder = k
			v3.itemCardWidth = itemCardWidth

			v3.isSelected = isEquipped
			v3.onSelectionChanged = onSelectionChanged
			function v3.onItemCardActivated(p)
				onSelectionChanged(p, not isEquipped)
			end
			v3.priceOptions = priceOptions
			local v4

			if row.itemData and row.itemData.id ~= nil and row.itemData.itemType ~= nil then
				v4 = "Row_" .. tostring(row.itemData.id) .. "-" .. tostring(row.itemData.itemType)
			else
				v4 = "Row_" .. tostring(k)
			end

			children[v4] = React.createElement(SelectableCardRowContainer, v3)
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
		v2
	)
end

return SelectableItemCardList
