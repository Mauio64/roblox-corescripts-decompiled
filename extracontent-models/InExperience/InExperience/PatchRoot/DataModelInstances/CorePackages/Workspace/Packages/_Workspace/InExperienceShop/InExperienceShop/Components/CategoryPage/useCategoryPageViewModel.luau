local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local View = require(InExperienceShopParent.Foundation).View
local ShopItemTile = require(InExperienceShop.Components.ShopItemTile)
local RobuxPackageTileContainer = require(InExperienceShop.Components.RobuxPackageTileContainer)

require(InExperienceShop.Components.ItemRow)

local computeRobuxPackageMediaHeightScale = require(InExperienceShop.Components.computeShopRowTileWidths).computeRobuxPackageMediaHeightScale
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)
local FFlagPassShopPurchaseSurfaceToBuyModal = require(InExperienceShopParent.SharedFlags).FFlagPassShopPurchaseSurfaceToBuyModal

require(InExperienceShop.Types)

local findSection = require(InExperienceShop.Utils.findSection)
local v11 = if not FFlagPassShopPurchaseSurfaceToBuyModal then nil else require(InExperienceShop.Analytics.Constants).ShopPageType

require(script.Parent.CategoryPageView)

local t1 = {}

local function shopItemTileFlexItem(n1: number) -- line: 51
	return {
		ShrinkRatio = 1,
		FlexMode = Enum.UIFlexMode.Custom,
		GrowRatio = n1,
		ItemLineAlignment = Enum.ItemLineAlignment.Stretch
	}
end
local function explicitWidthFlexItem() -- line: 60
	return {
		GrowRatio = 0,
		ShrinkRatio = 0,
		FlexMode = Enum.UIFlexMode.None,
		ItemLineAlignment = Enum.ItemLineAlignment.Stretch
	}
end
local function resolveTileWidth(p1, n2: number, p2) -- line: 69
	if p2 == nil or p2.rowWidth <= 0 then
		return nil
	end

	if p2.isFeaturedDoubleWidthRobux(p1, n2) and p2.featuredRobuxWidth ~= nil then
		return p2.featuredRobuxWidth
	end

	return p2.shopWidth
end
local function resolveRobuxMediaHeightScale(p3) -- line: 81
	-- upvalues: computeRobuxPackageMediaHeightScale (copy)
	if p3 == nil or p3.shopWidth <= 0 then
		return nil
	end

	return computeRobuxPackageMediaHeightScale(p3.shopWidth, p3.gap)
end
local function tileWrapperProps(n3: number?, n4: number) -- line: 89
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
local function shopItemFromRobuxPackage(p4) -- line: 105
	return {
		id = p4.id,
		name = tostring(p4.robuxAmount),
		thumbnail = p4.robuxImage
	}
end
local function getTileLoggingProps(n5: number, p5, s1: string) -- line: 113
	local v32 = if not p5 then nil else p5.gridPositionRow

	return {
		categoryId = s1,
		gridPositionRow = v32,
		gridPositionColumn = n5
	}
end
local function useCategoryPageViewModel(t2: {[any]: any}) -- line: 131
	-- upvalues: React (copy), findSection (copy), t1 (copy), tileWrapperProps (copy), View (copy), RobuxPackageTileContainer (copy), computeRobuxPackageMediaHeightScale (copy), ShopItemTile (copy), v11 (copy), FFlagEnableInExperienceShopUnifiedLogging (copy)
	local v34 = React.useMemo(function() -- line: 132
		-- upvalues: findSection (copy), t2 (copy)
		return findSection(t2.sections, t2.sectionId)
	end, {
		t2.sections,
		t2.sectionId
	})
	local v35 = if v34 == nil then t1 else v34.items
	local v36 = if v34 == nil then nil else v34.robuxPackages
	local v37 = if v34 == nil then nil else v34.featuredRobuxPackage
	local v38 = if v34 == nil then nil else v34.paymentSessionId
	local v39 = v36 ~= nil and #v36 > 0
	local v40 = v37 ~= nil
	local onItemActivated = t2.onItemActivated
	local v42 = React.useMemo(function() -- line: 149
		-- upvalues: v39 (copy), v36 (copy), v37 (copy), v35 (copy)
		if v39 then
			local v46 = v36
			local t3 = table.create(#v46)

			for i = 1, #v46 do
				local v49 = v46[i]

				t3[i] = {
					id = v49.id,
					name = tostring(v49.robuxAmount),
					thumbnail = v49.robuxImage
				}
			end

			return t3
		end

		if v37 ~= nil then
			local t4 = table.create(#v35 + 1)
			local v51 = v37

			t4[1] = {
				id = v51.id,
				name = tostring(v51.robuxAmount),
				thumbnail = v51.robuxImage
			}

			for i = 1, #v35 do
				t4[i + 1] = v35[i]
			end

			return t4
		end

		return v35
	end, {
		v35,
		v36,
		v37,
		v39
	})
	local v43 = React.useMemo(function() -- line: 171
		-- upvalues: v39 (copy), v36 (copy), v37 (copy)
		if v39 then
			local t5 = {}

			for _, v55 in v36 do
				t5[v55.id] = v55
			end

			return t5
		end

		if v37 ~= nil then
			local v56 = v37

			return {
				[v56.id] = v56
			}
		end

		return nil
	end, {
		v36,
		v37,
		v39
	})
	local v44 = React.useCallback(function(p6, n6: number, p7) -- line: 189
		-- upvalues: t2 (copy), v43 (copy), v39 (copy), v40 (copy), tileWrapperProps (copy), React (copy), View (copy), RobuxPackageTileContainer (copy), v38 (copy), onItemActivated (copy), computeRobuxPackageMediaHeightScale (copy), ShopItemTile (copy), onItemActivated (copy), v11 (copy)
		local sectionId = t2.sectionId
		local v61 = if not p7 then nil else p7.gridPositionRow
		local t6 = {
			categoryId = sectionId,
			gridPositionRow = v61,
			gridPositionColumn = n6
		}
		local v63 = if v43 == nil then nil else v43[p6.id]

		if v63 ~= nil then
			local v64 = not (v39 or v40 and n6 == 1) and 1 or 2
			local v65 = tileWrapperProps(if p7 ~= nil and not (p7.rowWidth <= 0) then if not p7.isFeaturedDoubleWidthRobux(p6, n6) or p7.featuredRobuxWidth == nil then p7.shopWidth else p7.featuredRobuxWidth else nil, v64)

			return React.createElement(View, {
				tag = v65.tag,
				Size = v65.Size,
				flexItem = v65.flexItem,
				LayoutOrder = n6
			}, {
				Tile = React.createElement(RobuxPackageTileContainer, {
					pkg = v63,
					paymentSessionId = v38,
					onBonusItemActivated = onItemActivated,
					mediaHeightScale = if p7 ~= nil and not (p7.shopWidth <= 0) then computeRobuxPackageMediaHeightScale(p7.shopWidth, p7.gap) else nil,
					categoryId = t6.categoryId,
					gridPositionRow = t6.gridPositionRow,
					gridPositionColumn = t6.gridPositionColumn
				})
			})
		end

		local v66 = tileWrapperProps(if p7 ~= nil and not (p7.rowWidth <= 0) then if not p7.isFeaturedDoubleWidthRobux(p6, n6) or p7.featuredRobuxWidth == nil then p7.shopWidth else p7.featuredRobuxWidth else nil, 1)

		return React.createElement(View, {
			tag = v66.tag,
			Size = v66.Size,
			flexItem = v66.flexItem,
			LayoutOrder = n6
		}, {
			Tile = React.createElement(ShopItemTile, {
				itemId = p6.id,
				itemType = p6.itemType,
				name = p6.name,
				thumbnail = p6.thumbnail,
				price = p6.price,
				universeId = p6.universeId,
				categoryId = t6.categoryId,
				gridPositionRow = t6.gridPositionRow,
				gridPositionColumn = t6.gridPositionColumn,
				onItemActivated = onItemActivated,
				shopPageType = if not v11 then nil else v11.Category
			})
		})
	end, {
		v43,
		onItemActivated,
		onItemActivated,
		v39,
		v40,
		v38,
		t2.sectionId
	})
	local v45 = React.useMemo(function() -- line: 251
		-- upvalues: v39 (copy), v40 (copy), v37 (copy)
		if v39 then
			return function(_, _: number) -- line: 253
				return true
			end
		end

		if not v40 then
			return nil
		end

		local id = v37.id

		return function(p9, n8: number) -- line: 263
			-- upvalues: id (copy)
			return n8 == 1 and p9.id == id
		end
	end, {
		v39,
		v40,
		v37
	})

	return {
		items = v42,
		itemsPerRow = t2.itemsPerRow,
		sectionId = t2.sectionId,
		onItemActivated = onItemActivated,
		renderTile = if not FFlagEnableInExperienceShopUnifiedLogging then if v43 == nil then nil else v44 else v44,
		isFeaturedDoubleWidthRobux = v45,
		LayoutOrder = t2.LayoutOrder
	}
end

return useCategoryPageViewModel
