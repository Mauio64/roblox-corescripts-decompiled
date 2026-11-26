local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/FocusNavigationUtils")
local Tooltip = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/Tooltip")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/ControlBarTypes")
local ImageItem = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/Items/ImageItem")

local function ImageItemWithTooltip(props, p2)
	local v5 = FocusNavigationUtils.FocusNavigableSurfaceRegistry.useRegistryEntry(FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.Auxiliary)

	local clone = table.clone(props.toolTipConfig)
	clone.LayoutOrder = props.LayoutOrder
	clone.Visible = props.Visible
	clone.open = props.Visible ~= false and clone.open

	local element = React.createElement(Tooltip, clone, React.createElement(ImageItem, {
		thumbnailUrl = props.thumbnailUrl,
		isActive = props.isActive,
		size = props.size,
		onActivated = props.onActivated,
		disabled = props.disabled,
		enableFocusAnimation = props.enableFocusAnimation,
		Visible = props.Visible,
		LayoutOrder = props.LayoutOrder,
		hideIndicator = props.hideIndicator,
		ref = p2
	}))

	if props.toolTipConfig.compact and v5 then
		return React.createElement(Foundation.OverlayProvider, {
			gui = v5,
			children = element
		})
	end

	return element
end

return React.forwardRef(ImageItemWithTooltip)
