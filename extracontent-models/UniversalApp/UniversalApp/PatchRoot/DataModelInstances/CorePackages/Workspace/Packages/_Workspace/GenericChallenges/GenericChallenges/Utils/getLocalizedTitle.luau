local Parent = script:FindFirstAncestor("GenericChallenges").Parent
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(Parent.RobloxAppLocales).Localization
local localizeStrings = require(Parent.Localization).localizeStrings

return function(s1: string?) -- line: 10
	-- upvalues: localizeStrings (copy), Localization (copy), LocalizationService (copy)
	local s2 = "Feature.AccountSettings.Heading.Tab.Security"

	if s1 ~= nil then
		s2 = s1
	end

	return localizeStrings(Localization.new(LocalizationService.RobloxLocaleId), {
		title = s2
	}).title
end
