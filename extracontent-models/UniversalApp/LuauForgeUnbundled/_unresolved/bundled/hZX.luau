local module = require("@luauforge/bundled/dCp")
local ExperienceInviteStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/ExperienceInviteStatus")
local getDeepValue = require("@luauforge/bundled/hZG").SocialLibraries.Dictionary.getDeepValue
require("@luauforge/bundled/hZh")
local friendshipOriginSourceType = require("@game/CorePackages/Workspace/Packages/NetworkingFriends").Enums.FriendshipOriginSourceType
local module3 = require("@luauforge/bundled/eef")

return function(data, p2, value)
	local v5 = getDeepValue(data, "responseBody.profileLinkResolutionResponseData") or {}
	local shareLinksAnalytics = p2.analyticsImpls.shareLinksAnalytics

	if not v5.userId then
		shareLinksAnalytics.resolveLink({
			linkStatus = ExperienceInviteStatus.Invalid,
			linkId = data.linkId,
			linkType = data.linkType,
			isViaAppsFlyer = data.isViaAppsFlyer
		})

		return {
			{
				{ name = module.Home },
				{ name = module.ShareLinkInvalidModal }
			}
		}
	end

	shareLinksAnalytics.resolveLink({
		linkStatus = ExperienceInviteStatus.Valid,
		linkId = data.linkId,
		linkType = data.linkType,
		isViaAppsFlyer = data.isViaAppsFlyer
	})

	local v8 = { name = module.Home }
	local v9 = {
		name = module.ProfilePlatform,
		detail = tostring(v5.userId),
		extraProps = 0
	}

	local v11 = if string.lower(value or "") == string.lower(module3.Sources.ProfileShare) then friendshipOriginSourceType.ProfileShare.rawValue() else friendshipOriginSourceType.QrCode.rawValue()
	local v12 = if string.lower(value or "") == string.lower(module3.Sources.ProfileShare) then module3.Sources.ProfileShare else module3.Sources.QrCode
	v9.extraProps = {
		friendshipOriginSourceType = v11,
		source = v12,
		shareLinkId = data.linkId
	}
	return {
		{ v8, v9 }
	}
end
