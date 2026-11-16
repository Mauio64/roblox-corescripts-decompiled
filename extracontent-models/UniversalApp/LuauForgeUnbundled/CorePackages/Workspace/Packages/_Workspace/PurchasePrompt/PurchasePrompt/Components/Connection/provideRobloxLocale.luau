local LocalizationService = game:GetService("LocalizationService")

local roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Roact

local LocalizationContextProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/LocalizationContextProvider")

local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxAppLocales").Localization

return function(callback)
	local v5 = localization.new(LocalizationService.RobloxLocaleId)

	return roact.createElement(LocalizationContextProvider, { localizationContext = v5 }, {
		PurchasePromptApp = callback()
	})
end
