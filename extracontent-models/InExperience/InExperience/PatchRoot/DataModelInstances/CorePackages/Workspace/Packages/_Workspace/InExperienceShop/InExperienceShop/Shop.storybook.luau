local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local ReactRoblox = require(InExperienceShopParent.ReactRoblox)
local ContextProviders = require(InExperienceShop.Internal.ContextProviders)

return {
	name = InExperienceShop.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoots = { InExperienceShop.Components },
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
