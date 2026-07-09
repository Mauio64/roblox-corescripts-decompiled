local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local NumberLocalization = require(Parent.Localization).NumberLocalization

local function formatPrice(n1: number?) -- line: 10
	-- upvalues: NumberLocalization (copy), LocalizationService (copy)
	local v6 = string.format("%.0f", n1 or 0)

	return NumberLocalization.localize(v6, LocalizationService.RobloxLocaleId)
end

return formatPrice
