local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Foundation = require(InExperienceShopParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local ShopItemTile = require(InExperienceShop.Components.ShopItemTile)
local computeShopRowTileWidths = require(InExperienceShop.Components.computeShopRowTileWidths)

require(InExperienceShop.Types)

local computeShopRowTileWidths2 = computeShopRowTileWidths.computeShopRowTileWidths

local function defaultRenderTile(p1, n1: number, _: number, t1: {[any]: any}?, p2: ((...any) -> ...any)?, s1: string?) -- line: 39
	-- upvalues: React (copy), ShopItemTile (copy)
	local v20 = if not t1 then nil else t1.gridPositionRow

	return React.createElement(ShopItemTile, {
		itemId = p1.id,
		itemType = p1.itemType,
		name = p1.name,
		thumbnail = p1.thumbnail,
		price = p1.price,
		universeId = p1.universeId,
		categoryId = s1,
		gridPositionRow = v20,
		gridPositionColumn = n1,
		onItemActivated = p2,
		LayoutOrder = n1
	})
end
local function buildTileLayoutContext(t2: {[any]: any}, n3: number, n4: number, n5: number, n6: number?, p3: ((...any) -> ...any)) -- line: 64
	-- upvalues: computeShopRowTileWidths2 (copy)
	local v27 = false

	for v28, v29 in t2 do
		if p3(v29, v28) then
			v27 = true

			break
		end
	end

	local v30 = computeShopRowTileWidths2(n4, n5, n3, v27)

	return {
		rowWidth = n4,
		gap = n5,
		shopWidth = v30.shopWidth,
		featuredRobuxWidth = v30.featuredRobuxWidth,
		gridPositionRow = n6,
		isFeaturedDoubleWidthRobux = p3
	}
end
local function makeChildKey(p4) -- line: 98
	return "Item:" .. tostring(p4.itemType) .. ":" .. p4.id
end
local function ItemRow(t3: {[any]: any}) -- line: 102
	-- upvalues: useTokens (copy), React (copy), buildTileLayoutContext (copy), defaultRenderTile (copy), View (copy)
	local Medium = useTokens().Gap.Medium
	local v34, v35 = React.useState(0)
	local v36 = React.useCallback(function(p5) -- line: 107
		-- upvalues: v35 (copy)
		local AbsoluteSizeX = p5.AbsoluteSize.X

		if AbsoluteSizeX == 0 then
			return
		end

		v35(AbsoluteSizeX)
	end, {})
	local v37 = t3.isFeaturedDoubleWidthRobux or function(_, _: number) -- line: 116
		return false
	end
	local v38 = React.useMemo(function() -- line: 120
		-- upvalues: buildTileLayoutContext (copy), t3 (copy), v34 (copy), Medium (copy), v37 (copy)
		return (buildTileLayoutContext(t3.items, t3.columnCount, v34, Medium, t3.rowIndex, v37))
	end, {
		t3.items,
		t3.columnCount,
		v34,
		Medium,
		t3.rowIndex,
		v37
	})
	local v39 = t3.renderTile ~= nil and v34 > 0
	local t4 = {}

	for v41, v42 in t3.items do
		local v43 = "Item:" .. tostring(v42.itemType) .. ":" .. v42.id

		if t3.renderTile then
			t4[v43] = t3.renderTile(v42, v41, v38)
		else
			t4[v43] = defaultRenderTile(v42, v41, t3.columnCount, v38, t3.onItemActivated, t3.sectionId)
		end
	end

	if not v39 then
		for i = #t3.items + 1, t3.columnCount do
			t4["Filler" .. i] = React.createElement(View, {
				tag = "size-full-0",
				LayoutOrder = i
			})
		end
	end

	return React.createElement(View, {
		tag = "row flex-x-fill gap-medium size-full-0 auto-y",
		LayoutOrder = t3.LayoutOrder,
		onAbsoluteSizeChanged = v36
	}, t4)
end

return React.memo(ItemRow)
