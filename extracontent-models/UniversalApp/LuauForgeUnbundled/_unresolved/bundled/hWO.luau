local CorePackages = game:GetService("CorePackages")

local LocalizationService = game:GetService("LocalizationService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/edm")

local module2 = require("@luauforge/bundled/hWE")

function LUAUFORGE_MODULE_GLOBALS_hWO_UpdateLocalizationWithLocale(object)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	object:SetLocale(robloxLocaleId)

	module2:updateSharedAttributes({ Locale = robloxLocaleId })
end

return function(p2)
	local localization = p2.localization

	React.useEffect(function()
		if localization:GetLocale() ~= LocalizationService.RobloxLocaleId then
			LUAUFORGE_MODULE_GLOBALS_hWO_UpdateLocalizationWithLocale(localization)
		end
	end, { p2.localization })

	return Roact.createElement(module, {
		event = LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"),
		callback = function()
			LUAUFORGE_MODULE_GLOBALS_hWO_UpdateLocalizationWithLocale(localization)
		end
	})
end
