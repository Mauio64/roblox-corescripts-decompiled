local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local SegmentedControl = require(ParentParentParent.UIBlox).App.Control.SegmentedControl
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local onToggleActivation = require(ParentParent.Utils.onToggleActivation)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)

return function(t1: {[any]: any}) -- line: 25
	-- upvalues: useAnalytics (copy), useDispatch (copy), useSelector (copy), Constants (copy), useLocalization (copy), React (copy), onToggleActivation (copy), EventNames (copy), SegmentedControl (copy)
	local v15 = useAnalytics()
	local v16 = useDispatch()
	local v17 = useSelector(function(p1) -- line: 29
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].IsCapturesCoreGuiEnabled
	end)
	local v18 = useSelector(function(p2) -- line: 33
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].IsActive
	end)
	local v19 = useLocalization({
		offText = "Feature.Captures.Control.Off",
		onText = "Feature.Captures.Control.On"
	})
	local v20 = React.useCallback(function(p3) -- line: 42
		-- upvalues: onToggleActivation (copy), v18 (copy), v15 (copy), v16 (copy), EventNames (copy)
		onToggleActivation(v18, p3, v15.fireEvent, v16, EventNames.CapturesActivatedInGameMenu, EventNames.CapturesDeactivatedInGameMenu)
	end, { v18 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(t1.width, t1.height)
	}, {
		Control = React.createElement(SegmentedControl, {
			height = t1.height,
			onTabActivated = v20,
			selectedTabIndex = not v18 and 2 or 1,
			tabs = {
				{
					tabName = v19.onText,
					isDisabled = not v17
				},
				{
					tabName = v19.offText,
					isDisabled = not v17
				}
			},
			width = UDim.new(0, t1.width)
		})
	})
end
