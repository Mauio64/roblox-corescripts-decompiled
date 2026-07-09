local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local ButtonVariant = require(ProfilePlatformParent.Foundation).Enums.ButtonVariant
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.PendingFriendRequest] = function(p1) -- line: 13
		-- upvalues: ButtonVariant (copy), Enums (copy), ProfileTypes (copy)
		return {
			isDisabled = true,
			variant = ButtonVariant.Subtle,
			text = p1.localized[Enums.ProfileActions.PendingFriendRequest],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 18
				end
			}
		}
	end
}
