local InviteLinkExpiredModal = script:FindFirstAncestor("InviteLinkExpiredModal")
local dependencies = require(InviteLinkExpiredModal.dependencies)
local NetworkingGames = dependencies.NetworkingGames
local RoduxNetworking = dependencies.RoduxNetworking
local SocialLibraries = dependencies.SocialLibraries
local NetworkStatus = RoduxNetworking.Enum.NetworkStatus
local getDeepValue = SocialLibraries.Dictionary.getDeepValue

return function(p1, p2) -- line: 10
	-- upvalues: getDeepValue (copy), NetworkingGames (copy), NetworkStatus (copy)
	local universeId = p2.universeId
	local v11 = getDeepValue(p1, string.format("InviteLinkExpiredModal.Games.byGameId.%s.name", universeId))
	local v12 = #universeId > 0 and NetworkingGames.GetExperiencesDetails.getStatus(p1, universeId) == NetworkStatus.Fetching

	return {
		experienceName = v11,
		isLoading = v12,
		screenSize = p1.ScreenSize
	}
end
