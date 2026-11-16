local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)

local useBaseControlBarProps = require(AvatarExperienceControlBar.useBaseControlBarProps)
local BaseControlBar = require(AvatarExperienceControlBar.BaseControlBar)

local function BaseControlBarContainer(p)
	local v = useBaseControlBarProps(p)
	return React.createElement(BaseControlBar, v)
end

return React.memo(BaseControlBarContainer)
