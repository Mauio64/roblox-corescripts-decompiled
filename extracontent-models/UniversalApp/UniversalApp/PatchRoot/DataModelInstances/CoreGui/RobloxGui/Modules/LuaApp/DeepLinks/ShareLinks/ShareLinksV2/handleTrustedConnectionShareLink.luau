local CorePackages = game:GetService("CorePackages")
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)
local LinkStatus = require(script.Parent.Parent.LinkStatus)

require(CorePackages.Workspace.Packages.NavigationRodux)

local SocialLuaAnalytics = require(CorePackages.Workspace.Packages.SocialLuaAnalytics)

require(script.Parent.Parent.Types)

local FFlagTCUpdateProfileCTAButton = require(CorePackages.Workspace.Packages.SharedFlags).FFlagTCUpdateProfileCTAButton
local FFlagTCShareLinkErrorModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagTCShareLinkErrorModal
local v8 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function trustedConnectionModal(p1, p2, p3) -- line: 17
	-- upvalues: AppPage (copy), SocialLuaAnalytics (copy), FFlagTCUpdateProfileCTAButton (copy)
	return {{
		{
			name = AppPage.Home
		},
		{
			name = AppPage.ProfilePlatform,
			detail = p1,
			extraProps = {
				source = SocialLuaAnalytics.Analytics.Enums.Sources.ShareLink
			}
		},
		{
			name = AppPage.TrustedContactsModal,
			props = {
				userId = p1,
				source = SocialLuaAnalytics.Analytics.Enums.Sources.ShareLink,
				modalVariantOverride = SocialLuaAnalytics.Analytics.Enums.Sources.ShareLinkReceiver,
				tokens = p2,
				onRequestAccepted = if not FFlagTCUpdateProfileCTAButton or (not p3 or not p3.RefreshProfilePlatformActionInfo) then nil else function() -- line: 39
					-- upvalues: p3 (copy), p1 (copy)
					p3.RefreshProfilePlatformActionInfo((tostring(p1)))
				end
			}
		}
	}}
end
local function expiredLinkModal(p4) -- line: 49
	-- upvalues: AppPage (copy), FFlagTCShareLinkErrorModal (copy), LinkStatus (copy)
	return {{
		{
			name = AppPage.Home
		},
		if not FFlagTCShareLinkErrorModal then {
			name = AppPage.InviteLinkExpiredModal,
			extraProps = {
				closeModal = p4
			}
		} else {
			name = AppPage.TrustedFriendsShareLinkErrorModal,
			extraProps = {
				errorType = LinkStatus.Expired,
				closeModal = p4
			}
		}
	}}
end
local function invalidLinkModal(p5) -- line: 71
	-- upvalues: AppPage (copy), FFlagTCShareLinkErrorModal (copy), LinkStatus (copy)
	return {{
		{
			name = AppPage.Home
		},
		if not FFlagTCShareLinkErrorModal then {
			name = AppPage.ShareLinkInvalidModal,
			extraProps = {
				closeModal = p5
			}
		} else {
			name = AppPage.TrustedFriendsShareLinkErrorModal,
			extraProps = {
				errorType = LinkStatus.Invalid,
				closeModal = p5
			}
		}
	}}
end

return function(p6, s1: string, t1: {[any]: any}, p7: ((...any) -> ...any), p8) -- line: 93
	-- upvalues: LinkStatus (copy), v8 (copy), trustedConnectionModal (copy), FFlagTCUpdateProfileCTAButton (copy), expiredLinkModal (copy), invalidLinkModal (copy)
	if p6 == LinkStatus.Valid then
		local v22, v23 = v8.validateTrustedFriendLink(s1, t1):await()

		if v22 and v23.responseBody.valid then
			return (trustedConnectionModal(s1, t1, if not FFlagTCUpdateProfileCTAButton then nil else p8))
		end
	elseif p6 == LinkStatus.Expired then
		return (expiredLinkModal(p7))
	end

	return (invalidLinkModal(p7))
end
