local buttonVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").Enums.ButtonVariant

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local profileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.JoinExperience] = function(p2)
		return {
			variant = buttonVariant.Emphasis,
			isLoading = p2.experienceUtilities.isLoading,
			isDisabled = not p2.experienceUtilities.isInExperience,
			text = p2.localized[Enums.ProfileActions.JoinExperience],
			onActivated = {
				[profileTypes.User] = function()
					p2.experienceUtilities.joinExperience()
				end
			}
		}
	end
}
