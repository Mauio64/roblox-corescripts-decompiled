local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local UrlBuilder = require(AmpUpsellParent.UrlBuilder).UrlBuilder
local UrlBase = require(AmpUpsellParent.UrlBuilder).UrlBase
local HttpService = game:GetService("HttpService")
local VPCRequestTypeEnum = require(AmpUpsell.Common.Enums).VPCRequestTypeEnum
local v7 = UrlBuilder.new({
	path = "child-requests-api/v1/send-request-to-new-parent",
	base = UrlBase.APIS
})
local v8 = UrlBuilder.new({
	path = "child-requests-api/v1/send-request-to-all-parents",
	base = UrlBase.APIS
})
local v9 = UrlBuilder.new({
	path = "user-settings-api/v1/account-insights/parent-emails",
	base = UrlBase.APIS
})

return {
	sendRequestToNewParent = function(p1, s1: string, t1: {[any]: any}, t2: {[any]: any}) -- line: 29
		-- upvalues: v7 (copy), VPCRequestTypeEnum (copy), HttpService (copy)
		local v14 = v7()
		local v15 = t1 == nil and VPCRequestTypeEnum.LinkToChild or t1[1]

		return p1(v14, "POST", {
			postBody = HttpService:JSONEncode({
				email = s1,
				requestType = v15,
				requestDetails = t2
			}),
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}):andThen(function(p2) -- line: 50
			return {
				sessionId = p2.responseBody.sessionId,
				lockedUntil = p2.responseBody.lockedUntil
			}
		end):catch(function(p3) -- line: 56
			-- upvalues: HttpService (copy)
			local _, result = pcall(function() -- line: 57
				-- upvalues: HttpService (copy), p3 (copy)
				return HttpService:JSONDecode(p3.Body)
			end)

			error({
				code = result.code,
				message = result.message
			})
		end)
	end,
	sendRequestToAllParents = function(p4, t3: {[any]: any}, t4: {[any]: any}?) -- line: 72
		-- upvalues: v8 (copy), HttpService (copy)
		local v19 = v8()
		local v20 = t3[1]

		return p4(v19, "POST", {
			postBody = HttpService:JSONEncode({
				requestType = v20,
				requestDetails = t4
			}),
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}):andThen(function(p5) -- line: 90
			return {
				sessionId = p5.responseBody.sessionId,
				lockedUntil = p5.responseBody.lockedUntil
			}
		end):catch(function(p6) -- line: 96
			-- upvalues: HttpService (copy)
			local _, result = pcall(function() -- line: 97
				-- upvalues: HttpService (copy), p6 (copy)
				return HttpService:JSONDecode(p6.Body)
			end)

			error({
				code = result.code,
				message = result.message
			})
		end)
	end,
	getLinkedParentEmails = function(p7) -- line: 110
		-- upvalues: v9 (copy)
		return p7(v9(), "GET", {
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}):andThen(function(p8) -- line: 118
			return {
				parentEmails = p8.responseBody.parentEmails
			}
		end):catch(function(_) -- line: 123
			error({})
		end)
	end
}
