local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local View = Foundation.View
local ShopItemTile = require(InExperienceShop.Components.ShopItemTile)
local computeShopRowTileWidths = require(InExperienceShop.Components.computeShopRowTileWidths)

require(InExperienceShop.Types)

local computeShopRowTileWidths2 = computeShopRowTileWidths.computeShopRowTileWidths

local function defaultRenderTile(props, k: number, _: number, p, onItemActivated, sectionId: string?, shopPageType: string?)
	local gridPositionRow

	if p then
		gridPositionRow = p.gridPositionRow
	end

	return React.createElement(ShopItemTile, {
		itemId = props.id,
		itemType = props.itemType,
		name = props.name,
		thumbnail = props.thumbnail,
		price = props.price,
		userBasePriceInRobux = props.userBasePriceInRobux,
		universeId = props.universeId,
		categoryId = sectionId,
		gridPositionRow = gridPositionRow,
		gridPositionColumn = k,
		onItemActivated = onItemActivated,
		shopPageType = shopPageType,
		LayoutOrder = k
	})
end

local function buildTileLayoutContext(items, columnCount: number, state: number, medium: number, rowIndex: number?, isFeaturedDoubleWidthRobux)
	local v = false

	for k, item in items do
		if isFeaturedDoubleWidthRobux(item, k) then
			v = true
			break
		end
	end

	local v2 = computeShopRowTileWidths2(state, medium, columnCount, v)

	return {
		rowWidth = state,
		gap = medium,
		shopWidth = v2.shopWidth,
		featuredRobuxWidth = v2.featuredRobuxWidth,
		gridPositionRow = rowIndex,
		isFeaturedDoubleWidthRobux = isFeaturedDoubleWidthRobux
	}
end

local function makeChildKey(item) -- 1 equivalent call inferred from this helper
	return "Item:" .. tostring(item.itemType) .. ":" .. item.id
end

local function ItemRow(props)
	local medium = useTokens().Gap.Medium
	local state, setState = React.useState(0)

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		local x = p.AbsoluteSize.X

		if x == 0 then
			return
		end

		setState(x)
	end, {})

	local isFeaturedDoubleWidthRobux = props.isFeaturedDoubleWidthRobux or function(_, _: number): boolean
		return false
	end

	local v = React.useMemo(function()
		return buildTileLayoutContext(
			props.items,
			props.columnCount,
			state,
			medium,
			props.rowIndex,
			isFeaturedDoubleWidthRobux
		)
	end, {
		props.items,
		props.columnCount,
		state,
		medium,
		props.rowIndex,
		isFeaturedDoubleWidthRobux
	})
	local v2

	if props.renderTile == nil then
		v2 = false
	else
		v2 = state > 0
	end

	local children = {}

	for k, item in props.items do
		local childKey = makeChildKey(item) -- inferred equivalent call

		if props.renderTile then
			children[childKey] = props.renderTile(item, k, v)
		else
			children[childKey] = defaultRenderTile(
				item,
				k,
				props.columnCount,
				v,
				props.onItemActivated,
				props.sectionId,
				props.shopPageType
			)
		end
	end

	if not v2 then
		for i = #props.items + 1, props.columnCount do
			children["Filler" .. i] = React.createElement(View, {
				tag = "size-full-0",
				LayoutOrder = i
			})
		end
	end

	return React.createElement(
		View,
		{
			tag = "row flex-x-fill gap-medium size-full-0 auto-y",
			LayoutOrder = props.LayoutOrder,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged
		},
		children
	)
end

return React.memo(ItemRow)
