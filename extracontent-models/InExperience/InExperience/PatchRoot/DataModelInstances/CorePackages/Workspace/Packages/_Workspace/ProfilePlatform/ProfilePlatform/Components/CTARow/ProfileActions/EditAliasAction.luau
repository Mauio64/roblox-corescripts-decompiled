local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local SetAlias = require(parent.SetAlias)
local SocialStopwatch = require(parent.SocialStopwatch)

local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.EditAlias] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.EditAlias],
			onActivated = {
				[ProfileTypes.User] = function()
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
