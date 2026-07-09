local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local React = require(SocialUpsellParent.React)
local ReactRoblox = require(SocialUpsellParent.ReactRoblox)
local FoundationProvider = require(SocialUpsellParent.Foundation).FoundationProvider

return {
	name = SocialUpsell.Name,
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
	storyRoots = { SocialUpsell }
}
