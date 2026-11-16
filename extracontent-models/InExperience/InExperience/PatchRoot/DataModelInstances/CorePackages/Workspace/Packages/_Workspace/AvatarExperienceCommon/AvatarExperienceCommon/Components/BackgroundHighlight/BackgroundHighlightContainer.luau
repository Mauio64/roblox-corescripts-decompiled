local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)

local BackgroundHighlight = require(script.Parent.BackgroundHighlight)
local useBackgroundHighlightProps = require(script.Parent.useBackgroundHighlightProps)

local function BackgroundHighlightContainer(p)
	local v = useBackgroundHighlightProps(p)
	return React.createElement(BackgroundHighlight, v)
end

return BackgroundHighlightContainer
