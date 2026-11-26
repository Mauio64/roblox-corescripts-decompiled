local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")
local HttpService = game:GetService("HttpService")
local BadgesUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Badges/BadgesUrlBuilder")

local function requestRemoveBadge(p2)
	local badgeRemoveUrl = BadgesUrlBuilder.buildBadgeRemoveUrl(p2)

	return HttpRequest.config({
		requestFunction = function(p3, p4, p5)
			return HttpRequest.requestFunctions.RequestInternal(p3, p4, p5)
		end
	})(badgeRemoveUrl, "DELETE", { postBody = HttpService:JSONEncode({}) })
end

return requestRemoveBadge
