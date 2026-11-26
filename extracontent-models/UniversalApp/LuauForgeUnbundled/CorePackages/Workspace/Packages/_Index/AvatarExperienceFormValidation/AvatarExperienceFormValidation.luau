local module = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceFormValidation/AvatarExperienceFormValidation/FormValidationErrorEnum")

return {
	buildFormValidator = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceFormValidation/AvatarExperienceFormValidation/buildFormValidator"),
	Validators = {
		String = {
			isNotWhitespace = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceFormValidation/AvatarExperienceFormValidation/Validators/String/isNotWhitespace"),
			buildIsShorterThanOrEqualTo = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceFormValidation/AvatarExperienceFormValidation/Validators/String/buildIsShorterThanOrEqualTo")
		},
		isNotNull = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceFormValidation/AvatarExperienceFormValidation/Validators/isNotNull")
	},
	FormValidationErrorEnum = module
}
