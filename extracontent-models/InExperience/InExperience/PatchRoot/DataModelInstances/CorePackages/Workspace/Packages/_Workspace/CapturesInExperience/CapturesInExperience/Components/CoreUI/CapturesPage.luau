local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)

local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local CaptureConfigCTAs = require(parent.Components.CoreUI.CaptureConfigCTAs)
local CapturesGallery = require(parent.Components.CapturesGallery.CapturesGallery)
local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local useAnalytics = require(parent.Analytics.useAnalytics)

return function(p)
	local closeSettingsMenu = React.useCallback(function()
		p.closeSettingsMenu()
	end, {})

	local v = useAnalytics()
	local state, setState = React.useState(0)

	local visible = useSelector(function(p2)
		return p2[Constants.RoduxKey].IsMenuOpen
	end)

	useEffectOnce(function()
		v.fireEvent(EventNames.CapturesPageOpenedInGameMenu)
	end, visible)

	local onAbsoluteSizeChanged = React.useCallback(function(vector2: Vector2)
		setState(vector2.Y)
	end, {})

	return React.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = visible },
		{
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, 12)
			}),
			CaptureConfigCTAs = React.createElement(CaptureConfigCTAs, {
				closeSettingsMenu = closeSettingsMenu,
				LayoutOrder = 1,
				onAbsoluteSizeChanged = onAbsoluteSizeChanged
			}),
			CapturesGallery = React.createElement(CapturesGallery, {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 1, -state - 12)
			})
		}
	)
end
