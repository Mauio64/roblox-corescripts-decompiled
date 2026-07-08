local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local Roact = require(Parent.PurchasePromptDeps).Roact
local LocalizationContextProvider = require(script.Parent.LocalizationContextProvider)
local Localization = require(Parent.RobloxAppLocales).Localization

return function(p1) -- line: 17
	-- upvalues: Localization (copy), LocalizationService (copy), Roact (copy), LocalizationContextProvider (copy)
	local v7 = Localization.new(LocalizationService.RobloxLocaleId)

	return Roact.createElement(LocalizationContextProvider, {
		localizationContext = v7
	}, {
		PurchasePromptApp = p1()
	})
end
