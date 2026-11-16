local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)
local TransferContext = require(CurrencyTransfers.Contexts.TransferContext)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local AppLocales = require(parent.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

return function(p)
	local localization = Localization.new(LocalizationService.RobloxLocaleId)
	return function(p2)
		return React.createElement(LocalizationProvider, { localization = localization }, {
			React.createElement(FoundationProvider, { colorMode = Foundation.Enums.ColorMode.Dark }, {
				React.createElement(TransferContext.Provider, { value = p.transferStore }, p2.children)
			})
		})
	end
end
