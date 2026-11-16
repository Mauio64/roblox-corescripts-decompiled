local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local LocalizationService = game:GetService("LocalizationService")
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact
local Rodux = PurchasePromptDeps.Rodux
local RoactRodux = PurchasePromptDeps.RoactRodux
local IAPExperience = require(parent.IAPExperience)
local LocaleProvider = IAPExperience.Locale.LocaleProvider

local LayoutValuesProvider = require(PurchasePrompt.Components.Connection.LayoutValuesProvider)
local LocalizationContextProvider = require(PurchasePrompt.Components.Connection.LocalizationContextProvider)
local Reducer = require(PurchasePrompt.Reducers.Reducer)
local LayoutValues = require(PurchasePrompt.Services.LayoutValues)
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme

local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization

local extended = Roact.Component:extend("UnitTestContainer")

function extended:init()
	self.layoutValues = LayoutValues.new(false).layout
	self.store = self.props.overrideStore or Rodux.Store.new(Reducer, {})

	local overrideLocale = self.props.overrideLocale or LocalizationService.RobloxLocaleId
	self.localizationContext = Localization.new(overrideLocale)
end

function extended.render(props)
	local v = props.props[Roact.Children] ~= nil and #props.props[Roact.Children] > 0
	assert(v, "UnitTestContainer: no children provided, nothing will be tested")

	return Roact.createElement(RoactRodux.StoreProvider, { store = props.store }, {
		LocaleProvider = Roact.createElement(LocaleProvider, {
			locale = LocalizationService.RobloxLocaleId
		}, {
			StyleProvider = Roact.createElement(StyleProviderWithDefaultTheme, {
				LocalizationContextProvider = Roact.createElement(LocalizationContextProvider, {
					localizationContext = props.localizationContext,
					render = function()
						return Roact.createElement(LayoutValuesProvider, {
							isTenFootInterface = false,
							render = function()
								return Roact.createElement(
									"ScreenGui",
									{ AutoLocalize = false, IgnoreGuiInset = true },
									props.props[Roact.Children]
								)
							end
						})
					end
				})
			})
		})
	})
end

return extended
