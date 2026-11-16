local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Tooltip = require(AvatarExperienceControlBar.Components.Tooltip)
require(AvatarExperienceControlBar.ControlBarTypes)
local ImageItem = require(script.Parent.ImageItem)

local function ImageItemWithTooltip(props, ref)
	local gui = FocusNavigationUtils.FocusNavigableSurfaceRegistry.useRegistryEntry(FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.Auxiliary)

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
		ref = ref
	}))

	if props.toolTipConfig.compact and gui then
		return React.createElement(Foundation.OverlayProvider, { gui = gui, children = element })
	end

	return element
end

return React.forwardRef(ImageItemWithTooltip)
