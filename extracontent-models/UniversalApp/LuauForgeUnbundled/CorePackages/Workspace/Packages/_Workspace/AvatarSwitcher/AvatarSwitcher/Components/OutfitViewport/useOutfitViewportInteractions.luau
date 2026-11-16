local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/ReactOtter")

local fFlagAXItemViewportRestoreParentScrollingOnUnmount = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarExperienceFlags").FFlagAXItemViewportRestoreParentScrollingOnUnmount

local defineFastInt = game:DefineFastInt("ItemViewportInitialAngleX", -45)
local defineFastInt2 = game:DefineFastInt("ItemViewportInitialAngleY", 20)
local defineFastInt3 = game:DefineFastInt("ItemViewportIdleRotationSpeed", 30)
local defineFastInt4 = game:DefineFastInt("ItemViewportSwipeRotationSpeed", 1000)
local defineFastInt5 = game:DefineFastInt("ItemViewportMaxZoom", 5000)
local defineFastInt6 = game:DefineFastInt("ItemViewportMouseWheelZoomRatio", 1100)

local vector2 = Vector2.new(defineFastInt, defineFastInt2)

local v5 = defineFastInt4 / 1000
local v6 = defineFastInt4 / 1000

local v7 = defineFastInt4 / 1000
local v8 = 1 / (math.max(defineFastInt5, 1) / 1000)
local v9 = defineFastInt5 / 1000
local v10 = defineFastInt6 / 1000

local function swipeDistanceToRotationAngles(p2, p3)
	return Vector2.new(-p2.X * v5, (math.clamp(p2.Y * v6, -90 - p3, 90 - p3)))
end

local function useItemViewportInteractions(p2)
	local ref = React.useRef(false)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(false)
	local ref4 = React.useRef((Vector3.new()))
	local v11, v12 = ReactOtter.useAnimatedBinding(defineFastInt3)
	local ref5 = React.useRef(vector2)
	local ref6 = React.useRef(Vector2.new())
	local ref7 = React.useRef(nil)
	local ref8 = React.useRef(1)
	local ref9 = React.useRef(1)
	local ref10 = React.useRef(0)
	local v13, v14 = React.useBinding(CFrame.new())
	local setParentScrollingEnabled = p2.setParentScrollingEnabled

	React.useEffect(function()
		local total = 0
		local v15 = "ItemVewportSpin_" .. HttpService:GenerateGUID(false)
		local current = ref7.current

		RunService:BindToRenderStep(v15, Enum.RenderPriority.Camera.Value + 1, function(p3)
			if ref.current then
				local v16 = if ref7.current and current then (ref7.current - current) / p3 else Vector2.new(0, 0)
				v12(ReactOtter.instant(-v16.X * v7))
			elseif not ref2.current then
				total += p3 * v11:getValue()
			end

			current = ref7.current

			local v16 = (math.rad)(total) + math.rad(ref5.current.X) + math.rad(ref6.current.X)
			local v17 = math.rad(ref5.current.Y) + math.rad(ref6.current.Y)
			local v18 = CFrame.Angles(0, v16, 0) * CFrame.Angles(v17, 0, 0)
			local v19 = p2.defaultCameraDistanceRef.current / (ref8.current * ref9.current)

			v14(CFrame.lookAt(v18.LookVector * v19, Vector3.new(0, 0, 0), v18.UpVector))
		end)

		return function()
			RunService:UnbindFromRenderStep(v15)
		end
	end, { v12, p2.defaultCameraDistanceRef, v14 })

	local v15 = React.useCallback(function(p3)
		local v16 = ref5
		local current = v16.current
		local v17 = p3 - ref4.current
		local y = ref5.current.Y
		v16.current = current + Vector2.new(-v17.X * v5, (math.clamp(v17.Y * v6, -90 - y, 90 - y)))

		ref.current = false
		ref7.current = nil
		ref6.current = Vector2.new()

		if setParentScrollingEnabled and not ref3.current then
			setParentScrollingEnabled(true)
		end

		v12(ReactOtter.spring(defineFastInt3, { frequency = 1 }))
	end, { setParentScrollingEnabled, v12 })

	local v16 = React.useCallback(function(p3, p4)
		if
			(p4.UserInputType == Enum.UserInputType.MouseButton1 or p4.UserInputType == Enum.UserInputType.Touch)
			and not (ref.current or ref2.current)
		then
			ref.current = true
			ref4.current = p4.Position
			ref7.current = p4.Position

			if setParentScrollingEnabled then
				setParentScrollingEnabled(false)
			end
		end
	end, { setParentScrollingEnabled })

	local v17 = React.useCallback(function(p3)
		local v18 = p3.UserInputType == Enum.UserInputType.MouseMovement
			or p3.UserInputType == Enum.UserInputType.Touch

		if ref.current and v18 then
			local v19 = ref6
			local v20 = p3.Position - ref4.current
			local y = ref5.current.Y
			v19.current = Vector2.new(-v20.X * v5, (math.clamp(v20.Y * v6, -90 - y, 90 - y)))

			ref7.current = p3.Position
		end
	end, {})

	local v18 = React.useCallback(function(p3)
		if
			(p3.UserInputType == Enum.UserInputType.MouseButton1 or p3.UserInputType == Enum.UserInputType.Touch)
			and ref.current
		then
			v15(p3.Position)
		end
	end, { v15 })

	local v19 = React.useCallback(function(list, p3, p4, p5)
		if #list < 2 then
			return
		end

		local magnitude = (list[1] - list[2]).Magnitude
		local v20 = magnitude / ref10.current

		if p5 == Enum.UserInputState.Begin then
			ref2.current = true
			ref10.current = magnitude

			if ref.current then
				v15(ref7.current or ref4.current)
			end
		elseif p5 == Enum.UserInputState.Change then
			local current = ref8.current

			local v21 = math.min(v8 / current, v9 / current)

			local v22 = math.max(v8 / current, v9 / current)

			pcall(function()
				ref9.current = math.clamp(v20, v21, v22)
			end)
		elseif p5 == Enum.UserInputState.End then
			ref2.current = false
			ref9.current = 1
			ref8.current = math.clamp(ref8.current * v20, v8, v9)
		end
	end, { v15 })

	local v20 = React.useCallback(function()
		ref8.current = math.clamp(ref8.current * v10, v8, v9)
	end, {})

	local v21 = React.useCallback(function()
		ref8.current = math.clamp(ref8.current / v10, v8, v9)
	end, {})

	local v22 = React.useCallback(function()
		ref3.current = true

		if setParentScrollingEnabled then
			setParentScrollingEnabled(false)
		end
	end, { setParentScrollingEnabled })

	local v23 = React.useCallback(function()
		ref3.current = false

		if not ref.current and setParentScrollingEnabled then
			setParentScrollingEnabled(true)
		end
	end, { setParentScrollingEnabled })

	if fFlagAXItemViewportRestoreParentScrollingOnUnmount then
		local ref11 = React.useRef(setParentScrollingEnabled)
		ref11.current = setParentScrollingEnabled
		React.useEffect(function()
			return function()
				local current = ref11.current

				if current and (ref.current or ref3.current) then
					current(true)
				end
			end
		end, {})
	end

	return {
		onInputBegan = v16,
		onInputChanged = v17,
		onInputEnded = v18,
		onTouchPinch = v19,
		onMouseWheelForward = v20,
		onMouseWheelBackward = v21,
		onMouseEnter = v22,
		onMouseLeave = v23,
		cameraCFrame = v13
	}
end

return useItemViewportInteractions
