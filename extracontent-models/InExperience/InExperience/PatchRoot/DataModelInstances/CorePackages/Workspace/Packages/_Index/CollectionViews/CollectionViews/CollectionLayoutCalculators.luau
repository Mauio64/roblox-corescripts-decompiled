local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent

require(CollectionViewsParent.Style)
require(CollectionViewsParent.Foundation)

local Responsive = require(CollectionViewsParent.Responsive)
local hasExtraPlatformInset = Responsive.HardwareSafeAreaInsets.hasExtraPlatformInset
local ArgCheck = require(CollectionViewsParent.ArgCheck)
local calculateNumColumns = require(CollectionViews.calculateNumColumns)
local CollectionItemSize = require(CollectionViews.CollectionViewTypes).CollectionItemSize
local v8 = game:DefineFastInt("XSmallCollectionItemMinItemCount", 3)
local v9 = game:DefineFastInt("XSmallCollectionItemMaxItemCount", 20)
local v10 = game:DefineFastInt("XSmallCollectionItemMinItemWidth", 100)
local v11 = game:DefineFastInt("XSmallCollectionItemVerticalGap", 16)
local v12 = game:DefineFastInt("XSmallCollectionItemFractionalPercent", 15)
local v13 = game:DefineFastInt("SmallCollectionItemMinItemCount", 3)
local v14 = game:DefineFastInt("SmallCollectionItemMaxItemCount", 12)
local v15 = game:DefineFastInt("SmallCollectionItemMinItemWidth", 150)
local v16 = game:DefineFastInt("SmallCollectionItemVerticalGap", 16)
local v17 = game:DefineFastInt("SmallCollectionItemFractionalPercent", 15)
local v18 = game:DefineFastInt("MediumCollectionItemMinItemCount", 2)
local v19 = game:DefineFastInt("MediumCollectionItemMaxItemCount", 6)
local v20 = game:DefineFastInt("MediumCollectionItemMinItemWidth", 233)
local v21 = game:DefineFastInt("MediumCollectionItemVerticalGap", 16)
local v22 = game:DefineFastInt("MediumCollectionItemFractionalPercent", 15)
local v23 = game:DefineFastInt("LargeCollectionItemMinItemCount", 1)
local v24 = game:DefineFastInt("LargeCollectionItemMaxItemCount", 4)
local v25 = game:DefineFastInt("LargeCollectionItemMinItemWidth", 300)
local v26 = game:DefineFastInt("LargeCollectionItemVerticalGap", 16)
local v27 = game:DefineFastInt("LargeCollectionItemFractionalPercent", 30)
local v28 = game:DefineFastInt("XLargeCollectionItemMinItemCount", 1)
local v29 = game:DefineFastInt("XLargeCollectionItemMaxItemCount", 1)
local v30 = game:DefineFastInt("XLargeCollectionItemMinItemWidth", 300)
local v31 = game:DefineFastInt("XLargeCollectionItemVerticalGap", 16)
local v32 = game:DefineFastInt("XLargeCollectionItemFractionalPercent", 10) / 100
local v33 = v27 / 100
local v34 = v22 / 100
local v35 = v17 / 100
local v36 = v12 / 100
local FFlagLuaAppLayoutParamsInContext = require(CollectionViewsParent.SharedFlags).FFlagLuaAppLayoutParamsInContext

local function scaleSizeForPlatform(n1: number, p1) -- line: 58
	-- upvalues: FFlagLuaAppLayoutParamsInContext (copy)
	return n1 * if not FFlagLuaAppLayoutParamsInContext then p1.Stroke.Standard else p1.Config.UI.Scale
end
local function getLegacySideMargin(n2: number, p2) -- line: 67
	-- upvalues: FFlagLuaAppLayoutParamsInContext (copy)
	if n2 < 1024 * if not FFlagLuaAppLayoutParamsInContext then p2.Stroke.Standard else p2.Config.UI.Scale then
		if FFlagLuaAppLayoutParamsInContext then
			return p2.Padding.Medium
		end

		return p2.Size.Size_300
	end

	if n2 < 1280 * if not FFlagLuaAppLayoutParamsInContext then p2.Stroke.Standard else p2.Config.UI.Scale then
		return 18 * if not FFlagLuaAppLayoutParamsInContext then p2.Stroke.Standard else p2.Config.UI.Scale
	end

	if n2 < 1440 * if not FFlagLuaAppLayoutParamsInContext then p2.Stroke.Standard else p2.Config.UI.Scale then
		if FFlagLuaAppLayoutParamsInContext then
			return p2.Margin.Medium
		end

		return p2.Size.Size_600
	end

	if n2 < 1920 * if not FFlagLuaAppLayoutParamsInContext then p2.Stroke.Standard else p2.Config.UI.Scale then
		return 34 * if not FFlagLuaAppLayoutParamsInContext then p2.Stroke.Standard else p2.Config.UI.Scale
	end

	if n2 < 2260 * if not FFlagLuaAppLayoutParamsInContext then p2.Stroke.Standard else p2.Config.UI.Scale then
		return 38 * if not FFlagLuaAppLayoutParamsInContext then p2.Stroke.Standard else p2.Config.UI.Scale
	end

	if FFlagLuaAppLayoutParamsInContext then
		return p2.Margin.Large
	end

	return p2.Size.Size_1200
end
local function getLegacyColumnGap(n3: number, p3) -- line: 92
	-- upvalues: FFlagLuaAppLayoutParamsInContext (copy)
	if n3 < 1024 then
		if FFlagLuaAppLayoutParamsInContext then
			return p3.Gap.Medium
		end

		return p3.Size.Size_300
	end

	if n3 < 1280 then
		return 18
	end

	if FFlagLuaAppLayoutParamsInContext then
		return p3.Gap.XXLarge
	end

	return p3.Size.Size_600
end
local function calculateNumColumnsForCollection(n4: number, n5: number, n6: number, p4, p5) -- line: 134
	-- upvalues: CollectionItemSize (copy), v30 (copy), FFlagLuaAppLayoutParamsInContext (copy), v28 (copy), v29 (copy), v25 (copy), v23 (copy), v24 (copy), v20 (copy), v18 (copy), v19 (copy), ArgCheck (copy), v15 (copy), v13 (copy), v14 (copy), v10 (copy), v8 (copy), v9 (copy), calculateNumColumns (copy)
	local v59, v60, v61

	if p4 == CollectionItemSize.XLarge then
		v59 = v30 * if not FFlagLuaAppLayoutParamsInContext then p5.Stroke.Standard else p5.Config.UI.Scale
		v60 = v28
		v61 = v29
	elseif p4 == CollectionItemSize.Large then
		v59 = v25 * if not FFlagLuaAppLayoutParamsInContext then p5.Stroke.Standard else p5.Config.UI.Scale
		v60 = v23
		v61 = v24
	elseif p4 == CollectionItemSize.Medium then
		v59 = v20 * if not FFlagLuaAppLayoutParamsInContext then p5.Stroke.Standard else p5.Config.UI.Scale
		v60 = v18
		v61 = v19
	elseif p4 == CollectionItemSize.Small then
		ArgCheck.assert(p4 == CollectionItemSize.Small)
		v59 = v15 * if not FFlagLuaAppLayoutParamsInContext then p5.Stroke.Standard else p5.Config.UI.Scale
		v60 = v13
		v61 = v14
	else
		ArgCheck.assert(p4 == CollectionItemSize.XSmall)
		v59 = v10 * if not FFlagLuaAppLayoutParamsInContext then p5.Stroke.Standard else p5.Config.UI.Scale
		v60 = v8
		v61 = v9
	end

	local v62 = n4 - n5 * 2

	return calculateNumColumns(v59, n6, v60, v61, v62)
end

return {
	calculateNumColumns = calculateNumColumnsForCollection,
	calculateSideMargin = function(_: number, p6, n8: number) -- line: 108
		-- upvalues: hasExtraPlatformInset (copy), FFlagLuaAppLayoutParamsInContext (copy), getLegacySideMargin (copy)
		if hasExtraPlatformInset() then
			if FFlagLuaAppLayoutParamsInContext then
				return p6.Size.Size_1600
			end

			return p6.Size.Size_1600
		end

		return (getLegacySideMargin(n8, p6))
	end,
	calculateColumnGap = function(_: number, p7, n10: number) -- line: 125
		-- upvalues: FFlagLuaAppLayoutParamsInContext (copy)
		if n10 < 1024 then
			if FFlagLuaAppLayoutParamsInContext then
				return p7.Gap.Medium
			end

			return p7.Size.Size_300
		end

		if n10 < 1280 then
			return 18
		end

		if FFlagLuaAppLayoutParamsInContext then
			return p7.Gap.XXLarge
		end

		return p7.Size.Size_600
	end,
	calculateVerticalPadding = function(p8, p9) -- line: 173
		-- upvalues: CollectionItemSize (copy), v31 (copy), FFlagLuaAppLayoutParamsInContext (copy), v26 (copy), v21 (copy), v16 (copy), v11 (copy)
		if p9 == CollectionItemSize.XLarge then
			return v31 * if not FFlagLuaAppLayoutParamsInContext then p8.Stroke.Standard else p8.Config.UI.Scale
		end

		if p9 == CollectionItemSize.Large then
			return v26 * if not FFlagLuaAppLayoutParamsInContext then p8.Stroke.Standard else p8.Config.UI.Scale
		end

		if p9 == CollectionItemSize.Medium then
			return v21 * if not FFlagLuaAppLayoutParamsInContext then p8.Stroke.Standard else p8.Config.UI.Scale
		end

		if p9 == CollectionItemSize.Small then
			return v16 * if not FFlagLuaAppLayoutParamsInContext then p8.Stroke.Standard else p8.Config.UI.Scale
		end

		return v11 * if not FFlagLuaAppLayoutParamsInContext then p8.Stroke.Standard else p8.Config.UI.Scale
	end,
	calculateFractionalItemAmount = function(p10, s1: string) -- line: 201
		-- upvalues: CollectionItemSize (copy), Responsive (copy), v32 (copy), v33 (copy), v34 (copy), v35 (copy), v36 (copy)
		if p10 == CollectionItemSize.XLarge then
			if s1 == Responsive.Input.Directional then
				return 0
			end

			return v32
		end

		if p10 == CollectionItemSize.Large then
			if s1 == Responsive.Input.Directional then
				return 0
			end

			return v33
		end

		if p10 == CollectionItemSize.Medium then
			if s1 == Responsive.Input.Directional then
				return 0
			end

			return v34
		end

		if p10 == CollectionItemSize.Small then
			if s1 == Responsive.Input.Directional then
				return 0
			end

			return v35
		end

		if s1 == Responsive.Input.Directional then
			return 0
		end

		return v36
	end,
	calculateMaxTilesToShow = function(s2: string) -- line: 192
		-- upvalues: Responsive (copy)
		if s2 == Responsive.Input.Directional then
			return 20
		end

		return nil
	end,
	calculateLoadMoreThreshold = function(n11: number) -- line: 215
		return (math.max(1000, n11))
	end
}
