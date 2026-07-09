local Parent = script:FindFirstAncestor("AvatarExperienceControlBar").Parent
local React = require(Parent.React)
local ReactTestingLibrary = require(Parent.Dev.ReactTestingLibrary)
local Rodux = require(Parent.Rodux)
local RoactRodux = require(Parent.RoactRodux)
local Foundation = require(Parent.Foundation)
local Style = require(Parent.Style)
local Localization = require(Parent.Localization)
local FoundationProvider = Foundation.FoundationProvider
local AppStyleProvider = Style.AppStyleProvider
local Constants = Style.Constants
local LocalizationProvider = Localization.LocalizationProvider
local t1 = {
	themeName = Constants.ThemeName.Dark,
	fontName = Constants.FontName.Gotham
}

local function createMockLocalization() -- line: 27
	return {
		Format = function(_, s1: string) -- line: 29
			return s1
		end,
		GetLocale = function() -- line: 32
			return "locale"
		end,
		changed = {
			connect = function() -- line: 35
			end
		}
	}
end
local function renderWithProviders(p2, t2: {[any]: any}?) -- line: 44
	-- upvalues: Rodux (copy), createMockLocalization (copy), React (copy), FoundationProvider (copy), AppStyleProvider (copy), t1 (copy), LocalizationProvider (copy), RoactRodux (copy), ReactTestingLibrary (copy)
	local v18 = t2 or {}
	local v19 = v18.store or Rodux.Store.new(Rodux.createReducer({}, {}))
	local v20 = v18.localization or createMockLocalization()
	local v21 = React.createElement(FoundationProvider, {
		theme = "Dark"
	}, {
		StyleProvider = React.createElement(AppStyleProvider, {
			style = t1
		}, {
			LocalizationProvider = React.createElement(LocalizationProvider, {
				localization = v20
			}, {
				StoreProvider = React.createElement(RoactRodux.StoreProvider, {
					store = v19
				}, {
					TestSubject = p2
				})
			})
		})
	})

	return ReactTestingLibrary.render(v21)
end

return renderWithProviders
