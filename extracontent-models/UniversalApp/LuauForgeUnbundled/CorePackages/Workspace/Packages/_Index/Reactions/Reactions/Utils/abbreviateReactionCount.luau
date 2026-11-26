local LocalizationService = game:GetService("LocalizationService")

local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/Localization")

local function abbreviateReactionCount(p2)
	return Localization.abbreviateCount(p2, LocalizationService.RobloxLocaleId)
end

return abbreviateReactionCount
