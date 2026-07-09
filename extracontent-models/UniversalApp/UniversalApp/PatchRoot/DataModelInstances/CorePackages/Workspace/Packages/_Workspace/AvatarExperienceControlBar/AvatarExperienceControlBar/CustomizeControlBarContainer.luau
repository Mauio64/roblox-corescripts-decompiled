local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local useCustomizeControlBarProps = require(AvatarExperienceControlBar.useCustomizeControlBarProps)
local BaseControlBarContainer = require(AvatarExperienceControlBar.BaseControlBarContainer)

local function CustomizeControlBarContainer(p1) -- line: 9
	-- upvalues: useCustomizeControlBarProps (copy), React (copy), BaseControlBarContainer (copy)
	local v8 = useCustomizeControlBarProps(p1)

	return React.createElement(BaseControlBarContainer, {
		config = v8.config,
		onActiveMenuItemChanged = p1.onActiveMenuItemChanged,
		LayoutOrder = p1.LayoutOrder
	})
end

return React.memo(CustomizeControlBarContainer)
