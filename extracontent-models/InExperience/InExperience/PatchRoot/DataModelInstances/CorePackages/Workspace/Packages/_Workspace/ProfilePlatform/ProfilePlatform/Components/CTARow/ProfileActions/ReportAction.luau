local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Http = require(ProfilePlatformParent.Http)
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local RobloxAppEnums = require(ProfilePlatformParent.RobloxAppEnums)
local Url = Http.Url
local AppPage = RobloxAppEnums.AppPage
local NavigateDown = require(ProfilePlatformParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands
local CloseCentralOverlay = require(ProfilePlatformParent.CentralOverlay).Thunks.CloseCentralOverlay
local AbuseVector = require(ProfilePlatformParent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(ProfilePlatformParent.GenericAbuseReporting.OpenDynamicAbuseReport)
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes
local FFlagEnableAbuseReportRevampFlow = SharedFlags.FFlagEnableAbuseReportRevampFlow
local FFlagEnableAbuseReportRevampProfileAndGroup = require(ProfilePlatform.Flags.FFlagEnableAbuseReportRevampProfileAndGroup)

return {
	[Enums.ProfileActions.Report] = function(p1) -- line: 35
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), FFlagEnableAbuseReportRevampFlow (copy), FFlagEnableAbuseReportRevampProfileAndGroup (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), refreshProfilePlatformActionInfo (copy), AppPage (copy), Url (copy), TextKeys (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy)
		return {
			text = p1.localized[Enums.ProfileActions.Report],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 39
					-- upvalues: p1 (copy), EventNames (copy), FFlagEnableAbuseReportRevampFlow (copy), FFlagEnableAbuseReportRevampProfileAndGroup (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), refreshProfilePlatformActionInfo (copy), AppPage (copy), Url (copy), TextKeys (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonReport, {
						buttonSurface = p1.buttonSurface
					})

					if FFlagEnableAbuseReportRevampFlow and FFlagEnableAbuseReportRevampProfileAndGroup then
						p1.dispatch(OpenDynamicAbuseReport({
							abuseVector = AbuseVector.UserProfile,
							targetId = p1.profileId,
							onClose = function() -- line: 48
								-- upvalues: p1 (copy), CloseCentralOverlay (copy), refreshProfilePlatformActionInfo (copy)
								p1.dispatch(CloseCentralOverlay())
								p1.dispatch(refreshProfilePlatformActionInfo(p1.profileId, p1.actionsComponentRequest))
							end
						}))

						return
					end

					local t1 = {
						name = AppPage.GenericWebPage,
						detail = `{ Url.BASE_URL }abusereport/userprofile?id={ p1.profileId }`,
						extraProps = {
							titleKey = TextKeys.Report
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v10.down(v10.fromLegacyPage(t1))

						return
					end

					p1.dispatch(NavigateDown(t1))
				end,
				[ProfileTypes.Community] = function() -- line: 70
					-- upvalues: p1 (copy), EventNames (copy), FFlagEnableAbuseReportRevampFlow (copy), FFlagEnableAbuseReportRevampProfileAndGroup (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), refreshProfilePlatformActionInfo (copy), AppPage (copy), Url (copy), TextKeys (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonReport, {
						buttonSurface = p1.buttonSurface
					})

					if FFlagEnableAbuseReportRevampFlow and FFlagEnableAbuseReportRevampProfileAndGroup then
						p1.dispatch(OpenDynamicAbuseReport({
							abuseVector = AbuseVector.Group,
							targetId = p1.profileId,
							onClose = function() -- line: 79
								-- upvalues: p1 (copy), CloseCentralOverlay (copy), refreshProfilePlatformActionInfo (copy)
								p1.dispatch(CloseCentralOverlay())
								p1.dispatch(refreshProfilePlatformActionInfo(p1.profileId, p1.actionsComponentRequest))
							end
						}))

						return
					end

					local t2 = {
						name = AppPage.GenericWebPage,
						detail = `{ Url.BASE_URL }abusereport/group?id={ p1.profileId }`,
						extraProps = {
							titleKey = TextKeys.Report
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v10.down(v10.fromLegacyPage(t2))

						return
					end

					p1.dispatch(NavigateDown(t2))
				end
			}
		}
	end
}
