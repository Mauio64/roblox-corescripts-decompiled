local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)

local PeekView = require(parent.PeekView)
local PeekViewState = PeekView.PeekViewState
local peekView = PeekView.PeekView

local useStyle = UIBlox.Core.Style.useStyle

return function(props)
	local v = useStyle()
	local state, setState = React.useState(0)

	local briefToFullTransitionPercent = React.useCallback(function(p: number)
		setState(p)
	end, {})

	local viewStateChanged = React.useCallback(function(p, _)
		local onPeekViewClosed = props.onPeekViewClosed

		if p == PeekViewState.Closed and onPeekViewClosed then
			onPeekViewClosed()
		end
	end, { props.onPeekViewClosed })

	local viewWidth = props.viewWidth
	local udim = UDim2.new(0, viewWidth, 1, 0)
	local topBarHeight = props.topBarHeight
	local v2 = state > 0.95
	local v3

	if state > 0 then
		v3 = not v2
	else
		v3 = false
	end

	local createElement = React.createElement
	local v4 = {
		Position = UDim2.fromOffset(0, 0),
		Size = udim,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}
	local peekViewTopBar

	if v2 then
		peekViewTopBar = props.renderTopBar()
	end

	local peekViewTopBarEffectHolder

	if v3 then
		peekViewTopBarEffectHolder = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, topBarHeight),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = v.Theme.BackgroundDefault.Color,
			BorderSizePixel = 0,
			BackgroundTransparency = 1 - state
		})
	end

	return createElement("Frame", v4, {
		PeekViewTopBar = peekViewTopBar,
		PeekViewTopBarEffectHolder = peekViewTopBarEffectHolder,
		PeekViewContainer = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, -topBarHeight + 6),
			Position = UDim2.new(0, 0, 0, topBarHeight - 6),
			BackgroundTransparency = 1,
			ClipsDescendants = true
		}, {
			PeekView = React.createElement(peekView, {
				briefViewContentHeight = props.briefViewContentHeight,
				bottomDockedContainerHeight = 0,
				mountAsFullView = props.mountAsFullView,
				viewStateChanged = viewStateChanged,
				briefToFullTransitionPercent = briefToFullTransitionPercent
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				Content = props.renderContent()
			})
		})
	})
end
