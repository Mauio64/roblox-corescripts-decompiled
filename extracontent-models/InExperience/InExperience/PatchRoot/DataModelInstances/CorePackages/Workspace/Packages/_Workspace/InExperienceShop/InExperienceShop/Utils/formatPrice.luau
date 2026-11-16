local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("InExperienceShop").Parent
local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization

local function formatPrice(value: number?)
	local v = string.format("%.0f", value or 0)
	return NumberLocalization.localize(v, LocalizationService.RobloxLocaleId)
end

return formatPrice
