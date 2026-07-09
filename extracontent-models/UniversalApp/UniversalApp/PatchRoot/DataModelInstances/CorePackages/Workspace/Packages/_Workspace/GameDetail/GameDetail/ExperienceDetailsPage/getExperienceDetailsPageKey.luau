local Parent = script:FindFirstAncestor("GameDetail").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage

local function getExperienceDetailsPageKey(s1: string?) -- line: 6
	-- upvalues: AppPage (copy)
	if s1 == nil then
		return AppPage.ExperienceDetail .. "-Unknown"
	end

	return AppPage.ExperienceDetail .. "-" .. s1
end

return getExperienceDetailsPageKey
