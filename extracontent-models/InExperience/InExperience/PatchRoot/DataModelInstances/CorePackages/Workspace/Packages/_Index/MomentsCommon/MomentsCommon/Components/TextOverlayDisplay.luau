local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local useCallback = React.useCallback
local useMemo = React.useMemo

local View = Foundation.View

local TextOverlay = require(MomentsCommon.Components.TextOverlay)

local clampOverlayPosition = require(MomentsCommon.Utils.clampOverlayPosition)
local getCropSize = require(MomentsCommon.Utils.getCropSize)
local getFitSize = require(MomentsCommon.Utils.getFitSize)
local getScale = require(MomentsCommon.Utils.getScale)

require(parent.MomentsTypes)

local function getAbsoluteSize(udim: UDim2, itemSize: Vector2)
	return Vector2.new(itemSize.X * udim.X.Scale + udim.X.Offset, itemSize.Y * udim.Y.Scale + udim.Y.Offset)
end

local function getVisibleBounds(vector2: Vector2, itemSize: Vector2)
	return
		Vector2.new(math.max((vector2.X - itemSize.X) / 2, 0), (math.max((vector2.Y - itemSize.Y) / 2, 0))),
		Vector2.new(math.min(vector2.X, itemSize.X), (math.min(vector2.Y, itemSize.Y)))
end

local function arePositionsEqual(udim: UDim2, position: UDim2): boolean
	if
		math.abs(udim.X.Scale - position.X.Scale) < 0.0001
		and math.abs(udim.X.Offset - position.X.Offset) < 0.0001
		and math.abs(udim.Y.Scale - position.Y.Scale) < 0.0001
	then
		return math.abs(udim.Y.Offset - position.Y.Offset) < 0.0001
	end

	return false
end

local function TextOverlayDisplay(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local state, setState = React.useState(Vector2.new(0, 0))
	local v

	if props.textOverlayEdits then
		v = props.textOverlayEdits[1] or nil
	else
		v = nil
	end

	local size, v2 = useMemo(function()
		if not props.itemResolution then
			return UDim2.fromScale(1, 1), 1
		end

		local fitSize = getFitSize(props.itemSize, props.itemResolution)
		local cropSize = getCropSize(props.itemSize, props.itemResolution)
		local scale = getScale(props.itemSize, props.itemResolution, props.scaleType)

		if props.scaleType == Enum.ScaleType.Fit then
			return fitSize, scale
		end

		return cropSize, scale
	end, { props.scaleType, props.itemResolution, props.itemSize })

	local v3 = useMemo(function()
		return getAbsoluteSize(size, props.itemSize)
	end, { size, props.itemSize })
	local v4, v5 = useMemo(function()
		return getVisibleBounds(v3, props.itemSize)
	end, { v3, props.itemSize })

	local v6 = useCallback(function(position: UDim2)
		if not v then
			return nil
		end

		if props.clampToBoundsEnabled == true then
			position = clampOverlayPosition(position, v3, state, v4, v5)
		end

		return Dash.joinDeep(v, { position = position })
	end, { v, props.clampToBoundsEnabled, v3, state, v4, v5 })

	local onDragEnd = useCallback(function()
		if not (ref3.current and props.onTextOverlayDragEnd) then
			return
		end

		local v7 = v6(ref3.current.Position)

		if not v7 then
			return
		end

		props.onTextOverlayDragEnd({ v7 })
	end, { props.onTextOverlayDragEnd, v6 })

	local v7 = useCallback(function(p)
		if props.clampToBoundsEnabled ~= true then
			return
		end

		local absoluteSize = p.AbsoluteSize
		setState(function(p2)
			return if p2 == absoluteSize then p2 else absoluteSize
		end)
	end, { props.clampToBoundsEnabled })

	React.useEffect(function()
		if
			props.clampToBoundsEnabled ~= true
			or not props.onTextOverlayDragEnd
			or not v
			or v3.X <= 0
			or v3.Y <= 0
			or state.X <= 0
			or state.Y <= 0
		then
			return
		end

		local position = clampOverlayPosition(v.position, v3, state, v4, v5)

		if arePositionsEqual(position, v.position) then
			return
		end

		props.onTextOverlayDragEnd({ Dash.joinDeep(v, { position = position }) })
	end, { props.clampToBoundsEnabled, props.onTextOverlayDragEnd, v, v3, state, v4, v5 })

	local v8 = useCallback(function(textOverlayEdit)
		if not textOverlayEdit then
			return nil
		end

		local clampToBoundsEnabled = props.clampToBoundsEnabled == true
		local visualScale = props.visualScale
		local additionalScale

		if visualScale == nil then
			additionalScale = v2
		elseif typeof(visualScale) == "number" then
			additionalScale = v2 * visualScale
		else
			additionalScale = visualScale:map(function(p: number)
				return v2 * p
			end)
		end

		local createElement = React.createElement
		local current

		if props.unboundedDragEnabled ~= true then
			if clampToBoundsEnabled then
				current = ref2.current
			else
				current = ref.current
			end
		end

		local v8 = {
			additionalScale = additionalScale,
			boundingUI = current,
			containerRef = ref3,
			draggable = props.draggable,
			editable = props.editable,
			onActivated = props.onTextOverlayActivated,
			onAbsoluteSizeChanged = 0,
			onDragBegin = 0,
			onDragContinue = 0,
			onDragEnd = 0,
			onRotationChanged = 0,
			onScaleChanged = 0,
			referenceUI = 0,
			selected = 0,
			textOverlayEdit = 0
		}
		local onAbsoluteSizeChanged

		if clampToBoundsEnabled then
			onAbsoluteSizeChanged = v7
		end

		v8.onAbsoluteSizeChanged = onAbsoluteSizeChanged
		v8.onDragBegin = props.onTextOverlayDragBegin
		v8.onDragContinue = props.onTextOverlayDragContinue
		v8.onDragEnd = onDragEnd
		v8.onRotationChanged = props.onTextOverlayRotationChanged
		v8.onScaleChanged = props.onTextOverlayScaleChanged
		local referenceUI

		if clampToBoundsEnabled or props.unboundedDragEnabled == true then
			referenceUI = ref.current
		end

		v8.referenceUI = referenceUI

		v8.selected = props.selected
		v8.textOverlayEdit = textOverlayEdit
		return createElement(TextOverlay, v8)
	end, {
		props.clampToBoundsEnabled,
		props.draggable,
		props.editable,
		props.onTextOverlayActivated,
		props.onTextOverlayDragBegin,
		props.onTextOverlayDragContinue,
		props.onTextOverlayRotationChanged,
		props.onTextOverlayScaleChanged,
		props.selected,
		props.unboundedDragEnabled,
		props.visualScale,
		v2,
		v7,
		onDragEnd
	})

	if not props.textOverlayEdits or #props.textOverlayEdits == 0 then
		return nil
	end

	local createElement = React.createElement
	local v9 = {
		ref = ref,
		Size = size,
		tag = "position-center-center anchor-center-center",
		ZIndex = props.zIndex or 1
	}
	local visibleBounds

	if props.clampToBoundsEnabled == true then
		visibleBounds = React.createElement("Frame", {
			AnchorPoint = Vector2.zero,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(v4.X, v4.Y),
			ref = ref2,
			Size = UDim2.fromOffset(v5.X, v5.Y)
		})
	end

	return createElement(View, v9, { VisibleBounds = visibleBounds, TextOverlay = v8(v) })
end

return TextOverlayDisplay
