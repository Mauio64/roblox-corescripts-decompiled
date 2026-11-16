local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local ItemRow = require(InExperienceShop.Components.ItemRow)
local buildItemGridRows = require(InExperienceShop.Components.buildItemGridRows)
local buildItemGridRows2 = buildItemGridRows.buildItemGridRows

require(InExperienceShop.Types)

local function ItemGrid(props)
	local itemsPerRow = props.itemsPerRow
	local gap = props.gap or "gap-medium"

	local v = React.useMemo(function()
		return buildItemGridRows2(props.items, itemsPerRow, props.isFeaturedDoubleWidthRobux)
	end, { props.items, itemsPerRow, props.isFeaturedDoubleWidthRobux })

	local v2 = React.useMemo(function()
		local children = {}

		for k, items in v do
			children["Row" .. k] = React.createElement(ItemRow, {
				items = items,
				columnCount = itemsPerRow,
				sectionId = props.sectionId,
				rowIndex = k,
				onItemActivated = props.onItemActivated,
				renderTile = props.renderTile,
				isFeaturedDoubleWidthRobux = props.isFeaturedDoubleWidthRobux,
				LayoutOrder = k
			})
		end

		return children
	end, {
		v,
		itemsPerRow,
		props.sectionId,
		props.onItemActivated,
		props.renderTile,
		props.isFeaturedDoubleWidthRobux
	})

	local onAbsoluteSizeChanged = React.useCallback(function()
		if props.onGridLayoutChange then
			props.onGridLayoutChange()
		end
	end, { props.onGridLayoutChange })

	local createElement = React.createElement
	local v3 = {
		tag = `col size-full-0 auto-y {gap}`,
		LayoutOrder = props.LayoutOrder,
		ref = props.gridRef,
		onAbsoluteSizeChanged = 0
	}

	if props.onGridLayoutChange == nil then
		onAbsoluteSizeChanged = nil
	end

	v3.onAbsoluteSizeChanged = onAbsoluteSizeChanged
	return createElement(View, v3, v2)
end

return ItemGrid
