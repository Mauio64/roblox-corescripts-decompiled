local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/ReactOtter")
local getUserSettings = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Utils/getUserSettings")

local function makeOtterSpringValue(p2, p3)
	if getUserSettings().ReducedMotion then
		return ReactOtter.instant(p2)
	end

	return ReactOtter.spring(p2, p3)
end

return makeOtterSpringValue
