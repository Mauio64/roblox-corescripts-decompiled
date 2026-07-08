local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local Rodux = require(Parent.Rodux)
local Foundation = require(Parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local ReactRoblox = require(Parent.Dev.ReactRoblox)
local RoactRodux = require(Parent.Dev.RoactRodux)
local t1 = {
	Light = Theme.Light,
	Dark = Theme.Dark
}
local v11 = Rodux.Store.new(function(p1) -- line: 17
	return p1
end, {
	ScreenSize = Vector2.new(1920, 1080),
	TopBar = {
		topBarHeight = 10
	},
	GlobalGuiInset = {
		bottom = 0,
		left = 0,
		right = 0,
		top = 0
	},
	GamesProductInfoKey = {},
	PlayabilityStatus = {},
	FetchingStatus = {},
	GameDetails = {},
	Personalization = {
		GameInfosKey = {}
	},
	GameIconsKey = {},
	UserGameVotes = {},
	AgeRecommendations = {},
	ShowAgeVerificationOverlay = {}
}, {})

return {
	name = "ServerDrivenUiContent",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p2) -- line: 34
		-- upvalues: React (copy), RoactRodux (copy), v11 (copy), FoundationProvider (copy), t1 (copy), Device (copy)
		return function(p3) -- line: 35
			-- upvalues: React (copy), RoactRodux (copy), v11 (copy), FoundationProvider (copy), t1 (copy), Device (copy), p2 (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 10),
					PaddingBottom = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10)
				}),
				StoreProvider = React.createElement(RoactRodux.StoreProvider, {
					store = v11
				}, {
					FoundationContext = React.createElement(FoundationProvider, {
						theme = t1[p3.theme],
						device = Device[p3.platform],
						preferences = p3.settings,
						scale = p3.settings and p3.settings.scale
					}, {
						Child = React.createElement(p2, p3)
					})
				})
			})
		end
	end,
	storyRoot = script.Parent.Content
}
