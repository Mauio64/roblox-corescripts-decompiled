local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local parent = script:FindFirstAncestor("AvatarSwitcher").Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local function swipeDistanceToRotationAngle(vector3: Vector3) -- 2 equivalent calls inferred from this helper
	return -vector3.X * 1
end

local function useOutfitViewportInteractions(p)
	local ref = React.useRef(false)
	local ref2 = React.useRef((Vector3.new()))
	local v, v2 = ReactOtter.useAnimatedBinding(0)
	local ref3 = React.useRef(0)
	local ref4 = React.useRef(0)
	local ref5 = React.useRef(nil)
	local cameraCFrame, v3 = React.useBinding(CFrame.new())

	React.useEffect(function()
		local total = 0
		local v4 = "OutfitVewportSpin_" .. HttpService:GenerateGUID(false)
		local current = ref5.current

		RunService:BindToRenderStep(v4, Enum.RenderPriority.Camera.Value + 1, function(p2: number)
			if ref.current then
				local v5

				if ref5.current and current then
					v5 = (ref5.current - current) / p2
				else
					v5 = Vector2.new(0, 0)
				end

				v2(ReactOtter.instant(-v5.X * 1))
			else
				total += p2 * v:getValue()
			end

			current = ref5.current

			local v5 = math.rad(total) + math.rad(ref3.current) + math.rad(ref4.current)
			local cframe = CFrame.Angles(0, v5, 0)
			local current2 = p.defaultCameraDistanceRef.current

			v3(CFrame.lookAt(cframe.LookVector * current2, Vector3.new(0, 0, 0), cframe.UpVector))
		end)

		return function()
			RunService:UnbindFromRenderStep(v4)
		end
	end, { v2, p.defaultCameraDistanceRef, v3 })

	local v4 = React.useCallback(function(vector3: Vector3)
		ref3.current += swipeDistanceToRotationAngle(vector3 - ref2.current) -- inferred equivalent call
		ref.current = false
		ref5.current = nil
		ref4.current = 0

		if p.onInteractionChanged then
			p.onInteractionChanged(false)
		end

		v2((ReactOtter.spring(0, { frequency = 1 })))
	end, { p.onInteractionChanged, v2 })

	return {
		onInputBegan = React.useCallback(function(_, p2)
			if
				(p2.UserInputType == Enum.UserInputType.MouseButton1 or p2.UserInputType == Enum.UserInputType.Touch)
				and not ref.current
			then
				ref.current = true
				ref2.current = p2.Position
				ref5.current = p2.Position

				if p.onInteractionChanged then
					p.onInteractionChanged(true)
				end
			end
		end, { p.onInteractionChanged }),
		onInputChanged = React.useCallback(function(p2)
			local v5 = p2.UserInputType == Enum.UserInputType.MouseMovement
				or p2.UserInputType == Enum.UserInputType.Touch

			if ref.current and v5 then
				ref4.current = swipeDistanceToRotationAngle(p2.Position - ref2.current) -- inferred equivalent call
				ref5.current = p2.Position
			end
		end, {}),
		onInputEnded = React.useCallback(function(p2)
			if
				(p2.UserInputType == Enum.UserInputType.MouseButton1 or p2.UserInputType == Enum.UserInputType.Touch)
				and ref.current
			then
				v4(p2.Position)
			end
		end, { v4 }),
		cameraCFrame = cameraCFrame
	}
end

return useOutfitViewportInteractions
