local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local AvatarExperienceFormValidation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFormValidation")

local fIntAXOutfitNameMaxLength = AvatarExperienceFlags.FIntAXOutfitNameMaxLength

return (AvatarExperienceFormValidation.buildFormValidator({
	AvatarExperienceFormValidation.Validators.isNotNull,
	AvatarExperienceFormValidation.Validators.String.buildIsShorterThanOrEqualTo(fIntAXOutfitNameMaxLength),
	AvatarExperienceFormValidation.Validators.String.isNotWhitespace
}))
