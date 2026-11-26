local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/UrlBuilder").UrlBase
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Promise")

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "child-requests-api/v1/odp-requests/start-odp-session"
})

local challengeAwareRequest = nil
local function getChallengeAwareRequest()
	if challengeAwareRequest == nil then
		local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/HttpRequest")
		challengeAwareRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/GenericChallenges").Middleware.ChallengeRequestWrapper(HttpRequest.config({
			requestFunction = function(p2, p3, p4)
				return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
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

		return Promise.reject("Failed to decode ODP session response")
	end)
end

return {
	startOdpSession = function(p2)
		return postForSession(v5(), p2)
	end
}
