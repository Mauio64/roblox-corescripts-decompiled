local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")

local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.Dev.ReactRoblox)
local UIBlox = require(parent.UIBlox)
local Style = require(parent.Style)
local DesignTokenProvider = Style.DesignTokenProvider
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local RoactRodux = require(parent.RoactRodux)
local Rodux = require(parent.Rodux)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device

UIBlox.init(require(parent.Dev.RobloxAppUIBloxConfig))

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local function createLocalization()
	return {
		Format = function(_, p: string)
			return p
		end,
		GetLocale = function(): string
			return "locale"
		end
	}
end

local function createStore()
	local reducer = Rodux.createReducer({}, {})
	return Rodux.Store.new(reducer, nil, { Rodux.makeThunkMiddleware({}) })
end

local v = { Light = ColorMode.Light, Dark = ColorMode.Dark }

local v2 = { Console = Device.Console, Desktop = Device.Desktop }

local v3 = {
	Default = { themeName = "Dark", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

return {
	name = "AvatarExperienceInspectAndBuy",
	storyRoot = AvatarExperienceInspectAndBuy,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
			local colorMode = v[props.theme]

			return React.createElement(LocalizationProvider, { localization = createLocalization() }, {
				AppStyleProvider = React.createElement(AppStyleProvider, {
					style = props and v3[props.theme] or v3.Default
				}, {
					StoreProvider = React.createElement(RoactRodux.StoreProvider, {
						store = createStore()
					}, {
						DesignTokenProvider = React.createElement(DesignTokenProvider, {
							tokenMappers = {}
						}, {
							FoundationProvider = React.createElement(
								FoundationProvider,
								{
									colorMode = colorMode,
									device = v2[props.platform],
									preferences = props.settings
								},
								{ Child = React.createElement(p, props) }
							)
						})
					})
				})
			})
		end
	end
}
