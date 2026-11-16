local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Localization = require(parent2.Localization)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local UIBlox = require(parent2.UIBlox)

local SegmentedControl = UIBlox.App.Control.SegmentedControl

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local onToggleActivation = require(parent.Utils.onToggleActivation)
local useAnalytics = require(parent.Analytics.useAnalytics)

return function(p)
	local v = useAnalytics()
	local v2 = useDispatch()

	local v3 = useSelector(function(p2)
		return p2[Constants.RoduxKey].IsCapturesCoreGuiEnabled
	end)

	local v4 = useSelector(function(p2)
		return p2[Constants.RoduxKey].IsActive
	end)

	local v5 = useLocalization({
		offText = "Feature.Captures.Control.Off",
		onText = "Feature.Captures.Control.On"
	})

	local onTabActivated = React.useCallback(function(p2)
		onToggleActivation(
			v4,
			p2,
			v.fireEvent,
			v2,
			EventNames.CapturesActivatedInGameMenu,
			EventNames.CapturesDeactivatedInGameMenu
		)
	end, { v4 })

	return React.createElement(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(p.width, p.height)
		},
		{
			Control = React.createElement(SegmentedControl, {
				height = p.height,
				onTabActivated = onTabActivated,
				selectedTabIndex = v4 and 1 or 2,
				tabs = {
					{
						tabName = v5.onText,
						isDisabled = not v3
					},
					{
						tabName = v5.offText,
						isDisabled = not v3
					}
				},
				width = UDim.new(0, p.width)
			})
		}
	)
end
