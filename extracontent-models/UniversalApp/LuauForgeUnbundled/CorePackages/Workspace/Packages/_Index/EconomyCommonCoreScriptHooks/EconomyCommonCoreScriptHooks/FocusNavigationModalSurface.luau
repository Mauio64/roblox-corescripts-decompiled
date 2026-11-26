local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EconomyCommonCoreScriptHooks/React")
local focusNavigableSurfaceIdentifierEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/EconomyCommonCoreScriptHooks/FocusNavigationUtils").FocusNavigableSurfaceIdentifierEnum

local useFocusNavigationSurface = require("@game/CorePackages/Workspace/Packages/_Index/EconomyCommonCoreScriptHooks/EconomyCommonCoreScriptHooks/useFocusNavigationSurface")

local function FocusNavigationModalSurface(props)
	local v6 = {
		selectionGroupName = props.selectionGroupName,
		focusNavigableSurfaceIdentifier = 0
	}
	local v7 = if props.surfaceIdentifier then props.surfaceIdentifier else focusNavigableSurfaceIdentifierEnum.CentralOverlay
	v6.focusNavigableSurfaceIdentifier = v7
	local v8 = useFocusNavigationSurface(v6)

	return React.createElement("Frame", {
		ref = v8,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop
	}, props.children)
end

return FocusNavigationModalSurface
