local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Localization").NumberLocalization
local LocalizationService = game:GetService("LocalizationService")

local function getLocalizedPrice(value)
	local v5 = string.format("%.0f", value or 0)
	return numberLocalization.localize(v5, LocalizationService.RobloxLocaleId)
end

return getLocalizedPrice
