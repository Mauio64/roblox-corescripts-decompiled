local localizationContext = require("@luauforge/bundled/fxk").LocalizationContext

local function getAutocompleteLocale(p2)
	local v5 = if p2 then localizationContext.getBaseLanguage(p2) else nil

	if v5 == nil or v5 == "en" then
		return "en"
	end

	return v5 .. ",en"
end

return getAutocompleteLocale
