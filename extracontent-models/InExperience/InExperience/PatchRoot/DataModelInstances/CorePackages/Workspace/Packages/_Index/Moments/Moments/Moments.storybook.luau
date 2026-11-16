local LocalizationService = game:GetService("LocalizationService")

local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local RobloxAppLocales = require(parent.Dev.RobloxAppLocales)
local localization = RobloxAppLocales.Localization

local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device
local FoundationProvider = Foundation.FoundationProvider

local v = { Dark = ColorMode.Dark, Light = ColorMode.Light }

return {
	name = "Moments",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
			local localization2 = React.useMemo(function()
				return localization.new(LocalizationService.RobloxLocaleId)
			end, {})

			return React.createElement(LocalizationProvider, { localization = localization2 }, {
				Foundation = React.createElement(FoundationProvider, {
					colorMode = v[props.theme] or ColorMode.Dark,
					device = Device[props.platform] or Device.Phone,
					preferences = props.settings,
					scale = props.settings and props.settings.scale
				}, { Child = React.createElement(p, props) })
			})
		end
	end,
	storyRoots = { Moments }
}
