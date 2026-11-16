local function computeContentTopOffset(p: number, p2: number, p3: number) -- 2 equivalent calls inferred from this helper
	if p <= 0 then
		return 0
	end

	return (math.max(0, p / p2 - p3))
end

local function computeInitialScrollY(x: number, fullBleedAspectRatio: number, headerBarHeight: number, fullBleedOverlapOffset: number) -- 1 equivalent call inferred from this helper
	return (math.max(0, computeContentTopOffset(x, fullBleedAspectRatio, headerBarHeight) - fullBleedOverlapOffset)) -- inferred equivalent call
end

local function computeCanvasPaddingTop(p: number, hasFullBleed: boolean, fullBleedOverlapOffset: number, headerBarHeight: number) -- 1 equivalent call inferred from this helper
	local canvasPaddingTop = math.max(0, p - (not hasFullBleed and 0 or fullBleedOverlapOffset))

	if canvasPaddingTop == 0 then
		canvasPaddingTop = headerBarHeight
	end

	return canvasPaddingTop
end

local DetailsPageLayoutUtils = {}
DetailsPageLayoutUtils.computeContentTopOffset = computeContentTopOffset
DetailsPageLayoutUtils.computeInitialScrollY = computeInitialScrollY

function DetailsPageLayoutUtils.computeInitialScrollYForSize(vector2: Vector2, data)
	local fullBleedAspectRatio = data.fullBleedAspectRatio
	local headerBarHeight = data.headerBarHeight
	local fullBleedOverlapOffset = data.fullBleedOverlapOffset
	local hasFullBleed = data.hasFullBleed
	local bannerBottomVisiblePercent = data.bannerBottomVisiblePercent

	local v = vector2.X / fullBleedAspectRatio
	local v2

	if bannerBottomVisiblePercent == nil then
		v2 = computeInitialScrollY(vector2.X, fullBleedAspectRatio, headerBarHeight, fullBleedOverlapOffset) -- inferred equivalent call
	else
		v2 = math.max(0, (math.floor(v - bannerBottomVisiblePercent * v)))
	end

	return (math.min(
		v2,
		(math.max(
			0,
			math.min(
				computeCanvasPaddingTop( -- inferred equivalent call
					computeContentTopOffset(vector2.X, fullBleedAspectRatio, headerBarHeight), -- inferred equivalent call
					hasFullBleed,
					fullBleedOverlapOffset,
					headerBarHeight
				),
				vector2.Y * 0.75
			) - headerBarHeight
		))
	))
end

DetailsPageLayoutUtils.computeCanvasPaddingTop = computeCanvasPaddingTop

function DetailsPageLayoutUtils.getNoBannerFadeParams(p: number)
	return (math.max(60, p * 1.5))
end

function DetailsPageLayoutUtils.getHeaderFadeParams(p: number, p2: number, p3: number)
	local v = math.max(0, p - p3)
	local v2

	if p2 > 0 then
		v2 = p2 < p
	else
		v2 = false
	end

	local v3

	if v2 then
		v3 = math.max(1, p2 - v)
	else
		v3 = math.max(1, (p - v) / 3)
	end

	return v, v3
end

function DetailsPageLayoutUtils.shouldShowStickyBar(p: number, p2: number, p3: number, p4: number)
	local v = p3 + p4 <= p
	return p2 < p or v
end

return DetailsPageLayoutUtils
