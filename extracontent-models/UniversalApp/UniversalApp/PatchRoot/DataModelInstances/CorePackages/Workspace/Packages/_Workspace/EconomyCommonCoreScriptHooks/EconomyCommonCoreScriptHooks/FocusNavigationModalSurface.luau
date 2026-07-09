local Parent = script:FindFirstAncestor("EconomyCommonCoreScriptHooks").Parent
local React = require(Parent.React)
local FocusNavigableSurfaceIdentifierEnum = require(Parent.FocusNavigationUtils).FocusNavigableSurfaceIdentifierEnum
local useFocusNavigationSurface = require(script.Parent.useFocusNavigationSurface)

local function FocusNavigationModalSurface(t1: {[any]: any}) -- line: 16
	-- upvalues: useFocusNavigationSurface (copy), FocusNavigableSurfaceIdentifierEnum (copy), React (copy)
	local v7 = useFocusNavigationSurface({
		selectionGroupName = t1.selectionGroupName,
		focusNavigableSurfaceIdentifier = if not t1.surfaceIdentifier then FocusNavigableSurfaceIdentifierEnum.CentralOverlay else t1.surfaceIdentifier
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = v7,
		Size = UDim2.fromScale(1, 1),
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop
	}, t1.children)
end

return FocusNavigationModalSurface
