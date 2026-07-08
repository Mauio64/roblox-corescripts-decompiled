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
local v16 = game:DefineFastFlag("UpdateCaptureControlsForFoundationStyling", false)
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

local function validateRefs(t4: {[any]: any}) -- line: 35
	-- upvalues: v16 (copy)
	for _, v32 in t4 do
		if v32.current == nil then
			return false
		end

		if v16 and (v32.current.AbsoluteSize.X <= 0 or v32.current.AbsoluteSize.Y <= 0) then
			return false
		end
	end

	return true
end
local function clampItemPosition(vector2_2: Vector2, vector2_3: Vector2, vector2_4: Vector2, vector2_5: Vector2, vector2_6: Vector2) -- line: 52
	-- upvalues: FFlagCapturesDragEdgeOffsetEnabled (copy)
	local v38 = vector2_2 - vector2_4
	local v39 = not FFlagCapturesDragEdgeOffsetEnabled and 0 or 50
	local v40 = not FFlagCapturesDragEdgeOffsetEnabled and 0 or vector2_6.Y

	if not FFlagCapturesDragEdgeOffsetEnabled and (v38.X + vector2_3.X < vector2_6.X and v38.Y < vector2_6.Y) then
		v40 = vector2_6.Y
	elseif not FFlagCapturesDragEdgeOffsetEnabled and v38.Y < vector2_6.Y then
		v39 = vector2_6.X
	end

	if vector2_5.X - v39 > vector2_3.X then
		v39 = math.clamp(v38.X, v39, vector2_5.X - vector2_3.X - (not FFlagCapturesDragEdgeOffsetEnabled and 0 or 50))
	end

	if vector2_5.Y - v40 > vector2_3.Y then
		v40 = math.clamp(v38.Y, v40, vector2_5.Y - vector2_3.Y)
	end

	return Vector2.new(v39, v40)
end
local function getSnapPosition(vector2_7: Vector2, vector2_8: Vector2, vector2_9: Vector2, vector2_10: Vector2, vector2_11: Vector2, vector2_12: Vector2) -- line: 92
	-- upvalues: clampItemPosition (copy)
	local v47 = Vector2.new(vector2_10.X * vector2_11.X, vector2_10.Y * vector2_11.Y) - Vector2.new(vector2_7.X * vector2_8.X, vector2_7.Y * vector2_8.Y) + vector2_9

	return (clampItemPosition(v47, vector2_7, vector2_9, vector2_10, vector2_12))
end
local function getSnapAnchorPoint(vector2_13: Vector2, vector2_14: Vector2, vector2_15: Vector2, vector2_16: Vector2) -- line: 119
	local v52 = vector2_13 - vector2_14
	local t5 = {
		Vector2.new(0, (math.max(v52.Y, vector2_16.Y))),
		Vector2.new(vector2_15.X, v52.Y),
		Vector2.new(math.max(v52.X, vector2_16.X), 0),
		Vector2.new(v52.X, vector2_15.Y)
	}

	table.sort(t5, function(p1, p2) -- line: 134
		-- upvalues: v52 (copy)
		return (p1 - v52).Magnitude < (p2 - v52).Magnitude
	end)

	local v54 = t5[1]
	local Magnitude = (v54 - v52).Magnitude

	return v54 / vector2_15, Magnitude
end
local function getSnapDirectionFromAnchorPoint(vector2_17: Vector2) -- line: 143
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
local function getShouldRotate(b1: boolean, vector2_18: Vector2) -- line: 155
	local v59 = vector2_18.X == 0 or vector2_18.X == 1
	local v60 = vector2_18.Y == 0 or vector2_18.Y == 1
	local v61 = false

	if v59 and v60 then
		return false
	end

	if v60 and not b1 then
		return true
	end

	if v59 and b1 then
		v61 = true
	end

	return v61
end
local function useCaptureControlsController(b2: boolean, vector2_19: Vector2) -- line: 171
	-- upvalues: useRef (copy), CaptureControlsConfiguration (copy), useState (copy), vector2 (copy), Right (copy), useGuiInset (copy), useDeviceInsets (copy), useCallback (copy), useAnimatedBinding (copy), t1 (copy), t2 (copy), useEffect (copy), validateRefs (copy), SnapDirection (copy), ReactOtter (copy), t3 (copy), getSnapPosition (copy), clampItemPosition (copy), EngineFeature (copy), getSnapAnchorPoint (copy)
	local v64 = useRef(vector2_19)
	local v65 = useRef(nil)
	local v66 = useRef(nil)
	local v67 = useRef(nil)
	local v68 = useRef(false)
	local v69 = useRef(nil)
	local v70 = useRef(CaptureControlsConfiguration.getStoredSnapAnchorPoint())
	local v71, v72 = useState(vector2)
	local v73, v74 = useState(false)
	local v75, v76 = useState(false)
	local v77, v78 = useState(Right)
	local v79 = useGuiInset()
	local v80 = useDeviceInsets()
	local v81 = useCallback(function() -- line: 188
		-- upvalues: v68 (copy)
		v68.current = false
	end, {})
	local v82, v83 = useAnimatedBinding(t1)
	local v84, v85 = useAnimatedBinding(t2, v81)

	useEffect(function() -- line: 199
		-- upvalues: b2 (copy), validateRefs (copy), v67 (copy), v65 (copy), v64 (copy), vector2_19 (copy), v70 (copy), v72 (copy), v78 (copy), SnapDirection (copy), v75 (copy), v83 (copy), ReactOtter (copy), t3 (copy), v76 (copy), getSnapPosition (copy), v85 (copy)
		if not b2 or not validateRefs({
			v67,
			v65
		}) then
			return
		end

		assert(v67.current ~= nil, "dragItemRef is nil")
		assert(v65.current ~= nil, "dragContainerRef is nil")
		v64.current = vector2_19

		local current = v70.current

		v72(current)
		v78(if current.X ~= 0 then if current.X ~= 1 then if current.Y ~= 0 then SnapDirection.Bottom else SnapDirection.Top else SnapDirection.Right else SnapDirection.Left)

		local AbsoluteSize = v67.current.AbsoluteSize
		local currentAnchorPoint = v67.current.AnchorPoint
		local v96 = v75
		local v97 = current.X == 0 or current.X == 1
		local v98 = current.Y == 0 or current.Y == 1
		local v99 = false

		if v97 and v98 then
			v99 = false
		elseif v98 and not v96 then
			v99 = true
		elseif v97 and v96 then
			v99 = true
		end

		if v99 then
			AbsoluteSize = Vector2.new(AbsoluteSize.Y, AbsoluteSize.X)
			currentAnchorPoint = Vector2.new(currentAnchorPoint.Y, currentAnchorPoint.X)
			v83({
				x = ReactOtter.ease(currentAnchorPoint.X, t3),
				y = ReactOtter.ease(currentAnchorPoint.Y, t3)
			})
			v76(not v75)
		end

		local v100 = getSnapPosition(AbsoluteSize, currentAnchorPoint, v65.current.AbsolutePosition, v65.current.AbsoluteSize, current, vector2_19)
		local vector2_20 = Vector2.new(AbsoluteSize.X * currentAnchorPoint.X, AbsoluteSize.Y * currentAnchorPoint.Y)

		v85({
			xOffset = ReactOtter.instant(v100.X + vector2_20.X),
			yOffset = ReactOtter.instant(v100.Y + vector2_20.Y)
		})
	end, {
		b2,
		vector2_19,
		v83,
		v85
	})

	local v86 = useCallback(function() -- line: 255
		-- upvalues: b2 (copy), v68 (copy), validateRefs (copy), v67 (copy), v65 (copy), getSnapPosition (copy), v71 (copy), vector2_19 (copy), v85 (copy), ReactOtter (copy)
		if not b2 or (v68.current or not validateRefs({
			v67,
			v65
		})) then
			return
		end

		assert(v67.current ~= nil, "dragItemRef is nil")
		assert(v65.current ~= nil, "dragContainerRef is nil")

		local AbsoluteSize = v67.current.AbsoluteSize
		local currentAnchorPoint = v67.current.AnchorPoint
		local v104 = getSnapPosition(AbsoluteSize, currentAnchorPoint, v65.current.AbsolutePosition, v65.current.AbsoluteSize, v71, vector2_19)
		local vector2_21 = Vector2.new(AbsoluteSize.X * currentAnchorPoint.X, AbsoluteSize.Y * currentAnchorPoint.Y)

		v85({
			xOffset = ReactOtter.instant(v104.X + vector2_21.X),
			yOffset = ReactOtter.instant(v104.Y + vector2_21.Y)
		})
	end, {
		b2,
		vector2_19,
		v71,
		v73,
		v85
	})
	local v87 = useCallback(function(vector2_22: Vector2) -- line: 293
		-- upvalues: b2 (copy), v73 (copy), validateRefs (copy), v65 (copy), v67 (copy), v79 (copy), v80 (copy), v74 (copy), clampItemPosition (copy), vector2_19 (copy), v75 (copy), EngineFeature (copy), v83 (copy), ReactOtter (copy), v85 (copy)
		if not b2 or (v73 or not validateRefs({
			v65,
			v67
		})) then
			return
		end

		assert(v67.current ~= nil, "dragItemRef is nil")
		assert(v65.current ~= nil, "dragContainerRef is nil")

		local v107 = vector2_22 - Vector2.new(v79.left + v80.left, v79.top + v80.top)

		v74(true)

		local AbsoluteSize = v67.current.AbsoluteSize
		local AbsolutePosition = v67.current.AbsolutePosition
		local _ = v67.current.AnchorPoint
		local v111 = clampItemPosition(AbsolutePosition, AbsoluteSize, v65.current.AbsolutePosition, v65.current.AbsoluteSize, vector2_19)
		local vector2_23 = Vector2.new(not v75 and 0.5 or (((if not EngineFeature then v107 else vector2_22)).X - AbsolutePosition.X) / AbsoluteSize.X, if not v75 then (((if not EngineFeature then v107 else vector2_22)).Y - AbsolutePosition.Y) / AbsoluteSize.Y else 0.5)

		v83({
			x = ReactOtter.instant(vector2_23.X),
			y = ReactOtter.instant(vector2_23.Y)
		})

		local vector2_24 = Vector2.new(AbsoluteSize.X * vector2_23.X, AbsoluteSize.Y * vector2_23.Y)

		v85({
			xOffset = ReactOtter.instant(v111.X + vector2_24.X),
			yOffset = ReactOtter.instant(v111.Y + vector2_24.Y)
		})
	end, {
		b2,
		vector2_19,
		clampItemPosition,
		if not EngineFeature then v80 else nil,
		if not EngineFeature then v79 else nil,
		v73,
		v75,
		v85,
		v83
	})
	local v88 = useCallback(function(vector2_25: Vector2, b3: boolean) -- line: 359
		-- upvalues: validateRefs (copy), v67 (copy), v65 (copy), v79 (copy), v80 (copy), getSnapAnchorPoint (copy), EngineFeature (copy), vector2_19 (copy), v75 (copy), v83 (copy), ReactOtter (copy), v76 (copy), getSnapPosition (copy), clampItemPosition (copy), v85 (copy), v68 (copy), t3 (copy), v72 (copy), v78 (copy), SnapDirection (copy), CaptureControlsConfiguration (copy), v70 (copy)
		if not validateRefs({
			v67,
			v65
		}) then
			return
		end

		assert(v67.current ~= nil, "dragItemRef is nil")
		assert(v65.current ~= nil, "dragContainerRef is nil")

		local v116 = vector2_25 - Vector2.new(v79.left + v80.left, v79.top + v80.top)
		local AbsolutePosition = v65.current.AbsolutePosition
		local AbsoluteSize = v65.current.AbsoluteSize
		local v119, v120 = getSnapAnchorPoint(if not EngineFeature then v116 else vector2_25, AbsolutePosition, AbsoluteSize, vector2_19)
		local v121 = v120 < 70 or not b3
		local AbsoluteSize2 = v67.current.AbsoluteSize
		local currentAnchorPoint = v67.current.AnchorPoint
		local v124 = v75
		local v125 = v119.X == 0 or v119.X == 1
		local v126 = v119.Y == 0 or v119.Y == 1
		local v127 = false

		if v125 and v126 then
			v127 = false
		elseif v126 and not v124 then
			v127 = true
		elseif v125 and v124 then
			v127 = true
		end

		if v121 and v127 then
			AbsoluteSize2 = Vector2.new(AbsoluteSize2.Y, AbsoluteSize2.X)
			currentAnchorPoint = Vector2.new(currentAnchorPoint.Y, currentAnchorPoint.X)
			v83({
				x = ReactOtter.instant(currentAnchorPoint.X),
				y = ReactOtter.instant(currentAnchorPoint.Y)
			})
			v76(not v75)
		end

		local vector2_26 = Vector2.new(AbsoluteSize2.X * currentAnchorPoint.X, AbsoluteSize2.Y * currentAnchorPoint.Y)
		local v129 = if not v121 then clampItemPosition(((if not EngineFeature then v116 else vector2_25)) - vector2_26, AbsoluteSize2, AbsolutePosition, AbsoluteSize, vector2_19) else getSnapPosition(AbsoluteSize2, currentAnchorPoint, AbsolutePosition, AbsoluteSize, v119, vector2_19)

		if b3 then
			v85({
				xOffset = ReactOtter.instant(v129.X + vector2_26.X),
				yOffset = ReactOtter.instant(v129.Y + vector2_26.Y)
			})

			return
		end

		v68.current = true
		v85({
			xOffset = ReactOtter.ease(v129.X + vector2_26.X, t3),
			yOffset = ReactOtter.ease(v129.Y + vector2_26.Y, t3)
		})
		v72(v119)
		v78(if v119.X ~= 0 then if v119.X ~= 1 then if v119.Y ~= 0 then SnapDirection.Bottom else SnapDirection.Top else SnapDirection.Right else SnapDirection.Left)
		CaptureControlsConfiguration.setStoredSnapAnchorPoint(v119)
		v70.current = v119
	end, {
		vector2_19,
		if not EngineFeature then v80 else nil,
		if not EngineFeature then v79 else nil,
		v75,
		v85,
		v83
	})
	local v89 = useCallback(function(vector2_27: Vector2) -- line: 450
		-- upvalues: b2 (copy), v73 (copy), v88 (copy)
		if not b2 or not v73 then
			return
		end

		v88(vector2_27, true)
	end, {
		b2,
		v88,
		v73
	})
	local v90 = useCallback(function(vector2_28: Vector2) -- line: 458
		-- upvalues: b2 (copy), v73 (copy), v88 (copy), v74 (copy)
		if not b2 or not v73 then
			return
		end

		v88(vector2_28, false)
		v74(false)
	end, {
		b2,
		v88,
		v73
	})

	useEffect(function() -- line: 467
		-- upvalues: b2 (copy), v64 (copy), vector2_19 (copy), v86 (copy)
		if not b2 then
			return
		end

		if v64.current ~= vector2_19 then
			v64.current = vector2_19
			v86()
		end
	end, {
		b2,
		vector2_19,
		v86
	})
	useEffect(function() -- line: 478
		-- upvalues: b2 (copy), v66 (copy), v87 (copy), v89 (copy), v90 (copy), v65 (copy), v86 (copy), v67 (copy)
		if not b2 then
			return
		end

		local t6 = {}

		if v66.current ~= nil then
			table.insert(t6, v66.current.DragStart:Connect(v87))
			table.insert(t6, v66.current.DragContinue:Connect(v89))
			table.insert(t6, v66.current.DragEnd:Connect(v90))
		end

		if v65.current ~= nil then
			table.insert(t6, v65.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v86))
		end

		if v67.current ~= nil then
			table.insert(t6, v67.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v86))
		end

		return function() -- line: 504
			-- upvalues: t6 (copy)
			for _, v134 in t6 do
				v134:Disconnect()
			end
		end
	end, {
		b2,
		v87,
		v89,
		v90,
		v86
	})

	return {
		dragContainerRef = v65,
		dragDetectorRef = v66,
		dragItemAnchorPointBinding = v82,
		dragItemPositionBinding = v84,
		dragItemRef = v67,
		isItemHorizontal = v75,
		screenshotButtonRef = v69,
		snapDirection = v77
	}
end

return useCaptureControlsController
