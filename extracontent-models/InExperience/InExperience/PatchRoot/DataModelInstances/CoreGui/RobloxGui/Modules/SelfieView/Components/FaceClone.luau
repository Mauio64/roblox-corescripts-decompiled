local CorePackages = game:GetService("CorePackages")
local ModelUtils = require(script.Parent.Parent.Utils.ModelUtils)
local UserInputService = game:GetService("UserInputService")
local service = game:FindService("FaceAnimatorService")

local Thumbnailing = require(CorePackages.Packages.Thumbnailing)
local CharacterUtility = Thumbnailing.CharacterUtility
local Thumbnailing2 = require(CorePackages.Packages.Thumbnailing)
local CFrameUtility = Thumbnailing2.CFrameUtility

local engineFeature = game:GetEngineFeature("AnimatorAndADFRefactor")
local engineFeature2 = game:GetEngineFeature("PlayerViewRemoteEventSupport")

local trackerStreamAnimation = nil
local v = nil
local defineFastFlag = game:DefineFastFlag("SelfViewNewPoseSynchronization", false)
local defineFastFlag2 = game:DefineFastFlag("DebugSelfViewPerfBenchmark", false)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagSelfViewVisibilityFix = SharedFlags.GetFFlagSelfViewVisibilityFix

local RunService = game:GetService("RunService")

local v2 = 1.31

local v3 = 0

local connection = nil
local characterAddedConnection = nil
local connections = {}

local v4 = {}

local animator = nil
local v5 = {}
local playingAnimationTracksByAnimationId = {}
local v6 = nil
local size = nil

local viewportFrame = nil
local camera = nil

local v7 = Vector3.new(1.1721, 1.1811, 1.1578)
local parent = nil
local selfAvatar = nil
local v8 = nil
local v9 = nil
local v10 = nil
local cframe = nil
local parent2 = nil
local v11 = nil
local v12 = nil
local flag = false

local count = 0

local v13 = {}
local v14 = {
	AnimationPlayed = "AnimationPlayed",
	AnimationPlayedCoreScript = "AnimationPlayedCoreScript",
	DescendantAdded = "DescendantAdded",
	DescendantRemoving = "DescendantRemoving",
	HeadSize = "HeadSize",
	Color = "Color",
	CharacterAdded = "CharacterAdded",
	CharacterRemoving = "CharacterRemoving",
	HumanoidStateChanged = "HumanoidStateChanged",
	FaceControlsChanged = "FaceControlsChanged"
}

local Players = game:GetService("Players")

if not Players.LocalPlayer then
	warn("Players.LocalPlayer does not exist")
end

local LocalPlayer = Players.LocalPlayer

local v15 = false

function setCloneDirty(flag2: boolean)
	v3 = if flag2 then 0.35 else 0
end

function createCloneAnchor()
	if parent ~= nil then
		parent:Destroy()
		parent = nil
	end

	local worldModel = Instance.new("WorldModel")
	worldModel.Parent = viewportFrame

	parent = worldModel
end

local function clearObserver(p: string) -- 19 equivalent calls inferred from this helper
	if v13[p] then
		v13[p]:Disconnect()
		v13[p] = nil
	end
end

function clearCloneCharacter()
	if selfAvatar then
		selfAvatar:Destroy()
		selfAvatar = nil
	end

	if not parent then
		warn("cloneAnchor is nil, this shouldn't be possible")
		return
	end

	assert(parent ~= nil)
	local selfAvatar2 = parent:FindFirstChild("SelfAvatar")

	if selfAvatar2 then
		selfAvatar2:Destroy()
	end

	createCloneAnchor()
end

local function clearClone()
	stopRenderStepped()
	clearObserver("AnimationPlayed") -- inferred equivalent call
	clearObserver("AnimationPlayedCoreScript") -- inferred equivalent call

	for _, v16 in v5 do
		if v16 then
			v16:Stop(0)
		end
	end

	if v then
		v:Stop(0)
		v = nil
	end

	animator = nil
	v5 = {}

	clearCloneCharacter()
end

local function syncTrack(animator2, data)
	if not (animator2 and data.Animation) then
		return
	end

	local v16 = nil

	if not (data.Animation and data.Animation:IsA("Animation")) then
		if data.Animation and data.Animation:IsA("TrackerStreamAnimation") then
			if v then
				v:Stop(0)
			end

			trackerStreamAnimation = Instance.new("TrackerStreamAnimation")
			assert(trackerStreamAnimation ~= nil)

			if game:GetEngineFeature("UseNewLoadStreamAnimationAPI") then
				v = animator2:LoadStreamAnimationV2(trackerStreamAnimation, LocalPlayer, false, false)
			else
				v = animator2:LoadStreamAnimationForSelfieView_deprecated(trackerStreamAnimation, LocalPlayer)
			end

			v16 = v
		else
			warn("No animation to clone in SelfView")
		end
	end

	if v16 then
		v16:Play()
		v16.Priority = data.Priority

		connections[data] = data.Stopped:Connect(function()
			v16:Stop(0)

			if connections[data] then
				connections[data]:Disconnect()
			end
		end)
	end
end

local function updateClone(player)
	clearClone()

	if not player then
		return
	end

	assert(player ~= nil)

	startRenderStepped(player)

	local _character = player.Character

	if not (player and player.Character) then
		return
	end

	local character = player.Character

	if not character then
		return
	end

	assert(character ~= nil)

	local animator2 = ModelUtils.getAnimator(character, 10)

	clearCloneCharacter()

	local archivable = character.Archivable
	character.Archivable = true

	local head = ModelUtils.getHead(character)

	if not head then
		return
	end

	selfAvatar = character:Clone()

	if selfAvatar == nil then
		return
	end

	assert(selfAvatar ~= nil)

	ModelUtils.resetPartOrientation(selfAvatar)

	ModelUtils.updateTransparency(selfAvatar, v4)

	ModelUtils.removeTags(selfAvatar)

	selfAvatar.Name = "SelfAvatar"

	ModelUtils.removeScripts(selfAvatar)

	ModelUtils.sanitizeCharacter(selfAvatar)

	character.Archivable = archivable

	selfAvatar.Parent = parent

	local humanoidRootPart = selfAvatar:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		humanoidRootPart.CFrame = CFrame.new(Vector3.new(0, 0, 0))
		assert(camera ~= nil)

		if head then
			local head2 = ModelUtils.getHead(selfAvatar)

			if head2 then
				assert(head2 ~= nil)

				local targetCFrame = CFrameUtility.CalculateTargetCFrame(head2.CFrame)
				local headExtents, v16 = CharacterUtility.CalculateHeadExtents(selfAvatar, targetCFrame)

				local vector3 = Vector3.new(headExtents.X, headExtents.Y, headExtents.Z)
				v7 = Vector3.new(v16.X, v16.Y, v16.Z) - vector3

				assert(v7 ~= nil)

				v2 = head2.Size.Y
				math.min(v7.X, v7.Y)
				local v17 = math.min(v7.X, v7.Z)

				local model = Instance.new("Model")
				model.Parent = selfAvatar
				local head3 = ModelUtils.getHead(selfAvatar)
				character.Archivable = true
				v9 = head3:Clone()

				assert(v9 ~= nil)
				v9.CanCollide = false
				v9.Parent = model

				v10 = ModelUtils.getNeck(selfAvatar, v9)

				cframe = v9.CFrame
				v9:Destroy()
				assert(cframe ~= nil)

				local v18 = cframe.Position + cframe.LookVector * (v17 * 2)
				camera.CFrame = CFrame.lookAt(v18 + Vector3.new(0, 0.105, -0.25), cframe.Position)
				camera.Focus = cframe

				character.Archivable = archivable
				model:Destroy()
			end
		else
			local v16 = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 2.5
			camera.CFrame = CFrame.lookAt(v16 + Vector3.new(0, 1.5, 0), humanoidRootPart.Position)
			camera.CFrame = CFrame.new(camera.CFrame.Position) * CFrame.Angles(-0.0006981317007977319, 3.141592653589793, 0)
		end
	end

	if selfAvatar == nil then
		return
	end

	local humanoid = selfAvatar:FindFirstChildWhichIsA("Humanoid")

	if humanoid then
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end

	animator = ModelUtils.getAnimator(selfAvatar, 0)

	if animator then
		if not (engineFeature and defineFastFlag) then
			local playingAnimationTracks = animator:GetPlayingAnimationTracks()
			local playingAnimationTracksCoreScript = animator:GetPlayingAnimationTracksCoreScript()

			for _, playingAnimationTrack in ipairs(playingAnimationTracks) do
				if playingAnimationTrack == nil then
					continue
				end

				playingAnimationTrack:Stop(0)
				playingAnimationTrack:Destroy()
			end

			for _, v16 in ipairs(playingAnimationTracksCoreScript) do
				if v16 == nil then
					continue
				end

				v16:Stop(0)
				v16:Destroy()
			end

			if trackerStreamAnimation then
				trackerStreamAnimation:Destroy()
				trackerStreamAnimation = nil
			end
		end

		if animator2 then
			if engineFeature and defineFastFlag then
				animator:SynchronizeWith(animator2)
			else
				for _, v16 in ipairs(animator2:GetPlayingAnimationTracksCoreScript()) do
					syncTrack(animator, v16)
				end

				v13.AnimationPlayedCoreScript = animator2.AnimationPlayedCoreScript:Connect(function(p)
					syncTrack(animator, p)
				end)
			end

			setCloneDirty(false)
		end
	end
end

local function hasProperty(p, p2) -- 4 equivalent calls inferred from this helper
	local _ = p[p2]
end

function updateCachedHeadColor(p)
	if p == nil then
		return
	end

	assert(p ~= nil)

	if pcall(function()
		hasProperty(p, "Color") -- inferred equivalent call
	end) then
		v6 = p.Color

		if pcall(function()
			hasProperty(p, "Size") -- inferred equivalent call
		end) then
			size = p.Size
		end
	end
end

local function addHumanoidStateChangedObserver(p)
	if not p then
		return
	end

	if not v13.HumanoidStateChanged then
		v13.HumanoidStateChanged = p.StateChanged:Connect(function(p2, p3)
			if p2 == Enum.HumanoidStateType.PlatformStanding and p3 == Enum.HumanoidStateType.Running then
				setCloneDirty(true)
			end

			if p3 == Enum.HumanoidStateType.GettingUp then
				setCloneDirty(true)
			end
		end)
	end
end

local function addFaceControlsObserver(p)
	if not v13.FaceControlsChanged then
		v13.FaceControlsChanged = p.InternalFacsOverrideChanged:Connect(function()
			setCloneDirty(true)
		end)
	end
end

local function characterAdded(instance)
	if viewportFrame == nil or parent2 == nil or not instance then
		return
	end

	v8 = ModelUtils.getHead(instance)
	updateCachedHeadColor(v8)
	clearObserver("DescendantAdded") -- inferred equivalent call
	clearObserver("DescendantRemoving") -- inferred equivalent call
	clearObserver("HeadSize") -- inferred equivalent call
	clearObserver("Color") -- inferred equivalent call
	local humanoid = instance:FindFirstChildWhichIsA("Humanoid")

	if humanoid and not v13[v14.HumanoidStateChanged] then
		v13[v14.HumanoidStateChanged] = humanoid.StateChanged:Connect(function(p, p2)
			if p == Enum.HumanoidStateType.PlatformStanding and p2 == Enum.HumanoidStateType.Running then
				setCloneDirty(true)
			end

			if p2 == Enum.HumanoidStateType.GettingUp then
				setCloneDirty(true)
			end
		end)
	end

	local faceControls = instance:FindFirstChildWhichIsA("FaceControls", true)

	if faceControls and not v13[v14.FaceControlsChanged] then
		v13[v14.FaceControlsChanged] = faceControls.InternalFacsOverrideChanged:Connect(function()
			setCloneDirty(true)
		end)
	end

	v13.DescendantAdded = instance.DescendantAdded:Connect(function(instance2)
		if viewportFrame == nil or parent2 == nil then
			return
		end

		if instance2.Name == "Head" then
			v8 = ModelUtils.getHead(instance)

			updateCachedHeadColor(v8)
		end

		if instance2:IsA("Humanoid") and instance2 and not v13[v14.HumanoidStateChanged] then
			v13[v14.HumanoidStateChanged] = instance2.StateChanged:Connect(function(p, p2)
				if p == Enum.HumanoidStateType.PlatformStanding and p2 == Enum.HumanoidStateType.Running then
					setCloneDirty(true)
				end

				if p2 == Enum.HumanoidStateType.GettingUp then
					setCloneDirty(true)
				end
			end)
		end

		if instance2:IsA("FaceControls") and not v13[v14.FaceControlsChanged] then
			v13[v14.FaceControlsChanged] = instance2.InternalFacsOverrideChanged:Connect(function()
				setCloneDirty(true)
			end)
		end

		if ModelUtils.shouldMarkCloneDirtyForDescendant(instance2) then
			setCloneDirty(true)
		end
	end)
	v13.DescendantRemoving = instance.DescendantRemoving:Connect(function(instance2)
		if viewportFrame == nil or parent2 == nil then
			return
		end

		if instance2 and (instance2:IsA("MeshPart") or instance2:IsA("Accessory")) then
			if instance2:IsA("MeshPart") and instance2.MeshId == "" then
				return
			end

			if ModelUtils.shouldMarkCloneDirtyForDescendant(instance2) then
				setCloneDirty(true)
			end
		end
	end)

	setCloneDirty(true)
	flag = true
end

local function createViewport()
	if viewportFrame then
		viewportFrame:Destroy()
	end

	viewportFrame = Instance.new("ViewportFrame")
	viewportFrame.Position = UDim2.new(0, 0, 0, 0)
	viewportFrame.Size = UDim2.new(1, 0, 1, 0)
	viewportFrame.BackgroundTransparency = 1
	viewportFrame.Parent = parent2

	viewportFrame.Ambient = Color3.new(0.7529411765, 0.7098039216, 0.7137254902)
	viewportFrame.LightColor = Color3.new(1, 0.9960784314, 0.9960784314)
	viewportFrame.LightDirection = Vector3.new(9.5, -12, 7.5)
	viewportFrame.IsMirrored = true

	Instance.new("UICorner")
	local uiCorner = Instance.new("UICorner")
	uiCorner.Parent = viewportFrame

	createCloneAnchor()

	if parent2 then
		parent2.Destroying:Connect(clearViewportFrame)
	end

	camera = Instance.new("Camera")
	assert(camera ~= nil)

	camera.FieldOfView = 70
	viewportFrame.CurrentCamera = camera
	camera.Parent = viewportFrame
end

function ReInit(player)
	assert(player.Character ~= nil)

	if GetFFlagSelfViewVisibilityFix() and v12 and not v12.Visible then
		v15 = false
		return
	end

	v8 = ModelUtils.getHead(player.Character)
	updateCachedHeadColor(v8)

	setCloneDirty(false)
	clearObserver("CharacterAdded") -- inferred equivalent call
	clearObserver("CharacterRemoving") -- inferred equivalent call
	clearClone()
	createViewport()
	playerAdded(player)
	startRenderStepped(player)
end

local function onCharacterAdded(instance)
	if characterAddedConnection then
		characterAddedConnection:Disconnect()
	end

	if flag then
		ReInit(LocalPlayer)
	else
		characterAdded(instance)
	end

	clearObserver("HumanoidStateChanged") -- inferred equivalent call
	local humanoid = instance:FindFirstChildWhichIsA("Humanoid")

	if humanoid then
		if not humanoid then
			return
		end

		if not v13[v14.HumanoidStateChanged] then
			v13[v14.HumanoidStateChanged] = humanoid.StateChanged:Connect(function(p, p2)
				if p == Enum.HumanoidStateType.PlatformStanding and p2 == Enum.HumanoidStateType.Running then
					setCloneDirty(true)
				end

				if p2 == Enum.HumanoidStateType.GettingUp then
					setCloneDirty(true)
				end
			end)
		end
	end
end

local function FindInParents(ancestorName: string?) -- 1 equivalent call inferred from this helper
	if not (ancestorName and parent2) then
		return nil
	end

	assert(parent2 ~= nil, "Wrapper Frame cannot be nil")
	assert(ancestorName ~= nil, "Frame name cannot be nil ")

	return parent2:FindFirstAncestor(ancestorName)
end

function clearViewportFrame()
	if viewportFrame then
		viewportFrame:Destroy()
	end

	parent2 = nil
	stopRenderStepped()
end

local function onOuterContainerVisibilityChanged()
	if v12 then
		if v12.Visible then
			if not flag then
				return
			end

			v15 = true
		else
			v15 = false
		end
	end
end

function playerAdded(player)
	if player ~= nil and player == LocalPlayer then
		if characterAddedConnection ~= nil then
			characterAddedConnection:Disconnect()
			characterAddedConnection = nil
			clearObserver("CharacterAdded") -- inferred equivalent call
		end

		local _character = player.Character
		local character = player.Character

		characterAddedConnection = player.CharacterAdded:Connect(onCharacterAdded)

		if character then
			characterAdded(character)
		end

		v13.CharacterAdded = player.CharacterAdded:Connect(characterAdded)
		v13.CharacterRemoving = player.CharacterRemoving:Connect(function()
			clearObserver("DescendantAdded") -- inferred equivalent call
			clearObserver("DescendantRemoving") -- inferred equivalent call
			clearObserver("HeadSize") -- inferred equivalent call
			clearObserver("Color") -- inferred equivalent call
			clearClone()
			clearObserver("CharacterRemoving") -- inferred equivalent call
		end)
	end
end

function stopRenderStepped()
	if connection then
		connection:Disconnect()
		connection = nil
	end
end

function updateClonePartsColor(p)
	if pcall(function()
		hasProperty(v8, "Color") -- inferred equivalent call
	end) and v8 and v8.Color ~= v6 then
		local character = LocalPlayer.Character

		if not character then
			return
		end

		assert(character ~= nil)

		if not selfAvatar then
			return
		end

		assert(selfAvatar ~= nil)

		for _, part in pairs(character:GetChildren()) do
			if not part:IsA("MeshPart") then
				continue
			end

			local part2 = selfAvatar:FindFirstChild(part.Name)

			if part2 and part2:IsA("MeshPart") and part2.Color and part.Color then
				part2.Color = part.Color
			end
		end
	end

	v6 = p
end

function startRenderStepped(p)
	stopRenderStepped()
	local v16

	if defineFastFlag2 then
		v16 = RunService.Heartbeat
	else
		v16 = RunService.RenderStepped
	end

	connection = v16:Connect(function(p2: number)
		if defineFastFlag2 then
			debug.profilebegin("faceclone")
		end

		if GetFFlagSelfViewVisibilityFix() and selfAvatar and v12 and not v15 then
			if animator ~= nil then
				local playingAnimationTracks = animator:GetPlayingAnimationTracks()

				for _, playingAnimationTrack in pairs(playingAnimationTracks) do
					if playingAnimationTrack ~= nil then
						playingAnimationTrack:Stop(0)
					end
				end
			end
		else
			if LocalPlayer then
				local character = LocalPlayer.Character

				if not character or character.Parent == nil then
					return
				end

				assert(character ~= nil)

				if v8 == nil or v8.Parent ~= character then
					v8 = ModelUtils.getHead(character)
				end

				if v8 then
					local animator2 = ModelUtils.getAnimator(character, 0)

					if animator ~= nil and animator2 ~= nil then
						assert(animator ~= nil)

						local playingAnimationTracks = animator:GetPlayingAnimationTracks()

						for _, playingAnimationTrack in pairs(playingAnimationTracks) do
							if playingAnimationTrack ~= nil then
								playingAnimationTrack:Stop(0)
							end
						end

						local playingAnimationTracks2 = animator2:GetPlayingAnimationTracks()

						playingAnimationTracksByAnimationId = {}

						for _, playingAnimationTrack in ipairs(playingAnimationTracks2) do
							local animation = playingAnimationTrack.Animation

							if not (animation and animation:IsA("Animation") and animation.AnimationId ~= "") then
								continue
							end

							playingAnimationTracksByAnimationId[animation.AnimationId] = playingAnimationTrack

							if not v5[animation.AnimationId] then
								v5[animation.AnimationId] = animator:LoadAnimation(animation)
							end

							local v17 = v5[animation.AnimationId]
							assert(v17 ~= nil)
							v17:Play()
							v17.TimePosition = playingAnimationTrack.TimePosition
							v17.Priority = playingAnimationTrack.Priority
							v17:AdjustWeight(playingAnimationTrack.WeightCurrent, 0.1)
						end

						for k in v5 do
							local v17 = v5[k]

							if not v17 then
								continue
							end

							local animation = v17.Animation

							if not animation or playingAnimationTracksByAnimationId[animation.AnimationId] then
								continue
							end

							local v18 = v5[animation.AnimationId]

							if v18 ~= nil then
								v18:Stop(0)
							end

							v5[animation.AnimationId] = nil
						end

						for _, v17 in ipairs(animator2:GetPlayingAnimationTracksCoreScript()) do
							local playingAnimationTracksCoreScript = animator:GetPlayingAnimationTracksCoreScript()

							for _, v18 in pairs(playingAnimationTracksCoreScript) do
								if not v18.Animation:IsA("TrackerStreamAnimation") then
									continue
								end

								v18.Priority = v17.Priority
								v18:AdjustWeight(v17.WeightCurrent, 0)
							end
						end
					end
				end

				local cframe2 = nil

				local platform = UserInputService:GetPlatform()

				if (platform == Enum.Platform.IOS or platform == Enum.Platform.Android) and animator ~= nil then
					local playingAnimationTracksCoreScript = animator:GetPlayingAnimationTracksCoreScript()

					for _, v17 in pairs(playingAnimationTracksCoreScript) do
						if not v17.Animation:IsA("TrackerStreamAnimation") then
							continue
						end

						local trackerData, v18
						trackerData, cframe2, v18 = v17:GetTrackerData()
					end
				end

				count += 1

				if count == 1 then
					count = 0

					if selfAvatar then
						if not v9 then
							v9 = ModelUtils.getHead(selfAvatar)

							if v9 then
								v10 = ModelUtils.getNeck(selfAvatar, v9)
							end
						end

						if v9 then
							cframe = v9.CFrame
						end
					end

					if camera and v9 then
						local v17 = v9.Position
						local v18 = v9.Position

						local _cframe = v9.CFrame

						if v10 then
							local part0 = v10.Part0
							local _part1 = v10.Part1
							local c0 = v10.C0
							local c1 = v10.C1
							local transform = v10.Transform

							if part0 and c0 then
								local v19 = part0.CFrame * c0 * transform * c1:Inverse()

								v18 = Vector3.new(
									v19.Position.X * 0.25,
									(v9.CFrame.Position.Y + v19.Position.Y + v19.Position.Y * 0.75) * 0.33333,
									v19.Position.Z
								)

								v17 = Vector3.new(
									v19.Position.X * 0.6,
									(v9.CFrame.Position.Y + v19.Position.Y + v19.Position.Y * 0.75) * 0.33333,
									v19.Position.Z
								)
							end
						end

						if not v7 then
							warn("boundsSize is nil, this shouldn't be possible")
						end

						assert(v7 ~= nil)

						if service and service.VideoAnimationEnabled and (cframe2 ~= nil or engineFeature2) then
							if engineFeature2 then
								local PlayerViewService = game:GetService("PlayerViewService")
								local deviceCameraCFrameForSelfView = PlayerViewService:GetDeviceCameraCFrameForSelfView()
								local position = deviceCameraCFrameForSelfView.Position
								local eulerAnglesYXZ, v19, v20 = deviceCameraCFrameForSelfView:ToEulerAnglesYXZ()
								local cframe3 = CFrame.fromEulerAnglesYXZ(eulerAnglesYXZ, v19, v20)

								local v21 = not (position.Z > 0) and 0 or math.clamp(0.5 - position.Z * 3, -0.5, 0.5)

								local v22 = -(v7.Z + 1)

								local vector3 = Vector3.new(0, 0.105, math.floor((v22 + v21 * v22) * 100) / 100)

								camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(cframe3 * (v17 + vector3), v18), 0.5)
							elseif cframe2 then
								local vector3 = Vector3.new(0, 0.105, -(v7.Z + 1))
								local eulerAnglesXYZ, v19, v20 = cframe2:ToEulerAnglesXYZ()

								local cframe3 = CFrame.Angles(-eulerAnglesXYZ * 0.5, -v19 * 0.5, -v20 * 0.5)

								camera.CFrame = CFrame.lookAt(cframe3 * (v17 + vector3), v18)
							end
						else
							local vector3 = Vector3.new(0, v2 * 0.25 - 1.25, -(v7.Z + 1) + 0.125)

							if character then
								local head = character:FindFirstChild("Head")

								local humanoidRootPart = head and character:FindFirstChild("HumanoidRootPart")

								if humanoidRootPart then
									local v19 = humanoidRootPart.CFrame:Inverse() * head.CFrame

									local vector3_2 = Vector3.new(
										v19.Position.X * 0.15 + 0.125,
										v19.Position.Y,
										v19.Position.Z * 0.05
									)

									camera.CFrame = CFrame.lookAt(v17 + vector3 + vector3_2, v18)
									camera.Focus = v9.CFrame
								end
							end
						end
					end
				end

				if v8 then
					if v8.Size ~= size then
						size = v8.Size
						setCloneDirty(true)
					end

					if pcall(function()
						hasProperty(v8, "Color") -- inferred equivalent call
					end) and v8.Color ~= v6 then
						updateClonePartsColor(v8.Color)
					end
				end
			end

			if v3 > 0 then
				v3 -= p2

				if v3 <= 0 then
					updateClone(p)
					v3 = 0
				end
			end

			if defineFastFlag2 then
				debug.profileend()
			end
		end
	end)
end

local function Initialize(p, p2, p3: string?)
	if not p2 then
		return
	end

	parent2 = p2

	if GetFFlagSelfViewVisibilityFix() and p3 then
		v11 = p3
		v12 = FindInParents(v11) -- inferred equivalent call

		if v12 then
			v12:GetPropertyChangedSignal("Visible"):Connect(onOuterContainerVisibilityChanged)
		end
	end

	createViewport()

	playerAdded(p)

	Players.PlayerAdded:Connect(playerAdded)
	Players.PlayerRemoving:Connect(function(player)
		if player == LocalPlayer then
			clearObserver("HumanoidStateChanged") -- inferred equivalent call
			clearObserver("CharacterAdded") -- inferred equivalent call
			clearObserver("CharacterRemoving") -- inferred equivalent call
			clearObserver("FaceControlsChanged") -- inferred equivalent call
			clearClone()
		end
	end)

	startRenderStepped(p)

	return clearClone
end

return Initialize
