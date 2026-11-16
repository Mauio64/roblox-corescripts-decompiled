local TextChannelWindow = script:FindFirstAncestor("TextChannelWindow")

local parent = TextChannelWindow.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)

local FoundationProvider = Foundation.FoundationProvider

return {
	name = TextChannelWindow.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoots = { TextChannelWindow },
	mapStory = function(p)
		return function(p2)
			return React.createElement(FoundationProvider, {
				colorMode = p2 and p2.theme,
				device = p2 and p2.platform
			}, React.createElement(p, p2))
		end
	end
}
