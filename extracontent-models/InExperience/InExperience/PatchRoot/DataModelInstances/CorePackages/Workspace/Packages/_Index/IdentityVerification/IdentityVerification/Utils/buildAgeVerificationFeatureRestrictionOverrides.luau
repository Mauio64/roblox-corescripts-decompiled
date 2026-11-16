local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("IdentityVerification").Parent

local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
require(parent.UniversalFeatureRestrictions)

local function buildAgeVerificationFeatureRestrictionOverrides()
	local v = Localization.new(LocalizationService.RobloxLocaleId)

	return {
		titleOverride = v:Format("Feature.UniversalFeatureRestrictions.AbuseVector.AgeVerification.DialogTitle.Suspended"),
		bodyOverride = v:Format("Feature.UniversalFeatureRestrictions.AbuseVector.AgeVerification.DialogBody.Suspended")
	}
end

return buildAgeVerificationFeatureRestrictionOverrides
