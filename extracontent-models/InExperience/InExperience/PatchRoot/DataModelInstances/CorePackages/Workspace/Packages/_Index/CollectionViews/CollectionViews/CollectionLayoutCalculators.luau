local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent

require(parent.Style)
require(parent.Foundation)

local Responsive = require(parent.Responsive)
local hasExtraPlatformInset = Responsive.HardwareSafeAreaInsets.hasExtraPlatformInset

local ArgCheck = require(parent.ArgCheck)
local calculateNumColumns = require(CollectionViews.calculateNumColumns)
local CollectionViewTypes = require(CollectionViews.CollectionViewTypes)
local CollectionItemSize = CollectionViewTypes.CollectionItemSize

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
local v = game:DefineFastInt("XLargeCollectionItemFractionalPercent", 10) / 100
local v2 = defineFastInt20 / 100
local v3 = defineFastInt15 / 100
local v4 = defineFastInt10 / 100
local v5 = defineFastInt5 / 100

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext

local function scaleSizeForPlatform(defineFastInt25: number, p) -- 18 equivalent calls inferred from this helper
	local v6

	if FFlagLuaAppLayoutParamsInContext then
		v6 = p.Config.UI.Scale
	else
		v6 = p.Stroke.Standard
	end

	return defineFastInt25 * v6
end

local function getLegacySideMargin(p: number, data)
	if p < scaleSizeForPlatform(1024, data) then -- inferred equivalent call
		if FFlagLuaAppLayoutParamsInContext then
			return data.Padding.Medium
		end

		return data.Size.Size_300
	elseif p < scaleSizeForPlatform(1280, data) then -- inferred equivalent call
		return scaleSizeForPlatform(18, data) -- inferred equivalent call
	elseif p < scaleSizeForPlatform(1440, data) then -- inferred equivalent call
		if FFlagLuaAppLayoutParamsInContext then
			return data.Margin.Medium
		end

		return data.Size.Size_600
	elseif p < scaleSizeForPlatform(1920, data) then -- inferred equivalent call
		return scaleSizeForPlatform(34, data) -- inferred equivalent call
	elseif p < scaleSizeForPlatform(2260, data) then -- inferred equivalent call
		return scaleSizeForPlatform(38, data) -- inferred equivalent call
	elseif FFlagLuaAppLayoutParamsInContext then
		return data.Margin.Large
	else
		return data.Size.Size_1200
	end
end

local function getLegacyColumnGap(p: number, p2) -- 1 equivalent call inferred from this helper
	if p < 1024 then
		if FFlagLuaAppLayoutParamsInContext then
			return p2.Gap.Medium
		end

		return p2.Size.Size_300
	end

	if p < 1280 then
		return 18
	end

	if FFlagLuaAppLayoutParamsInContext then
		return p2.Gap.XXLarge
	end

	return p2.Size.Size_600
end

local function calculateNumColumnsForCollection(p: number, p2: number, p3: number, p4, p5)
	local v6, v7, v8

	if p4 == CollectionItemSize.XLarge then
		v6 = scaleSizeForPlatform(defineFastInt23, p5) -- inferred equivalent call

		v7 = defineFastInt21
		v8 = defineFastInt22
	elseif p4 == CollectionItemSize.Large then
		v6 = scaleSizeForPlatform(defineFastInt18, p5) -- inferred equivalent call

		v7 = defineFastInt16
		v8 = defineFastInt17
	elseif p4 == CollectionItemSize.Medium then
		v6 = scaleSizeForPlatform(defineFastInt13, p5) -- inferred equivalent call

		v7 = defineFastInt11
		v8 = defineFastInt12
	elseif p4 == CollectionItemSize.Small then
		ArgCheck.assert(p4 == CollectionItemSize.Small)
		v6 = scaleSizeForPlatform(defineFastInt8, p5) -- inferred equivalent call

		v7 = defineFastInt6
		v8 = defineFastInt7
	else
		ArgCheck.assert(p4 == CollectionItemSize.XSmall)
		v6 = scaleSizeForPlatform(defineFastInt3, p5) -- inferred equivalent call

		v7 = defineFastInt
		v8 = defineFastInt2
	end

	return calculateNumColumns(v6, p3, v7, v8, p - p2 * 2)
end

local CollectionLayoutCalculators = {}
CollectionLayoutCalculators.calculateNumColumns = calculateNumColumnsForCollection

function CollectionLayoutCalculators.calculateSideMargin(_: number, p, p2: number)
	if not hasExtraPlatformInset() then
		return (getLegacySideMargin(p2, p))
	end

	if FFlagLuaAppLayoutParamsInContext then
	end

	return p.Size.Size_1600
end

function CollectionLayoutCalculators.calculateColumnGap(_: number, p, p2: number)
	return getLegacyColumnGap(p2, p) -- inferred equivalent call
end

function CollectionLayoutCalculators.calculateVerticalPadding(p, p2)
	if p2 == CollectionItemSize.XLarge then
		return scaleSizeForPlatform(defineFastInt24, p) -- inferred equivalent call
	elseif p2 == CollectionItemSize.Large then
		return scaleSizeForPlatform(defineFastInt19, p) -- inferred equivalent call
	elseif p2 == CollectionItemSize.Medium then
		return scaleSizeForPlatform(defineFastInt14, p) -- inferred equivalent call
	elseif p2 == CollectionItemSize.Small then
		return scaleSizeForPlatform(defineFastInt9, p) -- inferred equivalent call
	else
		return scaleSizeForPlatform(defineFastInt4, p) -- inferred equivalent call
	end
end

function CollectionLayoutCalculators.calculateFractionalItemAmount(p, p2: string)
	if p == CollectionItemSize.XLarge then
		return if p2 == Responsive.Input.Directional then 0 else v
	elseif p == CollectionItemSize.Large then
		return if p2 == Responsive.Input.Directional then 0 else v2
	elseif p == CollectionItemSize.Medium then
		if p2 == Responsive.Input.Directional then
			return 0
		end

		return v3
	elseif p == CollectionItemSize.Small then
		if p2 == Responsive.Input.Directional then
			return 0
		end

		return v4
	elseif p2 == Responsive.Input.Directional then
		return 0
	else
		return v5
	end
end

function CollectionLayoutCalculators.calculateMaxTilesToShow(p: string): nil | number
	return if p == Responsive.Input.Directional then 20 else nil
end

function CollectionLayoutCalculators.calculateLoadMoreThreshold(p: number)
	return (math.max(1000, p))
end

return CollectionLayoutCalculators
