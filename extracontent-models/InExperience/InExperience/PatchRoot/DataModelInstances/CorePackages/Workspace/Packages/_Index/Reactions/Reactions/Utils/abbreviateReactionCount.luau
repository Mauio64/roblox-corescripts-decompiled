local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("Reactions").Parent

local Localization = require(parent.Localization)

local function abbreviateReactionCount(p: number)
	return Localization.abbreviateCount(p, LocalizationService.RobloxLocaleId)
end

return abbreviateReactionCount
