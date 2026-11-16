local EditProfileBackground = script:FindFirstAncestor("EditProfileBackground")
local parent = EditProfileBackground.Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local View = Foundation.View
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local RoactUtils = require(parent.RoactUtils)
local useSelectedTheme = RoactUtils.Hooks.useSelectedTheme
local BackgroundUtils = require(EditProfileBackground.Common.BackgroundUtils)
local getDisplayBackgroundId = BackgroundUtils.getDisplayBackgroundId
local Analytics = require(EditProfileBackground.Analytics)
local ErrorTypes = Analytics.ErrorTypes

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader

local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfilePlatformMeTabMobileProfileHero = SharedFlags2.FFlagProfilePlatformMeTabMobileProfileHero
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Promise = require(parent.Promise)
local UIBlox = require(parent.UIBlox)
local LoadableImage = UIBlox.App.Loading.LoadableImage

local function shouldEnableAnimation(): boolean -- 1 equivalent call inferred from this helper
	return UserInputService.PreferredInput ~= Enum.PreferredInput.Touch
end

local color = Color3.fromRGB(210, 210, 210)
local color2 = Color3.fromRGB(250, 250, 250)
local v = FFlagProfilePlatformNewProfileHeader and 6.5 or nil
local v2 = FFlagProfilePlatformNewProfileHeader and 8 or nil
local v3 = FFlagProfilePlatformNewProfileHeader and 70 or nil
local v4

if FFlagProfilePlatformNewProfileHeader then
	v4 = math.rad(v3 / 2)
else
	v4 = nil
end

local function getCameraDistanceForCharacterHeight(p: number, cameraDistanceScale: number) -- 1 equivalent call inferred from this helper
	return (math.clamp(p / (math.tan(v4) * 2) * cameraDistanceScale, v * cameraDistanceScale, v2 * cameraDistanceScale))
end

local v5 = FFlagProfilePlatformNewProfileHeader and 2 or nil
local cframe = CFrame.new(Vector3.new(0, 1000, 0))

local SharedFlags3 = require(parent.SharedFlags)
local FFlagPPVBackgroundUse2DAsLoadingState = SharedFlags3.FFlagPPVBackgroundUse2DAsLoadingState
local engineFeature = game:DefineFastFlag("PPVBackgroundUnthrottleProfileV2", false)
	and game:GetEngineFeature("IsGetThrottleFramerateEnabledAvailable")
local defineFastFlag = game:DefineFastFlag("PPVBackgroundUnthrottleRefCount", false)
local SharedFlags4 = require(parent.SharedFlags)
local FFlagPPVEnable3DBackground = SharedFlags4.FFlagPPVEnable3DBackground
local SharedFlags5 = require(parent.SharedFlags)
local FFlagProfileInspectAvatarSlideIn = SharedFlags5.FFlagProfileInspectAvatarSlideIn
local SharedFlags6 = require(parent.SharedFlags)
local FFlagProfileInspectAvatarShopChip = SharedFlags6.FFlagProfileInspectAvatarShopChip
local AvatarModelPrefetch = require(EditProfileBackground.Common.AvatarModelPrefetch)
local getCharacterAppearanceInfoAsync = require(EditProfileBackground.Common.getCharacterAppearanceInfoAsync)

local InsertService = game:GetService("InsertService")

local v6 = 0
local v7 = nil

local function acquireUnthrottle() -- 1 equivalent call inferred from this helper
	if v6 == 0 then
		v7 = RunService:getThrottleFramerateEnabled()
		RunService:setThrottleFramerateEnabled(false)
	end

	v6 += 1
end

local function releaseUnthrottle()
	v6 -= 1

	if v6 <= 0 then
		v6 = 0
		RunService:setThrottleFramerateEnabled(v7 == true)
		v7 = nil
	end
end

local function playToolAnimation(parent2)
	if not parent2:IsDescendantOf(game) then
		return
	end

	local animate = parent2:FindFirstChild("Animate")
	assert(animate ~= nil, "Expected animate to always exist")

	local toolnone = animate:FindFirstChild("toolnone")
	assert(toolnone ~= nil, "Expected tool animation to always exist")

	local animation = toolnone:GetChildren()[1]

	if animation == nil then
		return
	end

	assert(animation:IsA("Animation"), "Unexpected type for tool animation")

	local humanoid = parent2:FindFirstChild("Humanoid")
	assert(humanoid ~= nil, "Expected humanoid to always exist")

	local animator = humanoid:FindFirstChild("Animator")
	assert(animator ~= nil, "Expected Animator to always exist")

	assert(animator:IsA("Animator"), "Animator should be of type Animator")

	local track = animator:LoadAnimation(animation)
	track.Looped = true
	track:Play()
end

local function BackgroundDisplay(props)
	local v8 = useLocalUserId()
	local userId = props.userId or v8 and tonumber(v8)
	local v9 = useSelectedTheme()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local state, setState = React.useState(true)
	local ref5

	if engineFeature then
		ref5 = React.useRef(nil)
	else
		ref5 = nil
	end

	if FFlagPPVEnable3DBackground then
		React.useEffect(function()
			task.defer(function()
				if not props.currentBackgroundId then
					return
				end

				local success, result = pcall(function()
					return InsertService:LoadAsset(getDisplayBackgroundId(props.currentBackgroundId, v9))
				end)

				if success and result then
					if ref2.current then
						for _, child in pairs(ref2.current:GetChildren()) do
							if child.Name ~= "Character" then
								child:Destroy()
							end
						end
					end

					local backgroundModel = Instance.new("Model")
					backgroundModel.Name = "BackgroundModel"
					backgroundModel.Parent = ref2.current

					for _, child in pairs(result:GetChildren()) do
						child.Parent = backgroundModel
					end

					backgroundModel:PivotTo(CFrame.new(0, 7, -4.5))
					result:Destroy()

					local current = ref.current

					if current then
						current.Ambient = color
						current.LightColor = color2
						current.LightDirection = Vector3.new(-0.5, 0.2, 0.2)
					end
				end
			end)
		end, { props.currentBackgroundId })
	end

	if engineFeature then
		React.useEffect(function()
			if defineFastFlag then
				acquireUnthrottle() -- inferred equivalent call
				return releaseUnthrottle
			end

			ref5.current = RunService:getThrottleFramerateEnabled()
			RunService:setThrottleFramerateEnabled(false)
			return function()
				RunService:setThrottleFramerateEnabled(ref5.current or true)
			end
		end, {})
	end

	local v10 = React.useCallback(function(parent2, folder)
		if not (parent2 and folder) then
			return
		end

		local rightHand = parent2:FindFirstChild("RightHand")

		if not (rightHand and rightHand:IsA("BasePart")) then
			return
		end

		local rightGripAttachment = rightHand:FindFirstChild("RightGripAttachment")

		if not (rightGripAttachment and rightGripAttachment:IsA("Attachment")) then
			return
		end

		local handle = folder:FindFirstChild("Handle")

		if not (handle and handle:IsA("BasePart")) then
			return
		end

		for _, Script in ipairs(folder:GetDescendants()) do
			if Script:IsA("Script") or Script:IsA("LocalScript") then
				Script.Disabled = true
			end
		end

		folder.Parent = parent2

		playToolAnimation(parent2)

		handle.CFrame = rightGripAttachment.WorldCFrame
		local weld = Instance.new("Weld")
		weld.Parent = folder
		weld.Part0 = handle
		weld.Part1 = rightHand
		weld.C0 = folder.Grip
		weld.C1 = rightGripAttachment.CFrame
	end, {})

	local v11 = React.useCallback(function(parent2, folder)
		if not (parent2 and folder) then
			return
		end

		local rightArm = parent2:FindFirstChild("Right Arm")

		if not (rightArm and rightArm:IsA("BasePart")) then
			return
		end

		local rightGripAttachment = rightArm:FindFirstChild("RightGripAttachment")

		if not (rightGripAttachment and rightGripAttachment:IsA("Attachment")) then
			return
		end

		local rightShoulder = parent2:FindFirstChild("Right Shoulder", true)

		if not (rightShoulder and rightShoulder:IsA("Motor6D")) then
			return
		end

		local handle = folder:FindFirstChild("Handle")

		if not (handle and handle:IsA("BasePart")) then
			return
		end

		for _, Script in ipairs(folder:GetDescendants()) do
			if Script:IsA("Script") or Script:IsA("LocalScript") then
				Script.Disabled = true
			end
		end

		folder.Parent = parent2
		rightShoulder.C0 *= CFrame.Angles(0, 0, 1.5707963267948966)
		handle.CFrame = rightGripAttachment.WorldCFrame
		local c1 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
		local weld = Instance.new("Weld")
		weld.Parent = folder
		weld.Part0 = handle
		weld.Part1 = rightArm
		weld.C0 = folder.Grip
		weld.C1 = c1
	end, {})

	local useEffect = React.useEffect
	local function fn()
		task.defer(function()
			if not userId then
				return
			end

			setState(true)
			local v12 = Promise.resolve(nil)
			local v13 = Promise.resolve(nil)

			local v14 = AvatarModelPrefetch.get(userId)

			local v15 = Promise.new(function(callback)
				local success, result = pcall(function()
					if FFlagProfileInspectAvatarSlideIn or FFlagProfileInspectAvatarShopChip then
						return getCharacterAppearanceInfoAsync(userId)
					end

					return game.Players:GetCharacterAppearanceInfoAsync(userId)
				end)

				if success and result then
					if result.emotes and #result.emotes > 0 then
						v12 = Promise.new(function(callback2)
							local success2, result2 = pcall(function()
								return (InsertService:LoadAsset(result.emotes[1].assetId):FindFirstChildOfClass("Animation"))
							end)

							if not success2 then
								result2 = nil
							end

							callback2(result2)
						end)
					end

					local v15 = result.assets and Cryo.List.findWhere(result.assets, function(p): boolean
						return p.assetType.name == "Gear"
					end)

					if v15 then
						local asset = result.assets[v15]
						v13 = Promise.new(function(callback2)
							local success2, result2 = pcall(function()
								return InsertService:LoadAsset(asset.id):FindFirstChildOfClass("Tool")
							end)

							if not (success2 and result2 and result2:IsA("Tool")) then
								result2 = nil
							end

							callback2(result2)
						end)
					end
				end

				local v15

				if success then
					v15 = result
				end

				callback(v15)
			end)

			local v16, v17 = Promise.all({
				v14,
				v15:catch(function(): nil
					return nil
				end)
			}):await()

			if v16 then
				local character = v17[1]
				local v18 = v17[2]
				AvatarModelPrefetch.clear(userId)

				character.Name = "Character"
				character.Parent = ref2.current

				if character.PrimaryPart then
					character.PrimaryPart.CFrame = cframe
				end

				ref4.current = character

				if v18 then
					local _, v19 = v13:await()

					if v19 then
						local playerAvatarType = v18.playerAvatarType

						if playerAvatarType == "R15" then
							v10(character, v19)
						elseif playerAvatarType == "R6" then
							v11(character, v19)
						end
					end
				end

				local humanoid = character:FindFirstChild("Humanoid")

				if humanoid then
					Promise.race({ Promise.fromEvent(humanoid.ClusterCompositionFinished), Promise.delay(3) }):await()
				end

				if character.PrimaryPart then
					character.PrimaryPart.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), Vector3.new(0, 0, -10))
					local rightFoot = character:FindFirstChild("RightFoot") or character:FindFirstChild("Right Leg")

					if rightFoot and rightFoot:IsA("BasePart") then
						local v19 = rightFoot.Position.Y - rightFoot.Size.Y / 2

						local v20 = character.PrimaryPart.Position.Y + (-3 - v19)

						character.PrimaryPart.CFrame = CFrame.lookAt(Vector3.new(0, v20, 0), Vector3.new(0, 0, -10))

						if FFlagProfilePlatformNewProfileHeader and ref3.current then
							local boundingBox, v21 = character:GetBoundingBox()
							local v22 = v21.Y + v5
							local y = boundingBox.Position.Y
							local v23

							if FFlagProfilePlatformMeTabMobileProfileHero then
								v23 = getCameraDistanceForCharacterHeight(v22, props.cameraDistanceScale or 1) -- inferred equivalent call
							else
								v23 = math.clamp(v22 / (math.tan(v4) * 2), v, v2)
							end

							local vector3 = Vector3.new(0, 0, -v23)
							local vector3_2 = Vector3.new(0, y, 10)
							ref3.current.CFrame = CFrame.lookAt(vector3, vector3_2)
						end
					end
				end

				setState(false)

				if FFlagProfileInspectAvatarSlideIn or FFlagProfileInspectAvatarShopChip then
					local onSceneReady = props.onSceneReady

					if onSceneReady and ref3.current and ref.current and ref2.current then
						onSceneReady({
							character = character,
							camera = ref3.current,
							viewportFrame = ref.current,
							worldModel = ref2.current
						})
					end
				end

				if engineFeature or shouldEnableAnimation() then -- inferred equivalent call
					local success, _ = pcall(function()
						local _, v19 = v12:await()

						local animation1 = character:FindFirstChild("Animate"):FindFirstChild("idle"):FindFirstChild("Animation1")
						local animator = character:FindFirstChild("Humanoid"):FindFirstChild("Animator")

						if animation1 and animator and animator:IsA("Animator") then
							local track = animator:LoadAnimation(animation1)

							if v19 then
								local track2 = animator:LoadAnimation(v19)
								track2.Looped = false
								track2:Play()
								track2.Stopped:Connect(function()
									track:Play()
								end)
							else
								track:Play()
							end
						end
					end)

					if not success and props.analytics then
						props.analytics.fireAnalyticsEvent("EditProfileBackgroundFailure", {
							errorType = ErrorTypes.CharacterAnimationFailed
						})
					end
				end
			else
				if props.analytics then
					props.analytics.fireAnalyticsEvent("EditProfileBackgroundFailure", {
						errorType = ErrorTypes.CharacterModelCreationFailed
					})
				end

				setState(false)
			end
		end)
	end

	local v12

	if FFlagProfilePlatformMeTabMobileProfileHero then
		v12 = props.cameraDistanceScale
	end

	useEffect(fn, { userId, v12 })

	React.useEffect(function()
		if ref.current and ref3.current then
			ref.current.CurrentCamera = ref3.current
		end
	end)

	local createElement = React.createElement
	local v13 = {
		Size = UDim2.new(1, 0, 0, props.height),
		ZIndex = 2
	}

	local v14 = {
		Background = React.createElement("ViewportFrame", {
			Size = UDim2.fromScale(1, 1),
			ref = ref,
			Ambient = color,
			LightColor = color2,
			BackgroundTransparency = 1
		}, {
			WorldModel = React.createElement("WorldModel", { ref = ref2 }),
			Camera = React.createElement("Camera", {
				CameraType = Enum.CameraType.Scriptable,
				CFrame = CFrame.lookAt(Vector3.new(0, 0, -8), Vector3.new(0, 1, 10)),
				ref = ref3
			})
		}),
		LoadingFrame = 0
	}

	if state then
		local createElement2 = React.createElement
		local v15

		if FFlagPPVBackgroundUse2DAsLoadingState then
			v15 = React.createElement(LoadableImage, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, -24),
				Size = UDim2.new(1, -48, 1, -48),
				ScaleType = Enum.ScaleType.Fit,
				BackgroundTransparency = 1,
				Image = props.userThumbnail,
				useShimmerAnimationWhileLoading = true,
				ZIndex = 2
			})
		else
			v15 = React.createElement(Loading, {
				size = IconSize.Large,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		end

		state = createElement2(View, { tag = "size-full-full", ZIndex = 2 }, { v15 })
	end

	v14.LoadingFrame = state
	return createElement(View, v13, v14)
end

return BackgroundDisplay
