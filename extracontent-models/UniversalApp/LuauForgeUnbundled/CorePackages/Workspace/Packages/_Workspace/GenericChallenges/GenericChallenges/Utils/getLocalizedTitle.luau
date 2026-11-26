local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RobloxAppLocales").Localization
local localizeStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Localization").localizeStrings

return function(p2)
	local v5 = p2 == nil and "Feature.AccountSettings.Heading.Tab.Security" or p2

	return localizeStrings(localization.new(LocalizationService.RobloxLocaleId), {
		title = v5
	}).title
end
