local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local Localization = require(ParentParentParent.RobloxAppLocales).Localization
local LocalizationProvider = require(ParentParentParent.Localization).LocalizationProvider
local React = require(ParentParentParent.React)
local Roact = require(ParentParentParent.Roact)
local RoactRodux = require(ParentParentParent.RoactRodux)
local Style = require(ParentParentParent.Style)
local FoundationProvider = Foundation.FoundationProvider
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local CapturesContext = require(ParentParent.Context.CapturesContext)
local CapturesPolicy = require(ParentParent.App.CapturesPolicy)
local Constants = require(ParentParent.Constants)

require(ParentParent.Types)

local function makeWrapWithProviders(p1, p2) -- line: 20
	-- upvalues: React (copy), Roact (copy), RoactRodux (copy), CapturesPolicy (copy), StyleProviderWithDefaultTheme (copy), LocalizationProvider (copy), Localization (copy), CapturesContext (copy), FoundationProvider (copy), Foundation (copy), Constants (copy)
	local function v18(s1: string?, t1: {[any]: any}) -- line: 23
		-- upvalues: React (copy)
		if not s1 then
			return t1
		end

		return React.createElement("Folder", {
			Name = s1
		}, t1)
	end

	return function(p3, p4, t2: {[any]: any}, s2: string?) -- line: 33
		-- upvalues: Roact (copy), React (copy), RoactRodux (copy), p1 (copy), CapturesPolicy (copy), StyleProviderWithDefaultTheme (copy), LocalizationProvider (copy), Localization (copy), p2 (copy), CapturesContext (copy), v18 (copy), FoundationProvider (copy), Foundation (copy), Constants (copy)
		return Roact.mount(React.createElement(RoactRodux.StoreProvider, {
			store = p1
		}, {
			PolicyProvider = Roact.createElement(CapturesPolicy.Provider, {
				policy = { CapturesPolicy.Mapper }
			}, {
				StyleProvider = React.createElement(StyleProviderWithDefaultTheme, {
					withDarkTheme = true
				}, {
					LocalizationProvider = Roact.createElement(LocalizationProvider, {
						localization = Localization.new(p2.LocalizationService.RobloxLocaleId)
					}, {
						ContextProvider = Roact.createElement(CapturesContext.Provider, {
							value = p4
						}, {
							Portal = Roact.createElement(Roact.Portal, {
								target = p3
							}, v18(s2, {
								FoundationProvider = React.createElement(FoundationProvider, {
									theme = Foundation.Enums.Theme.Dark
								}, { t2 })
							}))
						})
					})
				})
			})
		}), nil, Constants.ReactName)
	end
end

return makeWrapWithProviders
