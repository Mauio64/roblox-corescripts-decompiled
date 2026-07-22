local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local CapturesCommon = require(ParentParentParent.CapturesCommon)
local React = require(ParentParentParent.React)
local ReactOtter = require(ParentParentParent.ReactOtter)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local useCallback = React.useCallback
local useDeviceInsets = require(ParentParentParent.Responsive).useDeviceInsets
local useEffect = React.useEffect
local useGuiInset = CapturesCommon.Hooks.useGuiInset
local useRef = React.useRef
local useState = React.useState
local CaptureControlsConfiguration = require(ParentParent.Utils.CaptureControlsConfiguration)
local SnapDirection = require(ParentParent.Enums.SnapDirection)
local FFlagCapturesDragEdgeOffsetEnabled = require(ParentParent.Flags.FFlagCapturesDragEdgeOffsetEnabled)
local EngineFeature = game:GetEngineFeature("UIDragDetectorFixEventPositionEnabled")
local t1 = {
	x = 0.5,
	y = 0.5
}
local t2 = {
	xOffset = -100,
	yOffset = -100
}
local vector2 = Vector2.new(1, 0.5)
local Right = SnapDirection.Right
local t3 = {
	duration = 0.4,
	easingStyle = {
		0.19,
		1,
		0.22,
		1
	}
}

local function validateRefs(t4: {[any]: any}) -- line: 33
	for _, v31 in t4 do
		if v31.current == nil then
			return false
		end

		if v31.current.AbsoluteSize.X <= 0 or v31.current.AbsoluteSize.Y <= 0 then
			return false
		end
	end

	return true
end
local function clampItemPosition(vector2_2: Vector2, vector2_3: Vector2, vector2_4: Vector2, vector2_5: Vector2, vector2_6: Vector2) -- line: 47
	-- upvalues: FFlagCapturesDragEdgeOffsetEnabled (copy)
	local v37 = vector2_2 - vector2_4
	local v38 = not FFlagCapturesDragEdgeOffsetEnabled and 0 or 50
	local v39 = not FFlagCapturesDragEdgeOffsetEnabled and 0 or vector2_6.Y

	if not FFlagCapturesDragEdgeOffsetEnabled and (v37.X + vector2_3.X < vector2_6.X and v37.Y < vector2_6.Y) then
		v39 = vector2_6.Y
	elseif not FFlagCapturesDragEdgeOffsetEnabled and v37.Y < vector2_6.Y then
		v38 = vector2_6.X
	end

	if vector2_5.X - v38 > vector2_3.X then
		v38 = math.clamp(v37.X, v38, vector2_5.X - vector2_3.X - (not FFlagCapturesDragEdgeOffsetEnabled and 0 or 50))
	end

	if vector2_5.Y - v39 > vector2_3.Y then
		v39 = math.clamp(v37.Y, v39, vector2_5.Y - vector2_3.Y)
	end

	return Vector2.new(v38, v39)
end
local function getSnapPosition(vector2_7: Vector2, vector2_8: Vector2, vector2_9: Vector2, vector2_10: Vector2, vector2_11: Vector2, vector2_12: Vector2) -- line: 87
	-- upvalues: clampItemPosition (copy)
	local v46 = Vector2.new(vector2_10.X * vector2_11.X, vector2_10.Y * vector2_11.Y) - Vector2.new(vector2_7.X * vector2_8.X, vector2_7.Y * vector2_8.Y) + vector2_9

	return (clampItemPosition(v46, vector2_7, vector2_9, vector2_10, vector2_12))
end
local function getSnapAnchorPoint(vector2_13: Vector2, vector2_14: Vector2, vector2_15: Vector2, vector2_16: Vector2) -- line: 114
	local v51 = vector2_13 - vector2_14
	local t5 = {
		Vector2.new(0, (math.max(v51.Y, vector2_16.Y))),
		Vector2.new(vector2_15.X, v51.Y),
		Vector2.new(math.max(v51.X, vector2_16.X), 0),
		Vector2.new(v51.X, vector2_15.Y)
	}

	table.sort(t5, function(p1, p2) -- line: 129
		-- upvalues: v51 (copy)
		return (p1 - v51).Magnitude < (p2 - v51).Magnitude
	end)

	local v53 = t5[1]
	local Magnitude = (v53 - v51).Magnitude

	return v53 / vector2_15, Magnitude
end
local function getSnapDirectionFromAnchorPoint(vector2_17: Vector2) -- line: 138
	-- upvalues: SnapDirection (copy)
	if vector2_17.X == 0 then
		return SnapDirection.Left
	end

	if vector2_17.X == 1 then
		return SnapDirection.Right
	end

	if vector2_17.Y == 0 then
		return SnapDirection.Top
	end

	return SnapDirection.Bottom
end
local function getShouldRotate(b1: boolean, vector2_18: Vector2) -- line: 150
	local v58 = vector2_18.X == 0 or vector2_18.X == 1
	local v59 = vector2_18.Y == 0 or vector2_18.Y == 1
	local v60 = false

	if v58 and v59 then
		return false
	end

	if v59 and not b1 then
		return true
	end

	if v58 and b1 then
		v60 = true
	end

	return v60
end
local function useCaptureControlsController(b2: boolean, vector2_19: Vector2) -- line: 166
	-- upvalues: useRef (copy), CaptureControlsConfiguration (copy), useState (copy), vector2 (copy), Right (copy), useGuiInset (copy), useDeviceInsets (copy), useCallback (copy), useAnimatedBinding (copy), t1 (copy), t2 (copy), useEffect (copy), validateRefs (copy), SnapDirection (copy), ReactOtter (copy), t3 (copy), getSnapPosition (copy), clampItemPosition (copy), EngineFeature (copy), getSnapAnchorPoint (copy)
	local v63 = useRef(vector2_19)
	local v64 = useRef(nil)
	local v65 = useRef(nil)
	local v66 = useRef(nil)
	local v67 = useRef(false)
	local v68 = useRef(nil)
	local v69 = useRef(CaptureControlsConfiguration.getStoredSnapAnchorPoint())
	local v70, v71 = useState(vector2)
	local v72, v73 = useState(false)
	local v74, v75 = useState(false)
	local v76, v77 = useState(Right)
	local v78 = useGuiInset()
	local v79 = useDeviceInsets()
	local v80 = useCallback(function() -- line: 183
		-- upvalues: v67 (copy)
		v67.current = false
	end, {})
	local v81, v82 = useAnimatedBinding(t1)
	local v83, v84 = useAnimatedBinding(t2, v80)

	useEffect(function() -- line: 194
		-- upvalues: b2 (copy), validateRefs (copy), v66 (copy), v64 (copy), v63 (copy), vector2_19 (copy), v69 (copy), v71 (copy), v77 (copy), SnapDirection (copy), v74 (copy), v82 (copy), ReactOtter (copy), t3 (copy), v75 (copy), getSnapPosition (copy), v84 (copy)
		if not b2 or not validateRefs({
			v66,
			v64
		}) then
			return
		end

		assert(v66.current ~= nil, "dragItemRef is nil")
		assert(v64.current ~= nil, "dragContainerRef is nil")
		v63.current = vector2_19

		local current = v69.current

		v71(current)
		v77(if current.X ~= 0 then if current.X ~= 1 then if current.Y ~= 0 then SnapDirection.Bottom else SnapDirection.Top else SnapDirection.Right else SnapDirection.Left)

		local AbsoluteSize = v66.current.AbsoluteSize
		local currentAnchorPoint = v66.current.AnchorPoint
		local v95 = v74
		local v96 = current.X == 0 or current.X == 1
		local v97 = current.Y == 0 or current.Y == 1
		local v98 = false

		if v96 and v97 then
			v98 = false
		elseif v97 and not v95 then
			v98 = true
		elseif v96 and v95 then
			v98 = true
		end

		if v98 then
			AbsoluteSize = Vector2.new(AbsoluteSize.Y, AbsoluteSize.X)
			currentAnchorPoint = Vector2.new(currentAnchorPoint.Y, currentAnchorPoint.X)
			v82({
				x = ReactOtter.ease(currentAnchorPoint.X, t3),
				y = ReactOtter.ease(currentAnchorPoint.Y, t3)
			})
			v75(not v74)
		end

		local v99 = getSnapPosition(AbsoluteSize, currentAnchorPoint, v64.current.AbsolutePosition, v64.current.AbsoluteSize, current, vector2_19)
		local vector2_20 = Vector2.new(AbsoluteSize.X * currentAnchorPoint.X, AbsoluteSize.Y * currentAnchorPoint.Y)

		v84({
			xOffset = ReactOtter.instant(v99.X + vector2_20.X),
			yOffset = ReactOtter.instant(v99.Y + vector2_20.Y)
		})
	end, {
		b2,
		vector2_19,
		v82,
		v84
	})

	local v85 = useCallback(function() -- line: 250
		-- upvalues: b2 (copy), v67 (copy), validateRefs (copy), v66 (copy), v64 (copy), getSnapPosition (copy), v70 (copy), vector2_19 (copy), v84 (copy), ReactOtter (copy)
		if not b2 or (v67.current or not validateRefs({
			v66,
			v64
		})) then
			return
		end

		assert(v66.current ~= nil, "dragItemRef is nil")
		assert(v64.current ~= nil, "dragContainerRef is nil")

		local AbsoluteSize = v66.current.AbsoluteSize
		local currentAnchorPoint = v66.current.AnchorPoint
		local v103 = getSnapPosition(AbsoluteSize, currentAnchorPoint, v64.current.AbsolutePosition, v64.current.AbsoluteSize, v70, vector2_19)
		local vector2_21 = Vector2.new(AbsoluteSize.X * currentAnchorPoint.X, AbsoluteSize.Y * currentAnchorPoint.Y)

		v84({
			xOffset = ReactOtter.instant(v103.X + vector2_21.X),
			yOffset = ReactOtter.instant(v103.Y + vector2_21.Y)
		})
	end, {
		b2,
		vector2_19,
		v70,
		v72,
		v84
	})
	local v86 = useCallback(function(vector2_22: Vector2) -- line: 288
		-- upvalues: b2 (copy), v72 (copy), validateRefs (copy), v64 (copy), v66 (copy), v78 (copy), v79 (copy), v73 (copy), clampItemPosition (copy), vector2_19 (copy), v74 (copy), EngineFeature (copy), v82 (copy), ReactOtter (copy), v84 (copy)
		if not b2 or (v72 or not validateRefs({
			v64,
			v66
		})) then
			return
		end

		assert(v66.current ~= nil, "dragItemRef is nil")
		assert(v64.current ~= nil, "dragContainerRef is nil")

		local v106 = vector2_22 - Vector2.new(v78.left + v79.left, v78.top + v79.top)

		v73(true)

		local AbsoluteSize = v66.current.AbsoluteSize
		local AbsolutePosition = v66.current.AbsolutePosition
		local _ = v66.current.AnchorPoint
		local v110 = clampItemPosition(AbsolutePosition, AbsoluteSize, v64.current.AbsolutePosition, v64.current.AbsoluteSize, vector2_19)
		local vector2_23 = Vector2.new(not v74 and 0.5 or (((if not EngineFeature then v106 else vector2_22)).X - AbsolutePosition.X) / AbsoluteSize.X, if not v74 then (((if not EngineFeature then v106 else vector2_22)).Y - AbsolutePosition.Y) / AbsoluteSize.Y else 0.5)

		v82({
			x = ReactOtter.instant(vector2_23.X),
			y = ReactOtter.instant(vector2_23.Y)
		})

		local vector2_24 = Vector2.new(AbsoluteSize.X * vector2_23.X, AbsoluteSize.Y * vector2_23.Y)

		v84({
			xOffset = ReactOtter.instant(v110.X + vector2_24.X),
			yOffset = ReactOtter.instant(v110.Y + vector2_24.Y)
		})
	end, {
		b2,
		vector2_19,
		clampItemPosition,
		if not EngineFeature then v79 else nil,
		if not EngineFeature then v78 else nil,
		v72,
		v74,
		v84,
		v82
	})
	local v87 = useCallback(function(vector2_25: Vector2, b3: boolean) -- line: 354
		-- upvalues: validateRefs (copy), v66 (copy), v64 (copy), v78 (copy), v79 (copy), getSnapAnchorPoint (copy), EngineFeature (copy), vector2_19 (copy), v74 (copy), v82 (copy), ReactOtter (copy), v75 (copy), getSnapPosition (copy), clampItemPosition (copy), v84 (copy), v67 (copy), t3 (copy), v71 (copy), v77 (copy), SnapDirection (copy), CaptureControlsConfiguration (copy), v69 (copy)
		if not validateRefs({
			v66,
			v64
		}) then
			return
		end

		assert(v66.current ~= nil, "dragItemRef is nil")
		assert(v64.current ~= nil, "dragContainerRef is nil")

		local v115 = vector2_25 - Vector2.new(v78.left + v79.left, v78.top + v79.top)
		local AbsolutePosition = v64.current.AbsolutePosition
		local AbsoluteSize = v64.current.AbsoluteSize
		local v118, v119 = getSnapAnchorPoint(if not EngineFeature then v115 else vector2_25, AbsolutePosition, AbsoluteSize, vector2_19)
		local v120 = v119 < 70 or not b3
		local AbsoluteSize2 = v66.current.AbsoluteSize
		local currentAnchorPoint = v66.current.AnchorPoint
		local v123 = v74
		local v124 = v118.X == 0 or v118.X == 1
		local v125 = v118.Y == 0 or v118.Y == 1
		local v126 = false

		if v124 and v125 then
			v126 = false
		elseif v125 and not v123 then
			v126 = true
		elseif v124 and v123 then
			v126 = true
		end

		if v120 and v126 then
			AbsoluteSize2 = Vector2.new(AbsoluteSize2.Y, AbsoluteSize2.X)
			currentAnchorPoint = Vector2.new(currentAnchorPoint.Y, currentAnchorPoint.X)
			v82({
				x = ReactOtter.instant(currentAnchorPoint.X),
				y = ReactOtter.instant(currentAnchorPoint.Y)
			})
			v75(not v74)
		end

		local vector2_26 = Vector2.new(AbsoluteSize2.X * currentAnchorPoint.X, AbsoluteSize2.Y * currentAnchorPoint.Y)
		local v128 = if not v120 then clampItemPosition(((if not EngineFeature then v115 else vector2_25)) - vector2_26, AbsoluteSize2, AbsolutePosition, AbsoluteSize, vector2_19) else getSnapPosition(AbsoluteSize2, currentAnchorPoint, AbsolutePosition, AbsoluteSize, v118, vector2_19)

		if b3 then
			v84({
				xOffset = ReactOtter.instant(v128.X + vector2_26.X),
				yOffset = ReactOtter.instant(v128.Y + vector2_26.Y)
			})

			return
		end

		v67.current = true
		v84({
			xOffset = ReactOtter.ease(v128.X + vector2_26.X, t3),
			yOffset = ReactOtter.ease(v128.Y + vector2_26.Y, t3)
		})
		v71(v118)
		v77(if v118.X ~= 0 then if v118.X ~= 1 then if v118.Y ~= 0 then SnapDirection.Bottom else SnapDirection.Top else SnapDirection.Right else SnapDirection.Left)
		CaptureControlsConfiguration.setStoredSnapAnchorPoint(v118)
		v69.current = v118
	end, {
		vector2_19,
		if not EngineFeature then v79 else nil,
		if not EngineFeature then v78 else nil,
		v74,
		v84,
		v82
	})
	local v88 = useCallback(function(vector2_27: Vector2) -- line: 445
		-- upvalues: b2 (copy), v72 (copy), v87 (copy)
		if not b2 or not v72 then
			return
		end

		v87(vector2_27, true)
	end, {
		b2,
		v87,
		v72
	})
	local v89 = useCallback(function(vector2_28: Vector2) -- line: 453
		-- upvalues: b2 (copy), v72 (copy), v87 (copy), v73 (copy)
		if not b2 or not v72 then
			return
		end

		v87(vector2_28, false)
		v73(false)
	end, {
		b2,
		v87,
		v72
	})

	useEffect(function() -- line: 462
		-- upvalues: b2 (copy), v63 (copy), vector2_19 (copy), v85 (copy)
		if not b2 then
			return
		end

		if v63.current ~= vector2_19 then
			v63.current = vector2_19
			v85()
		end
	end, {
		b2,
		vector2_19,
		v85
	})
	useEffect(function() -- line: 473
		-- upvalues: b2 (copy), v65 (copy), v86 (copy), v88 (copy), v89 (copy), v64 (copy), v85 (copy), v66 (copy)
		if not b2 then
			return
		end

		local t6 = {}

		if v65.current ~= nil then
			table.insert(t6, v65.current.DragStart:Connect(v86))
			table.insert(t6, v65.current.DragContinue:Connect(v88))
			table.insert(t6, v65.current.DragEnd:Connect(v89))
		end

		if v64.current ~= nil then
			table.insert(t6, v64.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v85))
		end

		if v66.current ~= nil then
			table.insert(t6, v66.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v85))
		end

		return function() -- line: 499
			-- upvalues: t6 (copy)
			for _, v133 in t6 do
				v133:Disconnect()
			end
		end
	end, {
		b2,
		v86,
		v88,
		v89,
		v85
	})

	return {
		dragContainerRef = v64,
		dragDetectorRef = v65,
		dragItemAnchorPointBinding = v81,
		dragItemPositionBinding = v83,
		dragItemRef = v66,
		isItemHorizontal = v74,
		screenshotButtonRef = v68,
		snapDirection = v76
	}
end

return useCaptureControlsController
