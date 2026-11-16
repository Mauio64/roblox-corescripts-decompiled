local module = require("@luauforge/bundled/gaZ")

local networkingGames = module.NetworkingGames
local roduxNetworking = module.RoduxNetworking
local socialLibraries = module.SocialLibraries

local networkStatus = roduxNetworking.Enum.NetworkStatus
local getDeepValue = socialLibraries.Dictionary.getDeepValue
return function(p2, p3)
	local universeId = p3.universeId

	return {
		experienceName = getDeepValue(
			p2,
			string.format("InviteLinkExpiredModal.Games.byGameId.%s.name", universeId)
		),
		isLoading = #universeId > 0 and networkingGames.GetExperiencesDetails.getStatus(p2, universeId) == networkStatus.Fetching,
		screenSize = p2.ScreenSize
	}
end
