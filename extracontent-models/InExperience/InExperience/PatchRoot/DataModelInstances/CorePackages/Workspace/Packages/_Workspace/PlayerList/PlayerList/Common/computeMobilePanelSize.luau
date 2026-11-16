local parent = script.Parent.Parent
local Constants = require(parent.Common.Constants)

local function lerpRange(p: number, p2: number, p3: number, p4: number, p5: number) -- 2 equivalent calls inferred from this helper
	return (p - p2) * (p5 - p4) / (p3 - p2) + p4
end

local function computeMobilePanelSize(vector2: Vector2, p: number, p2: number, p3: number?)
	local v = math.min(vector2.X, vector2.Y)
	local v2 = math.max(vector2.X, vector2.Y)
	local PANEL_BORDER = Constants.PANEL_BORDER
	local v3 = lerpRange(v, 320, 375, 270, 330) -- inferred equivalent call
	local v4 = lerpRange(v2, 480, 670, 434, 480) -- inferred equivalent call

	if not (Constants.PANEL_SIZE_MIN_CAP < v3) then
		p = math.clamp(v3, math.min(270, v - PANEL_BORDER), Constants.PANEL_SIZE_MIN_CAP)
	end

	if not (Constants.PANEL_SIZE_MAX_CAP < v4) then
		p2 = math.clamp(v4, math.min(434, v2 - PANEL_BORDER), Constants.PANEL_SIZE_MAX_CAP)
	end

	local v5 = if vector2.X > vector2.Y then p2 else p

	if vector2.Y > vector2.X then
		p = p2
	end

	if p3 ~= nil then
		p = math.min(p, (math.max(0, vector2.Y - p3)))
	end

	return Vector2.new(v5, p)
end

return computeMobilePanelSize
