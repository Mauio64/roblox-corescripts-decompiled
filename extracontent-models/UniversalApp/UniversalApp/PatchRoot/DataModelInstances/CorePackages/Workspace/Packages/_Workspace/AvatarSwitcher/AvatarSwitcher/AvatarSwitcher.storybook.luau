local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local React = require(AvatarSwitcherParent.React)
local ReactRoblox = require(AvatarSwitcherParent.ReactRoblox)
local ContextProviders = require(AvatarSwitcher.Internal.ContextProviders)

return {
	name = AvatarSwitcher.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoots = { AvatarSwitcher.Components },
	mapStory = function(p1) -- line: 16
		-- upvalues: React (copy), ContextProviders (copy)
		return function(p2) -- line: 17
			-- upvalues: React (copy), ContextProviders (copy), p1 (copy)
			return React.createElement(ContextProviders, {
				theme = p2.theme,
				overlayGui = p2.focus
			}, React.createElement(p1, p2))
		end
	end
}
