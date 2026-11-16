local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local RoactRodux = require(parent.RoactRodux)
local Rodux = require(parent.Rodux)
local Style = require(parent.Style)
local Foundation = require(parent.Foundation)

local GameInviteReducer = require(GameInvite.State.Reducers.GameInviteReducer)

return {
	name = "GameInvite",
	storyRoot = GameInvite,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(callback)
		return function(p)
			return React.createElement(Style.StyleProviderWithDefaultTheme, { withDarkTheme = true }, {
				StoreProvider = React.createElement(RoactRodux.StoreProvider, {
					store = Rodux.Store.new(GameInviteReducer, nil, { Rodux.thunkMiddleware })
				}, {
					FoundationProvider = React.createElement(
						Foundation.FoundationProvider,
						{ colorMode = Foundation.Enums.ColorMode.Dark },
						{ Story = callback(p) }
					)
				})
			})
		end
	end
}
