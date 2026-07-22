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
local RunService = game:GetService("RunService")
local Promise = require(EditProfileBackgroundParent.Promise)
local LoadableImage = require(EditProfileBackgroundParent.UIBlox).App.Loading.LoadableImage

local function shouldEnableAnimation() -- line: 27
	-- upvalues: UserInputService (copy)
	return UserInputService.PreferredInput ~= Enum.PreferredInput.Touch
end

local color3 = Color3.fromRGB(210, 210, 210)
local color3_2 = Color3.fromRGB(250, 250, 250)
local v22 = if not FFlagProfilePlatformNewProfileHeader then nil else 6.5
local v23 = if not FFlagProfilePlatformNewProfileHeader then nil else 8
local v24 = if not FFlagProfilePlatformNewProfileHeader then nil else math.rad(((if not FFlagProfilePlatformNewProfileHeader then nil else 70)) / 2)

local function getCameraDistanceForCharacterHeight(n1: number, n2: number) -- line: 47
	-- upvalues: v24 (copy), v22 (copy), v23 (copy)
	return (math.clamp(n1 / (math.tan(v24) * 2) * n2, v22 * n2, v23 * n2))
end

local v26 = if not FFlagProfilePlatformNewProfileHeader then nil else 2
local cFrame = CFrame.new((Vector3.new(0, 1000, 0)))
local FFlagPPVBackgroundUse2DAsLoadingState = require(EditProfileBackgroundParent.SharedFlags).FFlagPPVBackgroundUse2DAsLoadingState
local v29 = game:DefineFastFlag("PPVBackgroundUnthrottleProfileV2", false) and game:GetEngineFeature("IsGetThrottleFramerateEnabledAvailable")
local v30 = game:DefineFastFlag("PPVBackgroundUnthrottleRefCount", false)
local FFlagPPVEnable3DBackground = require(EditProfileBackgroundParent.SharedFlags).FFlagPPVEnable3DBackground
local AvatarModelPrefetch = require(EditProfileBackground.Common.AvatarModelPrefetch)
local InsertService = game:GetService("InsertService")
local n3 = 0
local u35 = nil

local function acquireUnthrottle() -- line: 108
	-- upvalues: n3 (ref), u35 (ref), RunService (copy)
	if n3 == 0 then
		u35 = RunService:getThrottleFramerateEnabled()
		RunService:setThrottleFramerateEnabled(false)
	end

	n3 += 1
end
local function releaseUnthrottle() -- line: 116
	-- upvalues: n3 (ref), RunService (copy), u35 (ref)
	n3 -= 1

	if n3 <= 0 then
		n3 = 0
		RunService:setThrottleFramerateEnabled(u35 == true)
		u35 = nil
	end
end
local function playToolAnimation(p1) -- line: 134
	if not p1:IsDescendantOf(game) then
		return
	end

	local Animate = p1:FindFirstChild("Animate")

	assert(Animate ~= nil, "Expected animate to always exist")

	local toolnone = Animate:FindFirstChild("toolnone")

	assert(toolnone ~= nil, "Expected tool animation to always exist")

	local v45 = toolnone:GetChildren()[1]

	if v45 == nil then
		return
	end

	assert(v45:IsA("Animation"), "Unexpected type for tool animation")

	local Humanoid = p1:FindFirstChild("Humanoid")

	assert(Humanoid ~= nil, "Expected humanoid to always exist")

	local Animator = Humanoid:FindFirstChild("Animator")

	assert(Animator ~= nil, "Expected Animator to always exist")
	assert(Animator:IsA("Animator"), "Animator should be of type Animator")

	local track = Animator:LoadAnimation(v45)

	track.Looped = true
	track:Play()
end
local function BackgroundDisplay(t1: {[any]: any}) -- line: 165
	-- upvalues: useLocalUserId (copy), useSelectedTheme (copy), React (copy), v29 (copy), FFlagPPVEnable3DBackground (copy), InsertService (copy), getDisplayBackgroundId (copy), color3 (copy), color3_2 (copy), v30 (copy), n3 (ref), u35 (ref), RunService (copy), releaseUnthrottle (copy), playToolAnimation (copy), Promise (copy), AvatarModelPrefetch (copy), Cryo (copy), ErrorTypes (copy), cFrame (copy), FFlagProfilePlatformNewProfileHeader (copy), v26 (copy), FFlagProfilePlatformMeTabMobileProfileHero (copy), v24 (copy), v22 (copy), v23 (copy), UserInputService (copy), View (copy), FFlagPPVBackgroundUse2DAsLoadingState (copy), LoadableImage (copy), Loading (copy), IconSize (copy)
	local v50 = useLocalUserId()
	local v51 = t1.userId or v50 and tonumber(v50)
	local v52 = useSelectedTheme()
	local v53 = React.useRef(nil)
	local v54 = React.useRef(nil)
	local v55 = React.useRef(nil)
	local v56 = React.useRef(nil)
	local v57, v58 = React.useState(true)
	local v59 = if not v29 then nil else React.useRef(nil)

	if FFlagPPVEnable3DBackground then
		React.useEffect(function() -- line: 179
			-- upvalues: t1 (copy), InsertService (copy), getDisplayBackgroundId (copy), v52 (copy), v54 (copy), v53 (copy), color3 (copy), color3_2 (copy)
			task.defer(function() -- line: 181
				-- upvalues: t1 (copy), InsertService (copy), getDisplayBackgroundId (copy), v52 (copy), v54 (copy), v53 (copy), color3 (copy), color3_2 (copy)
				if not t1.currentBackgroundId then
					return
				end

				local ok, result = pcall(function() -- line: 186
					-- upvalues: InsertService (copy), getDisplayBackgroundId (copy), t1 (copy), v52 (copy)
					return InsertService:LoadAsset(getDisplayBackgroundId(t1.currentBackgroundId, v52))
				end)

				if ok and result then
					if v54.current then
						for _, child in pairs(v54.current:GetChildren()) do
							if child.Name ~= "Character" then
								child:Destroy()
							end
						end
					end

					local Model = Instance.new("Model")

					Model.Name = "BackgroundModel"
					Model.Parent = v54.current

					for _, child in pairs(result:GetChildren()) do
						child.Parent = Model
					end

					Model:PivotTo(CFrame.new(0, 7, -4.5))
					result:Destroy()

					local current = v53.current

					if current then
						current.Ambient = color3
						current.LightColor = color3_2
						current.LightDirection = Vector3.new(-0.5, 0.20000000298023224, 0.20000000298023224)
					end
				end
			end)
		end, { t1.currentBackgroundId })
	end

	if v29 then
		React.useEffect(function() -- line: 223
			-- upvalues: v30 (copy), n3 (ref), u35 (ref), RunService (copy), releaseUnthrottle (copy), v59 (copy)
			if v30 then
				if n3 == 0 then
					u35 = RunService:getThrottleFramerateEnabled()
					RunService:setThrottleFramerateEnabled(false)
				end

				n3 += 1

				return releaseUnthrottle
			end

			v59.current = RunService:getThrottleFramerateEnabled()
			RunService:setThrottleFramerateEnabled(false)

			return function() -- line: 231
				-- upvalues: RunService (copy), v59 (copy)
				RunService:setThrottleFramerateEnabled(v59.current or true)
			end
		end, {})
	end

	local v60 = React.useCallback(function(p2, p3) -- line: 238
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
	local v61 = React.useCallback(function(p4, p5) -- line: 275
		if not p4 or not p5 then
			return
		end

		local v72 = p4:FindFirstChild("Right Arm")

		if not v72 or not v72:IsA("BasePart") then
			return
		end

		local RightGripAttachment = v72:FindFirstChild("RightGripAttachment")

		if not RightGripAttachment or not RightGripAttachment:IsA("Attachment") then
			return
		end

		local v74 = p4:FindFirstChild("Right Shoulder", true)

		if not v74 or not v74:IsA("Motor6D") then
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
		v74.C0 = v74.C0 * CFrame.Angles(0, 0, 1.5707963267948966)
		Handle.CFrame = RightGripAttachment.WorldCFrame

		local v78 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
		local Weld = Instance.new("Weld")

		Weld.Parent = p5
		Weld.Part0 = Handle
		Weld.Part1 = v72
		Weld.C0 = p5.Grip
		Weld.C1 = v78
	end, {})

	React.useEffect(function() -- line: 312
		-- upvalues: v51 (copy), v58 (copy), Promise (copy), AvatarModelPrefetch (copy), InsertService (copy), Cryo (copy), t1 (copy), ErrorTypes (copy), v54 (copy), cFrame (copy), v56 (copy), v60 (copy), v61 (copy), FFlagProfilePlatformNewProfileHeader (copy), v55 (copy), v26 (copy), FFlagProfilePlatformMeTabMobileProfileHero (copy), v24 (copy), v22 (copy), v23 (copy), v29 (copy), UserInputService (copy)
		task.defer(function() -- line: 314
			-- upvalues: v51 (copy), v58 (copy), Promise (copy), AvatarModelPrefetch (copy), InsertService (copy), Cryo (copy), t1 (copy), ErrorTypes (copy), v54 (copy), cFrame (copy), v56 (copy), v60 (copy), v61 (copy), FFlagProfilePlatformNewProfileHeader (copy), v55 (copy), v26 (copy), FFlagProfilePlatformMeTabMobileProfileHero (copy), v24 (copy), v22 (copy), v23 (copy), v29 (copy), UserInputService (copy)
			if not v51 then
				return
			end

			v58(true)

			local u88 = Promise.resolve(nil)
			local u89 = Promise.resolve(nil)
			local v90 = AvatarModelPrefetch.get(v51)
			local v91 = Promise.new(function(resolve) -- line: 325
				-- upvalues: v51 (copy), u88 (ref), Promise (copy), InsertService (copy), Cryo (copy), u89 (ref)
				local ok, result = pcall(function() -- line: 326
					-- upvalues: v51 (copy)
					return game.Players:GetCharacterAppearanceInfoAsync(v51)
				end)

				if ok and result then
					if result.emotes and #result.emotes > 0 then
						u88 = Promise.new(function(resolve2) -- line: 331
							-- upvalues: InsertService (copy), result (copy)
							local ok2, result2 = pcall(function() -- line: 332
								-- upvalues: InsertService (copy), result (copy)
								return (InsertService:LoadAsset(result.emotes[1].assetId):FindFirstChildOfClass("Animation"))
							end)

							resolve2(if not ok2 then nil else result2)
						end)
					end

					if result.assets then
						local v116 = Cryo.List.findWhere(result.assets, function(p6) -- line: 341
							return p6.assetType.name == "Gear"
						end)

						if v116 then
							local v117 = result.assets[v116]

							u89 = Promise.new(function(resolve3) -- line: 346
								-- upvalues: InsertService (copy), v117 (copy)
								local ok3, result3 = pcall(function() -- line: 347
									-- upvalues: InsertService (copy), v117 (copy)
									return InsertService:LoadAsset(v117.id):FindFirstChildOfClass("Tool")
								end)

								resolve3(if not ok3 or (not result3 or not result3:IsA("Tool")) then nil else result3)
							end)
						end
					end
				end

				resolve(if not ok then nil else result)
			end)
			local v92, v93 = Promise.all({
				v90,
				v91:catch(function() -- line: 366
					return nil
				end)
			}):await()

			if not v92 then
				if t1.analytics then
					t1.analytics.fireAnalyticsEvent("EditProfileBackgroundFailure", {
						errorType = ErrorTypes.CharacterModelCreationFailed
					})
				end

				v58(false)

				return
			end

			local v94 = v93[1]
			local v95 = v93[2]

			AvatarModelPrefetch.clear(v51)
			v94.Name = "Character"
			v94.Parent = v54.current

			if v94.PrimaryPart then
				v94.PrimaryPart.CFrame = cFrame
			end

			v56.current = v94

			if v95 then
				local _, v97 = u89:await()

				if v97 then
					local playerAvatarType = v95.playerAvatarType

					if playerAvatarType == "R15" then
						v60(v94, v97)
					elseif playerAvatarType == "R6" then
						v61(v94, v97)
					end
				end
			end

			local Humanoid = v94:FindFirstChild("Humanoid")

			if Humanoid then
				Promise.race({
					Promise.fromEvent(Humanoid.ClusterCompositionFinished),
					Promise.delay(3)
				}):await()
			end

			if v94.PrimaryPart then
				v94.PrimaryPart.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), (Vector3.new(0, 0, -10)))

				local v100 = v94:FindFirstChild("RightFoot") or v94:FindFirstChild("Right Leg")

				if v100 and v100:IsA("BasePart") then
					local v101 = v100.Position.Y - v100.Size.Y / 2
					local v102 = v94.PrimaryPart.Position.Y + (-3 - v101)

					v94.PrimaryPart.CFrame = CFrame.lookAt(Vector3.new(0, v102, 0), (Vector3.new(0, 0, -10)))

					if FFlagProfilePlatformNewProfileHeader and v55.current then
						local v103, v104 = v94:GetBoundingBox()
						local v105 = v104.Y + v26
						local PositionY = v103.Position.Y
						local v108

						if FFlagProfilePlatformMeTabMobileProfileHero then
							local v107 = t1.cameraDistanceScale or 1

							v108 = math.clamp(v105 / (math.tan(v24) * 2) * v107, v22 * v107, v23 * v107)
						else
							v108 = math.clamp(v105 / (math.tan(v24) * 2), v22, v23)
						end

						local vector3 = Vector3.new(0, 0, -v108)
						local vector3_2 = Vector3.new(0, PositionY, 10)

						v55.current.CFrame = CFrame.lookAt(vector3, vector3_2)
					end
				end
			end

			v58(false)

			if v29 or UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
				local ok, _ = pcall(function() -- line: 455
					-- upvalues: u88 (ref), v94 (copy)
					local _, v119 = u88:await()
					local Animation1 = v94:FindFirstChild("Animate"):FindFirstChild("idle"):FindFirstChild("Animation1")
					local Animator = v94:FindFirstChild("Humanoid"):FindFirstChild("Animator")

					if Animation1 and (Animator and Animator:IsA("Animator")) then
						local track = Animator:LoadAnimation(Animation1)

						if v119 then
							local track2 = Animator:LoadAnimation(v119)

							track2.Looped = false
							track2:Play()
							track2.Stopped:Connect(function() -- line: 470
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
		v51,
		if not FFlagProfilePlatformMeTabMobileProfileHero then nil else t1.cameraDistanceScale
	})
	React.useEffect(function() -- line: 491
		-- upvalues: v53 (copy), v55 (copy)
		if v53.current and v55.current then
			v53.current.CurrentCamera = v55.current
		end
	end)

	return React.createElement(View, {
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, t1.height)
	}, {
		Background = React.createElement("ViewportFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ref = v53,
			Ambient = color3,
			LightColor = color3_2
		}, {
			WorldModel = React.createElement("WorldModel", {
				ref = v54
			}),
			Camera = React.createElement("Camera", {
				CameraType = Enum.CameraType.Scriptable,
				CFrame = CFrame.lookAt(Vector3.new(0, 0, -8), (Vector3.new(0, 1, 10))),
				ref = v55
			})
		}),
		LoadingFrame = v57 and React.createElement(View, {
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
