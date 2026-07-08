local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)

local function swipeDistanceToRotationAngle(vector3: Vector3) -- line: 21
	return -vector3.X * 1
end
local function useOutfitViewportInteractions(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), ReactOtter (copy), HttpService (copy), RunService (copy)
	local v10 = React.useRef(false)
	local v11 = React.useRef((Vector3.new()))
	local v12, v13 = ReactOtter.useAnimatedBinding(0)
	local v14 = React.useRef(0)
	local v15 = React.useRef(0)
	local v16 = React.useRef(nil)
	local v17, v18 = React.useBinding(CFrame.new())

	React.useEffect(function() -- line: 39
		-- upvalues: HttpService (copy), v16 (copy), RunService (copy), v10 (copy), v13 (copy), ReactOtter (copy), v12 (copy), v14 (copy), v15 (copy), t1 (copy), v18 (copy)
		local n1 = 0
		local v24 = "OutfitVewportSpin_" .. HttpService:GenerateGUID(false)
		local current = v16.current

		RunService:BindToRenderStep(v24, Enum.RenderPriority.Camera.Value + 1, function(n2: number) -- line: 45
			-- upvalues: v10 (copy), v16 (copy), current (ref), v13 (copy), ReactOtter (copy), n1 (ref), v12 (copy), v14 (copy), v15 (copy), t1 (copy), v18 (copy)
			if v10.current then
				local v34 = if not v16.current or not current then Vector2.new(0, 0) else (v16.current - current) / n2

				v13(ReactOtter.instant(-v34.X * 1))
			else
				n1 += n2 * v12:getValue()
			end

			current = v16.current

			local v35 = math.rad(n1) + math.rad(v14.current) + math.rad(v15.current)
			local cFrame = CFrame.Angles(0, v35, 0)
			local current2 = t1.defaultCameraDistanceRef.current

			v18(CFrame.lookAt(cFrame.LookVector * current2, Vector3.new(0, 0, 0), cFrame.UpVector))
		end)

		return function() -- line: 68
			-- upvalues: RunService (copy), v24 (copy)
			RunService:UnbindFromRenderStep(v24)
		end
	end, {
		v13,
		t1.defaultCameraDistanceRef,
		v18
	})

	local v19 = React.useCallback(function(vector3: Vector3) -- line: 73
		-- upvalues: v14 (copy), v11 (copy), v10 (copy), v16 (copy), v15 (copy), t1 (copy), v13 (copy), ReactOtter (copy)
		local v27 = v14

		v27.current = v27.current + -(vector3 - v11.current).X * 1
		v10.current = false
		v16.current = nil
		v15.current = 0

		if t1.onInteractionChanged then
			t1.onInteractionChanged(false)
		end

		v13((ReactOtter.spring(0, {
			frequency = 1
		})))
	end, {
		t1.onInteractionChanged,
		v13
	})
	local v20 = React.useCallback(function(_, p2) -- line: 86
		-- upvalues: v10 (copy), v11 (copy), v16 (copy), t1 (copy)
		if (p2.UserInputType == Enum.UserInputType.MouseButton1 or p2.UserInputType == Enum.UserInputType.Touch) and not v10.current then
			v10.current = true
			v11.current = p2.Position
			v16.current = p2.Position

			if t1.onInteractionChanged then
				t1.onInteractionChanged(true)
			end
		end
	end, { t1.onInteractionChanged })
	local v21 = React.useCallback(function(p3) -- line: 100
		-- upvalues: v10 (copy), v15 (copy), v11 (copy), v16 (copy)
		local v31 = p3.UserInputType == Enum.UserInputType.MouseMovement or p3.UserInputType == Enum.UserInputType.Touch

		if v10.current and v31 then
			v15.current = -(p3.Position - v11.current).X * 1
			v16.current = p3.Position
		end
	end, {})
	local v22 = React.useCallback(function(p4) -- line: 109
		-- upvalues: v10 (copy), v19 (copy)
		if (p4.UserInputType == Enum.UserInputType.MouseButton1 or p4.UserInputType == Enum.UserInputType.Touch) and v10.current then
			v19(p4.Position)
		end
	end, { v19 })

	return {
		onInputBegan = v20,
		onInputChanged = v21,
		onInputEnded = v22,
		cameraCFrame = v17
	}
end

return useOutfitViewportInteractions
