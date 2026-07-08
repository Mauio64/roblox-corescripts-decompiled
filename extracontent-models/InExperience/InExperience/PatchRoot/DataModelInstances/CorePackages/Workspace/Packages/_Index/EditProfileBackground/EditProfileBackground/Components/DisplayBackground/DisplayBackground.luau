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
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Promise = require(EditProfileBackgroundParent.Promise)
local LoadableImage = require(EditProfileBackgroundParent.UIBlox).App.Loading.LoadableImage

local function shouldEnableAnimation() -- line: 26
	-- upvalues: UserInputService (copy)
	return UserInputService.PreferredInput ~= Enum.PreferredInput.Touch
end

local color3 = Color3.fromRGB(210, 210, 210)
local color3_2 = Color3.fromRGB(250, 250, 250)
local v22 = if not FFlagProfilePlatformNewProfileHeader then nil else 6.5
local v23 = if not FFlagProfilePlatformNewProfileHeader then nil else 8
local v24 = if not FFlagProfilePlatformNewProfileHeader then nil else math.rad(((if not FFlagProfilePlatformNewProfileHeader then nil else 70)) / 2)
local v25 = if not FFlagProfilePlatformNewProfileHeader then nil else 2
local cFrame = CFrame.new((Vector3.new(0, 1000, 0)))
local FFlagPPVBackgroundUse2DAsLoadingState = require(EditProfileBackgroundParent.SharedFlags).FFlagPPVBackgroundUse2DAsLoadingState
local v28 = game:DefineFastFlag("PPVBackgroundUnthrottleProfileV2", false) and game:GetEngineFeature("IsGetThrottleFramerateEnabledAvailable")
local FFlagPPVEnable3DBackground = require(EditProfileBackgroundParent.SharedFlags).FFlagPPVEnable3DBackground
local FFlagPPVBackgroundPrefetchAvatar = require(EditProfileBackgroundParent.SharedFlags).FFlagPPVBackgroundPrefetchAvatar
local v31 = if not FFlagPPVBackgroundPrefetchAvatar then nil else require(EditProfileBackground.Common.AvatarModelPrefetch)
local GetFFlagDisplayBackgroundToolNotInDataModel = require(script.Parent.GetFFlagDisplayBackgroundToolNotInDataModel)
local InsertService = game:GetService("InsertService")

local function playToolAnimation(p1) -- line: 107
	-- upvalues: GetFFlagDisplayBackgroundToolNotInDataModel (copy)
	if GetFFlagDisplayBackgroundToolNotInDataModel() and not p1:IsDescendantOf(game) then
		return
	end

	local Animate = p1:FindFirstChild("Animate")

	assert(Animate ~= nil, "Expected animate to always exist")

	local toolnone = Animate:FindFirstChild("toolnone")

	assert(toolnone ~= nil, "Expected tool animation to always exist")

	local v39 = toolnone:GetChildren()[1]

	if v39 == nil then
		return
	end

	assert(v39:IsA("Animation"), "Unexpected type for tool animation")

	local Humanoid = p1:FindFirstChild("Humanoid")

	assert(Humanoid ~= nil, "Expected humanoid to always exist")

	local Animator = Humanoid:FindFirstChild("Animator")

	assert(Animator ~= nil, "Expected Animator to always exist")
	assert(Animator:IsA("Animator"), "Animator should be of type Animator")

	local track = Animator:LoadAnimation(v39)

	track.Looped = true
	track:Play()
end
local function BackgroundDisplay(t1: {[any]: any}) -- line: 140
	-- upvalues: useLocalUserId (copy), useSelectedTheme (copy), React (copy), v28 (copy), FFlagPPVEnable3DBackground (copy), InsertService (copy), getDisplayBackgroundId (copy), color3 (copy), color3_2 (copy), RunService (copy), playToolAnimation (copy), Promise (copy), FFlagPPVBackgroundPrefetchAvatar (copy), v31 (copy), Players (copy), Cryo (copy), ErrorTypes (copy), cFrame (copy), FFlagProfilePlatformNewProfileHeader (copy), v25 (copy), v24 (copy), v22 (copy), v23 (copy), UserInputService (copy), View (copy), FFlagPPVBackgroundUse2DAsLoadingState (copy), LoadableImage (copy), Loading (copy), IconSize (copy)
	local v44 = useLocalUserId()
	local v45 = t1.userId or v44 and tonumber(v44)
	local v46 = useSelectedTheme()
	local v47 = React.useRef(nil)
	local v48 = React.useRef(nil)
	local v49 = React.useRef(nil)
	local v50 = React.useRef(nil)
	local v51, v52 = React.useState(true)
	local v53 = if not v28 then nil else React.useRef(nil)

	if FFlagPPVEnable3DBackground then
		React.useEffect(function() -- line: 154
			-- upvalues: t1 (copy), InsertService (copy), getDisplayBackgroundId (copy), v46 (copy), v48 (copy), v47 (copy), color3 (copy), color3_2 (copy)
			task.defer(function() -- line: 156
				-- upvalues: t1 (copy), InsertService (copy), getDisplayBackgroundId (copy), v46 (copy), v48 (copy), v47 (copy), color3 (copy), color3_2 (copy)
				if not t1.currentBackgroundId then
					return
				end

				local ok, result = pcall(function() -- line: 161
					-- upvalues: InsertService (copy), getDisplayBackgroundId (copy), t1 (copy), v46 (copy)
					return InsertService:LoadAsset(getDisplayBackgroundId(t1.currentBackgroundId, v46))
				end)

				if ok and result then
					if v48.current then
						for _, child in pairs(v48.current:GetChildren()) do
							if child.Name ~= "Character" then
								child:Destroy()
							end
						end
					end

					local Model = Instance.new("Model")

					Model.Name = "BackgroundModel"
					Model.Parent = v48.current

					for _, child in pairs(result:GetChildren()) do
						child.Parent = Model
					end

					Model:PivotTo(CFrame.new(0, 7, -4.5))
					result:Destroy()

					local current = v47.current

					if current then
						current.Ambient = color3
						current.LightColor = color3_2
						current.LightDirection = Vector3.new(-0.5, 0.20000000298023224, 0.20000000298023224)
					end
				end
			end)
		end, { t1.currentBackgroundId })
	end

	if v28 then
		React.useEffect(function() -- line: 198
			-- upvalues: v53 (copy), RunService (copy)
			v53.current = RunService:getThrottleFramerateEnabled()
			RunService:setThrottleFramerateEnabled(false)

			return function() -- line: 201
				-- upvalues: RunService (copy), v53 (copy)
				RunService:setThrottleFramerateEnabled(v53.current or true)
			end
		end, {})
	end

	local v54 = React.useCallback(function(p2, p3) -- line: 207
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
	local v55 = React.useCallback(function(p4, p5) -- line: 244
		if not p4 or not p5 then
			return
		end

		local v66 = p4:FindFirstChild("Right Arm")

		if not v66 or not v66:IsA("BasePart") then
			return
		end

		local RightGripAttachment = v66:FindFirstChild("RightGripAttachment")

		if not RightGripAttachment or not RightGripAttachment:IsA("Attachment") then
			return
		end

		local v68 = p4:FindFirstChild("Right Shoulder", true)

		if not v68 or not v68:IsA("Motor6D") then
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
		v68.C0 = v68.C0 * CFrame.Angles(0, 0, 1.5707963267948966)
		Handle.CFrame = RightGripAttachment.WorldCFrame

		local v72 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
		local Weld = Instance.new("Weld")

		Weld.Parent = p5
		Weld.Part0 = Handle
		Weld.Part1 = v66
		Weld.C0 = p5.Grip
		Weld.C1 = v72
	end, {})

	React.useEffect(function() -- line: 281
		-- upvalues: v45 (copy), v52 (copy), Promise (copy), FFlagPPVBackgroundPrefetchAvatar (copy), v31 (copy), Players (copy), InsertService (copy), Cryo (copy), t1 (copy), ErrorTypes (copy), v48 (copy), cFrame (copy), v50 (copy), v54 (copy), v55 (copy), FFlagProfilePlatformNewProfileHeader (copy), v49 (copy), v25 (copy), v24 (copy), v22 (copy), v23 (copy), v28 (copy), UserInputService (copy)
		task.defer(function() -- line: 283
			-- upvalues: v45 (copy), v52 (copy), Promise (copy), FFlagPPVBackgroundPrefetchAvatar (copy), v31 (copy), Players (copy), InsertService (copy), Cryo (copy), t1 (copy), ErrorTypes (copy), v48 (copy), cFrame (copy), v50 (copy), v54 (copy), v55 (copy), FFlagProfilePlatformNewProfileHeader (copy), v49 (copy), v25 (copy), v24 (copy), v22 (copy), v23 (copy), v28 (copy), UserInputService (copy)
			if not v45 then
				return
			end

			v52(true)

			local u82 = Promise.resolve(nil)
			local u83 = Promise.resolve(nil)
			local v84 = if not FFlagPPVBackgroundPrefetchAvatar then Promise.new(function(resolve, reject) -- line: 294
				-- upvalues: Players (copy), v45 (copy)
				local ok, result = pcall(function() -- line: 295
					-- upvalues: Players (copy), v45 (copy)
					if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
						return Players:CreateHumanoidModelFromUserIdAsync(v45)
					end

					return game.Players:CreateHumanoidModelFromUserId(v45)
				end)

				if ok and result then
					resolve(result)

					return
				end

				reject("CharacterModelCreationFailed")
			end) else v31.get(v45)
			local v85 = Promise.new(function(resolve) -- line: 309
				-- upvalues: v45 (copy), u82 (ref), Promise (copy), InsertService (copy), Cryo (copy), u83 (ref)
				local ok, result = pcall(function() -- line: 310
					-- upvalues: v45 (copy)
					return game.Players:GetCharacterAppearanceInfoAsync(v45)
				end)

				if ok and result then
					if result.emotes and #result.emotes > 0 then
						u82 = Promise.new(function(resolve2) -- line: 315
							-- upvalues: InsertService (copy), result (copy)
							local ok2, result2 = pcall(function() -- line: 316
								-- upvalues: InsertService (copy), result (copy)
								return (InsertService:LoadAsset(result.emotes[1].assetId):FindFirstChildOfClass("Animation"))
							end)

							resolve2(if not ok2 then nil else result2)
						end)
					end

					if result.assets then
						local v112 = Cryo.List.findWhere(result.assets, function(p6) -- line: 325
							return p6.assetType.name == "Gear"
						end)

						if v112 then
							local v113 = result.assets[v112]

							u83 = Promise.new(function(resolve3) -- line: 330
								-- upvalues: InsertService (copy), v113 (copy)
								local ok3, result3 = pcall(function() -- line: 331
									-- upvalues: InsertService (copy), v113 (copy)
									return InsertService:LoadAsset(v113.id):FindFirstChildOfClass("Tool")
								end)

								resolve3(if not ok3 or (not result3 or not result3:IsA("Tool")) then nil else result3)
							end)
						end
					end
				end

				resolve(if not ok then nil else result)
			end)
			local v86, v87 = Promise.all({
				v84,
				v85:catch(function() -- line: 350
					return nil
				end)
			}):await()

			if not v86 then
				if t1.analytics then
					t1.analytics.fireAnalyticsEvent("EditProfileBackgroundFailure", {
						errorType = ErrorTypes.CharacterModelCreationFailed
					})
				end

				v52(false)

				return
			end

			local v88 = v87[1]
			local v89 = v87[2]

			if FFlagPPVBackgroundPrefetchAvatar then
				v31.clear(v45)
			end

			v88.Name = "Character"
			v88.Parent = v48.current

			if v88.PrimaryPart then
				v88.PrimaryPart.CFrame = cFrame
			end

			v50.current = v88

			if v89 then
				local _, v91 = u83:await()

				if v91 then
					local playerAvatarType = v89.playerAvatarType

					if playerAvatarType == "R15" then
						v54(v88, v91)
					elseif playerAvatarType == "R6" then
						v55(v88, v91)
					end
				end
			end

			local Humanoid = v88:FindFirstChild("Humanoid")

			if Humanoid then
				Promise.race({
					Promise.fromEvent(Humanoid.ClusterCompositionFinished),
					Promise.delay(3)
				}):await()
			end

			if v88.PrimaryPart then
				v88.PrimaryPart.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), (Vector3.new(0, 0, -10)))

				local v94 = v88:FindFirstChild("RightFoot") or v88:FindFirstChild("Right Leg")

				if v94 and v94:IsA("BasePart") then
					local v95 = v94.Position.Y - v94.Size.Y / 2
					local v96 = v88.PrimaryPart.Position.Y + (-3 - v95)

					v88.PrimaryPart.CFrame = CFrame.lookAt(Vector3.new(0, v96, 0), (Vector3.new(0, 0, -10)))

					if FFlagProfilePlatformNewProfileHeader and v49.current then
						local v97, v98 = v88:GetBoundingBox()
						local v99 = v98.Y + v25
						local PositionY = v97.Position.Y
						local vector3 = Vector3.new(0, 0, -math.clamp(v99 / (math.tan(v24) * 2), v22, v23))
						local vector3_2 = Vector3.new(0, PositionY, 10)

						v49.current.CFrame = CFrame.lookAt(vector3, vector3_2)
					end
				end
			end

			v52(false)

			if v28 or UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
				local ok, _ = pcall(function() -- line: 438
					-- upvalues: u82 (ref), v88 (copy)
					local _, v115 = u82:await()
					local Animation1 = v88:FindFirstChild("Animate"):FindFirstChild("idle"):FindFirstChild("Animation1")
					local Animator = v88:FindFirstChild("Humanoid"):FindFirstChild("Animator")

					if Animation1 and (Animator and Animator:IsA("Animator")) then
						local track = Animator:LoadAnimation(Animation1)

						if v115 then
							local track2 = Animator:LoadAnimation(v115)

							track2.Looped = false
							track2:Play()
							track2.Stopped:Connect(function() -- line: 453
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
	end, { v45 })
	React.useEffect(function() -- line: 474
		-- upvalues: v47 (copy), v49 (copy)
		if v47.current and v49.current then
			v47.current.CurrentCamera = v49.current
		end
	end)

	return React.createElement(View, {
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, t1.height)
	}, {
		Background = React.createElement("ViewportFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ref = v47,
			Ambient = color3,
			LightColor = color3_2
		}, {
			WorldModel = React.createElement("WorldModel", {
				ref = v48
			}),
			Camera = React.createElement("Camera", {
				CameraType = Enum.CameraType.Scriptable,
				CFrame = CFrame.lookAt(Vector3.new(0, 0, -8), (Vector3.new(0, 1, 10))),
				ref = v49
			})
		}),
		LoadingFrame = v51 and React.createElement(View, {
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
