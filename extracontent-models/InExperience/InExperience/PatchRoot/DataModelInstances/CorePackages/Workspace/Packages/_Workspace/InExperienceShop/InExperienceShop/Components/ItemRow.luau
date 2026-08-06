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

local function defaultRenderTile(p1, n1: number, _: number, t1: {[any]: any}?, p2: ((...any) -> ...any)?, s1: string?, s2: string?) -- line: 40
	-- upvalues: React (copy), ShopItemTile (copy)
	local v21 = if not t1 then nil else t1.gridPositionRow

	return React.createElement(ShopItemTile, {
		itemId = p1.id,
		itemType = p1.itemType,
		name = p1.name,
		thumbnail = p1.thumbnail,
		price = p1.price,
		universeId = p1.universeId,
		categoryId = s1,
		gridPositionRow = v21,
		gridPositionColumn = n1,
		onItemActivated = p2,
		shopPageType = s2,
		LayoutOrder = n1
	})
end
local function buildTileLayoutContext(t2: {[any]: any}, n3: number, n4: number, n5: number, n6: number?, p3: ((...any) -> ...any)) -- line: 67
	-- upvalues: computeShopRowTileWidths2 (copy)
	local v28 = false

	for v29, v30 in t2 do
		if p3(v30, v29) then
			v28 = true

			break
		end
	end

	local v31 = computeShopRowTileWidths2(n4, n5, n3, v28)

	return {
		rowWidth = n4,
		gap = n5,
		shopWidth = v31.shopWidth,
		featuredRobuxWidth = v31.featuredRobuxWidth,
		gridPositionRow = n6,
		isFeaturedDoubleWidthRobux = p3
	}
end
local function makeChildKey(p4) -- line: 101
	return "Item:" .. tostring(p4.itemType) .. ":" .. p4.id
end
local function ItemRow(t3: {[any]: any}) -- line: 105
	-- upvalues: useTokens (copy), React (copy), buildTileLayoutContext (copy), defaultRenderTile (copy), View (copy)
	local Medium = useTokens().Gap.Medium
	local v35, v36 = React.useState(0)
	local v37 = React.useCallback(function(p5) -- line: 110
		-- upvalues: v36 (copy)
		local AbsoluteSizeX = p5.AbsoluteSize.X

		if AbsoluteSizeX == 0 then
			return
		end

		v36(AbsoluteSizeX)
	end, {})
	local v38 = t3.isFeaturedDoubleWidthRobux or function(_, _: number) -- line: 119
		return false
	end
	local v39 = React.useMemo(function() -- line: 123
		-- upvalues: buildTileLayoutContext (copy), t3 (copy), v35 (copy), Medium (copy), v38 (copy)
		return (buildTileLayoutContext(t3.items, t3.columnCount, v35, Medium, t3.rowIndex, v38))
	end, {
		t3.items,
		t3.columnCount,
		v35,
		Medium,
		t3.rowIndex,
		v38
	})
	local v40 = t3.renderTile ~= nil and v35 > 0
	local t4 = {}

	for v42, v43 in t3.items do
		local v44 = "Item:" .. tostring(v43.itemType) .. ":" .. v43.id

		if t3.renderTile then
			t4[v44] = t3.renderTile(v43, v42, v39)
		else
			t4[v44] = defaultRenderTile(v43, v42, t3.columnCount, v39, t3.onItemActivated, t3.sectionId, t3.shopPageType)
		end
	end

	if not v40 then
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
		onAbsoluteSizeChanged = v37
	}, t4)
end

return React.memo(ItemRow)
