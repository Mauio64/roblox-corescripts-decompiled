local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpRequest = require(Parent.HttpRequest)
local HttpService = game:GetService("HttpService")
local BadgesUrlBuilder = require(script.Parent.BadgesUrlBuilder)

local function requestRemoveBadge(s1: string) -- line: 10
	-- upvalues: BadgesUrlBuilder (copy), HttpRequest (copy), HttpService (copy)
	local v7 = BadgesUrlBuilder.buildBadgeRemoveUrl(s1)

	return HttpRequest.config({
		requestFunction = function(s2: string, s3: string, p1) -- line: 14
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.RequestInternal(s2, s3, p1)
		end
	})(v7, "DELETE", {
		postBody = HttpService:JSONEncode({})
	})
end

return requestRemoveBadge
