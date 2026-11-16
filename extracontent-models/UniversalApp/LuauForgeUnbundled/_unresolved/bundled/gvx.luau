local HttpService = game:GetService("HttpService")

local urlBuilder = require("@luauforge/bundled/gve").UrlBuilder
local urlBase = require("@luauforge/bundled/gve").UrlBase
local module = require("@luauforge/bundled/gvg")

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "child-requests-api/v1/odp-requests/start-odp-session"
})

local challengeAwareRequest = nil
local function getChallengeAwareRequest()
	if challengeAwareRequest == nil then
		local module2 = require("@luauforge/bundled/gvy")
		challengeAwareRequest = require("@luauforge/bundled/gvz").Middleware.ChallengeRequestWrapper(module2.config({
			requestFunction = function(p2, p3, p4)
				return module2.requestFunctions.RequestInternal(p2, p3, p4)
			end
		}))
	end

	return challengeAwareRequest
end

local function serializeRequest(data)
	return {
		requestType = data.requestType,
		requestDetails = data.requestDetails,
		isOdpInitiatedRequest = data.isOdpInitiatedRequest == true,
		odpProfileId = data.odpProfileId
	}
end

local function postForSession(p2, data)
	return getChallengeAwareRequest()(p2, "POST", {
		postBody = HttpService:JSONEncode({
			requestType = data.requestType,
			requestDetails = data.requestDetails,
			isOdpInitiatedRequest = data.isOdpInitiatedRequest == true,
			odpProfileId = data.odpProfileId
		}),
		headers = { ["Content-Type"] = "application/json" }
	}):andThen(function(p3)
		local responseBody = p3.responseBody

		if responseBody and responseBody.odpSessionId ~= nil then
			return { odpSessionId = responseBody.odpSessionId }
		end

		return module.reject("Failed to decode ODP session response")
	end)
end

return {
	startOdpSession = function(p2)
		return postForSession(v5(), p2)
	end
}
