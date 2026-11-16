local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpRequest = require(parent.HttpRequest)
local HttpService = game:GetService("HttpService")
local BadgesUrlBuilder = require(script.Parent.BadgesUrlBuilder)

local function requestRemoveBadge(p: string)
	local badgeRemoveUrl = BadgesUrlBuilder.buildBadgeRemoveUrl(p)

	return HttpRequest.config({
		requestFunction = function(p2: string, p3: string, p4)
			return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
		end
	})(badgeRemoveUrl, "DELETE", { postBody = HttpService:JSONEncode({}) })
end

return requestRemoveBadge
