local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Dash = require(MomentsCommonParent.Dash)
local Foundation = require(MomentsCommonParent.Foundation)
local React = require(MomentsCommonParent.React)
local useCallback = React.useCallback
local useMemo = React.useMemo
local View = Foundation.View
local TextOverlay = require(MomentsCommon.Components.TextOverlay)
local clampTextOverlayPosition = require(MomentsCommon.Utils.clampTextOverlayPosition)
local getCropSize = require(MomentsCommon.Utils.getCropSize)
local getFitSize = require(MomentsCommon.Utils.getFitSize)
local getScale = require(MomentsCommon.Utils.getScale)

require(MomentsCommonParent.MomentsTypes)

local function getAbsoluteSize(uDim2: UDim2, vector2: Vector2) -- line: 39
	return Vector2.new(vector2.X * uDim2.X.Scale + uDim2.X.Offset, vector2.Y * uDim2.Y.Scale + uDim2.Y.Offset)
end
local function getVisibleBounds(vector2: Vector2, vector2_2: Vector2) -- line: 43
	return Vector2.new(math.max((vector2.X - vector2_2.X) / 2, 0), (math.max((vector2.Y - vector2_2.Y) / 2, 0))), Vector2.new(math.min(vector2.X, vector2_2.X), (math.min(vector2.Y, vector2_2.Y)))
end
local function arePositionsEqual(uDim2: UDim2, uDim2_2: UDim2) -- line: 48
	return math.abs(uDim2.X.Scale - uDim2_2.X.Scale) < 0.0001 and (math.abs(uDim2.X.Offset - uDim2_2.X.Offset) < 0.0001 and (math.abs(uDim2.Y.Scale - uDim2_2.Y.Scale) < 0.0001 and math.abs(uDim2.Y.Offset - uDim2_2.Y.Offset) < 0.0001))
end
local function TextOverlayDisplay(t1: {[any]: any}) -- line: 55
	-- upvalues: React (copy), useMemo (copy), getFitSize (copy), getCropSize (copy), getScale (copy), getAbsoluteSize (copy), getVisibleBounds (copy), useCallback (copy), clampTextOverlayPosition (copy), Dash (copy), arePositionsEqual (copy), TextOverlay (copy), View (copy)
	local v25 = React.useRef(nil)
	local v26 = React.useRef(nil)
	local v27 = React.useRef(nil)
	local v28, v29 = React.useState(Vector2.new(0, 0))
	local v30 = t1.textOverlayEdits and t1.textOverlayEdits[1] or nil
	local v31, v32 = useMemo(function() -- line: 63
		-- upvalues: t1 (copy), getFitSize (copy), getCropSize (copy), getScale (copy)
		if not t1.itemResolution then
			return UDim2.fromScale(1, 1), 1
		end

		local v40 = getFitSize(t1.itemSize, t1.itemResolution)
		local v41 = getCropSize(t1.itemSize, t1.itemResolution)
		local v42 = getScale(t1.itemSize, t1.itemResolution, t1.scaleType)

		if t1.scaleType == Enum.ScaleType.Fit then
			return v40, v42
		end

		return v41, v42
	end, {
		t1.scaleType,
		t1.itemResolution,
		t1.itemSize
	})
	local v33 = useMemo(function() -- line: 79
		-- upvalues: getAbsoluteSize (copy), v31 (copy), t1 (copy)
		return getAbsoluteSize(v31, t1.itemSize)
	end, {
		v31,
		t1.itemSize
	})
	local v34, v35 = useMemo(function() -- line: 82
		-- upvalues: getVisibleBounds (copy), v33 (copy), t1 (copy)
		return getVisibleBounds(v33, t1.itemSize)
	end, {
		v33,
		t1.itemSize
	})
	local v36 = useCallback(function(uDim2: UDim2) -- line: 87
		-- upvalues: v30 (copy), t1 (copy), clampTextOverlayPosition (copy), v33 (copy), v28 (copy), v34 (copy), v35 (copy), Dash (copy)
		if not v30 then
			return nil
		end

		if t1.clampToBoundsEnabled == true then
			uDim2 = clampTextOverlayPosition(uDim2, v33, v28, v34, v35)
		end

		return Dash.joinDeep(v30, {
			position = uDim2
		})
	end, {
		v30,
		t1.clampToBoundsEnabled,
		v33,
		v28,
		v34,
		v35
	})
	local v37 = useCallback(function() -- line: 110
		-- upvalues: v27 (copy), t1 (copy), v36 (copy)
		if not v27.current or not t1.onTextOverlayDragEnd then
			return
		end

		local v44 = v36(v27.current.Position)

		if not v44 then
			return
		end

		t1.onTextOverlayDragEnd({ v44 })
	end, {
		t1.onTextOverlayDragEnd,
		v36
	})
	local v38 = useCallback(function(p1) -- line: 123
		-- upvalues: t1 (copy), v29 (copy)
		if t1.clampToBoundsEnabled ~= true then
			return
		end

		local AbsoluteSize = p1.AbsoluteSize

		v29(function(p2) -- line: 129
			-- upvalues: AbsoluteSize (copy)
			if p2 == AbsoluteSize then
				return p2
			end

			return AbsoluteSize
		end)
	end, { t1.clampToBoundsEnabled })

	React.useEffect(function() -- line: 139
		-- upvalues: t1 (copy), v30 (copy), v33 (copy), v28 (copy), clampTextOverlayPosition (copy), v34 (copy), v35 (copy), arePositionsEqual (copy), Dash (copy)
		if t1.clampToBoundsEnabled ~= true or (not t1.onTextOverlayDragEnd or not v30 or v33.X <= 0 or v33.Y <= 0 or v28.X <= 0 or v28.Y <= 0) then
			return
		end

		local v47 = clampTextOverlayPosition(v30.position, v33, v28, v34, v35)

		if arePositionsEqual(v47, v30.position) then
			return
		end

		t1.onTextOverlayDragEnd({ Dash.joinDeep(v30, {
			position = v47
		}) })
	end, {
		t1.clampToBoundsEnabled,
		t1.onTextOverlayDragEnd,
		v30,
		v33,
		v28,
		v34,
		v35
	})

	local v39 = useCallback(function(p3) -- line: 181
		-- upvalues: t1 (copy), React (copy), TextOverlay (copy), v32 (copy), v26 (copy), v25 (copy), v27 (copy), v38 (copy), v37 (copy)
		if not p3 then
			return nil
		end

		local v49 = t1.clampToBoundsEnabled == true

		return React.createElement(TextOverlay, {
			additionalScale = v32,
			boundingUI = if not v49 then v25.current else v26.current,
			containerRef = v27,
			draggable = t1.draggable,
			editable = t1.editable,
			onActivated = t1.onTextOverlayActivated,
			onAbsoluteSizeChanged = if not v49 then nil else v38,
			onDragEnd = v37,
			referenceUI = if not v49 then nil else v25.current,
			textOverlayEdit = p3
		})
	end, {
		t1.clampToBoundsEnabled,
		t1.draggable,
		t1.editable,
		t1.onTextOverlayActivated,
		v32,
		v38,
		v37
	})

	if not t1.textOverlayEdits or #t1.textOverlayEdits == 0 then
		return nil
	end

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center",
		ref = v25,
		Size = v31,
		ZIndex = t1.zIndex or 1
	}, {
		VisibleBounds = if t1.clampToBoundsEnabled ~= true then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.zero,
			Position = UDim2.fromOffset(v34.X, v34.Y),
			ref = v26,
			Size = UDim2.fromOffset(v35.X, v35.Y)
		}),
		TextOverlay = v39(v30)
	})
end

return TextOverlayDisplay
