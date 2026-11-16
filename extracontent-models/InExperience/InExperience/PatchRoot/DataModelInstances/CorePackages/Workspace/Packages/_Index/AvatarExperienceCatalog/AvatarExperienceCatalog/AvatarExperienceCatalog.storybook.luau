local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device
local Rodux = require(parent.Rodux)
local RoactRodux = require(parent.RoactRodux)
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local UIBlox = require(parent.UIBlox)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local Style = require(parent.Dev.Style)
local DesignTokenProvider = Style.DesignTokenProvider
local ReactRoblox = require(parent.Dev.ReactRoblox)
local AppLocales = require(parent.Dev.AppLocales)
local localization = AppLocales.Localization
local Style2 = require(parent.Dev.Style)
local appStyleProvider = Style2.AppStyleProvider

local function createStore()
	return Rodux.Store.new(Rodux.createReducer({}, {}))
end

local v = { Light = ColorMode.Light, Dark = ColorMode.Dark }

local v2 = { Console = Device.Console, Desktop = Device.Desktop }

local v3 = {
	Default = { themeName = "Dark", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

return {
	name = "AvatarExperienceCatalog",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
			local colorMode = v[props.theme]

			return React.createElement(
				"Frame",
				{
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0),
					BackgroundTransparency = 1
				},
				{
					UIPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 10),
						PaddingBottom = UDim.new(0, 10),
						PaddingLeft = UDim.new(0, 10),
						PaddingRight = UDim.new(0, 10)
					}),
					LocalizationProvider = React.createElement(
						LocalizationProvider,
						{ localization = localization.new("en-us") },
						{
							AppStyleProvider = React.createElement(AppStyleProvider, {
								style = props and v3[props.theme] or v3.Default
							}, {
								StyleProvider = React.createElement(appStyleProvider, {
									style = props and v3[props.theme] or v3.Default
								}, {
									StoreProvider = React.createElement(
										RoactRodux.StoreProvider,
										{ store = createStore() },
										{
											DesignTokenProvider = React.createElement(
												DesignTokenProvider,
												{ tokenMappers = {} },
												{
													FoundationProvider = React.createElement(
														FoundationProvider,
														{
															colorMode = colorMode,
															device = v2[props.platform],
															preferences = props.settings
														},
														{ Child = React.createElement(p, props) }
													)
												}
											)
										}
									)
								})
							})
						}
					)
				}
			)
		end
	end
}
