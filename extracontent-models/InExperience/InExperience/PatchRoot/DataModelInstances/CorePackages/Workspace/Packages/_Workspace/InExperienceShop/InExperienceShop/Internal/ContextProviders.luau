local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("InExperienceShop").Parent

local React = require(parent.React)
local Style = require(parent.Style)
local Foundation = require(parent.Foundation)
local AppLocales = require(parent.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local function ContextProviders(props)
	return React.createElement(
		Foundation.FoundationProvider,
		{ colorMode = props.theme, overlayGui = props.overlayGui },
		{
			AppStyleProvider = React.createElement(Style.AppStyleProvider, {
				style = { themeName = props.theme, fontName = "Gotham" }
			}, {
				LocalizationProvider = React.createElement(
					LocalizationProvider,
					{
						localization = Localization.new(LocalizationService.RobloxLocaleId)
					},
					props.children
				)
			})
		}
	)
end

return ContextProviders
