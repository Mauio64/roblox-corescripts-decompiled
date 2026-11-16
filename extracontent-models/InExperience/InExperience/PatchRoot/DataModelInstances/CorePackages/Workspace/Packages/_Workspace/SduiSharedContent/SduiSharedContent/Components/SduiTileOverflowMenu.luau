local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local AppBlox = require(parent.AppBlox)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local SduiCoreSystem = require(parent.SduiCoreSystem)

local GetInputModeStore = Responsive.GetInputModeStore
local InputSize = Foundation.Enums.InputSize
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local GameTile = require(parent.GameTile)
local useGameTileOverflowMenuFocusNavigation = GameTile.useGameTileOverflowMenuFocusNavigation
local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
local useTokens = Foundation.Hooks.useTokens

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiGameTileDirectAction = SharedFlags.FFlagSduiGameTileDirectAction

local function SduiTileOverflowMenu(props)
	local v = useTokens()
	local v2 = useOverflowMenuOpen(props.menuKey)

	local setFocusRef = useGameTileOverflowMenuFocusNavigation(
		props.menuKey,
		props.isSelected,
		props.parentRef,
		props.onMenuOpenChanged
	)
	local hasOverflowButton

	if FFlagSduiGameTileDirectAction then
		hasOverflowButton = GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Pointer
	end

	if not (props.isHovered or props.isSelected or v2) then
		return nil
	end

	if
		FFlagSduiGameTileDirectAction
		and props.directActionComponentConfig
		and props.isHovered
		and not v2
		and hasOverflowButton
	then
		return React.createElement(getSduiComponentWrapper(props.directActionComponentConfig), {
			componentConfig = props.directActionComponentConfig,
			debugName = "SduiTileOverflowMenu.DirectAction",
			sduiContext = props.sduiContext,
			extraLocalProps = {
				anchorPoint = Vector2.new(1, 0),
				position = UDim2.new(1, -v.Padding.Medium, 0, v.Padding.Medium),
				zIndex = props.zIndex
			}
		})
	end

	local createElement = React.createElement
	local sduiComponentWrapper = getSduiComponentWrapper(props.componentConfig)
	local v3 = {
		componentConfig = props.componentConfig,
		debugName = props.debugName,
		sduiContext = props.sduiContext,
		extraLocalProps = 0
	}
	local extraLocalProps = {
		anchorPoint = Vector2.new(1, 0),
		buttonIconBackgroundStyle = v.Color.OverMedia.OverMedia_0,
		buttonSize = InputSize.Small,
		hasOverflowButton = 0,
		includeMenuItemTelemetry = true,
		menuKey = 0,
		onMenuOpenChanged = 0,
		position = 0,
		setFocusRef = 0,
		shouldShowAnchor = 0,
		zIndex = 0
	}

	if not FFlagSduiGameTileDirectAction then
		hasOverflowButton = GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Pointer
	end

	extraLocalProps.hasOverflowButton = hasOverflowButton

	extraLocalProps.menuKey = props.menuKey
	extraLocalProps.onMenuOpenChanged = props.onMenuOpenChanged
	extraLocalProps.position = UDim2.new(1, -v.Padding.Medium, 0, v.Padding.Medium)
	extraLocalProps.setFocusRef = setFocusRef
	extraLocalProps.shouldShowAnchor = props.isHovered
	extraLocalProps.zIndex = props.zIndex
	v3.extraLocalProps = extraLocalProps
	return createElement(sduiComponentWrapper, v3)
end

return React.memo(SduiTileOverflowMenu)
