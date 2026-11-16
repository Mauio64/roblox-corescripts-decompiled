local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local AvatarExperienceFormValidation = require(parent.AvatarExperienceFormValidation)

local FIntAXOutfitNameMaxLength = AvatarExperienceFlags.FIntAXOutfitNameMaxLength

return (AvatarExperienceFormValidation.buildFormValidator({
	AvatarExperienceFormValidation.Validators.isNotNull,
	AvatarExperienceFormValidation.Validators.String.buildIsShorterThanOrEqualTo(FIntAXOutfitNameMaxLength),
	AvatarExperienceFormValidation.Validators.String.isNotWhitespace
}))
