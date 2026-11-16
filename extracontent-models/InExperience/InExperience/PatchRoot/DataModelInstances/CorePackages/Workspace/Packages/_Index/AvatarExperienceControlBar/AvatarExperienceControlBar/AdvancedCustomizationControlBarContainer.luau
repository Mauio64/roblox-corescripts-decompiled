local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)

local useAdvancedCustomizationControlBarProps = require(AvatarExperienceControlBar.useAdvancedCustomizationControlBarProps)
local BaseControlBarContainer = require(AvatarExperienceControlBar.BaseControlBarContainer)

local function AdvancedCustomizationControlBarContainer(p)
	local v = useAdvancedCustomizationControlBarProps(p)
	return React.createElement(BaseControlBarContainer, {
		config = v.config,
		onActiveMenuItemChanged = p.onActiveMenuItemChanged,
		LayoutOrder = p.LayoutOrder
	})
end

return React.memo(AdvancedCustomizationControlBarContainer)
