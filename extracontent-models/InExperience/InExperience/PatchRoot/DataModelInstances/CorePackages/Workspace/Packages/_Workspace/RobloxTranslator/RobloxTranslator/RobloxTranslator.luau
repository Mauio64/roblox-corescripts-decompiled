local LocalizationService = game:GetService("LocalizationService")

local parent = script.Parent.Parent

local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization

local v = Localization.new(LocalizationService.RobloxLocaleId)
local RobloxTranslator = {}

function RobloxTranslator.FormatByKey(_, p, p2)
	return v:Format(p, p2)
end

function RobloxTranslator.FormatByKeyForLocale(_, p, p2, p3)
	return Localization.new(p2):Format(p, p3)
end

return RobloxTranslator
