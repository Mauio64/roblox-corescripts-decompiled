local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

local function getSearchAutocompleteConfigKey(p2)
	return string.format(
		"SearchAutocomplete-%s-%s",
		HttpService:UrlEncode(LocalizationService.RobloxLocaleId),
		HttpService:UrlEncode(p2)
	)
end

return getSearchAutocompleteConfigKey
