local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)

local useCustomizeControlBarProps = require(AvatarExperienceControlBar.useCustomizeControlBarProps)
local BaseControlBarContainer = require(AvatarExperienceControlBar.BaseControlBarContainer)

local function CustomizeControlBarContainer(p)
	local v = useCustomizeControlBarProps(p)
	return React.createElement(BaseControlBarContainer, {
		config = v.config,
		onActiveMenuItemChanged = p.onActiveMenuItemChanged,
		LayoutOrder = p.LayoutOrder
	})
end

return React.memo(CustomizeControlBarContainer)
