local LocalizationService = game:GetService("LocalizationService")

local parent = script.Parent.Parent

local function translate(p: string)
	local InExperienceLocales = require(parent.InExperienceLocales)
	return InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId):Format(p)
end

return translate
