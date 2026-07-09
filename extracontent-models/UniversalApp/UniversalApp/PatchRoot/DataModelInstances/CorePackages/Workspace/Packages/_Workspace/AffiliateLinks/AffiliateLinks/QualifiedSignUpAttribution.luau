local HttpService = game:GetService("HttpService")
local AffiliateLinks = script:FindFirstAncestor("AffiliateLinks")
local AffiliateLinksParent = AffiliateLinks.Parent
local Promise = require(AffiliateLinksParent.Promise)
local Url = require(AffiliateLinksParent.Http).Url

require(AffiliateLinksParent.Http)

local default = require(AffiliateLinksParent.LoggingProtocol).default
local AffiliateJoinLinkResolver = require(AffiliateLinks.AffiliateJoinLinkResolver)
local TelemetryConfigs = require(AffiliateLinks.TelemetryConfigs)
local GetFFlagEnableAffiliateLinksQualifiedSignUpTracking = require(AffiliateLinksParent.SharedFlags).GetFFlagEnableAffiliateLinksQualifiedSignUpTracking
local t1 = {
	attribute = function(p1, s1: string, s2: string, s3: string) -- line: 23
		-- upvalues: GetFFlagEnableAffiliateLinksQualifiedSignUpTracking (copy), Promise (copy), HttpService (copy), Url (copy)
		if not GetFFlagEnableAffiliateLinksQualifiedSignUpTracking() then
			return Promise.resolve()
		end

		return Promise.new(function(resolve) -- line: 33
			-- upvalues: HttpService (copy), s1 (copy), s2 (copy), s3 (copy), Url (copy), p1 (copy)
			local json = HttpService:JSONEncode({
				linkId = s1,
				referralUrl = s2,
				linkType = s3
			})
			local v20 = string.format("%saffiliate-links/v1/events/qualified-signup", Url.APIS_URL)

			p1(v20, "POST", {
				postBody = json
			}):await()
			resolve()
		end)
	end
}

function t1.attributeJoinLink(p2, s4: string, s5: string) -- line: 45
	-- upvalues: Promise (copy), AffiliateJoinLinkResolver (copy), t1 (copy), default (copy), TelemetryConfigs (copy)
	return Promise.new(function(resolve) -- line: 50
		-- upvalues: AffiliateJoinLinkResolver (copy), p2 (copy), s5 (copy), t1 (copy), s4 (copy), default (copy), TelemetryConfigs (copy)
		local v22, v23 = AffiliateJoinLinkResolver.resolveReferralCode(p2, s5):await()

		if v22 then
			t1.attribute(p2, v23.responseBody.linkId, s4, v23.responseBody.linkType):await()
		else
			default:logRobloxTelemetryCounter(TelemetryConfigs.AttributeJoinLinkFailureCounter)
		end

		resolve()
	end)
end

return t1
