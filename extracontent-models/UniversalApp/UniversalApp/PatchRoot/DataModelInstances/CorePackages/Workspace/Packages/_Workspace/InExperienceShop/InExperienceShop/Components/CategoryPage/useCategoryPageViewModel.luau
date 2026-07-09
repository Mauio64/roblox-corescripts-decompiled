local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local View = require(InExperienceShopParent.Foundation).View
local ShopItemTile = require(InExperienceShop.Components.ShopItemTile)
local RobuxPackageTileContainer = require(InExperienceShop.Components.RobuxPackageTileContainer)

require(InExperienceShop.Components.ItemRow)

local computeRobuxPackageMediaHeightScale = require(InExperienceShop.Components.computeShopRowTileWidths).computeRobuxPackageMediaHeightScale
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)

require(InExperienceShop.Types)

local findSection = require(InExperienceShop.Utils.findSection)

require(script.Parent.CategoryPageView)

local t1 = {}

local function shopItemTileFlexItem(n1: number) -- line: 46
	return {
		ShrinkRatio = 1,
		FlexMode = Enum.UIFlexMode.Custom,
		GrowRatio = n1,
		ItemLineAlignment = Enum.ItemLineAlignment.Stretch
	}
end
local function explicitWidthFlexItem() -- line: 55
	return {
		GrowRatio = 0,
		ShrinkRatio = 0,
		FlexMode = Enum.UIFlexMode.None,
		ItemLineAlignment = Enum.ItemLineAlignment.Stretch
	}
end
local function resolveTileWidth(p1, n2: number, p2) -- line: 64
	if p2 == nil or p2.rowWidth <= 0 then
		return nil
	end

	if p2.isFeaturedDoubleWidthRobux(p1, n2) and p2.featuredRobuxWidth ~= nil then
		return p2.featuredRobuxWidth
	end

	return p2.shopWidth
end
local function resolveRobuxMediaHeightScale(p3) -- line: 76
	-- upvalues: computeRobuxPackageMediaHeightScale (copy)
	if p3 == nil or p3.shopWidth <= 0 then
		return nil
	end

	return computeRobuxPackageMediaHeightScale(p3.shopWidth, p3.gap)
end
local function tileWrapperProps(n3: number?, n4: number) -- line: 84
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
local function shopItemFromRobuxPackage(p4) -- line: 100
	return {
		id = p4.id,
		name = tostring(p4.robuxAmount),
		thumbnail = p4.robuxImage
	}
end
local function getTileLoggingProps(n5: number, p5, s1: string) -- line: 108
	local v30 = if not p5 then nil else p5.gridPositionRow

	return {
		categoryId = s1,
		gridPositionRow = v30,
		gridPositionColumn = n5
	}
end
local function useCategoryPageViewModel(t2: {[any]: any}) -- line: 126
	-- upvalues: React (copy), findSection (copy), t1 (copy), tileWrapperProps (copy), View (copy), RobuxPackageTileContainer (copy), computeRobuxPackageMediaHeightScale (copy), ShopItemTile (copy), FFlagEnableInExperienceShopUnifiedLogging (copy)
	local v32 = React.useMemo(function() -- line: 127
		-- upvalues: findSection (copy), t2 (copy)
		return findSection(t2.sections, t2.sectionId)
	end, {
		t2.sections,
		t2.sectionId
	})
	local v33 = if v32 == nil then t1 else v32.items
	local v34 = if v32 == nil then nil else v32.robuxPackages
	local v35 = if v32 == nil then nil else v32.featuredRobuxPackage
	local v36 = if v32 == nil then nil else v32.paymentSessionId
	local v37 = v34 ~= nil and #v34 > 0
	local v38 = v35 ~= nil
	local onItemActivated = t2.onItemActivated
	local v40 = React.useMemo(function() -- line: 144
		-- upvalues: v37 (copy), v34 (copy), v35 (copy), v33 (copy)
		if v37 then
			local v44 = v34
			local t3 = table.create(#v44)

			for i = 1, #v44 do
				local v47 = v44[i]

				t3[i] = {
					id = v47.id,
					name = tostring(v47.robuxAmount),
					thumbnail = v47.robuxImage
				}
			end

			return t3
		end

		if v35 ~= nil then
			local t4 = table.create(#v33 + 1)
			local v49 = v35

			t4[1] = {
				id = v49.id,
				name = tostring(v49.robuxAmount),
				thumbnail = v49.robuxImage
			}

			for i = 1, #v33 do
				t4[i + 1] = v33[i]
			end

			return t4
		end

		return v33
	end, {
		v33,
		v34,
		v35,
		v37
	})
	local v41 = React.useMemo(function() -- line: 166
		-- upvalues: v37 (copy), v34 (copy), v35 (copy)
		if v37 then
			local t5 = {}

			for _, v53 in v34 do
				t5[v53.id] = v53
			end

			return t5
		end

		if v35 ~= nil then
			local v54 = v35

			return {
				[v54.id] = v54
			}
		end

		return nil
	end, {
		v34,
		v35,
		v37
	})
	local v42 = React.useCallback(function(p6, n6: number, p7) -- line: 184
		-- upvalues: t2 (copy), v41 (copy), v37 (copy), v38 (copy), tileWrapperProps (copy), React (copy), View (copy), RobuxPackageTileContainer (copy), v36 (copy), onItemActivated (copy), computeRobuxPackageMediaHeightScale (copy), ShopItemTile (copy), onItemActivated (copy)
		local sectionId = t2.sectionId
		local v59 = if not p7 then nil else p7.gridPositionRow
		local t6 = {
			categoryId = sectionId,
			gridPositionRow = v59,
			gridPositionColumn = n6
		}
		local v61 = if v41 == nil then nil else v41[p6.id]

		if v61 ~= nil then
			local v62 = not (v37 or v38 and n6 == 1) and 1 or 2
			local v63 = tileWrapperProps(if p7 ~= nil and not (p7.rowWidth <= 0) then if not p7.isFeaturedDoubleWidthRobux(p6, n6) or p7.featuredRobuxWidth == nil then p7.shopWidth else p7.featuredRobuxWidth else nil, v62)

			return React.createElement(View, {
				tag = v63.tag,
				Size = v63.Size,
				flexItem = v63.flexItem,
				LayoutOrder = n6
			}, {
				Tile = React.createElement(RobuxPackageTileContainer, {
					pkg = v61,
					paymentSessionId = v36,
					onBonusItemActivated = onItemActivated,
					mediaHeightScale = if p7 ~= nil and not (p7.shopWidth <= 0) then computeRobuxPackageMediaHeightScale(p7.shopWidth, p7.gap) else nil,
					categoryId = t6.categoryId,
					gridPositionRow = t6.gridPositionRow,
					gridPositionColumn = t6.gridPositionColumn
				})
			})
		end

		local v64 = tileWrapperProps(if p7 ~= nil and not (p7.rowWidth <= 0) then if not p7.isFeaturedDoubleWidthRobux(p6, n6) or p7.featuredRobuxWidth == nil then p7.shopWidth else p7.featuredRobuxWidth else nil, 1)

		return React.createElement(View, {
			tag = v64.tag,
			Size = v64.Size,
			flexItem = v64.flexItem,
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
				onItemActivated = onItemActivated
			})
		})
	end, {
		v41,
		onItemActivated,
		onItemActivated,
		v37,
		v38,
		v36,
		t2.sectionId
	})
	local v43 = React.useMemo(function() -- line: 245
		-- upvalues: v37 (copy), v38 (copy), v35 (copy)
		if v37 then
			return function(_, _: number) -- line: 247
				return true
			end
		end

		if not v38 then
			return nil
		end

		local id = v35.id

		return function(p9, n8: number) -- line: 257
			-- upvalues: id (copy)
			return n8 == 1 and p9.id == id
		end
	end, {
		v37,
		v38,
		v35
	})

	return {
		items = v40,
		itemsPerRow = t2.itemsPerRow,
		sectionId = t2.sectionId,
		onItemActivated = onItemActivated,
		renderTile = if not FFlagEnableInExperienceShopUnifiedLogging then if v41 == nil then nil else v42 else v42,
		isFeaturedDoubleWidthRobux = v43,
		LayoutOrder = t2.LayoutOrder
	}
end

return useCategoryPageViewModel
