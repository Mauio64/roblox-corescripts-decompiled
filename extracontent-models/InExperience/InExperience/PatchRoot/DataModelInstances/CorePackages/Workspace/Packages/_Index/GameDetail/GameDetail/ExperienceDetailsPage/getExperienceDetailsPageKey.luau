local parent = script:FindFirstAncestor("GameDetail").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local function getExperienceDetailsPageKey(p: string?)
	if p == nil then
		return AppPage.ExperienceDetail .. "-Unknown"
	end

	return AppPage.ExperienceDetail .. "-" .. p
end

return getExperienceDetailsPageKey
