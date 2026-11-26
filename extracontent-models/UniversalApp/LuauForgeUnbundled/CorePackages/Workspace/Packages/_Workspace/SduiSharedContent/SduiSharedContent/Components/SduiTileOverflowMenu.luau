local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Responsive")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")

local getInputModeStore = Responsive.GetInputModeStore
local inputSize = Foundation.Enums.InputSize
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local useGameTileOverflowMenuFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/GameTile").useGameTileOverflowMenuFocusNavigation
local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
local useTokens = Foundation.Hooks.useTokens

local fFlagSduiGameTileDirectAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiGameTileDirectAction

local function SduiTileOverflowMenu(props)
	local v5 = useTokens()
	local v6 = useOverflowMenuOpen(props.menuKey)

	local v7 = useGameTileOverflowMenuFocusNavigation(
		props.menuKey,
		props.isSelected,
		props.parentRef,
		props.onMenuOpenChanged
	)
	local v8

	if fFlagSduiGameTileDirectAction then
		v8 = getInputModeStore(false).getLastInputType(false) == Responsive.Input.Pointer
	end

	if not (props.isHovered or props.isSelected or v6) then
		return nil
	end

	if
		fFlagSduiGameTileDirectAction
		and props.directActionComponentConfig
		and props.isHovered
		and not v6
		and v8
	then
		return React.createElement(getSduiComponentWrapper(props.directActionComponentConfig), {
			componentConfig = props.directActionComponentConfig,
			debugName = "SduiTileOverflowMenu.DirectAction",
			sduiContext = props.sduiContext,
			extraLocalProps = {
				anchorPoint = Vector2.new(1, 0),
				position = UDim2.new(1, -v5.Padding.Medium, 0, v5.Padding.Medium),
				zIndex = props.zIndex
			}
		})
	end

	local createElement = React.createElement
	local sduiComponentWrapper = getSduiComponentWrapper(props.componentConfig)
	local v9 = {
		componentConfig = props.componentConfig,
		debugName = props.debugName,
		sduiContext = props.sduiContext,
		extraLocalProps = 0
	}
	local v10 = {
		anchorPoint = Vector2.new(1, 0),
		buttonIconBackgroundStyle = v5.Color.OverMedia.OverMedia_0,
		buttonSize = inputSize.Small,
		hasOverflowButton = 0,
		includeMenuItemTelemetry = true,
		menuKey = 0,
		onMenuOpenChanged = 0,
		position = 0,
		setFocusRef = 0,
		shouldShowAnchor = 0,
		zIndex = 0
	}

	if not fFlagSduiGameTileDirectAction then
		v8 = getInputModeStore(false).getLastInputType(false) == Responsive.Input.Pointer
	end

	v10.hasOverflowButton = v8

	v10.menuKey = props.menuKey
	v10.onMenuOpenChanged = props.onMenuOpenChanged
	v10.position = UDim2.new(1, -v5.Padding.Medium, 0, v5.Padding.Medium)
	v10.setFocusRef = v7
	v10.shouldShowAnchor = props.isHovered
	v10.zIndex = props.zIndex
	v9.extraLocalProps = v10
	return createElement(sduiComponentWrapper, v9)
end

return React.memo(SduiTileOverflowMenu)
