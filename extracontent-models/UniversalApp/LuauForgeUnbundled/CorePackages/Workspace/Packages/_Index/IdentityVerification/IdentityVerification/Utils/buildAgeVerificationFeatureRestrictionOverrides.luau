local LocalizationService = game:GetService("LocalizationService")

local localization = require("@game/CorePackages/Workspace/Packages/_Index/IdentityVerification/RobloxAppLocales").Localization
require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityVerification/UniversalFeatureRestrictions")

local function buildAgeVerificationFeatureRestrictionOverrides()
	local v5 = localization.new(LocalizationService.RobloxLocaleId)

	return {
		titleOverride = v5:Format("Feature.UniversalFeatureRestrictions.AbuseVector.AgeVerification.DialogTitle.Suspended"),
		bodyOverride = v5:Format("Feature.UniversalFeatureRestrictions.AbuseVector.AgeVerification.DialogBody.Suspended")
	}
end

return buildAgeVerificationFeatureRestrictionOverrides
