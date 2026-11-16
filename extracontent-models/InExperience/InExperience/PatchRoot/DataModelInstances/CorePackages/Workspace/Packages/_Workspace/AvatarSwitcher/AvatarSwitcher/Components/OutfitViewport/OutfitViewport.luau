local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("AvatarSwitcher").Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local EventConnection = ReactUtils.EventConnection
local Foundation = require(parent.Foundation)

local OutfitViewportUtils = require(script.Parent.OutfitViewportUtils)
local useOutfitViewportInteractions = require(script.Parent.useOutfitViewportInteractions)

local defineFastFlag = game:DefineFastFlag("AvatarSwitcherPlayRandomEmote", false)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherAccurateAvatarWarning = AvatarExperienceFlags.FFlagAvatarSwitcherAccurateAvatarWarning

local color = Color3.fromRGB(218, 203, 173)

local function OutfitViewport(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local state, setState = React.useState(true)
	local ref4 = React.useRef("")
	local ref5 = React.useRef(0)

	local v = not state
	local v2 = useOutfitViewportInteractions({ defaultCameraDistanceRef = ref5 })

	local v3 = React.useCallback(function(p: number?, p2)
		setState(true)

		if ref.current then
			ref.current:ClearAllChildren()
		end

		if not (p and p2) then
			return
		end

		local guid = HttpService:GenerateGUID(false)
		ref4.current = guid
		local result, v3

		if FFlagAvatarSwitcherAccurateAvatarWarning then
			local success, v4
			success, result, v4 = pcall(function()
				return OutfitViewportUtils.buildOutfitModel(p, p2)
			end)

			if success and result and v4 then
				local humanoid = result:WaitForChild("Humanoid", 10)
				v3 = humanoid and humanoid.RootPart

				if humanoid and v3 then
					if ref4.current == guid then
						if props.onLoaded then
							props.onLoaded(humanoid, v4)
						end
					else
						result:Destroy()
						return
					end
				else
					if props.onLoadingFailed then
						props.onLoadingFailed()
					end

					return
				end
			else
				if props.onLoadingFailed then
					props.onLoadingFailed()
				end

				return
			end
		else
			local success
			success, result = pcall(function()
				return OutfitViewportUtils.buildOutfitModel(p, p2)
			end)

			if success and result then
				v3 = result:WaitForChild("HumanoidRootPart", 10)

				if v3 then
					if ref4.current ~= guid then
						result:Destroy()
						return
					end
				else
					if props.onLoadingFailed then
						props.onLoadingFailed()
					end

					return
				end
			else
				if props.onLoadingFailed then
					props.onLoadingFailed()
				end

				return
			end
		end

		result.Parent = ref.current
		local boundingBox, _ = result:GetBoundingBox()

		v3.CFrame = CFrame.new(v3.CFrame.Position - boundingBox.Position)

		ref5.current = OutfitViewportUtils.getCameraDistance(result, 50)

		if defineFastFlag then
			OutfitViewportUtils.playRandomEmote(result)
		else
			local idleAnimationForAvatar = OutfitViewportUtils.loadIdleAnimationForAvatar(result)

			if idleAnimationForAvatar then
				idleAnimationForAvatar:Play()
			end
		end

		setState(false)
	end, { props.onLoadingFailed })

	React.useEffect(function()
		task.spawn(function()
			v3(props.outfitId, props.rigType)
		end)
	end, { props.outfitId, props.rigType, v3 })

	React.useLayoutEffect(function()
		if ref3.current then
			ref3.current.CurrentCamera = ref2.current
		end
	end, {})

	local v4 = React.useCallback(function(interactable: boolean)
		local screenGui = ref3.current and ref3.current:FindFirstAncestorOfClass("ScreenGui")
		local inputWrapper = screenGui and screenGui:FindFirstChild("InputWrapper", true)

		if inputWrapper and inputWrapper:IsA("Frame") then
			inputWrapper.Interactable = interactable
		end
	end, {})

	local createElement = React.createElement
	local v5 = {
		["Size"] = UDim2.fromScale(1, 1),
		LightColor = color,
		LightDirection = Vector3.new(-1, -1, 2),
		BackgroundTransparency = 1,
		ref = ref3
	}

	local inputBegan = React.Event.InputBegan
	local v6

	if v then
		v6 = v2.onInputBegan
	end

	v5[inputBegan] = v6
	v5[React.Event.MouseEnter] = function()
		v4(false)
	end
	v5[React.Event.MouseLeave] = function()
		v4(true)
	end

	return createElement("ViewportFrame", v5, {
		WorldModel = React.createElement("WorldModel", { ref = ref }),
		Camera = React.createElement("Camera", {
			CameraType = Enum.CameraType.Scriptable,
			CFrame = v2.cameraCFrame,
			FieldOfView = 50,
			ref = ref2
		}),
		LoadingSpinner = state and React.createElement(Foundation.Loading, {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}),
		InputChangedConnection = v and React.createElement(EventConnection, {
			event = UserInputService.InputChanged,
			callback = v2.onInputChanged
		}),
		InputEndedConnection = v and React.createElement(EventConnection, {
			event = UserInputService.InputEnded,
			callback = v2.onInputEnded
		})
	})
end

return React.memo(OutfitViewport)
