local socialLibraries = require("@luauforge/bundled/fIp").SocialLibraries

local module = require("@luauforge/bundled/dFu")
local ExperienceInviteStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/ExperienceInviteStatus")
local getDeepValue = socialLibraries.Dictionary.getDeepValue
require("@luauforge/bundled/fIx")

local enums = require("@luauforge/bundled/eoT").Enums
local module3 = require("@luauforge/bundled/ehC")

return function(data, p2)
	local v5 = getDeepValue(data, "responseBody.friendInviteData") or {}
	local shareLinksAnalytics = p2.analyticsImpls.shareLinksAnalytics

	if not v5.senderUserId then
		shareLinksAnalytics.resolveLink({
			linkStatus = ExperienceInviteStatus.Invalid,
			linkId = data.linkId,
			linkType = data.linkType,
			isViaAppsFlyer = data.isViaAppsFlyer
		})

		return {
			{
				{ name = module.Home },
				{
					name = module.ShareLinkInvalidModal,
					extraProps = {
						closeModal = function()
							shareLinksAnalytics.errorDialogButtonClick({
								linkId = data.linkId,
								linkStatus = ExperienceInviteStatus.Invalid,
								linkType = data.linkType
							})
						end
					}
				}
			}
		}
	end

	local v6 = v5.friendingToken and v5.friendingToken ~= ""
	local status = v5.status
	shareLinksAnalytics.resolveLink({
		linkStatus = status,
		linkId = data.linkId,
		linkType = data.linkType,
		isViaAppsFlyer = data.isViaAppsFlyer
	})

	local v9 = { name = module.Home }
	local v10 = {
		name = module.ProfilePlatform,
		detail = tostring(v5.senderUserId),
		extraProps = 0
	}

	local v11 = if v6 then {
		offNetworkFriendRequestToken = v5.friendingToken,
		shareLinkId = data.linkId,
		contextualInfoType = enums.ContextualInfoTypes.OffNetworkFriendRequest,
		source = module3.Sources.OffNetworkFriendRequest
	} else { source = module3.Sources.OffNetworkFriendRequest }
	v10.extraProps = v11
	return {
		{ v9, v10 }
	}
end
