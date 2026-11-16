local parent = script:FindFirstAncestor("GenericChallenges").Parent

local LocalizationService = game:GetService("LocalizationService")
local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local Localization2 = require(parent.Localization)
local localizeStrings = Localization2.localizeStrings

return function(p: string?)
	local title = p == nil and "Feature.AccountSettings.Heading.Tab.Security" or p

	return localizeStrings(Localization.new(LocalizationService.RobloxLocaleId), { title = title }).title
end
