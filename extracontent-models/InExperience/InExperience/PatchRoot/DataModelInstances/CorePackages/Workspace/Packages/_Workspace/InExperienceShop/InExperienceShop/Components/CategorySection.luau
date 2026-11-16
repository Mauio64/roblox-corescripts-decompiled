local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local SectionTitle = require(InExperienceShop.Components.SectionTitle)
local ItemGrid = require(InExperienceShop.Components.ItemGrid)
local ShopItemTile = require(InExperienceShop.Components.ShopItemTile)
local RobuxPackageTileContainer = require(InExperienceShop.Components.RobuxPackageTileContainer)
require(InExperienceShop.Components.ItemRow)
local Constants = require(InExperienceShop.Constants)
local computeShopRowTileWidths = require(InExperienceShop.Components.computeShopRowTileWidths)
local computeRobuxPackageMediaHeightScale = computeShopRowTileWidths.computeRobuxPackageMediaHeightScale
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)
local FFlagEnableCategoryLoggingInShop = require(InExperienceShop.Flags.FFlagEnableCategoryLoggingInShop)
local SharedFlags = require(parent.SharedFlags)
local FFlagPassShopPurchaseSurfaceToBuyModal = SharedFlags.FFlagPassShopPurchaseSurfaceToBuyModal
local Analytics

if FFlagEnableInExperienceShopUnifiedLogging then
	Analytics = require(InExperienceShop.Analytics)
end

local shopPageType

if Analytics then
	shopPageType = Analytics.Constants.ShopPageType
else
	shopPageType = nil
end

local shopPageType2

if FFlagPassShopPurchaseSurfaceToBuyModal then
	local Constants2 = require(InExperienceShop.Analytics.Constants)
	shopPageType2 = Constants2.ShopPageType
else
	shopPageType2 = nil
end

local useShopImpressionsDetector = require(InExperienceShop.Hooks.useShopImpressionsDetector)

require(InExperienceShop.Types)

local function shopItemTileFlexItem(growRatio: number) -- 1 equivalent call inferred from this helper
	return {
		FlexMode = Enum.UIFlexMode.Custom,
		GrowRatio = growRatio,
		ShrinkRatio = 1,
		ItemLineAlignment = Enum.ItemLineAlignment.Stretch
	}
end

local function explicitWidthFlexItem() -- 1 equivalent call inferred from this helper
	return {
		FlexMode = Enum.UIFlexMode.None,
		GrowRatio = 0,
		ShrinkRatio = 0,
		ItemLineAlignment = Enum.ItemLineAlignment.Stretch
	}
end

local function resolveTileWidth(props, p: number, data) -- 2 equivalent calls inferred from this helper
	if data == nil or data.rowWidth <= 0 then
		return nil
	end

	if data.isFeaturedDoubleWidthRobux(props, p) and data.featuredRobuxWidth ~= nil then
		return data.featuredRobuxWidth
	end

	return data.shopWidth
end

local function resolveRobuxMediaHeightScale(data) -- 1 equivalent call inferred from this helper
	if data == nil or data.shopWidth <= 0 then
		return nil
	end

	return computeRobuxPackageMediaHeightScale(data.shopWidth, data.gap)
end

local function tileWrapperProps(p: number?, growRatio: number)
	if p == nil or not (p > 0) then
		return {
			tag = "size-full-0 auto-y",
			Size = UDim2.fromOffset(0, 0),
			flexItem = shopItemTileFlexItem(growRatio) -- inferred equivalent call
		}
	end

	return {
		tag = "size-full-0 auto-y",
		Size = UDim2.fromOffset(p, 0),
		flexItem = explicitWidthFlexItem() -- inferred equivalent call
	}
end

local function shopItemFromRobuxPackage(data) -- 2 equivalent calls inferred from this helper
	return { id = data.id, name = tostring(data.robuxAmount), thumbnail = data.robuxImage }
end

local function getTileLoggingProps(gridPositionColumn: number, data, sectionId: string, categoryType: string?, stableCategoryId: string?, categoryGroup: string?, categoryName: string?) -- 1 equivalent call inferred from this helper
	local gridPositionRow

	if data then
		gridPositionRow = data.gridPositionRow
	end

	return {
		categoryId = sectionId,
		categoryType = categoryType,
		stableCategoryId = stableCategoryId,
		categoryGroup = categoryGroup,
		categoryName = categoryName,
		gridPositionRow = gridPositionRow,
		gridPositionColumn = gridPositionColumn
	}
end

local function CategorySection(props)
	local v

	if props.robuxPackages == nil then
		v = false
	else
		v = #props.robuxPackages > 0
	end

	local featuredRobuxPackage = props.featuredRobuxPackage
	local v2 = featuredRobuxPackage ~= nil
	local onItemActivated = props.onItemActivated

	local isPageVisible = props.isPageVisible ~= false

	local v3 = useShopImpressionsDetector({
		pageType = not shopPageType and "" or shopPageType.Home,
		isPageActive = isPageVisible,
		externalScrollSignal = props.scrollImpressionsSignal
	})

	local items = React.useMemo(function()
		if v then
			local robuxPackages = props.robuxPackages

			local v4 = math.floor(props.itemsPerRow / 2)
			local v5 = math.min(#robuxPackages, Constants.ITEMS_PER_SECTION, v4)
			local result = table.create(v5)

			for i = 1, v5 do
				result[i] = shopItemFromRobuxPackage(robuxPackages[i]) -- inferred equivalent call
			end

			return result
		else
			if props.featuredRobuxPackage == nil then
				local v4 = math.min(#props.items, Constants.ITEMS_PER_SECTION, props.itemsPerRow)
				return table.move(props.items, 1, v4, 1, {})
			end

			local v4 = math.max(props.itemsPerRow - 2, 0)
			local v5 = math.min(#props.items, Constants.ITEMS_PER_SECTION, v4)
			local result = table.create(v5 + 1)
			result[1] = shopItemFromRobuxPackage(props.featuredRobuxPackage) -- inferred equivalent call

			for i = 1, v5 do
				result[i + 1] = props.items[i]
			end

			return result
		end
	end, { props.items, props.robuxPackages, props.featuredRobuxPackage, props.itemsPerRow, v, v2 })

	local v4 = React.useMemo(function()
		if v then
			local robuxPackagesById = {}

			for _, robuxPackage in props.robuxPackages do
				robuxPackagesById[robuxPackage.id] = robuxPackage
			end

			return robuxPackagesById
		else
			if props.featuredRobuxPackage == nil then
				return nil
			end

			local featuredRobuxPackage2 = props.featuredRobuxPackage
			return { [featuredRobuxPackage2.id] = featuredRobuxPackage2 }
		end
	end, { props.robuxPackages, props.featuredRobuxPackage, v })

	local renderTile = React.useCallback(function(props2, layoutOrder: number, data)
		local sectionId = props.sectionId
		local categoryType

		if FFlagEnableCategoryLoggingInShop then
			categoryType = props.categoryType
		end

		local stableCategoryId

		if FFlagEnableCategoryLoggingInShop then
			stableCategoryId = props.stableCategoryId
		end

		local categoryGroup

		if FFlagEnableCategoryLoggingInShop then
			categoryGroup = props.categoryGroup
		end

		local v5

		if FFlagEnableCategoryLoggingInShop then
			v5 = props.categoryName
		end

		local tileLoggingProps = getTileLoggingProps( -- inferred equivalent call
			layoutOrder,
			data,
			sectionId,
			categoryType,
			stableCategoryId,
			categoryGroup,
			v5
		)
		local pkg

		if v4 ~= nil then
			pkg = v4[props2.id]
		end

		if pkg == nil then
			local v6 = tileWrapperProps(resolveTileWidth(props2, layoutOrder, data), 1) -- inferred equivalent call

			local createElement = React.createElement
			local v7 = {
				tag = v6.tag,
				Size = v6.Size,
				flexItem = v6.flexItem,
				LayoutOrder = layoutOrder
			}

			local createElement2 = React.createElement
			local v8 = {
				itemId = props2.id,
				itemType = props2.itemType,
				name = props2.name,
				thumbnail = props2.thumbnail,
				price = props2.price,
				userBasePriceInRobux = props2.userBasePriceInRobux,
				universeId = props2.universeId,
				categoryId = tileLoggingProps.categoryId,
				categoryType = tileLoggingProps.categoryType,
				stableCategoryId = tileLoggingProps.stableCategoryId,
				categoryGroup = tileLoggingProps.categoryGroup,
				categoryName = tileLoggingProps.categoryName,
				gridPositionRow = tileLoggingProps.gridPositionRow,
				gridPositionColumn = tileLoggingProps.gridPositionColumn,
				onItemActivated = onItemActivated,
				shopPageType = 0
			}
			local shopPageType3

			if shopPageType2 then
				shopPageType3 = shopPageType2.Home
			end

			v8.shopPageType = shopPageType3
			return createElement(View, v7, {
				Tile = createElement2(ShopItemTile, v8)
			})
		else
			local growRatio = (v or v2 and layoutOrder == 1) and 2 or 1
			local v6 = tileWrapperProps(resolveTileWidth(props2, layoutOrder, data), growRatio) -- inferred equivalent call

			local createElement = React.createElement
			local v7 = {
				tag = v6.tag,
				Size = v6.Size,
				flexItem = v6.flexItem,
				LayoutOrder = layoutOrder
			}

			local createElement2 = React.createElement
			local v8 = {
				pkg = pkg,
				paymentSessionId = props.paymentSessionId,
				bonusJwt = props.bonusJwt,
				onBonusItemActivated = onItemActivated,
				mediaHeightScale = resolveRobuxMediaHeightScale(data), -- inferred equivalent call
				categoryId = tileLoggingProps.categoryId,
				categoryType = props.categoryType,
				stableCategoryId = tileLoggingProps.stableCategoryId,
				categoryGroup = tileLoggingProps.categoryGroup,
				categoryName = tileLoggingProps.categoryName,
				gridPositionRow = tileLoggingProps.gridPositionRow,
				gridPositionColumn = tileLoggingProps.gridPositionColumn,
				shopPageType = 0
			}
			local shopPageType3

			if shopPageType then
				shopPageType3 = shopPageType.Home
			end

			v8.shopPageType = shopPageType3
			return createElement(View, v7, {
				Tile = createElement2(RobuxPackageTileContainer, v8)
			})
		end
	end, {
		v4,
		onItemActivated,
		onItemActivated,
		v,
		v2,
		props.paymentSessionId,
		props.bonusJwt,
		props.sectionId,
		props.categoryType,
		props.stableCategoryId,
		props.categoryGroup,
		props.categoryName
	})

	local isFeaturedDoubleWidthRobux = React.useMemo(function()
		if v then
			return function(_, _: number): boolean
				return true
			end
		end

		if not v2 then
			return nil
		end

		local id = featuredRobuxPackage.id
		return function(p, p2: number): boolean
			return p2 == 1 and p.id == id
		end
	end, { v, v2, featuredRobuxPackage })

	local onActivated = React.useCallback(function()
		if props.onCategoryActivated then
			props.onCategoryActivated(props.sectionId)
		end
	end, { props.sectionId, props.onCategoryActivated })

	local createElement = React.createElement
	local v5 = {
		tag = "col gap-medium size-full-0 auto-y padding-bottom-xlarge",
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local v6 = { title = props.title, onActivated = 0, LayoutOrder = 1 }

	if not props.onCategoryActivated then
		onActivated = nil
	end

	v6.onActivated = onActivated
	local children = {
		Title = createElement2(SectionTitle, v6),
		Grid = 0,
		ImpressionsDetector = 0
	}

	local createElement3 = React.createElement
	local v7 = {
		items = items,
		itemsPerRow = props.itemsPerRow,
		sectionId = props.sectionId,
		onItemActivated = onItemActivated,
		renderTile = 0,
		isFeaturedDoubleWidthRobux = 0,
		gridRef = 0,
		onGridLayoutChange = 0,
		LayoutOrder = 2
	}

	if not FFlagEnableInExperienceShopUnifiedLogging and v4 == nil then
		renderTile = nil
	end

	v7.renderTile = renderTile

	v7.isFeaturedDoubleWidthRobux = isFeaturedDoubleWidthRobux
	local gridRef

	if FFlagEnableInExperienceShopUnifiedLogging then
		gridRef = v3.gridRef
	end

	v7.gridRef = gridRef
	local onGridLayoutChange

	if FFlagEnableInExperienceShopUnifiedLogging then
		onGridLayoutChange = v3.onLayoutChange
	end

	v7.onGridLayoutChange = onGridLayoutChange
	children.Grid = createElement3(ItemGrid, v7)
	local impressionsDetector

	if FFlagEnableInExperienceShopUnifiedLogging then
		impressionsDetector = v3.impressionsDetector
	end

	children.ImpressionsDetector = impressionsDetector
	return createElement(View, v5, children)
end

return React.memo(CategorySection)
