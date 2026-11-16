local parent = script:FindFirstAncestor("GameInvite").Parent

local ExperienceService = require(parent.ExperienceService)
local SharedFlags = require(parent.SharedFlags)
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies

local experienceService = ExperienceService.ExperienceService
local GameParams = ExperienceService.GameParams

local function joinFriendFromExperience(data)
	local v

	if data.placeId == "" then
		v = data.rootPlaceId
	else
		v = data.placeId
	end

	local fromParams = GameParams.fromParams
	local v2 = { userId = data.userId, placeId = 0, referralPage = "GameInviteFriendsList" }
	local placeId

	if v ~= "" then
		placeId = tonumber(v)
	end

	v2.placeId = placeId
	local v3 = fromParams(v2)

	if not isSubjectToDesktopPolicies() then
		game:Shutdown()
	end

	experienceService:LaunchExperience(v3, "GameInviteFriendsListFromInExp", nil)
end

return joinFriendFromExperience
