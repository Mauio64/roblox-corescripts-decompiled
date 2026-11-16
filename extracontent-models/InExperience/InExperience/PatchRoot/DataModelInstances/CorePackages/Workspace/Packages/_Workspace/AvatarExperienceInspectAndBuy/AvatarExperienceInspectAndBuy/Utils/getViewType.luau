local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)

local defineFastInt = game:DefineFastInt("MobileBreakpointInspectAndBuy", 850)

local function getViewType(vector2: Vector2)
	local wide = ViewType.Wide

	if vector2.X > vector2.Y and vector2.X < defineFastInt then
		return ViewType.WideLandscape
	end

	return if vector2.X < defineFastInt then ViewType.Compact else wide
end

return getViewType
