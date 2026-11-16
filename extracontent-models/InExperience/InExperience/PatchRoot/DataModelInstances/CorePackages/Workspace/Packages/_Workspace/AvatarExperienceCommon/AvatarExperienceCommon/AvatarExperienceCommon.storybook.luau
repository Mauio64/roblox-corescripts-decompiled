local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local UIBlox = require(parent.UIBlox)

UIBlox.init(require(parent.Dev.RobloxAppUIBloxConfig))
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device
local Rodux = require(parent.Rodux)
local Style = require(parent.Style)
local DesignTokenProvider = Style.DesignTokenProvider
local RoactRodux = require(parent.RoactRodux)
local Style2 = require(parent.Style)
local AppStyleProvider = Style2.AppStyleProvider
local appStyleProvider = UIBlox.App.Style.AppStyleProvider
local ReactRoblox = require(parent.ReactRoblox)

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
	name = "AvatarExperienceCommon",
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
					AppStyleProvider = React.createElement(appStyleProvider, {
						style = props and v3[props.theme] or v3.Default
					}, {
						StyleProvider = React.createElement(AppStyleProvider, {
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
				}
			)
		end
	end
}
