local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local LinkStatus = require(script.Parent.LinkStatus)
local getDeepValue = require(script.Parent.dependencies).SocialLibraries.Dictionary.getDeepValue

require(script.Parent.Types)

local FriendshipOriginSourceType = require(CorePackages.Workspace.Packages.FriendsNetworking).Enums.FriendshipOriginSourceType
local Enums = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums)

return function(p1, p2, s1: string?) -- line: 14
	-- upvalues: getDeepValue (copy), LinkStatus (copy), AppPage (copy), Enums (copy), FriendshipOriginSourceType (copy)
	local v11 = getDeepValue(p1, "responseBody.profileLinkResolutionResponseData") or {}
	local shareLinksAnalytics = p2.analyticsImpls.shareLinksAnalytics

	if v11.userId then
		shareLinksAnalytics.resolveLink({
			linkStatus = LinkStatus.Valid,
			linkId = p1.linkId,
			linkType = p1.linkType,
			isViaAppsFlyer = p1.isViaAppsFlyer
		})

		return {{
			{
				name = AppPage.Home
			},
			{
				name = AppPage.ProfilePlatform,
				detail = tostring(v11.userId),
				extraProps = {
					friendshipOriginSourceType = if string.lower(s1 or "") ~= string.lower(Enums.Sources.ProfileShare) then FriendshipOriginSourceType.QrCode.rawValue() else FriendshipOriginSourceType.ProfileShare.rawValue(),
					source = if string.lower(s1 or "") ~= string.lower(Enums.Sources.ProfileShare) then Enums.Sources.QrCode else Enums.Sources.ProfileShare,
					shareLinkId = p1.linkId
				}
			}
		}}
	end

	shareLinksAnalytics.resolveLink({
		linkStatus = LinkStatus.Invalid,
		linkId = p1.linkId,
		linkType = p1.linkType,
		isViaAppsFlyer = p1.isViaAppsFlyer
	})

	return {{
		{
			name = AppPage.Home
		},
		{
			name = AppPage.ShareLinkInvalidModal
		}
	}}
end
