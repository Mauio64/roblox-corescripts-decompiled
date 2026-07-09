local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local function selectUserInventoryRecommendationsFetchStatus(p1, s1: string?) -- line: 10
	-- upvalues: RetrievalStatus (copy)
	if not s1 then
		return RetrievalStatus.NotStarted
	end

	assert(s1, "searchUuid is non-nil. Silence type checker.")

	local v6 = p1.AvatarExperience.AvatarEditor.UserInventoryRecommendationsFetchStatus[s1]

	if v6 == nil then
		v6 = RetrievalStatus.NotStarted
	end

	return v6
end

return selectUserInventoryRecommendationsFetchStatus
