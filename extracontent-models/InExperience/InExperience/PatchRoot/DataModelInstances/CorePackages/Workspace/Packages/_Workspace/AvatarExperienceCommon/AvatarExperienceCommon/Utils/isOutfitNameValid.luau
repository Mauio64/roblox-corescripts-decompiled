local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local AvatarExperienceFormValidation = require(Parent.AvatarExperienceFormValidation)
local FIntAXOutfitNameMaxLength = AvatarExperienceFlags.FIntAXOutfitNameMaxLength

return (AvatarExperienceFormValidation.buildFormValidator({
	AvatarExperienceFormValidation.Validators.isNotNull,
	AvatarExperienceFormValidation.Validators.String.buildIsShorterThanOrEqualTo(FIntAXOutfitNameMaxLength),
	AvatarExperienceFormValidation.Validators.String.isNotWhitespace
}))
