local LocalizationService = game:GetService("LocalizationService")

local function translate(p2)
	return require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/InExperienceLocales").Localization.new(LocalizationService.RobloxLocaleId):Format(p2)
end

return translate
