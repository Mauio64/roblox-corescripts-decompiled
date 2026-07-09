local AppBlox = script:FindFirstAncestor("AppBlox")
local AppBloxParent = AppBlox.Parent
local React = require(AppBloxParent.React)
local Foundation = require(AppBloxParent.Foundation)
local ReactRoblox = require(AppBloxParent.Dev.ReactRoblox)
local FoundationProvider = Foundation.FoundationProvider

return {
	name = AppBlox.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 14
		-- upvalues: React (copy), FoundationProvider (copy)
		return function(p2) -- line: 15
			-- upvalues: React (copy), FoundationProvider (copy), p1 (copy)
			return React.createElement(FoundationProvider, {
				theme = p2.theme,
				device = p2.platform
			}, React.createElement(p1, p2))
		end
	end,
	storyRoots = { AppBlox }
}
