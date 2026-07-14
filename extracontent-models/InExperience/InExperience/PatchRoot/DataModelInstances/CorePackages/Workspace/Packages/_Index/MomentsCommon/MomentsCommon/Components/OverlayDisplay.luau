local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Dash = require(MomentsCommonParent.Dash)
local Foundation = require(MomentsCommonParent.Foundation)
local React = require(MomentsCommonParent.React)
local useCallback = React.useCallback
local useMemo = React.useMemo
local View = Foundation.View
local clampOverlayPosition = require(MomentsCommon.Utils.clampOverlayPosition)
local getCropSize = require(MomentsCommon.Utils.getCropSize)
local getFitSize = require(MomentsCommon.Utils.getFitSize)
local getScale = require(MomentsCommon.Utils.getScale)

local function getAbsoluteSize(uDim2: UDim2, vector2: Vector2) -- line: 46
	return Vector2.new(vector2.X * uDim2.X.Scale + uDim2.X.Offset, vector2.Y * uDim2.Y.Scale + uDim2.Y.Offset)
end
local function getVisibleBounds(vector2: Vector2, vector2_2: Vector2) -- line: 50
	return Vector2.new(math.max((vector2.X - vector2_2.X) / 2, 0), (math.max((vector2.Y - vector2_2.Y) / 2, 0))), Vector2.new(math.min(vector2.X, vector2_2.X), (math.min(vector2.Y, vector2_2.Y)))
end
local function arePositionsEqual(uDim2: UDim2, uDim2_2: UDim2) -- line: 55
	return math.abs(uDim2.X.Scale - uDim2_2.X.Scale) < 0.0001 and (math.abs(uDim2.X.Offset - uDim2_2.X.Offset) < 0.0001 and (math.abs(uDim2.Y.Scale - uDim2_2.Y.Scale) < 0.0001 and math.abs(uDim2.Y.Offset - uDim2_2.Y.Offset) < 0.0001))
end
local function OverlayDisplay(t1: {[any]: any}) -- line: 62
	-- upvalues: React (copy), useMemo (copy), getFitSize (copy), getCropSize (copy), getScale (copy), getAbsoluteSize (copy), getVisibleBounds (copy), useCallback (copy), clampOverlayPosition (copy), Dash (copy), arePositionsEqual (copy), View (copy)
	local v24 = React.useRef(nil)
	local v25 = React.useRef(nil)
	local v26 = React.useRef(nil)
	local v27, v28 = React.useState(Vector2.new(0, 0))
	local v29 = t1.overlayEdits and t1.overlayEdits[1] or nil
	local v30, v31 = useMemo(function() -- line: 70
		-- upvalues: t1 (copy), getFitSize (copy), getCropSize (copy), getScale (copy)
		if not t1.itemResolution then
			return UDim2.fromScale(1, 1), 1
		end

		local v39 = getFitSize(t1.itemSize, t1.itemResolution)
		local v40 = getCropSize(t1.itemSize, t1.itemResolution)
		local v41 = getScale(t1.itemSize, t1.itemResolution, t1.scaleType)

		if t1.scaleType == Enum.ScaleType.Fit then
			return v39, v41
		end

		return v40, v41
	end, {
		t1.scaleType,
		t1.itemResolution,
		t1.itemSize
	})
	local v32 = useMemo(function() -- line: 86
		-- upvalues: getAbsoluteSize (copy), v30 (copy), t1 (copy)
		return getAbsoluteSize(v30, t1.itemSize)
	end, {
		v30,
		t1.itemSize
	})
	local v33, v34 = useMemo(function() -- line: 89
		-- upvalues: getVisibleBounds (copy), v32 (copy), t1 (copy)
		return getVisibleBounds(v32, t1.itemSize)
	end, {
		v32,
		t1.itemSize
	})
	local v35 = useCallback(function(uDim2: UDim2) -- line: 94
		-- upvalues: v29 (copy), t1 (copy), clampOverlayPosition (copy), v32 (copy), v27 (copy), v33 (copy), v34 (copy), Dash (copy)
		if not v29 then
			return nil
		end

		if t1.clampToBoundsEnabled == true then
			uDim2 = clampOverlayPosition(uDim2, v32, v27, v33, v34)
		end

		return Dash.joinDeep(v29, {
			position = uDim2
		})
	end, {
		v29,
		t1.clampToBoundsEnabled,
		v32,
		v27,
		v33,
		v34
	})
	local v36 = useCallback(function() -- line: 112
		-- upvalues: v26 (copy), t1 (copy), v35 (copy)
		if not v26.current or not t1.onOverlayDragEnd then
			return
		end

		local v43 = v35(v26.current.Position)

		if not v43 then
			return
		end

		t1.onOverlayDragEnd({ v43 })
	end, {
		t1.onOverlayDragEnd,
		v35
	})
	local v37 = useCallback(function(p1) -- line: 125
		-- upvalues: t1 (copy), v28 (copy)
		if t1.clampToBoundsEnabled ~= true then
			return
		end

		local AbsoluteSize = p1.AbsoluteSize

		v28(function(p2) -- line: 131
			-- upvalues: AbsoluteSize (copy)
			if p2 == AbsoluteSize then
				return p2
			end

			return AbsoluteSize
		end)
	end, { t1.clampToBoundsEnabled })

	React.useEffect(function() -- line: 141
		-- upvalues: t1 (copy), v29 (copy), v32 (copy), v27 (copy), clampOverlayPosition (copy), v33 (copy), v34 (copy), arePositionsEqual (copy), Dash (copy)
		if t1.clampToBoundsEnabled ~= true or (not t1.onOverlayDragEnd or not v29 or v32.X <= 0 or v32.Y <= 0 or v27.X <= 0 or v27.Y <= 0) then
			return
		end

		local v46 = clampOverlayPosition(v29.position, v32, v27, v33, v34)

		if arePositionsEqual(v46, v29.position) then
			return
		end

		t1.onOverlayDragEnd({ Dash.joinDeep(v29, {
			position = v46
		}) })
	end, {
		t1.clampToBoundsEnabled,
		t1.onOverlayDragEnd,
		v29,
		v32,
		v27,
		v33,
		v34
	})

	local v38 = useCallback(function(t2: {[any]: any}?) -- line: 183
		-- upvalues: t1 (copy), React (copy), v31 (copy), v25 (copy), v24 (copy), v26 (copy), v37 (copy), v36 (copy)
		if not t2 then
			return nil
		end

		local v48 = t1.clampToBoundsEnabled == true

		return React.createElement(t1.overlayComponent, {
			additionalScale = v31,
			boundingUI = if not v48 then v24.current else v25.current,
			containerRef = v26,
			draggable = t1.draggable,
			editable = t1.editable,
			onActivated = t1.onOverlayActivated,
			onAbsoluteSizeChanged = if not v48 then nil else v37,
			onDragEnd = v36,
			overlayEdit = t2,
			referenceUI = if not v48 then nil else v24.current
		})
	end, {
		t1.clampToBoundsEnabled,
		t1.draggable,
		t1.editable,
		t1.onOverlayActivated,
		t1.overlayComponent,
		v31,
		v37,
		v36
	})

	if not t1.overlayEdits or #t1.overlayEdits == 0 then
		return nil
	end

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center",
		ref = v24,
		Size = v30,
		ZIndex = t1.zIndex or 1
	}, {
		VisibleBounds = if t1.clampToBoundsEnabled ~= true then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.zero,
			Position = UDim2.fromOffset(v33.X, v33.Y),
			ref = v25,
			Size = UDim2.fromOffset(v34.X, v34.Y)
		}),
		Overlay = v38(v29)
	})
end

return OverlayDisplay
