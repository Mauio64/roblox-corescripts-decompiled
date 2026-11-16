local ViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")

local defineFastInt = game:DefineFastInt("MobileBreakpointInspectAndBuy", 850)

local function getViewType(p2)
	local v5 = ViewType.Wide

	if p2.X > p2.Y and p2.X < defineFastInt then
		return ViewType.WideLandscape
	end

	if p2.X < defineFastInt then
		v5 = ViewType.Compact
	end

	return v5
end

return getViewType
