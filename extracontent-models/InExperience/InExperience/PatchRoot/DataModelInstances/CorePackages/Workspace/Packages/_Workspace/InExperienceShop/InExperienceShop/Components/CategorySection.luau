local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local View = require(InExperienceShopParent.Foundation).View
local SectionTitle = require(InExperienceShop.Components.SectionTitle)
local ItemGrid = require(InExperienceShop.Components.ItemGrid)
local ShopItemTile = require(InExperienceShop.Components.ShopItemTile)
local RobuxPackageTileContainer = require(InExperienceShop.Components.RobuxPackageTileContainer)

require(InExperienceShop.Components.ItemRow)

local Constants = require(InExperienceShop.Constants)
local computeRobuxPackageMediaHeightScale = require(InExperienceShop.Components.computeShopRowTileWidths).computeRobuxPackageMediaHeightScale
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)
local FFlagPassShopPurchaseSurfaceToBuyModal = require(InExperienceShopParent.SharedFlags).FFlagPassShopPurchaseSurfaceToBuyModal
local v13 = if not FFlagEnableInExperienceShopUnifiedLogging then nil else require(InExperienceShop.Analytics)
local v14 = if not v13 then nil else v13.Constants.ShopPageType
local v15 = if not FFlagPassShopPurchaseSurfaceToBuyModal then nil else require(InExperienceShop.Analytics.Constants).ShopPageType
local useShopImpressionsDetector = require(InExperienceShop.Hooks.useShopImpressionsDetector)

require(InExperienceShop.Types)

local function shopItemTileFlexItem(n1: number) -- line: 52
	return {
		ShrinkRatio = 1,
		FlexMode = Enum.UIFlexMode.Custom,
		GrowRatio = n1,
		ItemLineAlignment = Enum.ItemLineAlignment.Stretch
	}
end
local function explicitWidthFlexItem() -- line: 61
	return {
		GrowRatio = 0,
		ShrinkRatio = 0,
		FlexMode = Enum.UIFlexMode.None,
		ItemLineAlignment = Enum.ItemLineAlignment.Stretch
	}
end
local function resolveTileWidth(p1, n2: number, p2) -- line: 70
	if p2 == nil or p2.rowWidth <= 0 then
		return nil
	end

	if p2.isFeaturedDoubleWidthRobux(p1, n2) and p2.featuredRobuxWidth ~= nil then
		return p2.featuredRobuxWidth
	end

	return p2.shopWidth
end
local function resolveRobuxMediaHeightScale(p3) -- line: 82
	-- upvalues: computeRobuxPackageMediaHeightScale (copy)
	if p3 == nil or p3.shopWidth <= 0 then
		return nil
	end

	return computeRobuxPackageMediaHeightScale(p3.shopWidth, p3.gap)
end
local function tileWrapperProps(n3: number?, n4: number) -- line: 90
	if n3 ~= nil and n3 > 0 then
		return {
			tag = "size-full-0 auto-y",
			Size = UDim2.fromOffset(n3, 0),
			flexItem = {
				GrowRatio = 0,
				ShrinkRatio = 0,
				FlexMode = Enum.UIFlexMode.None,
				ItemLineAlignment = Enum.ItemLineAlignment.Stretch
			}
		}
	end

	return {
		tag = "size-full-0 auto-y",
		Size = UDim2.fromOffset(0, 0),
		flexItem = {
			ShrinkRatio = 1,
			FlexMode = Enum.UIFlexMode.Custom,
			GrowRatio = n4,
			ItemLineAlignment = Enum.ItemLineAlignment.Stretch
		}
	}
end
local function shopItemFromRobuxPackage(p4) -- line: 106
	return {
		id = p4.id,
		name = tostring(p4.robuxAmount),
		thumbnail = p4.robuxImage
	}
end
local function getTileLoggingProps(n5: number, p5, s1: string) -- line: 114
	local v36 = if not p5 then nil else p5.gridPositionRow

	return {
		categoryId = s1,
		gridPositionRow = v36,
		gridPositionColumn = n5
	}
end
local function CategorySection(t1: {[any]: any}) -- line: 132
	-- upvalues: useShopImpressionsDetector (copy), v14 (copy), React (copy), Constants (copy), tileWrapperProps (copy), View (copy), RobuxPackageTileContainer (copy), computeRobuxPackageMediaHeightScale (copy), ShopItemTile (copy), v15 (copy), SectionTitle (copy), ItemGrid (copy), FFlagEnableInExperienceShopUnifiedLogging (copy)
	local v38 = t1.robuxPackages ~= nil and #t1.robuxPackages > 0
	local featuredRobuxPackage = t1.featuredRobuxPackage
	local v40 = featuredRobuxPackage ~= nil
	local onItemActivated = t1.onItemActivated
	local v42 = t1.isPageVisible ~= false
	local v43 = useShopImpressionsDetector({
		pageType = not v14 and "" or v14.Home,
		isPageActive = v42,
		externalScrollSignal = t1.scrollImpressionsSignal
	})
	local v44 = React.useMemo(function() -- line: 148
		-- upvalues: v38 (copy), t1 (copy), Constants (copy)
		if v38 then
			local robuxPackages = t1.robuxPackages
			local v50 = math.floor(t1.itemsPerRow / 2)
			local v51 = math.min(#robuxPackages, Constants.ITEMS_PER_SECTION, v50)
			local t2 = table.create(v51)

			for i = 1, v51 do
				local v54 = robuxPackages[i]

				t2[i] = {
					id = v54.id,
					name = tostring(v54.robuxAmount),
					thumbnail = v54.robuxImage
				}
			end

			return t2
		end

		if t1.featuredRobuxPackage ~= nil then
			local v55 = math.max(t1.itemsPerRow - 2, 0)
			local v56 = math.min(#t1.items, Constants.ITEMS_PER_SECTION, v55)
			local t3 = table.create(v56 + 1)
			local featuredRobuxPackage2 = t1.featuredRobuxPackage

			t3[1] = {
				id = featuredRobuxPackage2.id,
				name = tostring(featuredRobuxPackage2.robuxAmount),
				thumbnail = featuredRobuxPackage2.robuxImage
			}

			for i = 1, v56 do
				t3[i + 1] = t1.items[i]
			end

			return t3
		end

		local v60 = math.min(#t1.items, Constants.ITEMS_PER_SECTION, t1.itemsPerRow)

		return table.move(t1.items, 1, v60, 1, {})
	end, {
		t1.items,
		t1.robuxPackages,
		t1.featuredRobuxPackage,
		t1.itemsPerRow,
		v38,
		v40
	})
	local v45 = React.useMemo(function() -- line: 189
		-- upvalues: v38 (copy), t1 (copy)
		if v38 then
			local t4 = {}

			for _, v63 in t1.robuxPackages do
				t4[v63.id] = v63
			end

			return t4
		end

		if t1.featuredRobuxPackage ~= nil then
			local featuredRobuxPackage3 = t1.featuredRobuxPackage

			return {
				[featuredRobuxPackage3.id] = featuredRobuxPackage3
			}
		end

		return nil
	end, {
		t1.robuxPackages,
		t1.featuredRobuxPackage,
		v38
	})
	local v46 = React.useCallback(function(p6, n6: number, p7) -- line: 207
		-- upvalues: t1 (copy), v45 (copy), v38 (copy), v40 (copy), tileWrapperProps (copy), React (copy), View (copy), RobuxPackageTileContainer (copy), onItemActivated (copy), computeRobuxPackageMediaHeightScale (copy), ShopItemTile (copy), onItemActivated (copy), v15 (copy)
		local sectionId = t1.sectionId
		local v69 = if not p7 then nil else p7.gridPositionRow
		local t5 = {
			categoryId = sectionId,
			gridPositionRow = v69,
			gridPositionColumn = n6
		}
		local v71 = if v45 == nil then nil else v45[p6.id]

		if v71 ~= nil then
			local v72 = not (v38 or v40 and n6 == 1) and 1 or 2
			local v73 = tileWrapperProps(if p7 ~= nil and not (p7.rowWidth <= 0) then if not p7.isFeaturedDoubleWidthRobux(p6, n6) or p7.featuredRobuxWidth == nil then p7.shopWidth else p7.featuredRobuxWidth else nil, v72)

			return React.createElement(View, {
				tag = v73.tag,
				Size = v73.Size,
				flexItem = v73.flexItem,
				LayoutOrder = n6
			}, {
				Tile = React.createElement(RobuxPackageTileContainer, {
					pkg = v71,
					paymentSessionId = t1.paymentSessionId,
					onBonusItemActivated = onItemActivated,
					mediaHeightScale = if p7 ~= nil and not (p7.shopWidth <= 0) then computeRobuxPackageMediaHeightScale(p7.shopWidth, p7.gap) else nil,
					categoryId = t5.categoryId,
					gridPositionRow = t5.gridPositionRow,
					gridPositionColumn = t5.gridPositionColumn
				})
			})
		end

		local v74 = tileWrapperProps(if p7 ~= nil and not (p7.rowWidth <= 0) then if not p7.isFeaturedDoubleWidthRobux(p6, n6) or p7.featuredRobuxWidth == nil then p7.shopWidth else p7.featuredRobuxWidth else nil, 1)

		return React.createElement(View, {
			tag = v74.tag,
			Size = v74.Size,
			flexItem = v74.flexItem,
			LayoutOrder = n6
		}, {
			Tile = React.createElement(ShopItemTile, {
				itemId = p6.id,
				itemType = p6.itemType,
				name = p6.name,
				thumbnail = p6.thumbnail,
				price = p6.price,
				universeId = p6.universeId,
				categoryId = t5.categoryId,
				gridPositionRow = t5.gridPositionRow,
				gridPositionColumn = t5.gridPositionColumn,
				onItemActivated = onItemActivated,
				shopPageType = if not v15 then nil else v15.Home
			})
		})
	end, {
		v45,
		onItemActivated,
		onItemActivated,
		v38,
		v40,
		t1.paymentSessionId,
		t1.sectionId
	})
	local v47 = React.useMemo(function() -- line: 269
		-- upvalues: v38 (copy), v40 (copy), featuredRobuxPackage (copy)
		if v38 then
			return function(_, _: number) -- line: 271
				return true
			end
		end

		if not v40 then
			return nil
		end

		local id = featuredRobuxPackage.id

		return function(p9, n8: number) -- line: 281
			-- upvalues: id (copy)
			return n8 == 1 and p9.id == id
		end
	end, {
		v38,
		v40,
		featuredRobuxPackage
	})
	local v48 = React.useCallback(function() -- line: 286
		-- upvalues: t1 (copy)
		if t1.onCategoryActivated then
			t1.onCategoryActivated(t1.sectionId)
		end
	end, {
		t1.sectionId,
		t1.onCategoryActivated
	})

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-bottom-xlarge",
		LayoutOrder = t1.LayoutOrder
	}, {
		Title = React.createElement(SectionTitle, {
			LayoutOrder = 1,
			title = t1.title,
			onActivated = if not t1.onCategoryActivated then nil else v48
		}),
		Grid = React.createElement(ItemGrid, {
			LayoutOrder = 2,
			items = v44,
			itemsPerRow = t1.itemsPerRow,
			sectionId = t1.sectionId,
			onItemActivated = onItemActivated,
			renderTile = if not FFlagEnableInExperienceShopUnifiedLogging then if v45 == nil then nil else v46 else v46,
			isFeaturedDoubleWidthRobux = v47,
			gridRef = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v43.gridRef,
			onGridLayoutChange = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v43.onLayoutChange
		}),
		ImpressionsDetector = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v43.impressionsDetector
	})
end

return React.memo(CategorySection)
