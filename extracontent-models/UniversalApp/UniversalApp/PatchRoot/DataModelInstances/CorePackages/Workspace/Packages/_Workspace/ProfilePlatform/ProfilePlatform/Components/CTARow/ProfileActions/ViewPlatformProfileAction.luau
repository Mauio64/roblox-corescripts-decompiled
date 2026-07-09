local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local FFlagEnablePlatformProfileContextualMenuOption = require(ProfilePlatformParent.SharedFlags).FFlagEnablePlatformProfileContextualMenuOption
local FFlagPPVEnabledOnConsole = require(ProfilePlatformParent.SharedFlags).FFlagPPVEnabledOnConsole
local getPlatformFriendsService = require(ProfilePlatform.Utils.getPlatformFriendsService)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.ViewPlatformProfile] = if not FFlagEnablePlatformProfileContextualMenuOption then nil else function(p1) -- line: 16
		-- upvalues: FFlagPPVEnabledOnConsole (copy), Enums (copy), ProfileTypes (copy), EventNames (copy), getPlatformFriendsService (copy)
		if FFlagPPVEnabledOnConsole then
			local profilePlatformId = p1.profileWrapperContext.profilePlatformId

			if not profilePlatformId or profilePlatformId == "" then
				return nil
			end
		end

		return {
			text = p1.localized[Enums.ProfileActions.ViewPlatformProfile],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 27
					-- upvalues: p1 (copy), EventNames (copy), getPlatformFriendsService (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonViewPlatformProfile, {
						buttonSurface = p1.buttonSurface
					})
					getPlatformFriendsService:ShowProfile(p1.profileWrapperContext.profilePlatformId)
				end
			}
		}
	end
}
