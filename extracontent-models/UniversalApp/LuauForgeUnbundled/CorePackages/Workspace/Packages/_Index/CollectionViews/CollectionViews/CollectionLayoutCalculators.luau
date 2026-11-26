require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Style")
require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Foundation")

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Responsive")
local hasExtraPlatformInset = Responsive.HardwareSafeAreaInsets.hasExtraPlatformInset

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/ArgCheck")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/calculateNumColumns")
local collectionItemSize = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionViewTypes").CollectionItemSize

local defineFastInt = game:DefineFastInt("XSmallCollectionItemMinItemCount", 3)
local defineFastInt2 = game:DefineFastInt("XSmallCollectionItemMaxItemCount", 20)
local defineFastInt3 = game:DefineFastInt("XSmallCollectionItemMinItemWidth", 100)
local defineFastInt4 = game:DefineFastInt("XSmallCollectionItemVerticalGap", 16)
local defineFastInt5 = game:DefineFastInt("XSmallCollectionItemFractionalPercent", 15)

local defineFastInt6 = game:DefineFastInt("SmallCollectionItemMinItemCount", 3)
local defineFastInt7 = game:DefineFastInt("SmallCollectionItemMaxItemCount", 12)
local defineFastInt8 = game:DefineFastInt("SmallCollectionItemMinItemWidth", 150)
local defineFastInt9 = game:DefineFastInt("SmallCollectionItemVerticalGap", 16)
local defineFastInt10 = game:DefineFastInt("SmallCollectionItemFractionalPercent", 15)

local defineFastInt11 = game:DefineFastInt("MediumCollectionItemMinItemCount", 2)
local defineFastInt12 = game:DefineFastInt("MediumCollectionItemMaxItemCount", 6)
local defineFastInt13 = game:DefineFastInt("MediumCollectionItemMinItemWidth", 233)
local defineFastInt14 = game:DefineFastInt("MediumCollectionItemVerticalGap", 16)
local defineFastInt15 = game:DefineFastInt("MediumCollectionItemFractionalPercent", 15)

local defineFastInt16 = game:DefineFastInt("LargeCollectionItemMinItemCount", 1)
local defineFastInt17 = game:DefineFastInt("LargeCollectionItemMaxItemCount", 4)
local defineFastInt18 = game:DefineFastInt("LargeCollectionItemMinItemWidth", 300)
local defineFastInt19 = game:DefineFastInt("LargeCollectionItemVerticalGap", 16)
local defineFastInt20 = game:DefineFastInt("LargeCollectionItemFractionalPercent", 30)

local defineFastInt21 = game:DefineFastInt("XLargeCollectionItemMinItemCount", 1)
local defineFastInt22 = game:DefineFastInt("XLargeCollectionItemMaxItemCount", 1)
local defineFastInt23 = game:DefineFastInt("XLargeCollectionItemMinItemWidth", 300)
local defineFastInt24 = game:DefineFastInt("XLargeCollectionItemVerticalGap", 16)
local v5 = game:DefineFastInt("XLargeCollectionItemFractionalPercent", 10) / 100
local v6 = defineFastInt20 / 100
local v7 = defineFastInt15 / 100
local v8 = defineFastInt10 / 100
local v9 = defineFastInt5 / 100

local fFlagLuaAppLayoutParamsInContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/SharedFlags").FFlagLuaAppLayoutParamsInContext

local function scaleSizeForPlatform(p2, p3)
	local v10 = if fFlagLuaAppLayoutParamsInContext then p3.Config.UI.Scale else p3.Stroke.Standard
	return p2 * v10
end

local function getLegacySideMargin(p2, data)
	local v11 = if fFlagLuaAppLayoutParamsInContext then data.Config.UI.Scale else data.Stroke.Standard

	if p2 < 1024 * v11 then
		if fFlagLuaAppLayoutParamsInContext then
			return data.Padding.Medium
		end

		return data.Size.Size_300
	else
		local v13 = if fFlagLuaAppLayoutParamsInContext then data.Config.UI.Scale else data.Stroke.Standard

		if p2 < 1280 * v13 then
			return 18 * (if fFlagLuaAppLayoutParamsInContext then data.Config.UI.Scale else data.Stroke.Standard)
		else
			local v15 = if fFlagLuaAppLayoutParamsInContext then data.Config.UI.Scale else data.Stroke.Standard

			if p2 < 1440 * v15 then
				if fFlagLuaAppLayoutParamsInContext then
					return data.Margin.Medium
				end

				return data.Size.Size_600
			else
				local v17 = if fFlagLuaAppLayoutParamsInContext then data.Config.UI.Scale else data.Stroke.Standard

				if p2 < 1920 * v17 then
					return 34 * (if fFlagLuaAppLayoutParamsInContext then data.Config.UI.Scale else data.Stroke.Standard)
				else
					local v19 = if fFlagLuaAppLayoutParamsInContext then data.Config.UI.Scale else data.Stroke.Standard

					if p2 < 2260 * v19 then
						return 38 * (if fFlagLuaAppLayoutParamsInContext then data.Config.UI.Scale else data.Stroke.Standard)
					elseif fFlagLuaAppLayoutParamsInContext then
						return data.Margin.Large
					else
						return data.Size.Size_1200
					end
				end
			end
		end
	end
end

local function getLegacyColumnGap(p2, p3)
	if p2 < 1024 then
		if fFlagLuaAppLayoutParamsInContext then
			return p3.Gap.Medium
		end

		return p3.Size.Size_300
	end

	if p2 < 1280 then
		return 18
	end

	if fFlagLuaAppLayoutParamsInContext then
		return p3.Gap.XXLarge
	end

	return p3.Size.Size_600
end

local function calculateNumColumnsForCollection(p2, p3, p4, p5, p6)
	local v10, v11, v12

	if p5 == collectionItemSize.XLarge then
		local v14 = if fFlagLuaAppLayoutParamsInContext then p6.Config.UI.Scale else p6.Stroke.Standard
		v10 = defineFastInt23 * v14

		v11 = defineFastInt21
		v12 = defineFastInt22
	elseif p5 == collectionItemSize.Large then
		local v14 = if fFlagLuaAppLayoutParamsInContext then p6.Config.UI.Scale else p6.Stroke.Standard
		v10 = defineFastInt18 * v14

		v11 = defineFastInt16
		v12 = defineFastInt17
	elseif p5 == collectionItemSize.Medium then
		local v14 = if fFlagLuaAppLayoutParamsInContext then p6.Config.UI.Scale else p6.Stroke.Standard
		v10 = defineFastInt13 * v14

		v11 = defineFastInt11
		v12 = defineFastInt12
	elseif p5 == collectionItemSize.Small then
		ArgCheck.assert(p5 == collectionItemSize.Small)
		local v14 = if fFlagLuaAppLayoutParamsInContext then p6.Config.UI.Scale else p6.Stroke.Standard
		v10 = defineFastInt8 * v14

		v11 = defineFastInt6
		v12 = defineFastInt7
	else
		ArgCheck.assert(p5 == collectionItemSize.XSmall)
		local v14 = if fFlagLuaAppLayoutParamsInContext then p6.Config.UI.Scale else p6.Stroke.Standard
		v10 = defineFastInt3 * v14

		v11 = defineFastInt
		v12 = defineFastInt2
	end

	return module3(v10, p4, v11, v12, p2 - 2 * p3)
end

return {
	calculateNumColumns = calculateNumColumnsForCollection,
	calculateSideMargin = function(p2, p3, p4)
		if not hasExtraPlatformInset() then
			return getLegacySideMargin(p4, p3)
		end

		if fFlagLuaAppLayoutParamsInContext then
		end

		return p3.Size.Size_1600
	end,
	calculateColumnGap = function(p2, p3, p4)
		if p4 < 1024 then
			if fFlagLuaAppLayoutParamsInContext then
				return p3.Gap.Medium
			end

			return p3.Size.Size_300
		end

		if p4 < 1280 then
			return 18
		end

		if fFlagLuaAppLayoutParamsInContext then
			return p3.Gap.XXLarge
		end

		return p3.Size.Size_600
	end,
	calculateVerticalPadding = function(p2, p3)
		if p3 == collectionItemSize.XLarge then
			local v11 = if fFlagLuaAppLayoutParamsInContext then p2.Config.UI.Scale else p2.Stroke.Standard
			return defineFastInt24 * v11
		elseif p3 == collectionItemSize.Large then
			local v11 = if fFlagLuaAppLayoutParamsInContext then p2.Config.UI.Scale else p2.Stroke.Standard
			return defineFastInt19 * v11
		elseif p3 == collectionItemSize.Medium then
			local v11 = if fFlagLuaAppLayoutParamsInContext then p2.Config.UI.Scale else p2.Stroke.Standard
			return defineFastInt14 * v11
		elseif p3 == collectionItemSize.Small then
			local v11 = if fFlagLuaAppLayoutParamsInContext then p2.Config.UI.Scale else p2.Stroke.Standard
			return defineFastInt9 * v11
		else
			local v11 = if fFlagLuaAppLayoutParamsInContext then p2.Config.UI.Scale else p2.Stroke.Standard
			return defineFastInt4 * v11
		end
	end,
	calculateFractionalItemAmount = function(p2, p3)
		if p2 == collectionItemSize.XLarge then
			if p3 == Responsive.Input.Directional then
				return 0
			end

			return v5
		elseif p2 == collectionItemSize.Large then
			if p3 == Responsive.Input.Directional then
				return 0
			end

			return v6
		elseif p2 == collectionItemSize.Medium then
			if p3 == Responsive.Input.Directional then
				return 0
			end

			return v7
		elseif p2 == collectionItemSize.Small then
			if p3 == Responsive.Input.Directional then
				return 0
			end

			return v8
		elseif p3 == Responsive.Input.Directional then
			return 0
		else
			return v9
		end
	end,
	calculateMaxTilesToShow = function(p2): nil | number
		if p2 == Responsive.Input.Directional then
			return 20
		end

		return nil
	end,
	calculateLoadMoreThreshold = function(p2)
		return (math.max(1000, p2))
	end
}
