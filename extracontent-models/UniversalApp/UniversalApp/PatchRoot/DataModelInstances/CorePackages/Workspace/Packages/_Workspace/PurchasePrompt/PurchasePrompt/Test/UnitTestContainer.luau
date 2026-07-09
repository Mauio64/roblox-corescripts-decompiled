local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local LocalizationService = game:GetService("LocalizationService")
local PurchasePromptDeps = require(PurchasePromptParent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact
local Rodux = PurchasePromptDeps.Rodux
local RoactRodux = PurchasePromptDeps.RoactRodux
local LocaleProvider = require(PurchasePromptParent.IAPExperience).Locale.LocaleProvider
local LayoutValuesProvider = require(PurchasePrompt.Components.Connection.LayoutValuesProvider)
local LocalizationContextProvider = require(PurchasePrompt.Components.Connection.LocalizationContextProvider)
local Reducer = require(PurchasePrompt.Reducers.Reducer)
local LayoutValues = require(PurchasePrompt.Services.LayoutValues)
local StyleProviderWithDefaultTheme = require(PurchasePromptParent.Style).StyleProviderWithDefaultTheme
local Localization = require(PurchasePromptParent.RobloxAppLocales).Localization
local v15 = Roact.Component:extend("UnitTestContainer")

function v15.init(p1) -- line: 26
	-- upvalues: LayoutValues (copy), Rodux (copy), Reducer (copy), LocalizationService (copy), Localization (copy)
	p1.layoutValues = LayoutValues.new(false).layout
	p1.store = p1.props.overrideStore or Rodux.Store.new(Reducer, {})

	local v17 = p1.props.overrideLocale or LocalizationService.RobloxLocaleId

	p1.localizationContext = Localization.new(v17)
end
function v15.render(p2) -- line: 34
	-- upvalues: Roact (copy), RoactRodux (copy), LocaleProvider (copy), LocalizationService (copy), StyleProviderWithDefaultTheme (copy), LocalizationContextProvider (copy), LayoutValuesProvider (copy)
	assert(p2.props[Roact.Children] ~= nil and #p2.props[Roact.Children] > 0, "UnitTestContainer: no children provided, nothing will be tested")

	return Roact.createElement(RoactRodux.StoreProvider, {
		store = p2.store
	}, {
		LocaleProvider = Roact.createElement(LocaleProvider, {
			locale = LocalizationService.RobloxLocaleId
		}, {
			StyleProvider = Roact.createElement(StyleProviderWithDefaultTheme, {
				LocalizationContextProvider = Roact.createElement(LocalizationContextProvider, {
					localizationContext = p2.localizationContext,
					render = function() -- line: 49
						-- upvalues: Roact (copy), LayoutValuesProvider (copy), p2 (copy)
						return Roact.createElement(LayoutValuesProvider, {
							isTenFootInterface = false,
							render = function() -- line: 52
								-- upvalues: Roact (copy), p2 (copy)
								return Roact.createElement("ScreenGui", {
									AutoLocalize = false,
									IgnoreGuiInset = true
								}, p2.props[Roact.Children])
							end
						})
					end
				})
			})
		})
	})
end

return v15
