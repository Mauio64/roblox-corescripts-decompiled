local parent = script.Parent.Parent.Parent

local React = require(parent.React)

local Rodux = require(parent.Rodux)
local RoactRodux = require(parent.RoactRodux)
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local RobloxAppLocales = require(parent.RobloxAppLocales)
local localization = RobloxAppLocales.Localization

local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode

local Style = require(parent.Style)
local AppStyleProvider = Style.AppStyleProvider
local Style2 = require(parent.Style)
local Constants = Style2.Constants

local style = {
	themeName = ColorMode.Dark,
	fontName = Constants.FontName.Gotham,
	Tokens = {
		Global = { Size_350 = 28, Size_500 = 40 }
	}
}

local v = {
	ScreenSize = Vector2.new(500, 500),
	SetAlias = {
		Aliases = {
			byUserId = { ["1"] = "foo" }
		}
	}
}

local function fn(options, p)
	return Rodux.Store.new(p or function(p2)
		return p2
	end, options or {}, { Rodux.thunkMiddleware })
end

local enus = localization.new("en-us")

return {
	mockServices = function(p)
		local v2 = {
			storeProvider = React.createElement(RoactRodux.StoreProvider, { store = fn(v) }, {
				foundationProvider = React.createElement(FoundationProvider, {
					colorMode = ColorMode.Dark
				}, {
					styleProvider = React.createElement(AppStyleProvider, { style = style }, {
						localizationProvider = React.createElement(LocalizationProvider, {
							localization = enus
						}, p)
					})
				})
			})
		}

		return (React.createElement(roactServices.ServiceProvider, {}, v2))
	end
}
