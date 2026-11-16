local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppEnums").AppPage

local function getExperienceDetailsPageKey(p2)
	if p2 == nil then
		return appPage.ExperienceDetail .. "-Unknown"
	end

	return appPage.ExperienceDetail .. "-" .. p2
end

return getExperienceDetailsPageKey
