local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")

local useCallback = React.useCallback
local useMemo = React.useMemo

local view = Foundation.View

local clampOverlayPosition = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/clampOverlayPosition")
local getCropSize = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/getCropSize")
local getFitSize = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/getFitSize")
local getScale = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/getScale")

local function getAbsoluteSize(p2, itemSize)
	return Vector2.new(itemSize.X * p2.X.Scale + p2.X.Offset, itemSize.Y * p2.Y.Scale + p2.Y.Offset)
end

local function getVisibleBounds(p2, itemSize)
	return
		Vector2.new(math.max((p2.X - itemSize.X) / 2, 0), (math.max((p2.Y - itemSize.Y) / 2, 0))),
		Vector2.new(math.min(p2.X, itemSize.X), (math.min(p2.Y, itemSize.Y)))
end

local function arePositionsEqual(p2, position)
	local v5

	if
		math.abs(p2.X.Scale - position.X.Scale) < 0.0001
		and math.abs(p2.X.Offset - position.X.Offset) < 0.0001
		and math.abs(p2.Y.Scale - position.Y.Scale) < 0.0001
	then
		v5 = math.abs(p2.Y.Offset - position.Y.Offset) < 0.0001
	else
		v5 = false
	end

	return v5
end

local function OverlayDisplay(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local state, setState = React.useState(Vector2.new(0, 0))

	local v5 = if props.overlayEdits then props.overlayEdits[1] or nil else nil

	local v6, v7 = useMemo(function()
		if not props.itemResolution then
			return UDim2.fromScale(1, 1), 1
		end

		local v8 = getFitSize(props.itemSize, props.itemResolution)
		local v9 = getCropSize(props.itemSize, props.itemResolution)
		local v10 = getScale(props.itemSize, props.itemResolution, props.scaleType)

		if props.scaleType == Enum.ScaleType.Fit then
			return v8, v10
		end

		return v9, v10
	end, { props.scaleType, props.itemResolution, props.itemSize })

	local v8 = useMemo(function()
		return getAbsoluteSize(v6, props.itemSize)
	end, { v6, props.itemSize })
	local v9, v10 = useMemo(function()
		return getVisibleBounds(v8, props.itemSize)
	end, { v8, props.itemSize })

	local v11 = useCallback(function(p2)
		if not v5 then
			return nil
		end

		if props.clampToBoundsEnabled == true then
			p2 = clampOverlayPosition(p2, v8, state, v9, v10)
		end

		return Dash.joinDeep(v5, { position = p2 })
	end, { v5, props.clampToBoundsEnabled, v8, state, v9, v10 })

	local v12 = useCallback(function()
		if not (ref3.current and props.onOverlayDragEnd) then
			return
		end

		local v13 = v11(ref3.current.Position)

		if not v13 then
			return
		end

		props.onOverlayDragEnd({ v13 })
	end, { props.onOverlayDragEnd, v11 })

	local v13 = useCallback(function(p2)
		if props.clampToBoundsEnabled ~= true then
			return
		end

		local absoluteSize = p2.AbsoluteSize
		setState(function(p3)
			if p3 == absoluteSize then
				return p3
			end

			return absoluteSize
		end)
	end, { props.clampToBoundsEnabled })

	React.useEffect(function()
		if
			props.clampToBoundsEnabled ~= true
			or not props.onOverlayDragEnd
			or not v5
			or v8.X <= 0
			or v8.Y <= 0
			or state.X <= 0
			or state.Y <= 0
		then
			return
		end

		local v14 = clampOverlayPosition(v5.position, v8, state, v9, v10)

		if arePositionsEqual(v14, v5.position) then
			return
		end

		props.onOverlayDragEnd({ Dash.joinDeep(v5, { position = v14 }) })
	end, { props.clampToBoundsEnabled, props.onOverlayDragEnd, v5, v8, state, v9, v10 })

	local v14 = useCallback(function(overlayEdit)
		if not overlayEdit then
			return nil
		end

		local clampToBoundsEnabled = props.clampToBoundsEnabled == true
		local visualScale = props.visualScale
		local v15

		if visualScale == nil then
			v15 = v7
		elseif typeof(visualScale) == "number" then
			v15 = v7 * visualScale
		else
			v15 = visualScale:map(function(p2)
				return v7 * p2
			end)
		end

		local createElement = React.createElement
		local overlayComponent = props.overlayComponent
		local current

		if props.unboundedDragEnabled ~= true then
			current = if clampToBoundsEnabled then ref2.current else ref.current
		end

		local v16 = {
			additionalScale = v15,
			boundingUI = current,
			containerRef = ref3,
			draggable = props.draggable,
			editable = props.editable,
			onActivated = props.onOverlayActivated,
			onAbsoluteSizeChanged = if clampToBoundsEnabled then v13 else nil,
			onDragBegin = props.onOverlayDragBegin,
			onDragContinue = props.onOverlayDragContinue,
			onDragEnd = v12,
			onRotationChanged = props.onOverlayRotationChanged,
			onScaleChanged = props.onOverlayScaleChanged,
			overlayEdit = overlayEdit,
			referenceUI = 0,
			selected = 0
		}

		local v18 = if clampToBoundsEnabled or props.unboundedDragEnabled == true then ref.current else nil
		v16.referenceUI = v18

		v16.selected = props.selected
		return createElement(overlayComponent, v16)
	end, {
		props.clampToBoundsEnabled,
		props.draggable,
		props.editable,
		props.onOverlayActivated,
		props.onOverlayDragBegin,
		props.onOverlayDragContinue,
		props.onOverlayRotationChanged,
		props.onOverlayScaleChanged,
		props.overlayComponent,
		props.unboundedDragEnabled,
		props.selected,
		props.visualScale,
		v7,
		v13,
		v12
	})

	if not props.overlayEdits or #props.overlayEdits == 0 then
		return nil
	end

	local createElement = React.createElement
	local v16 = {
		ref = ref,
		Size = v6,
		tag = "position-center-center anchor-center-center",
		ZIndex = props.zIndex or 1
	}

	local v18 = if props.clampToBoundsEnabled == true then React.createElement("Frame", {
		AnchorPoint = Vector2.zero,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(v9.X, v9.Y),
		ref = ref2,
		Size = UDim2.fromOffset(v10.X, v10.Y)
	}) else nil
	return createElement(view, v16, { VisibleBounds = v18, Overlay = v14(v5) })
end

return OverlayDisplay
