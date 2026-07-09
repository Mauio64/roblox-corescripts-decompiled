local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local SetAlias = require(ProfilePlatformParent.SetAlias)
local SocialStopwatch = require(ProfilePlatformParent.SocialStopwatch)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.EditAlias] = function(p1) -- line: 13
		-- upvalues: Enums (copy), ProfileTypes (copy), SocialStopwatch (copy), EventNames (copy), SetAlias (copy)
		return {
			text = p1.localized[Enums.ProfileActions.EditAlias],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 17
					-- upvalues: SocialStopwatch (copy), p1 (copy), EventNames (copy), Enums (copy), SetAlias (copy)
					SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CustomizeNameOpened)
					p1.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonSetAlias, {
						buttonSurface = p1.buttonSurface
					})
					p1.navigation.navigate(Enums.Screens.SetAliasModal, {
						profileUserId = p1.profileId,
						origin = SetAlias.Analytics.EntryPoints.ContextualMenu
					})
				end
			}
		}
	end
}
