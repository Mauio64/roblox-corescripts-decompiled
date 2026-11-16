local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.Dev.ReactRoblox)

local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device
local FoundationProvider = Foundation.FoundationProvider

local v = { Dark = ColorMode.Dark, Light = ColorMode.Light }

return {
	name = "MomentsCreation",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
			return React.createElement(FoundationProvider, {
				colorMode = v[props.theme] or ColorMode.Dark,
				device = Device[props.platform] or Device.Phone,
				preferences = props.settings,
				scale = props.settings and props.settings.scale
			}, { Child = React.createElement(p, props) })
		end
	end,
	storyRoots = { MomentsCreation }
}
