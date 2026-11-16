local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)

local IntroScroll = require(parent.HorizontalNav.IntroScroll)
local GradientFrame = require(parent.HorizontalNav.GradientFrame)
local ArrowFrame = require(parent.HorizontalNav.ArrowFrame)
local Utils = require(parent.HorizontalNav.Utils)
local useIsMouseAndKeyboard = require(parent2.Utility.useIsMouseAndKeyboard)

local function ScrollingListWithArrowsAndGradient(props)
	local listHeight = props.listHeight
	local childWidgetIndex = props.childWidgetIndex
	local useIntroScroll = props.useIntroScroll
	local canvasWidth = props.canvasWidth or 0

	local v = useIsMouseAndKeyboard()
	local ref = React.useRef(nil)

	local isVisibleLeft, v2 = React.useBinding(false)
	local isVisibleRight, v3 = React.useBinding(false)

	local canvasPosition, updateCanvasPosition = React.useBinding(Vector2.new(0, 0))

	local v4 = React.useCallback(function(p)
		local value = ref:getValue()

		if not value then
			return
		end

		local shouldShowGradientsForScrollingFrame, visible, visible2 = Utils.shouldShowGradientsForScrollingFrame(p)

		value.Visible = shouldShowGradientsForScrollingFrame and (not props.hideGradient or v)

		local left = value:FindFirstChild("Left")
		local right = value:FindFirstChild("Right")

		if left and right then
			left.Visible = visible
			right.Visible = visible2
		end

		v2(visible)
		v3(visible2)
	end, { ref, v2, v3 })

	local v5 = React.useCallback(function(p)
		v4(p)

		updateCanvasPosition(p.CanvasPosition)
	end, { v4, updateCanvasPosition })

	React.useEffect(function()
		local value = props.scrollingFrameRef:getValue()

		if value then
			v4(value)
		end
	end)

	return React.createElement(React.Fragment, {}, {
		ScrollingList = React.createElement("ScrollingFrame", {
			ClipsDescendants = props.clipsDescendants,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, canvasWidth, 1, 0),
			CanvasPosition = canvasPosition,
			ScrollBarThickness = 0,
			BackgroundTransparency = 1,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollingDirection = Enum.ScrollingDirection.X,
			ZIndex = 2,
			[React.Change.AbsoluteSize] = v4,
			[React.Change.CanvasSize] = v4,
			[React.Change.CanvasPosition] = v5,
			ref = props.scrollingFrameRef
		}, props.getScollingListContent()),
		GradientFrame = React.createElement(GradientFrame, {
			height = listHeight,
			frameRef = ref,
			ZIndex = 3
		}),
		ArrowFrame = v and React.createElement(ArrowFrame, {
			isVisibleLeft = isVisibleLeft,
			isVisibleRight = isVisibleRight,
			defaultUseProps = {
				scrollingFrameRef = props.scrollingFrameRef,
				buttonRefs = props.buttonRefs,
				buttonWidth = props.buttonWidth,
				padOutsideEdges = props.padOutsideEdges,
				numButtons = props.numButtons,
				buttonPadding = props.buttonPadding,
				updateCanvasPosition = updateCanvasPosition
			},
			ZIndex = 4
		}),
		IntroScroll = useIntroScroll and React.createElement(IntroScroll, {
			childWidgetIndex = childWidgetIndex,
			scrollingFrameRef = props.scrollingFrameRef,
			updateCanvasPosition = updateCanvasPosition
		}) or nil
	})
end

return ScrollingListWithArrowsAndGradient
