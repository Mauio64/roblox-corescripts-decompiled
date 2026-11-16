local parent = script:FindFirstAncestor("EconomyCommonCoreScriptHooks").Parent
local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local useFocusNavigationSurface = require(script.Parent.useFocusNavigationSurface)

local function FocusNavigationModalSurface(props)
	local v = { selectionGroupName = props.selectionGroupName, focusNavigableSurfaceIdentifier = 0 }
	local focusNavigableSurfaceIdentifier

	if props.surfaceIdentifier then
		focusNavigableSurfaceIdentifier = props.surfaceIdentifier
	else
		focusNavigableSurfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
	end

	v.focusNavigableSurfaceIdentifier = focusNavigableSurfaceIdentifier
	local ref = useFocusNavigationSurface(v)

	return React.createElement("Frame", {
		ref = ref,
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
