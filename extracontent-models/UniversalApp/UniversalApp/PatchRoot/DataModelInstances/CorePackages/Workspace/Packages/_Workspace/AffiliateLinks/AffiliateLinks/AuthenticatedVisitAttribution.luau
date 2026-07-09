local HttpService = game:GetService("HttpService")
local AffiliateLinks = script:FindFirstAncestor("AffiliateLinks")
local AffiliateLinksParent = AffiliateLinks.Parent
local Promise = require(AffiliateLinksParent.Promise)
local Url = require(AffiliateLinksParent.Http).Url

require(AffiliateLinksParent.Http)

local default = require(AffiliateLinksParent.LoggingProtocol).default
local AffiliateJoinLinkResolver = require(AffiliateLinks.AffiliateJoinLinkResolver)
local TelemetryConfigs = require(AffiliateLinks.TelemetryConfigs)
local t1 = {
	attribute = function(p1, s1: string, s2: string, s3: string, b1: boolean) -- line: 20
		-- upvalues: Promise (copy), HttpService (copy), Url (copy)
		return Promise.new(function(resolve) -- line: 27
			-- upvalues: HttpService (copy), s1 (copy), s2 (copy), s3 (copy), b1 (copy), Url (copy), p1 (copy)
			local json = HttpService:JSONEncode({
				linkId = s1,
				referralUrl = s2,
				linkType = s3,
				userDidLogIn = b1
			})
			local v21 = string.format("%saffiliate-links/v1/events/authenticated-visit", Url.APIS_URL)

			p1(v21, "POST", {
				postBody = json
			}):await()
			resolve()
		end)
	end
}

function t1.attributeJoinLink(p2, s4: string, s5: string, b2: boolean) -- line: 40
	-- upvalues: Promise (copy), AffiliateJoinLinkResolver (copy), t1 (copy), default (copy), TelemetryConfigs (copy)
	return Promise.new(function(resolve) -- line: 46
		-- upvalues: AffiliateJoinLinkResolver (copy), p2 (copy), s5 (copy), t1 (copy), s4 (copy), b2 (copy), default (copy), TelemetryConfigs (copy)
		local v23, v24 = AffiliateJoinLinkResolver.resolveReferralCode(p2, s5):await()

		if v23 then
			t1.attribute(p2, v24.responseBody.linkId, s4, v24.responseBody.linkType, b2):await()
		else
			default:logRobloxTelemetryCounter(TelemetryConfigs.AttributeJoinLinkFailureCounter)
		end

		resolve()
	end)
end

return t1
