local LocalizationService = game:GetService("LocalizationService")

local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxTranslator/InExperienceLocales").Localization

local v5 = localization.new(LocalizationService.RobloxLocaleId)

return {
	FormatByKey = function(self, p3, p4)
		return v5:Format(p3, p4)
	end,
	FormatByKeyForLocale = function(p2, p3, p4, p5)
		return localization.new(p4):Format(p3, p5)
	end
}
