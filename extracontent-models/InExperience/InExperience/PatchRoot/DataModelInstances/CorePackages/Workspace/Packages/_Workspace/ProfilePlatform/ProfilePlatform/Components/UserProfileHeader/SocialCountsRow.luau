local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local HorizontalPageMargin = require(Parent.UIBlox).App.Container.HorizontalPageMargin

local function SocialCountsRow(t1: {[any]: any}) -- line: 14
	-- upvalues: React (copy), HorizontalPageMargin (copy)
	return React.createElement(HorizontalPageMargin, {
		backgroundTransparency = 1,
		useAutomaticSizing = true,
		layoutOrder = t1.layoutOrder,
		size = t1.size
	}, t1.children)
end

return SocialCountsRow
