local TextChannelWindow = script:FindFirstAncestor("TextChannelWindow")
local TextChannelWindowParent = TextChannelWindow.Parent
local React = require(TextChannelWindowParent.React)
local ReactRoblox = require(TextChannelWindowParent.ReactRoblox)
local FoundationProvider = require(TextChannelWindowParent.Foundation).FoundationProvider

return {
	name = TextChannelWindow.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoots = { TextChannelWindow },
	mapStory = function(p1) -- line: 17
		-- upvalues: React (copy), FoundationProvider (copy)
		return function(p2) -- line: 18
			-- upvalues: React (copy), FoundationProvider (copy), p1 (copy)
			return React.createElement(FoundationProvider, {
				theme = p2 and p2.theme,
				device = p2 and p2.platform
			}, React.createElement(p1, p2))
		end
	end
}
