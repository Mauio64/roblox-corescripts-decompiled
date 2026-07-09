local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local ReactOtter = require(CorePackages.Packages.ReactOtter)
local GetFFlagAXFixItemViewportErrors = require(Modules.AvatarExperience.Flags.GetFFlagAXFixItemViewportErrors)
local v8 = game:DefineFastInt("ItemViewportInitialAngleX", -45)
local v9 = game:DefineFastInt("ItemViewportInitialAngleY", 20)
local v10 = game:DefineFastInt("ItemViewportIdleRotationSpeed", 30)
local v11 = game:DefineFastInt("ItemViewportSwipeRotationSpeed", 1000)
local v12 = game:DefineFastInt("ItemViewportMaxZoom", 5000)
local v13 = game:DefineFastInt("ItemViewportMouseWheelZoomRatio", 1100)
local vector2 = Vector2.new(v8, v9)
local v15 = v11 / 1000
local v16 = v11 / 1000
local v17 = v11 / 1000
local v18 = 1 / (math.max(v12, 1) / 1000)
local v19 = v12 / 1000
local v20 = v13 / 1000

local function swipeDistanceToRotationAngles(vector3: Vector3, n1: number) -- line: 41
	-- upvalues: v15 (copy), v16 (copy)
	return Vector2.new(-vector3.X * v15, (math.clamp(vector3.Y * v16, -90 - n1, 90 - n1)))
end
local function useItemViewportInteractions(t1: {[any]: any}) -- line: 57
	-- upvalues: React (copy), ReactOtter (copy), v10 (copy), vector2 (copy), HttpService (copy), RunService (copy), v17 (copy), v15 (copy), v16 (copy), v18 (copy), v19 (copy), GetFFlagAXFixItemViewportErrors (copy), v20 (copy)
	local v26 = React.useRef(false)
	local v27 = React.useRef(false)
	local v28 = React.useRef(false)
	local v29 = React.useRef((Vector3.new()))
	local v30, v31 = ReactOtter.useAnimatedBinding(v10)
	local v32 = React.useRef(vector2)
	local v33 = React.useRef(Vector2.new())
	local v34 = React.useRef(nil)
	local v35 = React.useRef(1)
	local v36 = React.useRef(1)
	local v37 = React.useRef(0)
	local v38, v39 = React.useBinding(CFrame.new())
	local setParentScrollingEnabled = t1.setParentScrollingEnabled

	React.useEffect(function() -- line: 72
		-- upvalues: HttpService (copy), v34 (copy), RunService (copy), v26 (copy), v31 (copy), ReactOtter (copy), v17 (copy), v27 (copy), v30 (copy), v32 (copy), v33 (copy), t1 (copy), v35 (copy), v36 (copy), v39 (copy)
		local n2 = 0
		local v51 = "ItemVewportSpin_" .. HttpService:GenerateGUID(false)
		local current = v34.current

		RunService:BindToRenderStep(v51, Enum.RenderPriority.Camera.Value + 1, function(n3: number) -- line: 78
			-- upvalues: v26 (copy), v34 (copy), current (ref), v31 (copy), ReactOtter (copy), v17 (copy), v27 (copy), n2 (ref), v30 (copy), v32 (copy), v33 (copy), t1 (copy), v35 (copy), v36 (copy), v39 (copy)
			if v26.current then
				local v76 = if not v34.current or not current then Vector2.new(0, 0) else (v34.current - current) / n3

				v31(ReactOtter.instant(-v76.X * v17))
			elseif not v27.current then
				n2 += n3 * v30:getValue()
			end

			current = v34.current

			local v77 = math.rad(n2) + math.rad(v32.current.X) + math.rad(v33.current.X)
			local v78 = math.rad(v32.current.Y) + math.rad(v33.current.Y)
			local v79 = CFrame.Angles(0, v77, 0) * CFrame.Angles(v78, 0, 0)
			local v80 = t1.defaultCameraDistanceRef.current / (v35.current * v36.current)

			v39(CFrame.lookAt(v79.LookVector * v80, Vector3.new(0, 0, 0), v79.UpVector))
		end)

		return function() -- line: 102
			-- upvalues: RunService (copy), v51 (copy)
			RunService:UnbindFromRenderStep(v51)
		end
	end, {
		v31,
		t1.defaultCameraDistanceRef,
		v39
	})

	local v41 = React.useCallback(function(vector3: Vector3) -- line: 107
		-- upvalues: v32 (copy), v29 (copy), v15 (copy), v16 (copy), v26 (copy), v34 (copy), v33 (copy), setParentScrollingEnabled (copy), v28 (copy), v31 (copy), ReactOtter (copy), v10 (copy)
		local v54 = v32
		local current = v54.current
		local v56 = vector3 - v29.current
		local currentY = v32.current.Y

		v54.current = current + Vector2.new(-v56.X * v15, (math.clamp(v56.Y * v16, -90 - currentY, 90 - currentY)))
		v26.current = false
		v34.current = nil
		v33.current = Vector2.new()

		if setParentScrollingEnabled and not v28.current then
			setParentScrollingEnabled(true)
		end

		v31((ReactOtter.spring(v10, {
			frequency = 1
		})))
	end, {
		setParentScrollingEnabled,
		v31
	})
	local v42 = React.useCallback(function(_, p2) -- line: 124
		-- upvalues: v26 (copy), v27 (copy), v29 (copy), v34 (copy), setParentScrollingEnabled (copy)
		if (p2.UserInputType == Enum.UserInputType.MouseButton1 or p2.UserInputType == Enum.UserInputType.Touch) and (not v26.current and not v27.current) then
			v26.current = true
			v29.current = p2.Position
			v34.current = p2.Position

			if setParentScrollingEnabled then
				setParentScrollingEnabled(false)
			end
		end
	end, { setParentScrollingEnabled })
	local v43 = React.useCallback(function(p3) -- line: 137
		-- upvalues: v26 (copy), v33 (copy), v29 (copy), v32 (copy), v15 (copy), v16 (copy), v34 (copy)
		local v61 = p3.UserInputType == Enum.UserInputType.MouseMovement or p3.UserInputType == Enum.UserInputType.Touch

		if v26.current and v61 then
			local v62 = v33
			local v63 = p3.Position - v29.current
			local currentY = v32.current.Y

			v62.current = Vector2.new(-v63.X * v15, (math.clamp(v63.Y * v16, -90 - currentY, 90 - currentY)))
			v34.current = p3.Position
		end
	end, {})
	local v44 = React.useCallback(function(p4) -- line: 147
		-- upvalues: v26 (copy), v41 (copy)
		if (p4.UserInputType == Enum.UserInputType.MouseButton1 or p4.UserInputType == Enum.UserInputType.Touch) and v26.current then
			v41(p4.Position)
		end
	end, { v41 })
	local v45 = React.useCallback(function(t2: {[any]: any}, _, _, p7) -- line: 155
		-- upvalues: v37 (copy), v27 (copy), v26 (copy), v41 (copy), v34 (copy), v29 (copy), v35 (copy), v18 (copy), v19 (copy), GetFFlagAXFixItemViewportErrors (copy), v36 (copy)
		if #t2 < 2 then
			return
		end

		local Magnitude = (t2[1] - t2[2]).Magnitude
		local v71 = Magnitude / v37.current

		if p7 == Enum.UserInputState.Begin then
			v27.current = true
			v37.current = Magnitude

			if v26.current then
				v41(v34.current or v29.current)

				return
			end
		else
			if p7 == Enum.UserInputState.Change then
				local current = v35.current
				local v73 = math.min(v18 / current, v19 / current)
				local v74 = math.max(v18 / current, v19 / current)

				if GetFFlagAXFixItemViewportErrors() then
					pcall(function() -- line: 181
						-- upvalues: v36 (copy), v71 (copy), v73 (copy), v74 (copy)
						v36.current = math.clamp(v71, v73, v74)
					end)

					return
				end

				v36.current = math.clamp(v71, v73, v74)

				return
			end

			if p7 == Enum.UserInputState.End then
				v27.current = false
				v36.current = 1
				v35.current = math.clamp(v35.current * v71, v18, v19)
			end
		end
	end, { v41 })
	local v46 = React.useCallback(function() -- line: 194
		-- upvalues: v35 (copy), v20 (copy), v18 (copy), v19 (copy)
		v35.current = math.clamp(v35.current * v20, v18, v19)
	end, {})
	local v47 = React.useCallback(function() -- line: 199
		-- upvalues: v35 (copy), v20 (copy), v18 (copy), v19 (copy)
		v35.current = math.clamp(v35.current / v20, v18, v19)
	end, {})
	local v48 = React.useCallback(function() -- line: 205
		-- upvalues: v28 (copy), setParentScrollingEnabled (copy)
		v28.current = true

		if setParentScrollingEnabled then
			setParentScrollingEnabled(false)
		end
	end, { setParentScrollingEnabled })
	local v49 = React.useCallback(function() -- line: 212
		-- upvalues: v28 (copy), v26 (copy), setParentScrollingEnabled (copy)
		v28.current = false

		if not v26.current and setParentScrollingEnabled then
			setParentScrollingEnabled(true)
		end
	end, { setParentScrollingEnabled })

	return {
		onInputBegan = v42,
		onInputChanged = v43,
		onInputEnded = v44,
		onTouchPinch = v45,
		onMouseWheelForward = v46,
		onMouseWheelBackward = v47,
		onMouseEnter = v48,
		onMouseLeave = v49,
		cameraCFrame = v38
	}
end

return useItemViewportInteractions
