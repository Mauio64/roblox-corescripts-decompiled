local Parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local NumberLocalization = require(Parent.Localization).NumberLocalization
local LocalizationService = game:GetService("LocalizationService")

local function formatNumber(n1: number?) -- line: 10
	-- upvalues: NumberLocalization (copy), LocalizationService (copy)
	local v6 = string.format("%.0f", n1 or 0)

	return NumberLocalization.localize(v6, LocalizationService.RobloxLocaleId)
end

return formatNumber
