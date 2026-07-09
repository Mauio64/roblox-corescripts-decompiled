local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)
local v3 = game:DefineFastInt("MobileBreakpointInspectAndBuy", 850)

local function getViewType(vector2: Vector2) -- line: 13
	-- upvalues: ViewType (copy), v3 (copy)
	local Wide = ViewType.Wide

	if vector2.X > vector2.Y and vector2.X < v3 then
		return ViewType.WideLandscape
	end

	if vector2.X < v3 then
		Wide = ViewType.Compact
	end

	return Wide
end

return getViewType
