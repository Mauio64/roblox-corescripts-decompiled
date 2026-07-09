local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local React = require(Parent.React)
local EventConnection = require(Parent.ReactUtils).EventConnection
local Foundation = require(Parent.Foundation)
local OutfitViewportUtils = require(script.Parent.OutfitViewportUtils)
local useOutfitViewportInteractions = require(script.Parent.useOutfitViewportInteractions)
local v9 = game:DefineFastFlag("AvatarSwitcherPlayRandomEmote", false)
local FFlagAvatarSwitcherAccurateAvatarWarning = require(Parent.AvatarExperienceFlags).FFlagAvatarSwitcherAccurateAvatarWarning
local color3 = Color3.fromRGB(218, 203, 173)

local function OutfitViewport(t1: {[any]: any}) -- line: 37
	-- upvalues: React (copy), useOutfitViewportInteractions (copy), HttpService (copy), FFlagAvatarSwitcherAccurateAvatarWarning (copy), OutfitViewportUtils (copy), v9 (copy), color3 (copy), Foundation (copy), EventConnection (copy), UserInputService (copy)
	local v14 = React.useRef(nil)
	local v15 = React.useRef(nil)
	local v16 = React.useRef(nil)
	local v17, v18 = React.useState(true)
	local v19 = React.useRef("")
	local v20 = React.useRef(0)
	local v21 = not v17
	local v22 = useOutfitViewportInteractions({
		defaultCameraDistanceRef = v20
	})
	local v23 = React.useCallback(function(n1: number?, p1) -- line: 50
		-- upvalues: v18 (copy), v14 (copy), HttpService (copy), v19 (copy), FFlagAvatarSwitcherAccurateAvatarWarning (copy), OutfitViewportUtils (copy), t1 (copy), v20 (copy), v9 (copy)
		v18(true)

		if v14.current then
			v14.current:ClearAllChildren()
		end

		if not n1 or not p1 then
			return
		end

		local guid = HttpService:GenerateGUID(false)

		v19.current = guid

		local result, v32

		if FFlagAvatarSwitcherAccurateAvatarWarning then
			local ok, v30

			ok, result, v30 = pcall(function() -- line: 71
				-- upvalues: OutfitViewportUtils (copy), n1 (copy), p1 (copy)
				return OutfitViewportUtils.buildOutfitModel(n1, p1)
			end)

			if not ok or not result or not v30 then
				if t1.onLoadingFailed then
					t1.onLoadingFailed()
				end

				return
			end

			local Humanoid = result:WaitForChild("Humanoid", 10)

			v32 = Humanoid and Humanoid.RootPart

			if not Humanoid or not v32 then
				if t1.onLoadingFailed then
					t1.onLoadingFailed()
				end

				return
			end

			if guid ~= v19.current then
				result:Destroy()

				return
			end

			if t1.onLoaded then
				t1.onLoaded(Humanoid, v30)
			end
		else
			local ok

			ok, result = pcall(function() -- line: 99
				-- upvalues: OutfitViewportUtils (copy), n1 (copy), p1 (copy)
				return OutfitViewportUtils.buildOutfitModel(n1, p1)
			end)

			if not ok or not result then
				if t1.onLoadingFailed then
					t1.onLoadingFailed()
				end

				return
			end

			v32 = result:WaitForChild("HumanoidRootPart", 10)

			if not v32 then
				if t1.onLoadingFailed then
					t1.onLoadingFailed()
				end

				return
			end

			if guid ~= v19.current then
				result:Destroy()

				return
			end
		end

		result.Parent = v14.current

		local v34, _ = result:GetBoundingBox()

		v32.CFrame = CFrame.new(v32.CFrame.Position - v34.Position)
		v20.current = OutfitViewportUtils.getCameraDistance(result, 50)

		if v9 then
			OutfitViewportUtils.playRandomEmote(result)
		else
			local v36 = OutfitViewportUtils.loadIdleAnimationForAvatar(result)

			if v36 then
				v36:Play()
			end
		end

		v18(false)
	end, { t1.onLoadingFailed })

	React.useEffect(function() -- line: 143
		-- upvalues: v23 (copy), t1 (copy)
		task.spawn(function() -- line: 144
			-- upvalues: v23 (copy), t1 (copy)
			v23(t1.outfitId, t1.rigType)
		end)
	end, {
		t1.outfitId,
		t1.rigType,
		v23
	})
	React.useLayoutEffect(function() -- line: 150
		-- upvalues: v16 (copy), v15 (copy)
		if v16.current then
			v16.current.CurrentCamera = v15.current
		end
	end, {})

	local v24 = React.useCallback(function(b1: boolean) -- line: 159
		-- upvalues: v16 (copy)
		local v38 = v16.current and v16.current:FindFirstAncestorOfClass("ScreenGui")
		local v39 = v38 and v38:FindFirstChild("InputWrapper", true)

		if v39 and v39:IsA("Frame") then
			v39.Interactable = b1
		end
	end, {})

	return React.createElement("ViewportFrame", {
		Size = UDim2.fromScale(1, 1),
		LightColor = color3,
		LightDirection = Vector3.new(-1, -1, 2),
		BackgroundTransparency = 1,
		ref = v16,
		[React.Event.InputBegan] = if not v21 then nil else v22.onInputBegan,
		[React.Event.MouseEnter] = function() -- line: 176
			-- upvalues: v24 (copy)
			v24(false)
		end,
		[React.Event.MouseLeave] = function() -- line: 179
			-- upvalues: v24 (copy)
			v24(true)
		end
	}, {
		WorldModel = React.createElement("WorldModel", {
			ref = v14
		}),
		Camera = React.createElement("Camera", {
			FieldOfView = 50,
			CameraType = Enum.CameraType.Scriptable,
			CFrame = v22.cameraCFrame,
			ref = v15
		}),
		LoadingSpinner = v17 and React.createElement(Foundation.Loading, {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}),
		InputChangedConnection = v21 and React.createElement(EventConnection, {
			event = UserInputService.InputChanged,
			callback = v22.onInputChanged
		}),
		InputEndedConnection = v21 and React.createElement(EventConnection, {
			event = UserInputService.InputEnded,
			callback = v22.onInputEnded
		})
	})
end

return React.memo(OutfitViewport)
