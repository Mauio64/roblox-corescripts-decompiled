local parent = script.Parent.Parent
local parent2 = parent.Parent

local Foundation = require(parent2.Foundation)
local RobloxAppLocales = require(parent2.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local React = require(parent2.React)
local Roact = require(parent2.Roact)
local RoactRodux = require(parent2.RoactRodux)
local Style = require(parent2.Style)

local FoundationProvider = Foundation.FoundationProvider
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme

local CapturesContext = require(parent.Context.CapturesContext)
local CapturesPolicy = require(parent.App.CapturesPolicy)
local Constants = require(parent.Constants)
require(parent.Types)

local function makeWrapWithProviders(store, p)
	local function fn(name: string?, p2)
		if name then
			return React.createElement("Folder", { Name = name }, p2)
		end

		return p2
	end

	return function(target, p2, p3, name: string?, p4)
		local v = (not p4 or p4.withFoundationProvider ~= false) and {
			FoundationProvider = React.createElement(
				FoundationProvider,
				{ colorMode = Foundation.Enums.ColorMode.Dark },
				{ p3 }
			)
		} or p3

		return Roact.mount(React.createElement(RoactRodux.StoreProvider, { store = store }, {
			PolicyProvider = Roact.createElement(CapturesPolicy.Provider, {
				policy = { CapturesPolicy.Mapper }
			}, {
				StyleProvider = React.createElement(StyleProviderWithDefaultTheme, {
					withDarkTheme = true
				}, {
					LocalizationProvider = Roact.createElement(
						LocalizationProvider,
						{
							localization = Localization.new(p.LocalizationService.RobloxLocaleId)
						},
						{
							ContextProvider = Roact.createElement(CapturesContext.Provider, {
								value = p2
							}, {
								Portal = Roact.createElement(Roact.Portal, { target = target }, fn(name, v))
							})
						}
					)
				})
			})
		}), nil, Constants.ReactName)
	end
end

return makeWrapWithProviders
