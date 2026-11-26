local LocalizationService = game:GetService("LocalizationService")

require("@game/CorePackages/Workspace/Packages/Http")
local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(
		string.format("%sv1/locales/user-localization-locus-supported-locales", module.LOCALE),
		"GET",
		{
			headers = { ["Accept-Language"] = LocalizationService.SystemLocaleId }
		}
	)
end
