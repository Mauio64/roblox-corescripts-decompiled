local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Common.Constants)

local function lerpRange(n1: number, n2: number, n3: number, n4: number, n5: number) -- line: 14
	return (n1 - n2) * (n5 - n4) / (n3 - n2) + n4
end
local function computeMobilePanelSize(vector2: Vector2, n6: number, n7: number) -- line: 20
	-- upvalues: Constants (copy)
	local v13 = math.min(vector2.X, vector2.Y)
	local v14 = math.max(vector2.X, vector2.Y)
	local PANEL_BORDER = Constants.PANEL_BORDER
	local v16 = (v13 - 320) * 60 / 55 + 270
	local v17 = (v14 - 480) * 46 / 190 + 434
	local v18 = if not (v16 > Constants.PANEL_SIZE_MIN_CAP) then math.clamp(v16, math.min(270, v13 - PANEL_BORDER), Constants.PANEL_SIZE_MIN_CAP) else n6
	local v19 = if not (v17 > Constants.PANEL_SIZE_MAX_CAP) then math.clamp(v17, math.min(434, v14 - PANEL_BORDER), Constants.PANEL_SIZE_MAX_CAP) else n7
	local v20 = if not (vector2.X > vector2.Y) then v18 else v19
	local v21 = if not (vector2.Y > vector2.X) then v18 else v19

	return Vector2.new(v20, v21)
end

return computeMobilePanelSize
