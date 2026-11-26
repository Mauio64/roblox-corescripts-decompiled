local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Localization").NumberLocalization
local LocalizationService = game:GetService("LocalizationService")

local function formatNumber(value)
	local v5 = string.format("%.0f", value or 0)
	return numberLocalization.localize(v5, LocalizationService.RobloxLocaleId)
end

return formatNumber
