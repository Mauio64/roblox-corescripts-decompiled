local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase
local HttpService = game:GetService("HttpService")
local Enums = require(AmpUpsell.Common.Enums)
local VPCRequestTypeEnum = Enums.VPCRequestTypeEnum

local v = urlBuilder.new({
	base = UrlBase.APIS,
	path = "child-requests-api/v1/send-request-to-new-parent"
})

local v2 = urlBuilder.new({
	base = UrlBase.APIS,
	path = "child-requests-api/v1/send-request-to-all-parents"
})

local v3 = urlBuilder.new({
	base = UrlBase.APIS,
	path = "user-settings-api/v1/account-insights/parent-emails"
})
local VPCApiProvider = {}

function VPCApiProvider.sendRequestToNewParent(callback, email: string, list, requestDetails, analyticsSessionId: string?)
	local v4 = v()
	local v5 = {
		email = email,
		requestType = list == nil and VPCRequestTypeEnum.LinkToChild or list[1],
		requestDetails = requestDetails,
		analyticsSessionId = 0
	}

	if analyticsSessionId == "" then
		analyticsSessionId = nil
	end

	v5.analyticsSessionId = analyticsSessionId
	return callback(v4, "POST", {
		postBody = HttpService:JSONEncode(v5),
		headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}):andThen(function(p)
		return { sessionId = p.responseBody.sessionId, lockedUntil = p.responseBody.lockedUntil }
	end):catch(function(p)
		local _, result = pcall(function()
			return HttpService:JSONDecode(p.Body)
		end)

		error({ code = result.code, message = result.message })
	end)
end

function VPCApiProvider.sendRequestToAllParents(callback, list, requestDetails, analyticsSessionId: string?)
	local v4 = v2()
	local v5 = { requestType = list[1], requestDetails = requestDetails, analyticsSessionId = 0 }

	if analyticsSessionId == "" then
		analyticsSessionId = nil
	end

	v5.analyticsSessionId = analyticsSessionId
	return callback(v4, "POST", {
		postBody = HttpService:JSONEncode(v5),
		headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}):andThen(function(p)
		return { sessionId = p.responseBody.sessionId, lockedUntil = p.responseBody.lockedUntil }
	end):catch(function(p)
		local _, result = pcall(function()
			return HttpService:JSONDecode(p.Body)
		end)

		error({ code = result.code, message = result.message })
	end)
end

function VPCApiProvider.getLinkedParentEmails(callback)
	return callback(v3(), "GET", {
		headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}):andThen(function(p)
		return { parentEmails = p.responseBody.parentEmails }
	end):catch(function(_)
		error({})
	end)
end

return VPCApiProvider
