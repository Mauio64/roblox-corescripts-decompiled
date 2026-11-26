local NO_BACKGROUND_ASSET_ID = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/constants").NO_BACKGROUND_ASSET_ID

local function normalizeBackgroundId(p2)
	if p2 == nil or p2 == NO_BACKGROUND_ASSET_ID then
		return nil
	end

	return p2
end

return normalizeBackgroundId
