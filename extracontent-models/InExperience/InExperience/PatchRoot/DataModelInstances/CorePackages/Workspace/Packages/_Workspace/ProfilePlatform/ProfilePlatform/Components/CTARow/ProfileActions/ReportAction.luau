local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Http = require(parent.Http)
local SharedFlags = require(parent.SharedFlags)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local Url = Http.Url
local AppPage = RobloxAppEnums.AppPage

local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local AbuseVector = require(parent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(parent.GenericAbuseReporting.OpenDynamicAbuseReport)

local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

local FFlagEnableAbuseReportRevampFlow = SharedFlags.FFlagEnableAbuseReportRevampFlow

local FFlagEnableAbuseReportRevampProfileAndGroup = require(ProfilePlatform.Flags.FFlagEnableAbuseReportRevampProfileAndGroup)

return {
	[Enums.ProfileActions.Report] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.Report],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonReport, {
						buttonSurface = data.buttonSurface
					})

					if FFlagEnableAbuseReportRevampFlow and FFlagEnableAbuseReportRevampProfileAndGroup then
						data.dispatch(OpenDynamicAbuseReport({
							abuseVector = AbuseVector.UserProfile,
							targetId = data.profileId,
							onClose = function()
								data.dispatch(CloseCentralOverlay())
								data.dispatch(refreshProfilePlatformActionInfo(
									data.profileId,
									data.actionsComponentRequest
								))
							end
						}))
						return
					end

					local v = {
						name = AppPage.GenericWebPage,
						detail = `{Url.BASE_URL}abusereport/userprofile?id={data.profileId}`,
						extraProps = { titleKey = TextKeys.Report }
					}

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v))
					else
						data.dispatch(NavigateDown(v))
					end
				end,
				[ProfileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonReport, {
						buttonSurface = data.buttonSurface
					})

					if FFlagEnableAbuseReportRevampFlow and FFlagEnableAbuseReportRevampProfileAndGroup then
						data.dispatch(OpenDynamicAbuseReport({
							abuseVector = AbuseVector.Group,
							targetId = data.profileId,
							onClose = function()
								data.dispatch(CloseCentralOverlay())
								data.dispatch(refreshProfilePlatformActionInfo(
									data.profileId,
									data.actionsComponentRequest
								))
							end
						}))
						return
					end

					local v = {
						name = AppPage.GenericWebPage,
						detail = `{Url.BASE_URL}abusereport/group?id={data.profileId}`,
						extraProps = { titleKey = TextKeys.Report }
					}

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v))
					else
						data.dispatch(NavigateDown(v))
					end
				end
			}
		}
	end
}
