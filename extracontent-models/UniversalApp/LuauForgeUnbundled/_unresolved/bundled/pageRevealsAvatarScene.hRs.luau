local module = require("@luauforge/bundled/dCp")

local function pageRevealsAvatarScene(p2): boolean
	return p2 == module.AvatarExperienceRoot
		or p2 == module.AvatarExperienceWrapper
		or p2 == module.AvatarExperienceWrapperTransparent
end

return pageRevealsAvatarScene
