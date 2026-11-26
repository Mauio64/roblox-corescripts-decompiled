local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local view = Foundation.View
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/RobloxAppHooks").useLocalUserId
local useSelectedTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/RoactUtils").Hooks.useSelectedTheme
local getDisplayBackgroundId = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Common/BackgroundUtils").getDisplayBackgroundId
local errorTypes = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Analytics").ErrorTypes

local fFlagProfilePlatformNewProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/SharedFlags").FFlagProfilePlatformNewProfileHeader

local fFlagProfilePlatformMeTabMobileProfileHero = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/SharedFlags").FFlagProfilePlatformMeTabMobileProfileHero
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/Promise")
local loadableImage = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/UIBlox").App.Loading.LoadableImage

local function shouldEnableAnimation(): boolean
	return UserInputService.PreferredInput ~= Enum.PreferredInput.Touch
end

local color = Color3.fromRGB(210, 210, 210)
local color2 = Color3.fromRGB(250, 250, 250)
local v5 = fFlagProfilePlatformNewProfileHeader and 6.5 or nil
local v6 = fFlagProfilePlatformNewProfileHeader and 8 or nil
local v7 = fFlagProfilePlatformNewProfileHeader and 70 or nil
local v8 = if fFlagProfilePlatformNewProfileHeader then math.rad(v7 / 2) else nil

local function getCameraDistanceForCharacterHeight(p2, p3)
	return (math.clamp(p2 / (math.tan(v8) * 2) * p3, v5 * p3, v6 * p3))
end

local v9 = fFlagProfilePlatformNewProfileHeader and 2 or nil
local cframe = CFrame.new(Vector3.new(0, 1000, 0))

local fFlagPPVBackgroundUse2DAsLoadingState = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/SharedFlags").FFlagPPVBackgroundUse2DAsLoadingState
local engineFeature = game:DefineFastFlag("PPVBackgroundUnthrottleProfileV2", false)
	and game:GetEngineFeature("IsGetThrottleFramerateEnabledAvailable")
local defineFastFlag = game:DefineFastFlag("PPVBackgroundUnthrottleRefCount", false)
local fFlagPPVEnable3DBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/SharedFlags").FFlagPPVEnable3DBackground
local fFlagProfileInspectAvatarSlideIn = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/SharedFlags").FFlagProfileInspectAvatarSlideIn
local fFlagProfileInspectAvatarShopChip = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/SharedFlags").FFlagProfileInspectAvatarShopChip
local AvatarModelPrefetch = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Common/AvatarModelPrefetch")
local getCharacterAppearanceInfoAsync = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Common/getCharacterAppearanceInfoAsync")

local InsertService = game:GetService("InsertService")

local v10 = 0
local v11 = nil

local function acquireUnthrottle()
	if v10 == 0 then
		v11 = RunService:getThrottleFramerateEnabled()
		RunService:setThrottleFramerateEnabled(false)
	end

	v10 += 1
end

local function releaseUnthrottle()
	v10 -= 1

	if v10 <= 0 then
		v10 = 0
		RunService:setThrottleFramerateEnabled(v11 == true)
		v11 = nil
	end
end

local function playToolAnimation(parent)
	if not parent:IsDescendantOf(game) then
		return
	end

	local animate = parent:FindFirstChild("Animate")
	assert(animate ~= nil, "Expected animate to always exist")

	local toolnone = animate:FindFirstChild("toolnone")
	assert(toolnone ~= nil, "Expected tool animation to always exist")

	local animation = toolnone:GetChildren()[1]

	if animation == nil then
		return
	end

	assert(animation:IsA("Animation"), "Unexpected type for tool animation")

	local humanoid = parent:FindFirstChild("Humanoid")
	assert(humanoid ~= nil, "Expected humanoid to always exist")

	local animator = humanoid:FindFirstChild("Animator")
	assert(animator ~= nil, "Expected Animator to always exist")

	assert(animator:IsA("Animator"), "Animator should be of type Animator")

	local track = animator:LoadAnimation(animation)
	track.Looped = true
	track:Play()
end

local function BackgroundDisplay(props)
	local v12 = useLocalUserId()
	local userId = props.userId or v12 and tonumber(v12)
	local v13 = useSelectedTheme()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local state, setState = React.useState(true)

	local ref5 = if engineFeature then React.useRef(nil) else nil

	if fFlagPPVEnable3DBackground then
		React.useEffect(function()
			task.defer(function()
				if not props.currentBackgroundId then
					return
				end

				local success, result = pcall(function()
					return InsertService:LoadAsset(getDisplayBackgroundId(props.currentBackgroundId, v13))
				end)

				if success and result then
					if ref2.current then
						for i, child in pairs(ref2.current:GetChildren()) do
							if child.Name ~= "Character" then
								child:Destroy()
							end
						end
					end

					local backgroundModel = Instance.new("Model")
					backgroundModel.Name = "BackgroundModel"
					backgroundModel.Parent = ref2.current

					for i, child in pairs(result:GetChildren()) do
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
				if v10 == 0 then
					v11 = RunService:getThrottleFramerateEnabled()
					RunService:setThrottleFramerateEnabled(false)
				end

				v10 += 1

				return releaseUnthrottle
			end

			ref5.current = RunService:getThrottleFramerateEnabled()
			RunService:setThrottleFramerateEnabled(false)
			return function()
				RunService:setThrottleFramerateEnabled(ref5.current or true)
			end
		end, {})
	end

	local v14 = React.useCallback(function(parent, folder)
		if not (parent and folder) then
			return
		end

		local rightHand = parent:FindFirstChild("RightHand")

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

		for i, Script in ipairs(folder:GetDescendants()) do
			if Script:IsA("Script") or Script:IsA("LocalScript") then
				Script.Disabled = true
			end
		end

		folder.Parent = parent

		playToolAnimation(parent)

		handle.CFrame = rightGripAttachment.WorldCFrame
		local weld = Instance.new("Weld")
		weld.Parent = folder
		weld.Part0 = handle
		weld.Part1 = rightHand
		weld.C0 = folder.Grip
		weld.C1 = rightGripAttachment.CFrame
	end, {})

	local v15 = React.useCallback(function(parent, folder)
		if not (parent and folder) then
			return
		end

		local rightArm = parent:FindFirstChild("Right Arm")

		if not (rightArm and rightArm:IsA("BasePart")) then
			return
		end

		local rightGripAttachment = rightArm:FindFirstChild("RightGripAttachment")

		if not (rightGripAttachment and rightGripAttachment:IsA("Attachment")) then
			return
		end

		local rightShoulder = parent:FindFirstChild("Right Shoulder", true)

		if not (rightShoulder and rightShoulder:IsA("Motor6D")) then
			return
		end

		local handle = folder:FindFirstChild("Handle")

		if not (handle and handle:IsA("BasePart")) then
			return
		end

		for i, Script in ipairs(folder:GetDescendants()) do
			if Script:IsA("Script") or Script:IsA("LocalScript") then
				Script.Disabled = true
			end
		end

		folder.Parent = parent
		rightShoulder.C0 *= CFrame.Angles(0, 0, 1.5707963267948966)
		handle.CFrame = rightGripAttachment.WorldCFrame
		local v16 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
		local weld = Instance.new("Weld")
		weld.Parent = folder
		weld.Part0 = handle
		weld.Part1 = rightArm
		weld.C0 = folder.Grip
		weld.C1 = v16
	end, {})

	local useEffect = React.useEffect
	local function fn()
		task.defer(function()
			if not userId then
				return
			end

			setState(true)
			local v16 = Promise.resolve(nil)
			local v17 = Promise.resolve(nil)

			local v18 = AvatarModelPrefetch.get(userId)

			local v19 = Promise.new(function(callback)
				local success, result = pcall(function()
					if fFlagProfileInspectAvatarSlideIn or fFlagProfileInspectAvatarShopChip then
						return getCharacterAppearanceInfoAsync(userId)
					end

					return game.Players:GetCharacterAppearanceInfoAsync(userId)
				end)

				if success and result then
					if result.emotes and #result.emotes > 0 then
						v16 = Promise.new(function(callback2)
							local success2, result2 = pcall(function()
								return InsertService:LoadAsset(result.emotes[1].assetId):FindFirstChildOfClass("Animation")
							end)

							if not success2 then
								result2 = nil
							end

							callback2(result2)
						end)
					end

					local v20 = result.assets
						and Cryo.List.findWhere(result.assets, function(p2): boolean
							return p2.assetType.name == "Gear"
						end)

					if v20 then
						local asset = result.assets[v20]
						v17 = Promise.new(function(callback2)
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

				callback(if success then result else nil)
			end)

			local v20, v21 = Promise.all({
				v18,
				v19:catch(function(): nil
					return nil
				end)
			}):await()

			if v20 then
				local character = v21[1]
				local v22 = v21[2]
				AvatarModelPrefetch.clear(userId)

				character.Name = "Character"
				character.Parent = ref2.current

				if character.PrimaryPart then
					character.PrimaryPart.CFrame = cframe
				end

				ref4.current = character

				if v22 then
					local v23, v24 = v17:await()

					if v24 then
						local playerAvatarType = v22.playerAvatarType

						if playerAvatarType == "R15" then
							v14(character, v24)
						elseif playerAvatarType == "R6" then
							v15(character, v24)
						end
					end
				end

				local humanoid = character:FindFirstChild("Humanoid")

				if humanoid then
					Promise.race({
						Promise.fromEvent(humanoid.ClusterCompositionFinished),
						Promise.delay(3)
					}):await()
				end

				if character.PrimaryPart then
					character.PrimaryPart.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), Vector3.new(0, 0, -10))
					local rightFoot = character:FindFirstChild("RightFoot")
						or character:FindFirstChild("Right Leg")

					if rightFoot and rightFoot:IsA("BasePart") then
						local v23 = rightFoot.Position.Y - rightFoot.Size.Y / 2

						local v24 = character.PrimaryPart.Position.Y + (-3 - v23)

						character.PrimaryPart.CFrame = CFrame.lookAt(
							Vector3.new(0, v24, 0),
							Vector3.new(0, 0, -10)
						)

						if fFlagProfilePlatformNewProfileHeader and ref3.current then
							local boundingBox, v25 = character:GetBoundingBox()
							local v26 = v25.Y + v9
							local y = boundingBox.Position.Y
							local v27

							if fFlagProfilePlatformMeTabMobileProfileHero then
								local cameraDistanceScale = props.cameraDistanceScale or 1
								v27 = math.clamp(
									v26 / (math.tan(v8) * 2) * cameraDistanceScale,
									v5 * cameraDistanceScale,
									v6 * cameraDistanceScale
								)
							else
								v27 = math.clamp(v26 / (math.tan(v8) * 2), v5, v6)
							end

							local vector3 = Vector3.new(0, 0, -v27)
							local vector3_2 = Vector3.new(0, y, 10)
							ref3.current.CFrame = CFrame.lookAt(vector3, vector3_2)
						end
					end
				end

				setState(false)

				if fFlagProfileInspectAvatarSlideIn or fFlagProfileInspectAvatarShopChip then
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

				if engineFeature or UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
					local success, result = pcall(function()
						local v23, v24 = v16:await()

						local animation1 = character:FindFirstChild("Animate"):FindFirstChild("idle"):FindFirstChild("Animation1")
						local animator = character:FindFirstChild("Humanoid"):FindFirstChild("Animator")

						if animation1 and animator and animator:IsA("Animator") then
							local track = animator:LoadAnimation(animation1)

							if v24 then
								local track2 = animator:LoadAnimation(v24)
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
							errorType = errorTypes.CharacterAnimationFailed
						})
					end
				end
			else
				if props.analytics then
					props.analytics.fireAnalyticsEvent("EditProfileBackgroundFailure", {
						errorType = errorTypes.CharacterModelCreationFailed
					})
				end

				setState(false)
			end
		end)
	end
	local v17 = if fFlagProfilePlatformMeTabMobileProfileHero then props.cameraDistanceScale else nil
	useEffect(fn, { userId, v17 })

	React.useEffect(function()
		if ref.current and ref3.current then
			ref.current.CurrentCamera = ref3.current
		end
	end)

	local createElement = React.createElement
	local v19 = {
		Size = UDim2.new(1, 0, 0, props.height),
		ZIndex = 2
	}

	local v20 = {
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
		state = React.createElement(view, { tag = "size-full-full", ZIndex = 2 }, {
			if fFlagPPVBackgroundUse2DAsLoadingState then React.createElement(loadableImage, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, -24),
				Size = UDim2.new(1, -48, 1, -48),
				ScaleType = Enum.ScaleType.Fit,
				BackgroundTransparency = 1,
				Image = props.userThumbnail,
				useShimmerAnimationWhileLoading = true,
				ZIndex = 2
			}) else React.createElement(loading, {
				size = iconSize.Large,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		})
	end

	v20.LoadingFrame = state
	return createElement(view, v19, v20)
end

return BackgroundDisplay
