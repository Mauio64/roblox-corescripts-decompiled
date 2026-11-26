local LocalizationService = game:GetService("LocalizationService")

local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/Localization").NumberLocalization

local function formatReferralStat(p2)
	if p2 == nil then
		return "—"
	end

	return numberLocalization.localize(tostring(p2), LocalizationService.RobloxLocaleId)
end

return formatReferralStat
