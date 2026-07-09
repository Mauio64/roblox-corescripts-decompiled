local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local LocalizationService = game:GetService("LocalizationService")
local React = require(CurrencyTransfersParent.React)
local TransferContext = require(CurrencyTransfers.Contexts.TransferContext)
local Foundation = require(CurrencyTransfersParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Localization = require(CurrencyTransfersParent.AppLocales).Localization
local LocalizationProvider = require(CurrencyTransfersParent.Localization).LocalizationProvider

return function(t1: {[any]: any}) -- line: 16
	-- upvalues: Localization (copy), LocalizationService (copy), React (copy), LocalizationProvider (copy), FoundationProvider (copy), Foundation (copy), TransferContext (copy)
	local v11 = Localization.new(LocalizationService.RobloxLocaleId)

	return function(p1) -- line: 18
		-- upvalues: React (copy), LocalizationProvider (copy), v11 (copy), FoundationProvider (copy), Foundation (copy), TransferContext (copy), t1 (copy)
		return React.createElement(LocalizationProvider, {
			localization = v11
		}, { React.createElement(FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, { React.createElement(TransferContext.Provider, {
			value = t1.transferStore
		}, p1.children) }) })
	end
end
