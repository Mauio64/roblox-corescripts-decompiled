local buttonVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").Enums.ButtonVariant

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local profileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.PendingFriendRequest] = function(p2)
		return {
			variant = buttonVariant.Subtle,
			text = p2.localized[Enums.ProfileActions.PendingFriendRequest],
			onActivated = {
				[profileTypes.User] = function() end
			},
			isDisabled = true
		}
	end
}
