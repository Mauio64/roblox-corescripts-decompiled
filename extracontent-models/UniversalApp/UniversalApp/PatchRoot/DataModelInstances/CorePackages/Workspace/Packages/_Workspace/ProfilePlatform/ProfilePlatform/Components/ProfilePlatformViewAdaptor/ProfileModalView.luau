local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local useStyle = require(Parent.UIBlox).Core.Style.useStyle
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(Parent.InputHandlers)
local FFlagEnableLeftNavOnConsole = require(Parent.SharedFlags).FFlagEnableLeftNavOnConsole
local Display = require(Parent.Display)
local useSignalState = require(Parent.SignalsReact).useSignalState
local View = require(Parent.Foundation).View

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: useStyle (copy), FFlagEnableLeftNavOnConsole (copy), useSignalState (copy), Display (copy), React (copy), InputHandlers (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), FocusNavigationEventNameEnum (copy), View (copy)
	local v14 = useStyle()
	local v15 = if not FFlagEnableLeftNavOnConsole then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local t2 = {
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.new(0, t1.viewWidth, 1, 0),
		BackgroundTransparency = v14.Theme.BackgroundDefault.Transparency,
		BackgroundColor3 = v14.Theme.BackgroundDefault.Color
	}
	local v17 = React.useCallback(function(p1) -- line: 49
		-- upvalues: React (copy)
		return React.createElement("TextButton", {
			BackgroundTransparency = 1,
			Text = "",
			Selectable = false,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0)
		}, { p1 })
	end)
	local v18 = React.useMemo(function() -- line: 59
		-- upvalues: InputHandlers (copy), t1 (copy)
		return InputHandlers.onRelease(function(p2) -- line: 60
			-- upvalues: t1 (copy)
			p2:cancel()
			t1.navigateBack()
		end)
	end, { t1.navigateBack })

	return React.createElement("ImageButton", {
		Position = if not FFlagEnableLeftNavOnConsole then nil else UDim2.fromOffset(0, -v15.top),
		Size = if not FFlagEnableLeftNavOnConsole then UDim2.new(1, 0, 1, 0) else UDim2.new(1, v15.right, 1, v15.top + v15.bottom),
		BackgroundTransparency = v14.Theme.Overlay.Transparency,
		BackgroundColor3 = v14.Theme.Overlay.Color,
		Active = true,
		AutoButtonColor = false,
		[React.Event.Activated] = t1.navigateBack
	}, {
		ProfileWindow = React.createElement(FocusNavigableSurfaceWrapper, {
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
			frameProps = t2,
			customEventHandlers = {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = v18
				}
			}
		}, { v17({
			ProfileTopBarContainer = React.createElement(View, {
				tag = "position-top-left",
				ZIndex = 100,
				Size = UDim2.new(1, 0, 0, 56)
			}, {
				ProfileTopBar = t1.renderTopBar()
			}),
			PeekViewContainer = React.createElement("ScrollingFrame", {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				Selectable = false,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Size = UDim2.new(1, 1, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				CanvasSize = UDim2.new(1, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y
			}, {
				Content = t1.renderContent()
			})
		}) })
	})
end
