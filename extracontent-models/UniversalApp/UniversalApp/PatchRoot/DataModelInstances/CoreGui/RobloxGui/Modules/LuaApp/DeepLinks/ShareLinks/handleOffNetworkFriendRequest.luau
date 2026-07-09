local SocialLibraries = require(script.Parent.dependencies).SocialLibraries
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local LinkStatus = require(script.Parent.LinkStatus)
local getDeepValue = SocialLibraries.Dictionary.getDeepValue

require(script.Parent.Types)

local CorePackages = game:GetService("CorePackages")
local Enums = require(CorePackages.Workspace.Packages.SocialCommon).Enums
local Enums2 = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums)

return function(p1, p2) -- line: 12
	-- upvalues: getDeepValue (copy), AppPage (copy), Enums (copy), Enums2 (copy), LinkStatus (copy)
	local v11 = getDeepValue(p1, "responseBody.friendInviteData") or {}
	local shareLinksAnalytics = p2.analyticsImpls.shareLinksAnalytics

	if v11.senderUserId then
		local v13 = v11.friendingToken and v11.friendingToken ~= ""
		local status = v11.status

		shareLinksAnalytics.resolveLink({
			linkStatus = status,
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
				detail = tostring(v11.senderUserId),
				extraProps = if not v13 then {
					source = Enums2.Sources.OffNetworkFriendRequest
				} else {
					offNetworkFriendRequestToken = v11.friendingToken,
					shareLinkId = p1.linkId,
					contextualInfoType = Enums.ContextualInfoTypes.OffNetworkFriendRequest,
					source = Enums2.Sources.OffNetworkFriendRequest
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
			name = AppPage.ShareLinkInvalidModal,
			extraProps = {
				closeModal = function() -- line: 58
					-- upvalues: shareLinksAnalytics (copy), p1 (copy), LinkStatus (copy)
					shareLinksAnalytics.errorDialogButtonClick({
						linkId = p1.linkId,
						linkStatus = LinkStatus.Invalid,
						linkType = p1.linkType
					})
				end
			}
		}
	}}
end
