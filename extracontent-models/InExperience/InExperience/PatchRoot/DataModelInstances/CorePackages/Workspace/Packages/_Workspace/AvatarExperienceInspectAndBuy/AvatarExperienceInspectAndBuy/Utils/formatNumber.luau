local parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization
local LocalizationService = game:GetService("LocalizationService")

local function formatNumber(value: number?)
	local v = string.format("%.0f", value or 0)
	return NumberLocalization.localize(v, LocalizationService.RobloxLocaleId)
end

return formatNumber
