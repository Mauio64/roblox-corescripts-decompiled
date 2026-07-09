local CorePackages = game:GetService("CorePackages")
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage

require(CorePackages.Workspace.Packages.NavigationRodux)

local ShareLinksRodux = require(script.Parent.dependencies).ShareLinksRodux
local SocialStopwatch = require(CorePackages.Workspace.Packages.SocialStopwatch)
local handleExperienceInviteLinkResponse = require(script.Parent.handleExperienceInviteLinkResponse)
local handleInvalidLink = require(script.Parent.handleInvalidLink)
local handleOffNetworkFriendRequest = require(script.Parent.handleOffNetworkFriendRequest)
local handleExperienceDetailsLink = require(script.Parent.handleExperienceDetailsLink)
local handleExperienceAffiliateLink = require(script.Parent.handleExperienceAffiliateLink)
local handleAvatarItemDetailsLink = require(script.Parent.handleAvatarItemDetailsLink)
local handleNotificationExperienceInviteLink = require(script.Parent.handleNotificationExperienceInviteLink)
local handleProfileLink = require(script.Parent.handleProfileLink)
local handleExperienceEventLink = require(script.Parent.handleExperienceEventLink)
local handleShareLinkV2 = require(script.Parent.ShareLinksV2.handleShareLinkV2)
local LinkStatus = ShareLinksRodux.Enums.LinkStatus
local ShareLinkTypes = require(script.Parent.ShareLinkTypes)

require(script.Parent.Types)

local Cryo = require(CorePackages.Packages.Cryo)
local FFlagTCShareLinkReceiverUI = require(CorePackages.Workspace.Packages.SharedFlags).FFlagTCShareLinkReceiverUI
local FFlagTCShareLinkErrorModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagTCShareLinkErrorModal

return function(t1: {[any]: any}, p1) -- line: 27
	-- upvalues: ShareLinkTypes (copy), SocialStopwatch (copy), FFlagTCShareLinkReceiverUI (copy), FFlagTCShareLinkErrorModal (copy), Cryo (copy), handleShareLinkV2 (copy), AppPage (copy), LinkStatus (copy), handleInvalidLink (copy), handleExperienceInviteLinkResponse (copy), handleOffNetworkFriendRequest (copy), handleExperienceDetailsLink (copy), handleExperienceAffiliateLink (copy), handleAvatarItemDetailsLink (copy), handleProfileLink (copy), handleNotificationExperienceInviteLink (copy), handleExperienceEventLink (copy)
	local v22 = string.lower(t1.type or ShareLinkTypes.Unknown)
	local code = t1.code
	local shareLinksAnalytics = p1.analyticsImpls.shareLinksAnalytics

	SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.ShareLinkOpened)
	p1.closeCentralOverlay()

	if t1.v == "v2" or FFlagTCShareLinkReceiverUI and t1.v == "v2-filtered" then
		if FFlagTCShareLinkErrorModal then
			return (p1.resolveLinkFromLinkIdV2(code):andThen(function(p2) -- line: 41
				-- upvalues: shareLinksAnalytics (copy), Cryo (copy), t1 (copy), code (copy), handleShareLinkV2 (copy), v22 (copy), p1 (copy)
				shareLinksAnalytics.openAppViaShareLink(Cryo.Dictionary.union(t1, {
					code = Cryo.None,
					linkId = code,
					linkType = p2.responseBody.linkType,
					type = Cryo.None
				}))

				return handleShareLinkV2({
					linkId = code,
					linkType = v22,
					responseBody = p2.responseBody,
					isViaAppsFlyer = t1.isViaAppsFlyer
				}, p1)
			end):catch(function() -- line: 56
				-- upvalues: SocialStopwatch (copy), AppPage (copy), shareLinksAnalytics (copy), code (copy), v22 (copy), LinkStatus (copy)
				SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.ShareLinkOpened)

				return {{
					{
						name = AppPage.Home
					},
					{
						name = AppPage.ShareLinkInvalidModal,
						extraProps = {
							closeModal = function() -- line: 64
								-- upvalues: shareLinksAnalytics (copy), code (copy), v22 (copy), LinkStatus (copy)
								shareLinksAnalytics.errorJoinDialogButtonClick({
									linkId = code,
									linkType = v22,
									linkStatus = LinkStatus.Invalid.rawValue()
								})
							end
						}
					}
				}}
			end))
		end

		return (p1.resolveLinkFromLinkIdV2(code):andThen(function(p3) -- line: 76
			-- upvalues: shareLinksAnalytics (copy), Cryo (copy), t1 (copy), code (copy), handleShareLinkV2 (copy), v22 (copy), p1 (copy)
			shareLinksAnalytics.openAppViaShareLink(Cryo.Dictionary.union(t1, {
				code = Cryo.None,
				linkId = code,
				linkType = p3.responseBody.linkType,
				type = Cryo.None
			}))

			return handleShareLinkV2({
				linkId = code,
				linkType = v22,
				responseBody = p3.responseBody,
				isViaAppsFlyer = t1.isViaAppsFlyer
			}, p1)
		end))
	end

	shareLinksAnalytics.openAppViaShareLink(Cryo.Dictionary.join(t1, {
		code = Cryo.None,
		linkId = code,
		linkType = v22,
		type = Cryo.None
	}))

	if v22 == string.lower(ShareLinkTypes.Home) then
		SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.ShareLinkOpened)

		return {{{
			name = AppPage.Home
		}}}
	end

	if v22 == string.lower(ShareLinkTypes.Unknown) then
		SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.ShareLinkOpened)

		return handleInvalidLink({
			type = v22,
			code = t1.code,
			isViaAppsFlyer = t1.isViaAppsFlyer,
			stamp = t1.stamp
		}, p1)
	end

	return p1.resolveLinkFromLinkId(code, v22):andThen(function(p4) -- line: 121
		-- upvalues: Cryo (copy), t1 (copy), v22 (copy), code (copy), ShareLinkTypes (copy), handleExperienceInviteLinkResponse (copy), p1 (copy), handleOffNetworkFriendRequest (copy), handleExperienceDetailsLink (copy), handleExperienceAffiliateLink (copy), handleAvatarItemDetailsLink (copy), handleProfileLink (copy), handleNotificationExperienceInviteLink (copy), handleExperienceEventLink (copy), SocialStopwatch (copy)
		local v28 = Cryo.Dictionary.join(t1, {
			code = Cryo.None,
			linkType = v22,
			linkId = code,
			responseBody = p4.responseBody
		})

		if v22 == string.lower(ShareLinkTypes.ExperienceInviteLinkType) or v22 == string.lower(ShareLinkTypes.PrivateServerLinkType) then
			return (handleExperienceInviteLinkResponse(v28, p1))
		end

		if v22 == string.lower(ShareLinkTypes.ScreenshotInviteLinkType) then
			return handleExperienceInviteLinkResponse(v28, p1)
		end

		if v22 == string.lower(ShareLinkTypes.OffNetworkFriendRequestLinkType) then
			return handleOffNetworkFriendRequest(v28, p1)
		end

		if v22 == string.lower(ShareLinkTypes.ExperienceDetails) then
			return handleExperienceDetailsLink(v28, p1)
		end

		if v22 == string.lower(ShareLinkTypes.ExperienceAffiliate) then
			return handleExperienceAffiliateLink(v28, p1)
		end

		if v22 == string.lower(ShareLinkTypes.AvatarItemDetails) then
			return handleAvatarItemDetailsLink(v28, p1)
		end

		if v22 == string.lower(ShareLinkTypes.Profile) then
			return handleProfileLink(v28, p1, t1.source)
		end

		if v22 == string.lower(ShareLinkTypes.NotificationExperienceInviteLinkType) then
			return handleNotificationExperienceInviteLink(v28, p1)
		end

		if v22 == string.lower(ShareLinkTypes.ExperienceEvent) then
			return handleExperienceEventLink(v28, p1)
		end

		SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.ShareLinkOpened)

		return nil
	end):catch(function() -- line: 155
		-- upvalues: SocialStopwatch (copy), AppPage (copy), shareLinksAnalytics (copy), code (copy), v22 (copy), LinkStatus (copy)
		SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.ShareLinkOpened)

		return {
			{{
				name = AppPage.Games
			}},
			{
				{
					name = AppPage.Games
				},
				{
					name = AppPage.ShareLinkInvalidModal,
					extraProps = {
						closeModal = function() -- line: 166
							-- upvalues: shareLinksAnalytics (copy), code (copy), v22 (copy), LinkStatus (copy)
							shareLinksAnalytics.errorJoinDialogButtonClick({
								linkId = code,
								linkType = v22,
								linkStatus = LinkStatus.Invalid.rawValue()
							})
						end
					}
				}
			}
		}
	end)
end
