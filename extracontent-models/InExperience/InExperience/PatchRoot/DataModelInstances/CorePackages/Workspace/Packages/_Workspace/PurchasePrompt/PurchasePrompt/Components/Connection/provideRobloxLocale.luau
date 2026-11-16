local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact

local LocalizationContextProvider = require(script.Parent.LocalizationContextProvider)

local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization

return function(callback)
	local localizationContext = Localization.new(LocalizationService.RobloxLocaleId)

	return Roact.createElement(LocalizationContextProvider, {
		localizationContext = localizationContext
	}, {
		PurchasePromptApp = callback()
	})
end
