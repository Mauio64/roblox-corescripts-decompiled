local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Responsive")

local function useIsDirectional(): boolean
	local v5 = Responsive.useLastInput()
	return Responsive.usePreferredInput() == Responsive.Input.Directional or v5 == Responsive.Input.Directional
end

return useIsDirectional
