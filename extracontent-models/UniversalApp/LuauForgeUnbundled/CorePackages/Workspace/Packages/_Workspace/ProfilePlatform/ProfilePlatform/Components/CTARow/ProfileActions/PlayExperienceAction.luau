local buttonVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").Enums.ButtonVariant

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local profileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.PlayExperience] = function(p2)
		return {
			variant = buttonVariant.Emphasis,
			isLoading = p2.experienceUtilities.isLoading,
			isDisabled = not p2.experienceUtilities.isInExperience,
			text = p2.localized[Enums.ProfileActions.PlayExperience],
			onActivated = {
				[profileTypes.User] = function()
					p2.experienceUtilities.playExperience()
				end
			}
		}
	end
}
