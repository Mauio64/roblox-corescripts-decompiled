local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Foundation = require(parent.Foundation)

local ButtonVariant = Foundation.Enums.ButtonVariant

local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.PlayExperience] = function(p)
		return {
			variant = ButtonVariant.Emphasis,
			isLoading = p.experienceUtilities.isLoading,
			isDisabled = not p.experienceUtilities.isInExperience,
			text = p.localized[Enums.ProfileActions.PlayExperience],
			onActivated = {
				[ProfileTypes.User] = function()
					p.experienceUtilities.playExperience()
				end
			}
		}
	end
}
