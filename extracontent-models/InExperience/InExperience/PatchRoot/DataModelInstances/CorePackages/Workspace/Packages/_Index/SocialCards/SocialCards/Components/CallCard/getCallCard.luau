local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("SocialCards").Parent

local UrlBuilder = require(parent.UrlBuilder)

require(script.Parent.parseCallCard)

local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local function getCallCard(callId: string, callback)
	HttpService:RequestInternal({
		Headers = { Accept = "application/json" },
		Method = "GET",
		Url = urlBuilder.new({
			base = UrlBase.APIS,
			path = "call/v2/get-call-card",
			query = { callId = callId }
		})()
	}):Start(function(_, p)
		if p.StatusCode == 200 then
			callback(HttpService:JSONDecode(p.Body))
		end
	end)
end

return getCallCard
