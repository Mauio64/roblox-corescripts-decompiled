local HttpService = game:GetService("HttpService")

local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/UrlBuilder")

require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/parseCallCard")

local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase

local function getCallCard(p2, callback)
	HttpService:RequestInternal({
		Headers = { Accept = "application/json" },
		Method = "GET",
		Url = urlBuilder.new({
			base = urlBase.APIS,
			path = "call/v2/get-call-card",
			query = { callId = p2 }
		})()
	}):Start(function(p3, p4)
		if p4.StatusCode == 200 then
			callback(HttpService:JSONDecode(p4.Body))
		end
	end)
end

return getCallCard
