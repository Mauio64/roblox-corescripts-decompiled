local ExperienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/ExperienceService")
local isSubjectToDesktopPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").isSubjectToDesktopPolicies

local experienceService = ExperienceService.ExperienceService
local gameParams = ExperienceService.GameParams

local function joinFriendFromExperience(data)
	local v5 = if data.placeId == "" then data.rootPlaceId else data.placeId
	local fromParams = gameParams.fromParams
	local v6 = {
		userId = data.userId,
		placeId = 0,
		referralPage = "GameInviteFriendsList"
	}
	local v7 = if v5 ~= "" then tonumber(v5) else nil
	v6.placeId = v7
	local v8 = fromParams(v6)

	if not isSubjectToDesktopPolicies() then
		game:Shutdown()
	end

	experienceService:LaunchExperience(v8, "GameInviteFriendsListFromInExp", nil)
end

return joinFriendFromExperience
