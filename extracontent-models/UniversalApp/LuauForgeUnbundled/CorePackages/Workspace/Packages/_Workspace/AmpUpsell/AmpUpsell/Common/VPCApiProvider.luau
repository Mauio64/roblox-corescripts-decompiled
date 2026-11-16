local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UrlBuilder").UrlBase
local HttpService = game:GetService("HttpService")
local vpcRequestTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Enums").VPCRequestTypeEnum

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "child-requests-api/v1/send-request-to-new-parent"
})

local v6 = urlBuilder.new({
	base = urlBase.APIS,
	path = "child-requests-api/v1/send-request-to-all-parents"
})

local v7 = urlBuilder.new({
	base = urlBase.APIS,
	path = "user-settings-api/v1/account-insights/parent-emails"
})

return {
	sendRequestToNewParent = function(callback, p2, list, p3, analyticsSessionId)
		local v8 = v5()
		local linkToChild = list == nil and vpcRequestTypeEnum.LinkToChild or list[1]

		if analyticsSessionId == "" then
			analyticsSessionId = nil
		end

		return callback(v8, "POST", {
			postBody = HttpService:JSONEncode({
				email = p2,
				requestType = linkToChild,
				requestDetails = p3,
				analyticsSessionId = analyticsSessionId
			}),
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}):andThen(function(p4)
			return {
				sessionId = p4.responseBody.sessionId,
				lockedUntil = p4.responseBody.lockedUntil
			}
		end):catch(function(p4)
			local success, result = pcall(function()
				return HttpService:JSONDecode(p4.Body)
			end)

			error({ code = result.code, message = result.message })
		end)
	end,
	sendRequestToAllParents = function(callback, list, p2, analyticsSessionId)
		local v8 = v6()
		local item = list[1]

		if analyticsSessionId == "" then
			analyticsSessionId = nil
		end

		return callback(v8, "POST", {
			postBody = HttpService:JSONEncode({
				requestType = item,
				requestDetails = p2,
				analyticsSessionId = analyticsSessionId
			}),
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}):andThen(function(p3)
			return {
				sessionId = p3.responseBody.sessionId,
				lockedUntil = p3.responseBody.lockedUntil
			}
		end):catch(function(p3)
			local success, result = pcall(function()
				return HttpService:JSONDecode(p3.Body)
			end)

			error({ code = result.code, message = result.message })
		end)
	end,
	getLinkedParentEmails = function(callback)
		return callback(v7(), "GET", {
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}):andThen(function(p2)
			return { parentEmails = p2.responseBody.parentEmails }
		end):catch(function(p2)
			error({})
		end)
	end
}
