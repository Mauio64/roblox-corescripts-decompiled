local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local ButtonVariant = require(ProfilePlatformParent.Foundation).Enums.ButtonVariant
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.JoinExperience] = function(p1) -- line: 13
		-- upvalues: ButtonVariant (copy), Enums (copy), ProfileTypes (copy)
		return {
			variant = ButtonVariant.Emphasis,
			isLoading = p1.experienceUtilities.isLoading,
			isDisabled = not p1.experienceUtilities.isInExperience,
			text = p1.localized[Enums.ProfileActions.JoinExperience],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 20
					-- upvalues: p1 (copy)
					p1.experienceUtilities.joinExperience()
				end
			}
		}
	end
}
