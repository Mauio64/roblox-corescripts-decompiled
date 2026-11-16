local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Foundation = require(parent.Foundation)

local ButtonVariant = Foundation.Enums.ButtonVariant

local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.PendingFriendRequest] = function(p)
		return {
			variant = ButtonVariant.Subtle,
			text = p.localized[Enums.ProfileActions.PendingFriendRequest],
			onActivated = {
				[ProfileTypes.User] = function() end
			},
			isDisabled = true
		}
	end
}
