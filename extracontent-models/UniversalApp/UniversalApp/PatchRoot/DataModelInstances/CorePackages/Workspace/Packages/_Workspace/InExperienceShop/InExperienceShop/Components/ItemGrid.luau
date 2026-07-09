local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local View = require(InExperienceShopParent.Foundation).View
local ItemRow = require(InExperienceShop.Components.ItemRow)
local buildItemGridRows = require(InExperienceShop.Components.buildItemGridRows).buildItemGridRows

require(InExperienceShop.Types)

local function ItemGrid(t1: {[any]: any}) -- line: 32
	-- upvalues: React (copy), buildItemGridRows (copy), ItemRow (copy), View (copy)
	local itemsPerRow = t1.itemsPerRow
	local v10 = t1.gap or "gap-medium"
	local v11 = React.useMemo(function() -- line: 36
		-- upvalues: buildItemGridRows (copy), t1 (copy), itemsPerRow (copy)
		return buildItemGridRows(t1.items, itemsPerRow, t1.isFeaturedDoubleWidthRobux)
	end, {
		t1.items,
		itemsPerRow,
		t1.isFeaturedDoubleWidthRobux
	})
	local v12 = React.useMemo(function() -- line: 41
		-- upvalues: v11 (copy), React (copy), ItemRow (copy), itemsPerRow (copy), t1 (copy)
		local t2 = {}

		for v15, v16 in v11 do
			t2["Row" .. v15] = React.createElement(ItemRow, {
				items = v16,
				columnCount = itemsPerRow,
				sectionId = t1.sectionId,
				rowIndex = v15,
				onItemActivated = t1.onItemActivated,
				renderTile = t1.renderTile,
				isFeaturedDoubleWidthRobux = t1.isFeaturedDoubleWidthRobux,
				LayoutOrder = v15
			})
		end

		return t2
	end, {
		v11,
		itemsPerRow,
		t1.sectionId,
		t1.onItemActivated,
		t1.renderTile,
		t1.isFeaturedDoubleWidthRobux
	})
	local v13 = React.useCallback(function() -- line: 67
		-- upvalues: t1 (copy)
		if t1.onGridLayoutChange then
			t1.onGridLayoutChange()
		end
	end, { t1.onGridLayoutChange })

	return React.createElement(View, {
		tag = `col size-full-0 auto-y { v10 }`,
		LayoutOrder = t1.LayoutOrder,
		ref = t1.gridRef,
		onAbsoluteSizeChanged = if t1.onGridLayoutChange == nil then nil else v13
	}, v12)
end

return ItemGrid
