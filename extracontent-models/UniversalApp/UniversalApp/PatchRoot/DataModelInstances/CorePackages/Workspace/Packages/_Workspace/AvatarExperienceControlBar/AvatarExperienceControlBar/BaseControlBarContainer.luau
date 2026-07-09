local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local useBaseControlBarProps = require(AvatarExperienceControlBar.useBaseControlBarProps)
local BaseControlBar = require(AvatarExperienceControlBar.BaseControlBar)

local function BaseControlBarContainer(p1) -- line: 9
	-- upvalues: useBaseControlBarProps (copy), React (copy), BaseControlBar (copy)
	local v8 = useBaseControlBarProps(p1)

	return React.createElement(BaseControlBar, v8)
end

return React.memo(BaseControlBarContainer)
