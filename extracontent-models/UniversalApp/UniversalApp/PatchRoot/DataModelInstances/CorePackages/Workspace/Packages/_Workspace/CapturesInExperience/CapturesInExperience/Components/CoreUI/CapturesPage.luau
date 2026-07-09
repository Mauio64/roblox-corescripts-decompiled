local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local CaptureConfigCTAs = require(ParentParent.Components.CoreUI.CaptureConfigCTAs)
local CapturesGallery = require(ParentParent.Components.CapturesGallery.CapturesGallery)
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)

return function(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), useAnalytics (copy), useSelector (copy), Constants (copy), useEffectOnce (copy), EventNames (copy), CaptureConfigCTAs (copy), CapturesGallery (copy)
	local v13 = React.useCallback(function() -- line: 23
		-- upvalues: t1 (copy)
		t1.closeSettingsMenu()
	end, {})
	local v14 = useAnalytics()
	local v15, v16 = React.useState(0)
	local v17 = useSelector(function(p1) -- line: 30
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].IsMenuOpen
	end)

	useEffectOnce(function() -- line: 34
		-- upvalues: v14 (copy), EventNames (copy)
		v14.fireEvent(EventNames.CapturesPageOpenedInGameMenu)
	end, v17)

	local v18 = React.useCallback(function(vector2: Vector2) -- line: 38
		-- upvalues: v16 (copy)
		v16(vector2.Y)
	end, {})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Visible = v17
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 12)
		}),
		CaptureConfigCTAs = React.createElement(CaptureConfigCTAs, {
			LayoutOrder = 1,
			closeSettingsMenu = v13,
			onAbsoluteSizeChanged = v18
		}),
		CapturesGallery = React.createElement(CapturesGallery, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 1, -v15 - 12)
		})
	})
end
