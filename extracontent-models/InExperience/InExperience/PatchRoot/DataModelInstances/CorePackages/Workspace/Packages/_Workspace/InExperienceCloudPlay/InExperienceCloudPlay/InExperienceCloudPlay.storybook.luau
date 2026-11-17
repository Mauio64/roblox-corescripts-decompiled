local InExperienceCloudPlay = script:FindFirstAncestor("InExperienceCloudPlay")
local parent = InExperienceCloudPlay.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device
local FoundationProvider = Foundation.FoundationProvider

local v = { Light = ColorMode.Light, Dark = ColorMode.Dark }

return {
	name = "InExperienceCloudPlay",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
			return React.createElement(FoundationProvider, {
				colorMode = v[props.theme],
				device = Device[props.platform],
				preferences = props.settings,
				scale = props.settings and props.settings.scale
			}, { Child = React.createElement(p, props) })
		end
	end,
	storyRoots = { InExperienceCloudPlay }
}
