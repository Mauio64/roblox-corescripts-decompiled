local FriendsActivityFeed = script:FindFirstAncestor("FriendsActivityFeed")
local FriendsActivityFeedParent = FriendsActivityFeed.Parent
local React = require(FriendsActivityFeedParent.React)
local ReactRoblox = require(FriendsActivityFeedParent.Dev.ReactRoblox)
local Foundation = require(FriendsActivityFeedParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local t1 = {
	Light = Theme.Light,
	Dark = Theme.Dark
}

return {
	name = "FriendsActivityFeed",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 17
		-- upvalues: React (copy), FoundationProvider (copy), t1 (copy), Device (copy)
		return function(p2) -- line: 18
			-- upvalues: React (copy), FoundationProvider (copy), t1 (copy), Device (copy), p1 (copy)
			return React.createElement(FoundationProvider, {
				theme = t1[p2.theme],
				device = Device[p2.platform],
				preferences = p2.settings,
				scale = p2.settings and p2.settings.scale
			}, {
				Child = React.createElement(p1, p2)
			})
		end
	end,
	storyRoots = { FriendsActivityFeed }
}
