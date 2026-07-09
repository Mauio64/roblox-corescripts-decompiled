local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent

require(CollectionViewsParent.Style)
require(CollectionViewsParent.Foundation)

local FFlagRenameDeprecatedUIBloxTokens = require(CollectionViewsParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Responsive = require(CollectionViewsParent.Responsive)
local hasExtraPlatformInset = Responsive.HardwareSafeAreaInsets.hasExtraPlatformInset
local ArgCheck = require(CollectionViewsParent.ArgCheck)
local calculateNumColumns = require(CollectionViews.calculateNumColumns)
local CollectionItemSize = require(CollectionViews.CollectionViewTypes).CollectionItemSize
local v9 = game:DefineFastInt("XSmallCollectionItemMinItemCount", 3)
local v10 = game:DefineFastInt("XSmallCollectionItemMaxItemCount", 20)
local v11 = game:DefineFastInt("XSmallCollectionItemMinItemWidth", 100)
local v12 = game:DefineFastInt("XSmallCollectionItemVerticalGap", 16)
local v13 = game:DefineFastInt("XSmallCollectionItemFractionalPercent", 15)
local v14 = game:DefineFastInt("SmallCollectionItemMinItemCount", 3)
local v15 = game:DefineFastInt("SmallCollectionItemMaxItemCount", 12)
local v16 = game:DefineFastInt("SmallCollectionItemMinItemWidth", 150)
local v17 = game:DefineFastInt("SmallCollectionItemVerticalGap", 16)
local v18 = game:DefineFastInt("SmallCollectionItemFractionalPercent", 15)
local v19 = game:DefineFastInt("MediumCollectionItemMinItemCount", 2)
local v20 = game:DefineFastInt("MediumCollectionItemMaxItemCount", 6)
local v21 = game:DefineFastInt("MediumCollectionItemMinItemWidth", 233)
local v22 = game:DefineFastInt("MediumCollectionItemVerticalGap", 16)
local v23 = game:DefineFastInt("MediumCollectionItemFractionalPercent", 15)
local v24 = game:DefineFastInt("LargeCollectionItemMinItemCount", 1)
local v25 = game:DefineFastInt("LargeCollectionItemMaxItemCount", 4)
local v26 = game:DefineFastInt("LargeCollectionItemMinItemWidth", 300)
local v27 = game:DefineFastInt("LargeCollectionItemVerticalGap", 16)
local v28 = game:DefineFastInt("LargeCollectionItemFractionalPercent", 30)
local v29 = game:DefineFastInt("XLargeCollectionItemMinItemCount", 1)
local v30 = game:DefineFastInt("XLargeCollectionItemMaxItemCount", 1)
local v31 = game:DefineFastInt("XLargeCollectionItemMinItemWidth", 300)
local v32 = game:DefineFastInt("XLargeCollectionItemVerticalGap", 16)
local v33 = game:DefineFastInt("XLargeCollectionItemFractionalPercent", 10) / 100
local v34 = v28 / 100
local v35 = v23 / 100
local v36 = v18 / 100
local v37 = v13 / 100
local FFlagLuaAppLayoutParamsInContext = require(CollectionViewsParent.SharedFlags).FFlagLuaAppLayoutParamsInContext

local function scaleSizeForPlatform(n1: number, p1) -- line: 60
	-- upvalues: FFlagLuaAppLayoutParamsInContext (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	return n1 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Stroke_100 else p1.Stroke.Standard else p1.Config.UI.Scale
end
local function getLegacySideMargin(n2: number, p2) -- line: 71
	-- upvalues: FFlagLuaAppLayoutParamsInContext (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	if n2 < 1024 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Stroke_100 else p2.Stroke.Standard else p2.Config.UI.Scale then
		if FFlagLuaAppLayoutParamsInContext then
			return p2.Padding.Medium
		end

		if FFlagRenameDeprecatedUIBloxTokens then
			return p2.Size.Size_300
		end

		return p2.Global.Space_150
	end

	if n2 < 1280 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Stroke_100 else p2.Stroke.Standard else p2.Config.UI.Scale then
		return 18 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Stroke_100 else p2.Stroke.Standard else p2.Config.UI.Scale
	end

	if n2 < 1440 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Stroke_100 else p2.Stroke.Standard else p2.Config.UI.Scale then
		if FFlagLuaAppLayoutParamsInContext then
			return p2.Margin.Medium
		end

		if FFlagRenameDeprecatedUIBloxTokens then
			return p2.Size.Size_600
		end

		return p2.Global.Space_300
	end

	if n2 < 1920 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Stroke_100 else p2.Stroke.Standard else p2.Config.UI.Scale then
		return 34 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Stroke_100 else p2.Stroke.Standard else p2.Config.UI.Scale
	end

	if n2 < 2260 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Stroke_100 else p2.Stroke.Standard else p2.Config.UI.Scale then
		return 38 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Stroke_100 else p2.Stroke.Standard else p2.Config.UI.Scale
	end

	if FFlagLuaAppLayoutParamsInContext then
		return p2.Margin.Large
	end

	if FFlagRenameDeprecatedUIBloxTokens then
		return p2.Size.Size_1200
	end

	return p2.Global.Space_600
end
local function getLegacyColumnGap(n3: number, p3) -- line: 102
	-- upvalues: FFlagLuaAppLayoutParamsInContext (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	if n3 < 1024 then
		if FFlagLuaAppLayoutParamsInContext then
			return p3.Gap.Medium
		end

		if FFlagRenameDeprecatedUIBloxTokens then
			return p3.Size.Size_300
		end

		return p3.Global.Space_150
	end

	if n3 < 1280 then
		return 18
	end

	if FFlagLuaAppLayoutParamsInContext then
		return p3.Gap.XXLarge
	end

	if FFlagRenameDeprecatedUIBloxTokens then
		return p3.Size.Size_600
	end

	return p3.Global.Space_300
end
local function calculateNumColumnsForCollection(n4: number, n5: number, n6: number, p4, p5) -- line: 167
	-- upvalues: CollectionItemSize (copy), v31 (copy), FFlagLuaAppLayoutParamsInContext (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v29 (copy), v30 (copy), v26 (copy), v24 (copy), v25 (copy), v21 (copy), v19 (copy), v20 (copy), ArgCheck (copy), v16 (copy), v14 (copy), v15 (copy), v11 (copy), v9 (copy), v10 (copy), calculateNumColumns (copy)
	local v60, v61, v62

	if p4 == CollectionItemSize.XLarge then
		v60 = v31 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p5.Global.Stroke_100 else p5.Stroke.Standard else p5.Config.UI.Scale
		v61 = v29
		v62 = v30
	elseif p4 == CollectionItemSize.Large then
		v60 = v26 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p5.Global.Stroke_100 else p5.Stroke.Standard else p5.Config.UI.Scale
		v61 = v24
		v62 = v25
	elseif p4 == CollectionItemSize.Medium then
		v60 = v21 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p5.Global.Stroke_100 else p5.Stroke.Standard else p5.Config.UI.Scale
		v61 = v19
		v62 = v20
	elseif p4 == CollectionItemSize.Small then
		ArgCheck.assert(p4 == CollectionItemSize.Small)
		v60 = v16 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p5.Global.Stroke_100 else p5.Stroke.Standard else p5.Config.UI.Scale
		v61 = v14
		v62 = v15
	else
		ArgCheck.assert(p4 == CollectionItemSize.XSmall)
		v60 = v11 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p5.Global.Stroke_100 else p5.Stroke.Standard else p5.Config.UI.Scale
		v61 = v9
		v62 = v10
	end

	local v63 = n4 - n5 * 2

	return calculateNumColumns(v60, n6, v61, v62, v63)
end

return {
	calculateNumColumns = calculateNumColumnsForCollection,
	calculateSideMargin = function(_: number, p6, n8: number) -- line: 122
		-- upvalues: hasExtraPlatformInset (copy), FFlagLuaAppLayoutParamsInContext (copy), FFlagRenameDeprecatedUIBloxTokens (copy), getLegacySideMargin (copy)
		if hasExtraPlatformInset() then
			if FFlagLuaAppLayoutParamsInContext then
				return p6.Size.Size_1600
			end

			if FFlagRenameDeprecatedUIBloxTokens then
				return p6.Size.Size_1600
			end

			return p6.Global.Space_800
		end

		return (getLegacySideMargin(n8, p6))
	end,
	calculateColumnGap = function(_: number, p7, n10: number) -- line: 150
		-- upvalues: FFlagLuaAppLayoutParamsInContext (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
		if n10 < 1024 then
			if FFlagLuaAppLayoutParamsInContext then
				return p7.Gap.Medium
			end

			if FFlagRenameDeprecatedUIBloxTokens then
				return p7.Size.Size_300
			end

			return p7.Global.Space_150
		end

		if n10 < 1280 then
			return 18
		end

		if FFlagLuaAppLayoutParamsInContext then
			return p7.Gap.XXLarge
		end

		if FFlagRenameDeprecatedUIBloxTokens then
			return p7.Size.Size_600
		end

		return p7.Global.Space_300
	end,
	calculateVerticalPadding = function(p8, p9) -- line: 206
		-- upvalues: CollectionItemSize (copy), v32 (copy), FFlagLuaAppLayoutParamsInContext (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v27 (copy), v22 (copy), v17 (copy), v12 (copy)
		if p9 == CollectionItemSize.XLarge then
			return v32 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p8.Global.Stroke_100 else p8.Stroke.Standard else p8.Config.UI.Scale
		end

		if p9 == CollectionItemSize.Large then
			return v27 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p8.Global.Stroke_100 else p8.Stroke.Standard else p8.Config.UI.Scale
		end

		if p9 == CollectionItemSize.Medium then
			return v22 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p8.Global.Stroke_100 else p8.Stroke.Standard else p8.Config.UI.Scale
		end

		if p9 == CollectionItemSize.Small then
			return v17 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p8.Global.Stroke_100 else p8.Stroke.Standard else p8.Config.UI.Scale
		end

		return v12 * if not FFlagLuaAppLayoutParamsInContext then if not FFlagRenameDeprecatedUIBloxTokens then p8.Global.Stroke_100 else p8.Stroke.Standard else p8.Config.UI.Scale
	end,
	calculateFractionalItemAmount = function(p10, s1: string) -- line: 234
		-- upvalues: CollectionItemSize (copy), Responsive (copy), v33 (copy), v34 (copy), v35 (copy), v36 (copy), v37 (copy)
		if p10 == CollectionItemSize.XLarge then
			if s1 == Responsive.Input.Directional then
				return 0
			end

			return v33
		end

		if p10 == CollectionItemSize.Large then
			if s1 == Responsive.Input.Directional then
				return 0
			end

			return v34
		end

		if p10 == CollectionItemSize.Medium then
			if s1 == Responsive.Input.Directional then
				return 0
			end

			return v35
		end

		if p10 == CollectionItemSize.Small then
			if s1 == Responsive.Input.Directional then
				return 0
			end

			return v36
		end

		if s1 == Responsive.Input.Directional then
			return 0
		end

		return v37
	end,
	calculateMaxTilesToShow = function(s2: string) -- line: 225
		-- upvalues: Responsive (copy)
		if s2 == Responsive.Input.Directional then
			return 20
		end

		return nil
	end,
	calculateLoadMoreThreshold = function(n11: number) -- line: 248
		return (math.max(1000, n11))
	end
}
