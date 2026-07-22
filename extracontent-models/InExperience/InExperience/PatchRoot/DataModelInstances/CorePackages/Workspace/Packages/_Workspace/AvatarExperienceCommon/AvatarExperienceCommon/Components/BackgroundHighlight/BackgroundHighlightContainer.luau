local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local BackgroundHighlight = require(script.Parent.BackgroundHighlight)
local useBackgroundHighlightProps = require(script.Parent.useBackgroundHighlightProps)

local function BackgroundHighlightContainer(p1) -- line: 11
	-- upvalues: useBackgroundHighlightProps (copy), React (copy), BackgroundHighlight (copy)
	local v7 = useBackgroundHighlightProps(p1)

	return React.createElement(BackgroundHighlight, v7)
end

return BackgroundHighlightContainer
