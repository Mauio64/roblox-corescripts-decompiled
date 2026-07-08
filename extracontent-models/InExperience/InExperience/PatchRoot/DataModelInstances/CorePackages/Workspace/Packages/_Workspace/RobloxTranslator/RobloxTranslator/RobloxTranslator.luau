local LocalizationService = game:GetService("LocalizationService")
local ParentParent = script.Parent.Parent
local Localization = require(ParentParent.InExperienceLocales).Localization
local v4 = Localization.new(LocalizationService.RobloxLocaleId)

return {
	FormatByKey = function(_, p2, p3) -- line: 14
		-- upvalues: v4 (copy)
		return v4:Format(p2, p3)
	end,
	FormatByKeyForLocale = function(_, p5, p6, p7) -- line: 18
		-- upvalues: Localization (copy)
		return Localization.new(p6):Format(p5, p7)
	end
}
