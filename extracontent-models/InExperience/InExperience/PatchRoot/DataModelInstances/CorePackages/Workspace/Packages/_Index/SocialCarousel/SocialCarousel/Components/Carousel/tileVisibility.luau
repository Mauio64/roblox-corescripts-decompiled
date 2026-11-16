local function tileVisibilityFraction(p: number, p2: number, p3: number, p4: number, p5: number) -- 1 equivalent call inferred from this helper
	if p < 1 or p4 <= 0 or p3 <= 0 then
		return 0
	end

	local v = (p - 1) * (p4 + p5)
	return math.max(0, math.min(v + p4, p2 + p3) - math.max(v, p2)) / p4
end

local function verticalVisibilityFraction(p: number, p2: number, p3: number, p4: number) -- 1 equivalent call inferred from this helper
	if p2 <= 0 or p4 <= 0 then
		return 0
	end

	return math.max(0, math.min(p + p2, p3 + p4) - math.max(p, p3)) / p2
end

local TileVisibility = {}
TileVisibility.MIN_VISIBLE_FRACTION = 0.7
TileVisibility.tileVisibilityFraction = tileVisibilityFraction
TileVisibility.verticalVisibilityFraction = verticalVisibilityFraction

function TileVisibility.isAtLeast70PercentVerticallyVisible(p: number, p2: number, p3: number, p4: number): boolean
	return verticalVisibilityFraction(p, p2, p3, p4) >= 0.7 -- inferred equivalent call
end

function TileVisibility.isAtLeast70PercentVisible(p: number, p2: number, p3: number, p4: number, p5: number): boolean
	return tileVisibilityFraction(p, p2, p3, p4, p5) >= 0.7 -- inferred equivalent call
end

return TileVisibility
