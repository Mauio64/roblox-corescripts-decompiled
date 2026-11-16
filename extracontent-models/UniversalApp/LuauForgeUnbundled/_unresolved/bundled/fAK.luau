local LocalizationService = game:GetService("LocalizationService")

require("@game/CorePackages/Workspace/Packages/Http")
local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(
		string.format("%sv1/locales/user-localization-locus-supported-locales", Url.LOCALE),
		"GET",
		{
			headers = { ["Accept-Language"] = LocalizationService.SystemLocaleId }
		}
	)
end
