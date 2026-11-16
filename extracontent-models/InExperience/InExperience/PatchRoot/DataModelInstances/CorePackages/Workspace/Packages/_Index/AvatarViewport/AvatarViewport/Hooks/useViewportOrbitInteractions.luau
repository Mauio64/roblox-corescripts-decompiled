local AvatarViewport = script:FindFirstAncestor("AvatarViewport")
local parent = AvatarViewport.Parent

local React = require(parent.React)

local CameraMath = require(AvatarViewport.CameraMath)
local GetFIntAvatarViewportDegreesPerPixel = require(AvatarViewport.Flags.GetFIntAvatarViewportDegreesPerPixel)
require(AvatarViewport.Types)
local ViewportInputTypes = require(AvatarViewport.ViewportInputTypes)
local ViewportUserInputSubscriptions = require(AvatarViewport.ViewportUserInputSubscriptions)

local function useViewportOrbitInteractions(data)
	local v = data.enabled == nil or data.enabled
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

	local v2 = React.useCallback(function(current: number, p)
		ref.current = current

		if p and p.syncReactState then
			setState(current)
		end

		if p and p.notifyParent == true and ref10.current then
			ref10.current(current)
		end

		if ref12.current then
			ref12.current()
		end
	end, {})

	local ref13 = React.useRef(clampYRotDeg)
	local ref14 = React.useRef(nil)

	local v3 = React.useCallback(function()
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
	ref14.current = v3

	local resetYaw = React.useCallback(function(p: number?)
		local clampYRotDeg2 = CameraMath.clampYRotDeg(p or data.initialYRotDeg or 0)
		ref13.current = clampYRotDeg2
		v2(clampYRotDeg2, { syncReactState = true })
	end, { v2, data.initialYRotDeg })

	local applyZoomGesture = React.useCallback(function(p: number)
		local adjustDistanceScaleByZoomGesture = CameraMath.adjustDistanceScaleByZoomGesture(ref9.current, p)

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

	local v4 = React.useCallback(function(p)
		if ref5.current > 1 or not (ref2.current and v) then
			return
		end

		local current = ref4.current

		if not current then
			ref4.current = p.Position
			return
		end

		local v4 = p.Position.X - current.X
		ref4.current = p.Position

		v2(CameraMath.clampYRotDeg(ref.current - v4 * degreesPerPixel), {
			syncReactState = false,
			notifyParent = false
		})
	end, { v, degreesPerPixel, v2 })

	local applyYawDelta = React.useCallback(function(p: number)
		if not v then
			return
		end

		v2(CameraMath.clampYRotDeg(ref.current + p), {
			syncReactState = false,
			notifyParent = false
		})
	end, { v, v2 })

	React.useEffect(function()
		if ref2.current then
			return
		end

		resetYaw(clampYRotDeg)
	end, { clampYRotDeg, resetYaw })

	React.useEffect(function()
		local connection = ViewportUserInputSubscriptions.connectInputChanged(function(p)
			if ref3.current then
				if ViewportInputTypes.isMouseMovement(p) then
					v4(p)
				end
			elseif ref2.current and ref5.current == 1 and ViewportInputTypes.isTouch(p) and p == ref7.current then
				v4(p)
			end
		end)

		local connection2 = ViewportUserInputSubscriptions.connectInputEnded(function(p)
			if ViewportInputTypes.isPrimaryPointerEnded(p) then
				if not ref3.current then
					return
				end

				ref3.current = false
				ref2.current = false
				ref4.current = nil

				if ref14.current then
					ref14.current()
				end
			elseif ViewportInputTypes.isTouch(p) then
				if not ref6.current[p] then
					return
				end

				ref6.current[p] = nil
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
	end, { v4 })

	local onTouchPinch = React.useCallback(function(_, list, _: number, _: Vector2, p)
		if not v or #list < 2 then
			return
		end

		if p == Enum.UserInputState.Begin then
			ref8.current = (list[1] - list[2]).Magnitude
			ref2.current = false
			ref7.current = nil
			ref4.current = nil
		else
			local magnitude = (list[1] - list[2]).Magnitude
			local v5 = magnitude - ref8.current
			ref8.current = magnitude
			applyZoomGesture(v5 * pinchDeltaToZoomDelta)
		end
	end, { v, applyZoomGesture, pinchDeltaToZoomDelta })

	return {
		yRotDeg = state,
		yRotDegRef = ref,
		distanceScaleRef = ref9,
		resetYaw = resetYaw,
		commitYaw = v3,
		applyYawDelta = applyYawDelta,
		applyZoomGesture = applyZoomGesture,
		inputHandlers = {
			onInputBegan = React.useCallback(function(_, current)
				if not v then
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
			end, { v }),
			onInputChanged = React.useCallback(function(_, p)
				if ViewportInputTypes.isMouseWheel(p) then
					applyZoomGesture(p.Position.Z)
					return
				end

				if ref3.current or ref2.current and ref5.current >= 1 and ViewportInputTypes.isTouch(p) then
					return
				end

				v4(p)
			end, { v4, applyZoomGesture }),
			onInputEnded = React.useCallback(function(_, p)
				if ViewportInputTypes.isPrimaryPointerEnded(p) then
					ref3.current = false
					ref2.current = false
					ref4.current = nil

					if ref14.current then
						ref14.current()
					end
				end
			end, {}),
			onTouchPinch = onTouchPinch
		}
	}
end

return useViewportOrbitInteractions
