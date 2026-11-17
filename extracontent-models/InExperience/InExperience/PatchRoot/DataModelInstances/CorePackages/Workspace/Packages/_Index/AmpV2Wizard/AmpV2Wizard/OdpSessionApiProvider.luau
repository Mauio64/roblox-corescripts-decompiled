local parent = script:FindFirstAncestor("AmpV2Wizard").Parent

local HttpService = game:GetService("HttpService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase
local Promise = require(parent.Promise)

local v = urlBuilder.new({
	base = UrlBase.APIS,
	path = "child-requests-api/v1/odp-requests/start-odp-session"
})

local challengeAwareRequest = nil
local function getChallengeAwareRequest()
	if challengeAwareRequest == nil then
		local HttpRequest = require(parent.HttpRequest)
		local GenericChallenges = require(parent.GenericChallenges)
		challengeAwareRequest = GenericChallenges.Middleware.ChallengeRequestWrapper(HttpRequest.config({
			requestFunction = function(p, p2, p3)
				return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
			end
		}))
	end

	return challengeAwareRequest
end

local function serializeRequest(data) -- 1 equivalent call inferred from this helper
	return {
		requestType = data.requestType,
		requestDetails = data.requestDetails,
		isOdpInitiatedRequest = data.isOdpInitiatedRequest == true,
		odpProfileId = data.odpProfileId
	}
end

local function postForSession(p: string, data)
	return getChallengeAwareRequest()(p, "POST", {
		postBody = HttpService:JSONEncode(serializeRequest(data)), -- inferred equivalent call
		headers = { ["Content-Type"] = "application/json" }
	}):andThen(function(p2)
		local responseBody = p2.responseBody

		if responseBody and responseBody.odpSessionId ~= nil then
			return { odpSessionId = responseBody.odpSessionId }
		end

		return Promise.reject("Failed to decode ODP session response")
	end)
end

return {
	startOdpSession = function(p)
		return postForSession(v(), p)
	end
}
