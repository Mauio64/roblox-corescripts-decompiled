local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Constants = require(Foundation.Constants)

local InputMode = require(Foundation.Utility.Input.InputMode)

require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useLastInputMode = require(Foundation.Utility.Input.useLastInputMode)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local CursorType = require(Foundation.Enums.CursorType)

local InputSize = require(Foundation.Enums.InputSize)

local Orientation = require(Foundation.Enums.Orientation)

local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

local Visibility = require(Foundation.Enums.Visibility)

local CursorComponent = require(Foundation.Providers.Cursor.CursorComponent)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local getKnobSize = require(Foundation.Components.Knob.getKnobSize)
local useTokens = require(Foundation.Providers.Style.useTokens)

local SliderThumb = require(Foundation.Components.Slider.SliderThumb)
local getKnobVisibility = require(script.Parent.getKnobVisibility)
local useSliderCapture = require(script.Parent.useSliderCapture)
local useSliderPointerDrag = require(script.Parent.useSliderPointerDrag)
local useSliderThumbs = require(script.Parent.useSliderThumbs)

local v = {
	range = NumberRange.new(0, 1),
	size = InputSize.Medium,
	width = UDim.new(1, 0),
	orientation = Orientation.Horizontal,
	isDisabled = false,
	isContained = false,
	knobVisibility = Visibility.Auto,
	testId = "--foundation-internal-slider"
}

local selectionGroup = {
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop
}

local v2 = {
	SelectionBehaviorLeft = Enum.SelectionBehavior.Escape,
	SelectionBehaviorRight = Enum.SelectionBehavior.Escape,
	SelectionBehaviorUp = Enum.SelectionBehavior.Escape,
	SelectionBehaviorDown = Enum.SelectionBehavior.Escape
}

local vector2 = Vector2.new(0.5, 0.5)

local function noop() end

local function getFullBounds(): (number, number)
	return 0, 1
end

local function InternalSlider(p, p2)
	local v3 = withDefaults(p, v)
	local isVertical = v3.orientation == Orientation.Vertical
	local v4 = useTokens()
	local v5 = PresentationContext.usePresentationContext()
	local lastInputMode = useLastInputMode()

	local ref = React.useRef(nil)
	React.useImperativeHandle(p2, function()
		return ref.current
	end, {})

	local knobSize = getKnobSize(v4, v3.size)

	local ref2 = React.useRef(Vector2.new(knobSize.X.Offset, knobSize.Y.Offset))
	local getKnobScale = React.useCallback(function()
		local current = ref.current

		if current and current.AbsoluteSize.X > 0 and current.AbsoluteSize.Y > 0 then
			return ref2.current / current.AbsoluteSize
		end

		return Vector2.zero
	end, {})
	local knobScale, v6 = React.useBinding(Vector2.zero)
	local v7 = React.useCallback(function()
		v6(getKnobScale())
	end, { getKnobScale })
	local onAbsoluteSizeChanged = React.useCallback(function(p3)
		ref2.current = p3.AbsoluteSize
		v7()
	end, { v7 })
	local onAbsoluteSizeChanged2 = React.useCallback(function(p3)
		v7()

		if v3.onAbsoluteSizeChanged then
			v3.onAbsoluteSizeChanged(p3)
		end
	end, { v7, v3.onAbsoluteSizeChanged })

	local v8 = useSliderThumbs({
		thumbs = v3.thumbs,
		range = v3.range,
		step = v3.step,
		onValueChanged = v3.onValueChanged,
		knobScale = knobScale,
		getKnobScale = getKnobScale,
		isVertical = isVertical,
		isContained = v3.isContained
	})

	local v9 = useSliderCapture({
		thumbs = v3.thumbs,
		rootRef = ref,
		range = v3.range,
		step = v3.step,
		isVertical = isVertical,
		isDisabled = v3.isDisabled,
		lastInputMode = lastInputMode,
		updateThumbValue = v8.updateThumbValue,
		clampToNeighbors = v8.clampToNeighbors,
		onCaptureStarted = v3.onDragStarted,
		onCaptureEnded = v3.onDragEnded
	})

	local v10 = useSliderPointerDrag({
		thumbs = v3.thumbs,
		rootRef = ref,
		isVertical = isVertical,
		getThumbTrackFraction = v8.getThumbTrackFraction,
		seekThumbToTrackFraction = v8.seekThumbToTrackFraction,
		setActiveIndex = v9.setActiveIndex,
		onDragStarted = v3.onDragStarted,
		onDragEnded = v3.onDragEnded
	})

	local v11 = lastInputMode == InputMode.Directional and v9.isSelected

	local isDragEnabled = lastInputMode ~= InputMode.Directional
	local knobVisibility = getKnobVisibility({
		knobVisibility = v3.knobVisibility,
		controlState = v9.controlState,
		isDisabled = v3.isDisabled,
		isSelected = v9.isSelected,
		isDragging = v10.draggedIndex ~= nil
	})

	local udim = UDim.new(0, knobSize.X.Offset)
	local udim2

	if isVertical then
		udim2 = UDim2.new(udim, v3.width)
	else
		udim2 = UDim2.new(v3.width, udim)
	end

	local createElement = React.createElement

	local v12 = {
		Size = UDim2.fromScale(1, 1),
		stateLayer = { affordance = StateLayerAffordance.None },
		cursor = 0,
		onStateChanged = 0,
		isDisabled = 0,
		ref = 0,
		ZIndex = 0,
		testId = 0
	}
	local cursor

	if v9.isCaptured then
		cursor = CursorType.Invisible
	end

	v12.cursor = cursor
	v12.onStateChanged = v9.onStateChanged
	v12.isDisabled = v3.isDisabled
	v12.ref = v9.focusTargetRef

	v12.testId = `{v3.testId}--focus-target`
	local dragDetector

	if not v11 then
		dragDetector = React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v10.onTrackDragStarted,
			[React.Event.DragContinue] = v10.onTrackDrag,
			[React.Event.DragEnd] = v10.onTrackDragEnded,
			SelectionModeDragSpeed = UDim2.new(),
			Enabled = not v3.isDisabled
		})
	end

	local children = {
		FocusTarget = createElement(View, v12, { DragDetector = dragDetector }),
		Track = 0,
		SelectionCursor = 0
	}

	local createElement2 = React.createElement
	local fragment = React.Fragment
	local v13

	if v3.renderTrack then
		v13 = v3.renderTrack(v8.span)
	else
		v13 = v3.children
	end

	children.Track = createElement2(fragment, nil, v13)
	local selectionCursor

	if v9.isCaptured then
		selectionCursor = React.createElement(View, {
			Size = knobScale:map(function(vector2_2: Vector2)
				return UDim2.fromScale(vector2_2.X, vector2_2.Y)
			end),
			AnchorPoint = vector2,
			Position = v8.positions[v9.activeThumbIndex],
			ZIndex = 3,
			selection = { Selectable = true },
			selectionGroup = selectionGroup,
			cursor = CursorType.Invisible,
			onStateChanged = noop,
			ref = v9.captureTargetRef,
			testId = `{v3.testId}--selection-cursor`
		}, {
			Cursor = React.createElement(CursorComponent, {
				isVisible = true,
				cornerRadius = UDim.new(0.5, 0),
				offset = v4.Padding.XSmall,
				borderWidth = v4.Stroke.Thicker,
				colorNamespace = v5.colorNamespace
			})
		})
	end

	children.SelectionCursor = selectionCursor

	for k, thumb in v3.thumbs do
		children[`Thumb{k}`] = React.createElement(SliderThumb, {
			trackRef = ref,
			fraction = v8.trackFractions[k],
			isVertical = isVertical,
			AnchorPoint = vector2,
			Position = v8.positions[k],
			Visible = knobVisibility,
			isDisabled = v3.isDisabled,
			isDragEnabled = isDragEnabled,
			knob = v3.renderThumb(k, {
				isVisible = knobVisibility,
				isDragging = v10.draggedIndex == k
			}),
			onSeek = function(p3: number)
				v8.seekThumbToTrackFraction(k, p3)
			end,
			getBounds = getFullBounds,
			onDragStarted = function()
				v10.onThumbDragStarted(k)
			end,
			onDragEnded = v10.onThumbDragEnded,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			testId = thumb.testId
		})
	end

	local groupTransparency

	if v3.isDisabled then
		groupTransparency = Constants.DISABLED_TRANSPARENCY
	end

	local selectionGroup2 = if v9.isCaptured then selectionGroup else v2
	local v14 = withCommonProps(v3, {
		Size = udim2,
		GroupTransparency = groupTransparency,
		selectionGroup = selectionGroup2,
		ref = ref
	})

	v14.onAbsoluteSizeChanged = onAbsoluteSizeChanged2

	return React.createElement(View, v14, children)
end

return React.forwardRef(InternalSlider)
