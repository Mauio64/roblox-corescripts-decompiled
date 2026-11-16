local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(parent.React)
local Rodux = require(parent.Rodux)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device
local ReactRoblox = require(parent.Dev.ReactRoblox)
local RoactRodux = require(parent.Dev.RoactRodux)

local v = { Light = ColorMode.Light, Dark = ColorMode.Dark }

local store = Rodux.Store.new(function(p)
	return p
end, {
	ScreenSize = Vector2.new(1920, 1080),
	TopBar = { topBarHeight = 10 },
	GlobalGuiInset = { bottom = 0, left = 0, right = 0, top = 0 },
	GamesProductInfoKey = {},
	PlayabilityStatus = {},
	FetchingStatus = {},
	GameDetails = {},
	Personalization = { GameInfosKey = {} },
	GameIconsKey = {},
	UserGameVotes = {},
	AgeRecommendations = {},
	ShowAgeVerificationOverlay = {}
}, {})

return {
	name = "ServerDrivenUiContent",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
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
					StoreProvider = React.createElement(RoactRodux.StoreProvider, { store = store }, {
						FoundationContext = React.createElement(FoundationProvider, {
							colorMode = v[props.theme],
							device = Device[props.platform],
							preferences = props.settings,
							scale = props.settings and props.settings.scale
						}, { Child = React.createElement(p, props) })
					})
				}
			)
		end
	end,
	storyRoot = script.Parent.Content
}
