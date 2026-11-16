local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarViewport/React")

local CameraMath = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/CameraMath")
local GetFIntAvatarViewportDegreesPerPixel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Flags/GetFIntAvatarViewportDegreesPerPixel")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Types")
local ViewportInputTypes = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/ViewportInputTypes")
local ViewportUserInputSubscriptions = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/ViewportUserInputSubscriptions")

local function useViewportOrbitInteractions(data)
	local v5 = data.enabled == nil or data.enabled
	local degreesPerPixel = data.degreesPerPixel or GetFIntAvatarViewportDegreesPerPixel()
	local pinchDeltaToZoomDelta = data.pinchDeltaToZoomDelta or CameraMath.PINCH_DELTA_TO_ZOOM_DELTA

	local clampYRotDeg = CameraMath.clampYRotDeg(data.initialYRotDeg or 0)
	local state, setState = React.useState(clampYRotDeg)
	local ref = React.useRef(clampYRotDeg)

	local ref2 = React.useRef(false)
	local ref3 = React.useRef(false)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(0)

	local ref6 = React.useRef({})

	local ref7 = React.useRef(nil)
	local ref8 = React.useRef(1)

	local ref9 = React.useRef(data.distanceScale)
	local ref10 = React.useRef(data.onYRotDegChanged)
	local ref11 = React.useRef(data.onDistanceScaleChanged)
	local ref12 = React.useRef(data.onCameraUpdateRequested)
	ref10.current = data.onYRotDegChanged
	ref11.current = data.onDistanceScaleChanged
	ref12.current = data.onCameraUpdateRequested

	React.useEffect(function()
		ref9.current = CameraMath.clampDistanceScale(data.distanceScale)
	end, { data.distanceScale })

	local v6 = React.useCallback(function(current, p2)
		ref.current = current

		if p2 and p2.syncReactState then
			setState(current)
		end

		if p2 and p2.notifyParent == true and ref10.current then
			ref10.current(current)
		end

		if ref12.current then
			ref12.current()
		end
	end, {})

	local ref13 = React.useRef(clampYRotDeg)
	local ref14 = React.useRef(nil)

	local v7 = React.useCallback(function()
		local current = ref.current

		if current == ref13.current then
			return
		end

		ref13.current = current
		setState(current)

		if ref10.current then
			ref10.current(current)
		end
	end, {})
	ref14.current = v7

	local v8 = React.useCallback(function(p2)
		local clampYRotDeg2 = CameraMath.clampYRotDeg(p2 or data.initialYRotDeg or 0)
		ref13.current = clampYRotDeg2
		v6(clampYRotDeg2, { syncReactState = true })
	end, { v6, data.initialYRotDeg })

	local v9 = React.useCallback(function(p2)
		local adjustDistanceScaleByZoomGesture = CameraMath.adjustDistanceScaleByZoomGesture(ref9.current, p2)

		if adjustDistanceScaleByZoomGesture == ref9.current then
			return
		end

		ref9.current = adjustDistanceScaleByZoomGesture

		if ref11.current then
			ref11.current(adjustDistanceScaleByZoomGesture)
		end

		if ref12.current then
			ref12.current()
		end
	end, {})

	local v10 = React.useCallback(function(p2)
		if ref5.current > 1 or not (ref2.current and v5) then
			return
		end

		local current = ref4.current

		if not current then
			ref4.current = p2.Position
			return
		end

		local v11 = p2.Position.X - current.X
		ref4.current = p2.Position

		v6(CameraMath.clampYRotDeg(ref.current - v11 * degreesPerPixel), {
			syncReactState = false,
			notifyParent = false
		})
	end, { v5, degreesPerPixel, v6 })

	local v11 = React.useCallback(function(p2)
		if not v5 then
			return
		end

		v6(CameraMath.clampYRotDeg(ref.current + p2), {
			syncReactState = false,
			notifyParent = false
		})
	end, { v5, v6 })

	React.useEffect(function()
		if ref2.current then
			return
		end

		v8(clampYRotDeg)
	end, { clampYRotDeg, v8 })

	React.useEffect(function()
		local connection = ViewportUserInputSubscriptions.connectInputChanged(function(p2)
			if ref3.current then
				if ViewportInputTypes.isMouseMovement(p2) then
					v10(p2)
				end
			elseif ref2.current and ref5.current == 1 and ViewportInputTypes.isTouch(p2) and p2 == ref7.current then
				v10(p2)
			end
		end)

		local connection2 = ViewportUserInputSubscriptions.connectInputEnded(function(p2)
			if ViewportInputTypes.isPrimaryPointerEnded(p2) then
				if not ref3.current then
					return
				end

				ref3.current = false
				ref2.current = false
				ref4.current = nil

				if ref14.current then
					ref14.current()
				end
			elseif ViewportInputTypes.isTouch(p2) then
				if not ref6.current[p2] then
					return
				end

				ref6.current[p2] = nil
				ref5.current = math.max(0, ref5.current - 1)

				if ref5.current == 0 then
					ref2.current = false
					ref7.current = nil
					ref4.current = nil

					if ref14.current then
						ref14.current()
					end
				elseif ref5.current > 1 then
					ref2.current = false
					ref7.current = nil
					ref4.current = nil
				end
			end
		end)

		return function()
			connection:Disconnect()
			connection2:Disconnect()
			ref3.current = false
			ref2.current = false
			ref4.current = nil
			ref5.current = 0
			table.clear(ref6.current)
			ref7.current = nil
		end
	end, { v10 })

	local v12 = React.useCallback(function(p2, list, p3, p4, p5)
		if not v5 or #list < 2 then
			return
		end

		if p5 == Enum.UserInputState.Begin then
			ref8.current = (list[1] - list[2]).Magnitude
			ref2.current = false
			ref7.current = nil
			ref4.current = nil
		else
			local magnitude = (list[1] - list[2]).Magnitude
			local v13 = magnitude - ref8.current
			ref8.current = magnitude
			v9(v13 * pinchDeltaToZoomDelta)
		end
	end, { v5, v9, pinchDeltaToZoomDelta })

	return {
		yRotDeg = state,
		yRotDegRef = ref,
		distanceScaleRef = ref9,
		resetYaw = v8,
		commitYaw = v7,
		applyYawDelta = v11,
		applyZoomGesture = v9,
		inputHandlers = {
			onInputBegan = React.useCallback(function(p2, current)
				if not v5 then
					return
				end

				if ViewportInputTypes.isPrimaryPointerBegan(current) then
					ref3.current = true
					ref2.current = true
					ref4.current = current.Position
				else
					if not ViewportInputTypes.isTouch(current) or ref6.current[current] then
						return
					end

					ref6.current[current] = true
					ref5.current += 1

					if ref5.current > 1 then
						ref2.current = false
						ref7.current = nil
						ref4.current = nil
					else
						ref2.current = true
						ref7.current = current
						ref4.current = current.Position
					end
				end
			end, { v5 }),
			onInputChanged = React.useCallback(function(p2, p3)
				if ViewportInputTypes.isMouseWheel(p3) then
					v9(p3.Position.Z)
					return
				end

				if ref3.current or ref2.current and ref5.current >= 1 and ViewportInputTypes.isTouch(p3) then
					return
				end

				v10(p3)
			end, { v10, v9 }),
			onInputEnded = React.useCallback(function(p2, p3)
				if ViewportInputTypes.isPrimaryPointerEnded(p3) then
					ref3.current = false
					ref2.current = false
					ref4.current = nil

					if ref14.current then
						ref14.current()
					end
				end
			end, {}),
			onTouchPinch = v12
		}
	}
end

return useViewportOrbitInteractions
