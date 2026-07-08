local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local ParentParent2Parent = ParentParent2.Parent
local React = require(ParentParent2Parent.React)
local IntroScroll = require(ParentParent.HorizontalNav.IntroScroll)
local GradientFrame = require(ParentParent.HorizontalNav.GradientFrame)
local ArrowFrame = require(ParentParent.HorizontalNav.ArrowFrame)
local Utils = require(ParentParent.HorizontalNav.Utils)
local useIsMouseAndKeyboard = require(ParentParent2.Utility.useIsMouseAndKeyboard)

local function ScrollingListWithArrowsAndGradient(t1: {[any]: any}) -- line: 56
	-- upvalues: useIsMouseAndKeyboard (copy), React (copy), Utils (copy), GradientFrame (copy), ArrowFrame (copy), IntroScroll (copy)
	local listHeight = t1.listHeight
	local childWidgetIndex = t1.childWidgetIndex
	local useIntroScroll = t1.useIntroScroll
	local v15 = t1.canvasWidth or 0
	local v16 = useIsMouseAndKeyboard()
	local v17 = React.useRef(nil)
	local v18, v19 = React.useBinding(false)
	local v20, v21 = React.useBinding(false)
	local v22, v23 = React.useBinding(Vector2.new(0, 0))
	local v24 = React.useCallback(function(p1) -- line: 70
		-- upvalues: v17 (copy), Utils (copy), t1 (copy), v16 (copy), v19 (copy), v21 (copy)
		local v27 = v17:getValue()

		if not v27 then
			return
		end

		local v28, v29, v30 = Utils.shouldShowGradientsForScrollingFrame(p1)

		v27.Visible = v28 and (not t1.hideGradient or v16)

		local Left = v27:FindFirstChild("Left")
		local Right = v27:FindFirstChild("Right")

		if Left and Right then
			Left.Visible = v29
			Right.Visible = v30
		end

		v19(v29)
		v21(v30)
	end, {
		v17,
		v19,
		v21
	})
	local v25 = React.useCallback(function(p2) -- line: 92
		-- upvalues: v24 (copy), v23 (copy)
		v24(p2)
		v23(p2.CanvasPosition)
	end, {
		v24,
		v23
	})

	React.useEffect(function() -- line: 99
		-- upvalues: t1 (copy), v24 (copy)
		local v34 = t1.scrollingFrameRef:getValue()

		if v34 then
			v24(v34)
		end
	end)

	return React.createElement(React.Fragment, {}, {
		ScrollingList = React.createElement("ScrollingFrame", {
			ClipsDescendants = t1.clipsDescendants,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, v15, 1, 0),
			CanvasPosition = v22,
			ScrollBarThickness = 0,
			BackgroundTransparency = 1,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollingDirection = Enum.ScrollingDirection.X,
			ZIndex = 2,
			[React.Change.AbsoluteSize] = v24,
			[React.Change.CanvasSize] = v24,
			[React.Change.CanvasPosition] = v25,
			ref = t1.scrollingFrameRef
		}, t1.getScollingListContent()),
		GradientFrame = React.createElement(GradientFrame, {
			ZIndex = 3,
			height = listHeight,
			frameRef = v17
		}),
		ArrowFrame = v16 and React.createElement(ArrowFrame, {
			ZIndex = 4,
			isVisibleLeft = v18,
			isVisibleRight = v20,
			defaultUseProps = {
				scrollingFrameRef = t1.scrollingFrameRef,
				buttonRefs = t1.buttonRefs,
				buttonWidth = t1.buttonWidth,
				padOutsideEdges = t1.padOutsideEdges,
				numButtons = t1.numButtons,
				buttonPadding = t1.buttonPadding,
				updateCanvasPosition = v23
			}
		}),
		IntroScroll = useIntroScroll and React.createElement(IntroScroll, {
			childWidgetIndex = childWidgetIndex,
			scrollingFrameRef = t1.scrollingFrameRef,
			updateCanvasPosition = v23
		}) or nil
	})
end

return ScrollingListWithArrowsAndGradient
