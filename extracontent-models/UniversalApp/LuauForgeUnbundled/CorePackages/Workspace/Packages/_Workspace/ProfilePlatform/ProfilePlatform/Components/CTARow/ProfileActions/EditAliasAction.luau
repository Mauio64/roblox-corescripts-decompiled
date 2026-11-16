local SetAlias = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SetAlias")
local SocialStopwatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialStopwatch")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.EditAlias] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.EditAlias],
			onActivated = {
				[profileTypes.User] = function()
					SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CustomizeNameOpened)
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonSetAlias, {
						buttonSurface = data.buttonSurface
					})

					data.navigation.navigate(Enums.Screens.SetAliasModal, {
						profileUserId = data.profileId,
						origin = SetAlias.Analytics.EntryPoints.ContextualMenu
					})
				end
			}
		}
	end
}
