local EditProfileBackground = script:FindFirstAncestor("EditProfileBackground")
local EditProfileBackgroundParent = EditProfileBackground.Parent
local React = require(EditProfileBackgroundParent.React)
local Cryo = require(EditProfileBackgroundParent.Cryo)
local Foundation = require(EditProfileBackgroundParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local View = Foundation.View
local useLocalUserId = require(EditProfileBackgroundParent.RobloxAppHooks).useLocalUserId
local useSelectedTheme = require(EditProfileBackgroundParent.RoactUtils).Hooks.useSelectedTheme
local getDisplayBackgroundId = require(EditProfileBackground.Common.BackgroundUtils).getDisplayBackgroundId
local ErrorTypes = require(EditProfileBackground.Analytics).ErrorTypes
local FFlagProfilePlatformNewProfileHeader = require(EditProfileBackgroundParent.SharedFlags).FFlagProfilePlatformNewProfileHeader
local FFlagProfilePlatformMeTabMobileProfileHero = require(EditProfileBackgroundParent.SharedFlags).FFlagProfilePlatformMeTabMobileProfileHero
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Promise = require(EditProfileBackgroundParent.Promise)
local LoadableImage = require(EditProfileBackgroundParent.UIBlox).App.Loading.LoadableImage

local function shouldEnableAnimation() -- line: 28
	-- upvalues: UserInputService (copy)
	return UserInputService.PreferredInput ~= Enum.PreferredInput.Touch
end

local color3 = Color3.fromRGB(210, 210, 210)
local color3_2 = Color3.fromRGB(250, 250, 250)
local v23 = if not FFlagProfilePlatformNewProfileHeader then nil else 6.5
local v24 = if not FFlagProfilePlatformNewProfileHeader then nil else 8
local v25 = if not FFlagProfilePlatformNewProfileHeader then nil else math.rad(((if not FFlagProfilePlatformNewProfileHeader then nil else 70)) / 2)

local function getCameraDistanceForCharacterHeight(n1: number, n2: number) -- line: 48
	-- upvalues: v25 (copy), v23 (copy), v24 (copy)
	return (math.clamp(n1 / (math.tan(v25) * 2) * n2, v23 * n2, v24 * n2))
end

local v27 = if not FFlagProfilePlatformNewProfileHeader then nil else 2
local cFrame = CFrame.new((Vector3.new(0, 1000, 0)))
local FFlagPPVBackgroundUse2DAsLoadingState = require(EditProfileBackgroundParent.SharedFlags).FFlagPPVBackgroundUse2DAsLoadingState
local v30 = game:DefineFastFlag("PPVBackgroundUnthrottleProfileV2", false) and game:GetEngineFeature("IsGetThrottleFramerateEnabledAvailable")
local v31 = game:DefineFastFlag("PPVBackgroundUnthrottleRefCount", false)
local FFlagPPVEnable3DBackground = require(EditProfileBackgroundParent.SharedFlags).FFlagPPVEnable3DBackground
local FFlagPPVBackgroundPrefetchAvatar = require(EditProfileBackgroundParent.SharedFlags).FFlagPPVBackgroundPrefetchAvatar
local v34 = if not FFlagPPVBackgroundPrefetchAvatar then nil else require(EditProfileBackground.Common.AvatarModelPrefetch)
local InsertService = game:GetService("InsertService")
local n3 = 0
local u37 = nil

local function acquireUnthrottle() -- line: 112
	-- upvalues: n3 (ref), u37 (ref), RunService (copy)
	if n3 == 0 then
		u37 = RunService:getThrottleFramerateEnabled()
		RunService:setThrottleFramerateEnabled(false)
	end

	n3 += 1
end
local function releaseUnthrottle() -- line: 120
	-- upvalues: n3 (ref), RunService (copy), u37 (ref)
	n3 -= 1

	if n3 <= 0 then
		n3 = 0
		RunService:setThrottleFramerateEnabled(u37 == true)
		u37 = nil
	end
end
local function playToolAnimation(p1) -- line: 138
	if not p1:IsDescendantOf(game) then
		return
	end

	local Animate = p1:FindFirstChild("Animate")

	assert(Animate ~= nil, "Expected animate to always exist")

	local toolnone = Animate:FindFirstChild("toolnone")

	assert(toolnone ~= nil, "Expected tool animation to always exist")

	local v47 = toolnone:GetChildren()[1]

	if v47 == nil then
		return
	end

	assert(v47:IsA("Animation"), "Unexpected type for tool animation")

	local Humanoid = p1:FindFirstChild("Humanoid")

	assert(Humanoid ~= nil, "Expected humanoid to always exist")

	local Animator = Humanoid:FindFirstChild("Animator")

	assert(Animator ~= nil, "Expected Animator to always exist")
	assert(Animator:IsA("Animator"), "Animator should be of type Animator")

	local track = Animator:LoadAnimation(v47)

	track.Looped = true
	track:Play()
end
local function BackgroundDisplay(t1: {[any]: any}) -- line: 169
	-- upvalues: useLocalUserId (copy), useSelectedTheme (copy), React (copy), v30 (copy), FFlagPPVEnable3DBackground (copy), InsertService (copy), getDisplayBackgroundId (copy), color3 (copy), color3_2 (copy), v31 (copy), n3 (ref), u37 (ref), RunService (copy), releaseUnthrottle (copy), playToolAnimation (copy), Promise (copy), FFlagPPVBackgroundPrefetchAvatar (copy), v34 (copy), Players (copy), Cryo (copy), ErrorTypes (copy), cFrame (copy), FFlagProfilePlatformNewProfileHeader (copy), v27 (copy), FFlagProfilePlatformMeTabMobileProfileHero (copy), v25 (copy), v23 (copy), v24 (copy), UserInputService (copy), View (copy), FFlagPPVBackgroundUse2DAsLoadingState (copy), LoadableImage (copy), Loading (copy), IconSize (copy)
	local v52 = useLocalUserId()
	local v53 = t1.userId or v52 and tonumber(v52)
	local v54 = useSelectedTheme()
	local v55 = React.useRef(nil)
	local v56 = React.useRef(nil)
	local v57 = React.useRef(nil)
	local v58 = React.useRef(nil)
	local v59, v60 = React.useState(true)
	local v61 = if not v30 then nil else React.useRef(nil)

	if FFlagPPVEnable3DBackground then
		React.useEffect(function() -- line: 183
			-- upvalues: t1 (copy), InsertService (copy), getDisplayBackgroundId (copy), v54 (copy), v56 (copy), v55 (copy), color3 (copy), color3_2 (copy)
			task.defer(function() -- line: 185
				-- upvalues: t1 (copy), InsertService (copy), getDisplayBackgroundId (copy), v54 (copy), v56 (copy), v55 (copy), color3 (copy), color3_2 (copy)
				if not t1.currentBackgroundId then
					return
				end

				local ok, result = pcall(function() -- line: 190
					-- upvalues: InsertService (copy), getDisplayBackgroundId (copy), t1 (copy), v54 (copy)
					return InsertService:LoadAsset(getDisplayBackgroundId(t1.currentBackgroundId, v54))
				end)

				if ok and result then
					if v56.current then
						for _, child in pairs(v56.current:GetChildren()) do
							if child.Name ~= "Character" then
								child:Destroy()
							end
						end
					end

					local Model = Instance.new("Model")

					Model.Name = "BackgroundModel"
					Model.Parent = v56.current

					for _, child in pairs(result:GetChildren()) do
						child.Parent = Model
					end

					Model:PivotTo(CFrame.new(0, 7, -4.5))
					result:Destroy()

					local current = v55.current

					if current then
						current.Ambient = color3
						current.LightColor = color3_2
						current.LightDirection = Vector3.new(-0.5, 0.20000000298023224, 0.20000000298023224)
					end
				end
			end)
		end, { t1.currentBackgroundId })
	end

	if v30 then
		React.useEffect(function() -- line: 227
			-- upvalues: v31 (copy), n3 (ref), u37 (ref), RunService (copy), releaseUnthrottle (copy), v61 (copy)
			if v31 then
				if n3 == 0 then
					u37 = RunService:getThrottleFramerateEnabled()
					RunService:setThrottleFramerateEnabled(false)
				end

				n3 += 1

				return releaseUnthrottle
			end

			v61.current = RunService:getThrottleFramerateEnabled()
			RunService:setThrottleFramerateEnabled(false)

			return function() -- line: 235
				-- upvalues: RunService (copy), v61 (copy)
				RunService:setThrottleFramerateEnabled(v61.current or true)
			end
		end, {})
	end

	local v62 = React.useCallback(function(p2, p3) -- line: 242
		-- upvalues: playToolAnimation (copy)
		if not p2 or not p3 then
			return
		end

		local RightHand = p2:FindFirstChild("RightHand")

		if not RightHand or not RightHand:IsA("BasePart") then
			return
		end

		local RightGripAttachment = RightHand:FindFirstChild("RightGripAttachment")

		if not RightGripAttachment or not RightGripAttachment:IsA("Attachment") then
			return
		end

		local Handle = p3:FindFirstChild("Handle")

		if not Handle or not Handle:IsA("BasePart") then
			return
		end

		for _, descendant in ipairs(p3:GetDescendants()) do
			if descendant:IsA("Script") or descendant:IsA("LocalScript") then
				descendant.Disabled = true
			end
		end

		p3.Parent = p2
		playToolAnimation(p2)
		Handle.CFrame = RightGripAttachment.WorldCFrame

		local Weld = Instance.new("Weld")

		Weld.Parent = p3
		Weld.Part0 = Handle
		Weld.Part1 = RightHand
		Weld.C0 = p3.Grip
		Weld.C1 = RightGripAttachment.CFrame
	end, {})
	local v63 = React.useCallback(function(p4, p5) -- line: 279
		if not p4 or not p5 then
			return
		end

		local v74 = p4:FindFirstChild("Right Arm")

		if not v74 or not v74:IsA("BasePart") then
			return
		end

		local RightGripAttachment = v74:FindFirstChild("RightGripAttachment")

		if not RightGripAttachment or not RightGripAttachment:IsA("Attachment") then
			return
		end

		local v76 = p4:FindFirstChild("Right Shoulder", true)

		if not v76 or not v76:IsA("Motor6D") then
			return
		end

		local Handle = p5:FindFirstChild("Handle")

		if not Handle or not Handle:IsA("BasePart") then
			return
		end

		for _, descendant in ipairs(p5:GetDescendants()) do
			if descendant:IsA("Script") or descendant:IsA("LocalScript") then
				descendant.Disabled = true
			end
		end

		p5.Parent = p4
		v76.C0 = v76.C0 * CFrame.Angles(0, 0, 1.5707963267948966)
		Handle.CFrame = RightGripAttachment.WorldCFrame

		local v80 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
		local Weld = Instance.new("Weld")

		Weld.Parent = p5
		Weld.Part0 = Handle
		Weld.Part1 = v74
		Weld.C0 = p5.Grip
		Weld.C1 = v80
	end, {})

	React.useEffect(function() -- line: 316
		-- upvalues: v53 (copy), v60 (copy), Promise (copy), FFlagPPVBackgroundPrefetchAvatar (copy), v34 (copy), Players (copy), InsertService (copy), Cryo (copy), t1 (copy), ErrorTypes (copy), v56 (copy), cFrame (copy), v58 (copy), v62 (copy), v63 (copy), FFlagProfilePlatformNewProfileHeader (copy), v57 (copy), v27 (copy), FFlagProfilePlatformMeTabMobileProfileHero (copy), v25 (copy), v23 (copy), v24 (copy), v30 (copy), UserInputService (copy)
		task.defer(function() -- line: 318
			-- upvalues: v53 (copy), v60 (copy), Promise (copy), FFlagPPVBackgroundPrefetchAvatar (copy), v34 (copy), Players (copy), InsertService (copy), Cryo (copy), t1 (copy), ErrorTypes (copy), v56 (copy), cFrame (copy), v58 (copy), v62 (copy), v63 (copy), FFlagProfilePlatformNewProfileHeader (copy), v57 (copy), v27 (copy), FFlagProfilePlatformMeTabMobileProfileHero (copy), v25 (copy), v23 (copy), v24 (copy), v30 (copy), UserInputService (copy)
			if not v53 then
				return
			end

			v60(true)

			local u90 = Promise.resolve(nil)
			local u91 = Promise.resolve(nil)
			local v92 = if not FFlagPPVBackgroundPrefetchAvatar then Promise.new(function(resolve, reject) -- line: 329
				-- upvalues: Players (copy), v53 (copy)
				local ok, result = pcall(function() -- line: 330
					-- upvalues: Players (copy), v53 (copy)
					if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
						return Players:CreateHumanoidModelFromUserIdAsync(v53)
					end

					return game.Players:CreateHumanoidModelFromUserId(v53)
				end)

				if ok and result then
					resolve(result)

					return
				end

				reject("CharacterModelCreationFailed")
			end) else v34.get(v53)
			local v93 = Promise.new(function(resolve) -- line: 344
				-- upvalues: v53 (copy), u90 (ref), Promise (copy), InsertService (copy), Cryo (copy), u91 (ref)
				local ok, result = pcall(function() -- line: 345
					-- upvalues: v53 (copy)
					return game.Players:GetCharacterAppearanceInfoAsync(v53)
				end)

				if ok and result then
					if result.emotes and #result.emotes > 0 then
						u90 = Promise.new(function(resolve2) -- line: 350
							-- upvalues: InsertService (copy), result (copy)
							local ok2, result2 = pcall(function() -- line: 351
								-- upvalues: InsertService (copy), result (copy)
								return (InsertService:LoadAsset(result.emotes[1].assetId):FindFirstChildOfClass("Animation"))
							end)

							resolve2(if not ok2 then nil else result2)
						end)
					end

					if result.assets then
						local v122 = Cryo.List.findWhere(result.assets, function(p6) -- line: 360
							return p6.assetType.name == "Gear"
						end)

						if v122 then
							local v123 = result.assets[v122]

							u91 = Promise.new(function(resolve3) -- line: 365
								-- upvalues: InsertService (copy), v123 (copy)
								local ok3, result3 = pcall(function() -- line: 366
									-- upvalues: InsertService (copy), v123 (copy)
									return InsertService:LoadAsset(v123.id):FindFirstChildOfClass("Tool")
								end)

								resolve3(if not ok3 or (not result3 or not result3:IsA("Tool")) then nil else result3)
							end)
						end
					end
				end

				resolve(if not ok then nil else result)
			end)
			local v94, v95 = Promise.all({
				v92,
				v93:catch(function() -- line: 385
					return nil
				end)
			}):await()

			if not v94 then
				if t1.analytics then
					t1.analytics.fireAnalyticsEvent("EditProfileBackgroundFailure", {
						errorType = ErrorTypes.CharacterModelCreationFailed
					})
				end

				v60(false)

				return
			end

			local v96 = v95[1]
			local v97 = v95[2]

			if FFlagPPVBackgroundPrefetchAvatar then
				v34.clear(v53)
			end

			v96.Name = "Character"
			v96.Parent = v56.current

			if v96.PrimaryPart then
				v96.PrimaryPart.CFrame = cFrame
			end

			v58.current = v96

			if v97 then
				local _, v99 = u91:await()

				if v99 then
					local playerAvatarType = v97.playerAvatarType

					if playerAvatarType == "R15" then
						v62(v96, v99)
					elseif playerAvatarType == "R6" then
						v63(v96, v99)
					end
				end
			end

			local Humanoid = v96:FindFirstChild("Humanoid")

			if Humanoid then
				Promise.race({
					Promise.fromEvent(Humanoid.ClusterCompositionFinished),
					Promise.delay(3)
				}):await()
			end

			if v96.PrimaryPart then
				v96.PrimaryPart.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), (Vector3.new(0, 0, -10)))

				local v102 = v96:FindFirstChild("RightFoot") or v96:FindFirstChild("Right Leg")

				if v102 and v102:IsA("BasePart") then
					local v103 = v102.Position.Y - v102.Size.Y / 2
					local v104 = v96.PrimaryPart.Position.Y + (-3 - v103)

					v96.PrimaryPart.CFrame = CFrame.lookAt(Vector3.new(0, v104, 0), (Vector3.new(0, 0, -10)))

					if FFlagProfilePlatformNewProfileHeader and v57.current then
						local v105, v106 = v96:GetBoundingBox()
						local v107 = v106.Y + v27
						local PositionY = v105.Position.Y
						local v110

						if FFlagProfilePlatformMeTabMobileProfileHero then
							local v109 = t1.cameraDistanceScale or 1

							v110 = math.clamp(v107 / (math.tan(v25) * 2) * v109, v23 * v109, v24 * v109)
						else
							v110 = math.clamp(v107 / (math.tan(v25) * 2), v23, v24)
						end

						local vector3 = Vector3.new(0, 0, -v110)
						local vector3_2 = Vector3.new(0, PositionY, 10)

						v57.current.CFrame = CFrame.lookAt(vector3, vector3_2)
					end
				end
			end

			v60(false)

			if v30 or UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
				local ok, _ = pcall(function() -- line: 477
					-- upvalues: u90 (ref), v96 (copy)
					local _, v125 = u90:await()
					local Animation1 = v96:FindFirstChild("Animate"):FindFirstChild("idle"):FindFirstChild("Animation1")
					local Animator = v96:FindFirstChild("Humanoid"):FindFirstChild("Animator")

					if Animation1 and (Animator and Animator:IsA("Animator")) then
						local track = Animator:LoadAnimation(Animation1)

						if v125 then
							local track2 = Animator:LoadAnimation(v125)

							track2.Looped = false
							track2:Play()
							track2.Stopped:Connect(function() -- line: 492
								-- upvalues: track (copy)
								track:Play()
							end)

							return
						end

						track:Play()
					end
				end)

				if not ok and t1.analytics then
					t1.analytics.fireAnalyticsEvent("EditProfileBackgroundFailure", {
						errorType = ErrorTypes.CharacterAnimationFailed
					})
				end
			end
		end)
	end, {
		v53,
		if not FFlagProfilePlatformMeTabMobileProfileHero then nil else t1.cameraDistanceScale
	})
	React.useEffect(function() -- line: 513
		-- upvalues: v55 (copy), v57 (copy)
		if v55.current and v57.current then
			v55.current.CurrentCamera = v57.current
		end
	end)

	return React.createElement(View, {
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, t1.height)
	}, {
		Background = React.createElement("ViewportFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ref = v55,
			Ambient = color3,
			LightColor = color3_2
		}, {
			WorldModel = React.createElement("WorldModel", {
				ref = v56
			}),
			Camera = React.createElement("Camera", {
				CameraType = Enum.CameraType.Scriptable,
				CFrame = CFrame.lookAt(Vector3.new(0, 0, -8), (Vector3.new(0, 1, 10))),
				ref = v57
			})
		}),
		LoadingFrame = v59 and React.createElement(View, {
			tag = "size-full-full",
			ZIndex = 2
		}, { if not FFlagPPVBackgroundUse2DAsLoadingState then React.createElement(Loading, {
			size = IconSize.Large,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}) else React.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, -24),
			Size = UDim2.new(1, -48, 1, -48),
			ScaleType = Enum.ScaleType.Fit,
			Image = t1.userThumbnail
		}) })
	})
end

return BackgroundDisplay
