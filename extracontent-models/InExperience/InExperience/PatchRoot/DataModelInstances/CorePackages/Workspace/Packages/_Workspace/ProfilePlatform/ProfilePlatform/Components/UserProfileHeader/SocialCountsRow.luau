local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin

local function SocialCountsRow(props)
	return React.createElement(
		HorizontalPageMargin,
		{
			backgroundTransparency = 1,
			layoutOrder = props.layoutOrder,
			useAutomaticSizing = true,
			size = props.size
		},
		props.children
	)
end

return SocialCountsRow
