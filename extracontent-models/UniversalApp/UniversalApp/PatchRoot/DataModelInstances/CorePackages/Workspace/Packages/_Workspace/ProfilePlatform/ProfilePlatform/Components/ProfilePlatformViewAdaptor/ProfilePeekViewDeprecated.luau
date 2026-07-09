local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local PeekView = require(Parent.PeekView)
local PeekViewState = PeekView.PeekViewState
local PeekView2 = PeekView.PeekView
local useStyle = UIBlox.Core.Style.useStyle

return function(t1: {[any]: any}) -- line: 25
	-- upvalues: useStyle (copy), React (copy), PeekViewState (copy), PeekView2 (copy)
	local v9 = useStyle()
	local v10, v11 = React.useState(0)
	local v12 = React.useCallback(function(n1: number) -- line: 29
		-- upvalues: v11 (copy)
		v11(n1)
	end, {})
	local v13 = React.useCallback(function(p1, _) -- line: 33
		-- upvalues: t1 (copy), PeekViewState (copy)
		local onPeekViewClosed = t1.onPeekViewClosed

		if p1 == PeekViewState.Closed and onPeekViewClosed then
			onPeekViewClosed()
		end
	end, { t1.onPeekViewClosed })
	local viewWidth = t1.viewWidth
	local uDim2 = UDim2.new(0, viewWidth, 1, 0)
	local topBarHeight = t1.topBarHeight
	local v17 = v10 > 0.95
	local v18 = v10 > 0 and not v17

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 0),
		Size = uDim2
	}, {
		PeekViewTopBar = if not v17 then nil else t1.renderTopBar(),
		PeekViewTopBarEffectHolder = if not v18 then nil else React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, topBarHeight),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = v9.Theme.BackgroundDefault.Color,
			BackgroundTransparency = 1 - v10
		}),
		PeekViewContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 1, -topBarHeight + 6),
			Position = UDim2.new(0, 0, 0, topBarHeight - 6)
		}, {
			PeekView = React.createElement(PeekView2, {
				bottomDockedContainerHeight = 0,
				briefViewContentHeight = t1.briefViewContentHeight,
				mountAsFullView = t1.mountAsFullView,
				viewStateChanged = v13,
				briefToFullTransitionPercent = v12
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				Content = t1.renderContent()
			})
		})
	})
end
