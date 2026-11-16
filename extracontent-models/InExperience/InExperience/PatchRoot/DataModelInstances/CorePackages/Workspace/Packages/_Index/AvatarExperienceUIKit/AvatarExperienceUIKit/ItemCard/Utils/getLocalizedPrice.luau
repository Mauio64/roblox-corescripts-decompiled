local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization
local LocalizationService = game:GetService("LocalizationService")

local function getLocalizedPrice(value: number)
	local v = string.format("%.0f", value or 0)
	return NumberLocalization.localize(v, LocalizationService.RobloxLocaleId)
end

return getLocalizedPrice
