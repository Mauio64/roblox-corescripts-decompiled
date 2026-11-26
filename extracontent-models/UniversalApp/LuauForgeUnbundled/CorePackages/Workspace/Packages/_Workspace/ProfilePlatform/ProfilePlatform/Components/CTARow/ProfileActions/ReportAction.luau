local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Http")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums")

local url = Http.Url
local appPage = RobloxAppEnums.AppPage

local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CentralOverlay").Thunks.CloseCentralOverlay
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GenericAbuseReporting/AbuseVector")
local OpenDynamicAbuseReport = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GenericAbuseReporting/OpenDynamicAbuseReport")

local refreshProfilePlatformActionInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatformActionInfo")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

local fFlagEnableAbuseReportRevampFlow = SharedFlags.FFlagEnableAbuseReportRevampFlow

local FFlagEnableAbuseReportRevampProfileAndGroup = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagEnableAbuseReportRevampProfileAndGroup")

return {
	[Enums.ProfileActions.Report] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.Report],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonReport, {
						buttonSurface = data.buttonSurface
					})

					if fFlagEnableAbuseReportRevampFlow and FFlagEnableAbuseReportRevampProfileAndGroup then
						data.dispatch(OpenDynamicAbuseReport({
							abuseVector = AbuseVector.UserProfile,
							targetId = data.profileId,
							onClose = function()
								data.dispatch(closeCentralOverlay())
								data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
							end
						}))
						return
					end

					local v8 = {
						name = appPage.GenericWebPage,
						detail = `{url.BASE_URL}abusereport/userprofile?id={data.profileId}`,
						extraProps = { titleKey = TextKeys.Report }
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v8))
					else
						data.dispatch(navigateDown(v8))
					end
				end,
				[profileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonReport, {
						buttonSurface = data.buttonSurface
					})

					if fFlagEnableAbuseReportRevampFlow and FFlagEnableAbuseReportRevampProfileAndGroup then
						data.dispatch(OpenDynamicAbuseReport({
							abuseVector = AbuseVector.Group,
							targetId = data.profileId,
							onClose = function()
								data.dispatch(closeCentralOverlay())
								data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
							end
						}))
						return
					end

					local v8 = {
						name = appPage.GenericWebPage,
						detail = `{url.BASE_URL}abusereport/group?id={data.profileId}`,
						extraProps = { titleKey = TextKeys.Report }
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v8))
					else
						data.dispatch(navigateDown(v8))
					end
				end
			}
		}
	end
}
