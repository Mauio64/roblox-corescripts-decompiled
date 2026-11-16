local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local ShopItemTile = require(InExperienceShop.Components.ShopItemTile)
local RobuxPackageTileContainer = require(InExperienceShop.Components.RobuxPackageTileContainer)
require(InExperienceShop.Components.ItemRow)
local computeShopRowTileWidths = require(InExperienceShop.Components.computeShopRowTileWidths)
local computeRobuxPackageMediaHeightScale = computeShopRowTileWidths.computeRobuxPackageMediaHeightScale
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)
local FFlagEnableCategoryLoggingInShop = require(InExperienceShop.Flags.FFlagEnableCategoryLoggingInShop)
local FFlagEnableShopRobuxBuyTelemetry = require(InExperienceShop.Flags.FFlagEnableShopRobuxBuyTelemetry)
local FFlagShopRobuxTermsDisclosure = require(InExperienceShop.Flags.FFlagShopRobuxTermsDisclosure)
local Constants = require(InExperienceShop.Analytics.Constants)

local SharedFlags = require(parent.SharedFlags)
local FFlagPassShopPurchaseSurfaceToBuyModal = SharedFlags.FFlagPassShopPurchaseSurfaceToBuyModal

require(InExperienceShop.Types)
local findSection = require(InExperienceShop.Utils.findSection)
local shopPageType

if FFlagPassShopPurchaseSurfaceToBuyModal then
	shopPageType = Constants.ShopPageType
else
	shopPageType = nil
end

local shopPageType2

if FFlagEnableInExperienceShopUnifiedLogging then
	shopPageType2 = Constants.ShopPageType
else
	shopPageType2 = nil
end

require(script.Parent.CategoryPageView)

local v = {}

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

local function getTileLoggingProps(gridPositionColumn: number, data, sectionId: string, categoryType: string?, stableCategoryId: string?, categoryGroup: string?, name: string?) -- 1 equivalent call inferred from this helper
	local gridPositionRow

	if data then
		gridPositionRow = data.gridPositionRow
	end

	return {
		categoryId = sectionId,
		categoryType = categoryType,
		stableCategoryId = stableCategoryId,
		categoryGroup = categoryGroup,
		categoryName = name,
		gridPositionRow = gridPositionRow,
		gridPositionColumn = gridPositionColumn
	}
end

local function useCategoryPageViewModel(data)
	local v2 = React.useMemo(function()
		return findSection(data.sections, data.sectionId)
	end, { data.sections, data.sectionId })
	local v3

	if v2 == nil then
		v3 = v
	else
		v3 = v2.items
	end

	local categoryType

	if FFlagEnableCategoryLoggingInShop and v2 ~= nil then
		categoryType = v2.categoryType
	else
		categoryType = nil
	end

	local stableCategoryId

	if FFlagEnableCategoryLoggingInShop and v2 ~= nil then
		stableCategoryId = v2.stableCategoryId
	else
		stableCategoryId = nil
	end

	local categoryGroup

	if FFlagEnableCategoryLoggingInShop and v2 ~= nil then
		categoryGroup = v2.categoryGroup
	else
		categoryGroup = nil
	end

	local name

	if FFlagEnableCategoryLoggingInShop and v2 ~= nil then
		name = v2.name
	else
		name = nil
	end

	local robuxPackages

	if v2 == nil then
		robuxPackages = nil
	else
		robuxPackages = v2.robuxPackages
	end

	local featuredRobuxPackage

	if v2 == nil then
		featuredRobuxPackage = nil
	else
		featuredRobuxPackage = v2.featuredRobuxPackage
	end

	local paymentSessionId

	if v2 == nil then
		paymentSessionId = nil
	else
		paymentSessionId = v2.paymentSessionId
	end

	local bonusJwt

	if v2 == nil then
		bonusJwt = nil
	else
		bonusJwt = v2.bonusJwt
	end

	local categoryType2

	if FFlagEnableShopRobuxBuyTelemetry and v2 ~= nil then
		categoryType2 = v2.categoryType
	else
		categoryType2 = nil
	end

	local v4

	if robuxPackages == nil then
		v4 = false
	else
		v4 = #robuxPackages > 0
	end

	local v5 = featuredRobuxPackage ~= nil
	local onItemActivated = data.onItemActivated

	local items = React.useMemo(function()
		if v4 then
			local v6 = robuxPackages
			local result = table.create(#v6)

			for i = 1, #v6 do
				result[i] = shopItemFromRobuxPackage(v6[i]) -- inferred equivalent call
			end

			return result
		else
			if featuredRobuxPackage == nil then
				return v3
			end

			local result = table.create(#v3 + 1)
			result[1] = shopItemFromRobuxPackage(featuredRobuxPackage) -- inferred equivalent call

			for i = 1, #v3 do
				result[i + 1] = v3[i]
			end

			return result
		end
	end, { v3, robuxPackages, featuredRobuxPackage, v4 })

	local v6 = React.useMemo(function()
		if v4 then
			local robuxPackagesById = {}

			for _, robuxPackage in robuxPackages do
				robuxPackagesById[robuxPackage.id] = robuxPackage
			end

			return robuxPackagesById
		else
			if featuredRobuxPackage == nil then
				return nil
			end

			local v6 = featuredRobuxPackage
			return { [v6.id] = v6 }
		end
	end, { robuxPackages, featuredRobuxPackage, v4 })

	local renderTile = React.useCallback(function(props, layoutOrder: number, data2)
		local tileLoggingProps = getTileLoggingProps( -- inferred equivalent call
			layoutOrder,
			data2,
			data.sectionId,
			categoryType,
			stableCategoryId,
			categoryGroup,
			name
		)
		local pkg

		if v6 ~= nil then
			pkg = v6[props.id]
		end

		if pkg == nil then
			local v7 = tileWrapperProps(resolveTileWidth(props, layoutOrder, data2), 1) -- inferred equivalent call

			local createElement = React.createElement
			local v8 = {
				tag = v7.tag,
				Size = v7.Size,
				flexItem = v7.flexItem,
				LayoutOrder = layoutOrder
			}

			local createElement2 = React.createElement
			local v9 = {
				itemId = props.id,
				itemType = props.itemType,
				name = props.name,
				thumbnail = props.thumbnail,
				price = props.price,
				userBasePriceInRobux = props.userBasePriceInRobux,
				universeId = props.universeId,
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

			if shopPageType then
				shopPageType3 = shopPageType.Category
			end

			v9.shopPageType = shopPageType3
			return createElement(View, v8, {
				Tile = createElement2(ShopItemTile, v9)
			})
		else
			local growRatio = (v4 or v5 and layoutOrder == 1) and 2 or 1
			local v7 = tileWrapperProps(resolveTileWidth(props, layoutOrder, data2), growRatio) -- inferred equivalent call

			local createElement = React.createElement
			local v8 = {
				tag = v7.tag,
				Size = v7.Size,
				flexItem = v7.flexItem,
				LayoutOrder = layoutOrder
			}

			local createElement2 = React.createElement
			local v9 = {
				pkg = pkg,
				paymentSessionId = paymentSessionId,
				bonusJwt = bonusJwt,
				onBonusItemActivated = onItemActivated,
				mediaHeightScale = resolveRobuxMediaHeightScale(data2), -- inferred equivalent call
				categoryId = tileLoggingProps.categoryId,
				categoryType = 0,
				stableCategoryId = 0,
				categoryGroup = 0,
				categoryName = 0,
				gridPositionRow = 0,
				gridPositionColumn = 0,
				shopPageType = 0
			}
			local categoryType3

			if categoryType2 == nil then
				categoryType3 = tileLoggingProps.categoryType
			else
				categoryType3 = categoryType2
			end

			v9.categoryType = categoryType3
			v9.stableCategoryId = tileLoggingProps.stableCategoryId
			v9.categoryGroup = tileLoggingProps.categoryGroup
			v9.categoryName = tileLoggingProps.categoryName
			v9.gridPositionRow = tileLoggingProps.gridPositionRow
			v9.gridPositionColumn = tileLoggingProps.gridPositionColumn
			local shopPageType3

			if shopPageType2 then
				shopPageType3 = shopPageType2.Category
			end

			v9.shopPageType = shopPageType3
			return createElement(View, v8, {
				Tile = createElement2(RobuxPackageTileContainer, v9)
			})
		end
	end, {
		v6,
		onItemActivated,
		onItemActivated,
		v4,
		v5,
		paymentSessionId,
		bonusJwt,
		categoryType2,
		data.sectionId,
		categoryType,
		stableCategoryId,
		categoryGroup,
		name
	})

	local isFeaturedDoubleWidthRobux = React.useMemo(function()
		if v4 then
			return function(_, _: number): boolean
				return true
			end
		end

		if not v5 then
			return nil
		end

		local id = featuredRobuxPackage.id
		return function(p, p2: number): boolean
			return p2 == 1 and p.id == id
		end
	end, { v4, v5, featuredRobuxPackage })

	local v7 = {
		items = items,
		itemsPerRow = data.itemsPerRow,
		sectionId = data.sectionId,
		onItemActivated = onItemActivated,
		renderTile = 0,
		isFeaturedDoubleWidthRobux = 0,
		showRobuxTermsDisclosure = 0,
		LayoutOrder = 0
	}

	if not FFlagEnableInExperienceShopUnifiedLogging and v6 == nil then
		renderTile = nil
	end

	v7.renderTile = renderTile

	v7.isFeaturedDoubleWidthRobux = isFeaturedDoubleWidthRobux
	v7.showRobuxTermsDisclosure = FFlagShopRobuxTermsDisclosure and v4
	v7.LayoutOrder = data.LayoutOrder
	return v7
end

return useCategoryPageViewModel
