local CorePackages = game:GetService("CorePackages")
local ModelUtils = require(script.Parent.Parent.Utils.ModelUtils)
local UserInputService = game:GetService("UserInputService")
local Service = game:FindService("FaceAnimatorService")
local CharacterUtility = require(CorePackages.Packages.Thumbnailing).CharacterUtility
local CFrameUtility = require(CorePackages.Packages.Thumbnailing).CFrameUtility
local EngineFeature = game:GetEngineFeature("AnimatorAndADFRefactor")
local EngineFeature2 = game:GetEngineFeature("PlayerViewRemoteEventSupport")
local TrackerStreamAnimation = nil
local u10 = nil
local v11 = game:DefineFastFlag("SelfViewNewPoseSynchronization", false)
local v12 = game:DefineFastFlag("DebugSelfViewPerfBenchmark", false)
local GetFFlagSelfViewVisibilityFix = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagSelfViewVisibilityFix
local RunService = game:GetService("RunService")
local n1 = 1.31
local n2 = 0
local u17 = nil
local u18 = nil
local t1 = {}
local t2 = {}
local u21 = nil
local t3 = {}
local t4 = {}
local p7Color = nil
local p7Size = nil
local ViewportFrame = nil
local Camera = nil
local vector3 = Vector3.new(1.1720999479293823, 1.1811000108718872, 1.1577999591827393)
local u29 = nil
local u30 = nil
local u31 = nil
local clone = nil
local u33 = nil
local cloneCFrame = nil
local u35 = nil
local u36 = nil
local u37 = nil
local u38 = false
local n3 = 0
local t5 = {}
local t6 = {
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
local u44 = false

function setCloneDirty(b1: boolean) -- line: 93
	-- upvalues: n2 (ref)
	if b1 then
		n2 = 0.35

		return
	end

	n2 = 0
end
function createCloneAnchor() -- line: 101
	-- upvalues: u29 (ref), ViewportFrame (ref)
	if u29 ~= nil then
		u29:Destroy()
		u29 = nil
	end

	local WorldModel = Instance.new("WorldModel")

	WorldModel.Parent = ViewportFrame
	u29 = WorldModel
end

local function clearObserver(s1: string) -- line: 113
	-- upvalues: t5 (copy)
	if t5[s1] then
		t5[s1]:Disconnect()
		t5[s1] = nil
	end
end

function clearCloneCharacter() -- line: 120
	-- upvalues: u30 (ref), u29 (ref)
	if u30 then
		u30:Destroy()
		u30 = nil
	end

	if not u29 then
		warn("cloneAnchor is nil, this shouldn't be possible")

		return
	end

	assert(u29 ~= nil)

	local SelfAvatar = u29:FindFirstChild("SelfAvatar")

	if SelfAvatar then
		SelfAvatar:Destroy()
	end

	createCloneAnchor()
end

local function clearClone() -- line: 139
	-- upvalues: t5 (copy), t3 (ref), u10 (ref), u21 (ref)
	stopRenderStepped()

	if t5.AnimationPlayed then
		t5.AnimationPlayed:Disconnect()
		t5.AnimationPlayed = nil
	end

	if t5.AnimationPlayedCoreScript then
		t5.AnimationPlayedCoreScript:Disconnect()
		t5.AnimationPlayedCoreScript = nil
	end

	for _, v63 in t3 do
		if v63 then
			v63:Stop(0)
		end
	end

	if u10 then
		u10:Stop(0)
		u10 = nil
	end

	u21 = nil
	t3 = {}
	clearCloneCharacter()
end
local function syncTrack(p1, p2) -- line: 160
	-- upvalues: u10 (ref), TrackerStreamAnimation (ref), LocalPlayer (copy), t1 (copy)
	if not p1 or not p2.Animation then
		return
	end

	local u66 = nil

	if not p2.Animation or not p2.Animation:IsA("Animation") then
		if p2.Animation and p2.Animation:IsA("TrackerStreamAnimation") then
			if u10 then
				u10:Stop(0)
			end

			TrackerStreamAnimation = Instance.new("TrackerStreamAnimation")
			assert(TrackerStreamAnimation ~= nil)

			if game:GetEngineFeature("UseNewLoadStreamAnimationAPI") then
				u10 = p1:LoadStreamAnimationV2(TrackerStreamAnimation, LocalPlayer, false, false)
			else
				u10 = p1:LoadStreamAnimationForSelfieView_deprecated(TrackerStreamAnimation, LocalPlayer)
			end

			u66 = u10
		else
			warn("No animation to clone in SelfView")
		end
	end

	if u66 then
		u66:Play()
		u66.Priority = p2.Priority
		t1[p2] = p2.Stopped:Connect(function() -- line: 192
			-- upvalues: u66 (ref), t1 (copy), p2 (copy)
			u66:Stop(0)

			if t1[p2] then
				t1[p2]:Disconnect()
			end
		end)
	end
end
local function updateClone(p3) -- line: 201
	-- upvalues: clearClone (copy), ModelUtils (copy), u30 (ref), t2 (copy), u29 (ref), Camera (ref), CFrameUtility (copy), CharacterUtility (copy), vector3 (ref), n1 (ref), clone (ref), u33 (ref), cloneCFrame (ref), u21 (ref), EngineFeature (copy), v11 (copy), TrackerStreamAnimation (ref), syncTrack (copy), t5 (copy)
	clearClone()

	if not p3 then
		return
	end

	assert(p3 ~= nil)
	startRenderStepped(p3)

	local _ = p3.Character

	if not p3 or not p3.Character then
		return
	end

	local Character = p3.Character

	if not Character then
		return
	end

	assert(Character ~= nil)

	local v70 = ModelUtils.getAnimator(Character, 10)

	clearCloneCharacter()

	local Archivable = Character.Archivable

	Character.Archivable = true

	local v72 = ModelUtils.getHead(Character)

	if not v72 then
		return
	end

	u30 = Character:Clone()

	if u30 == nil then
		return
	end

	assert(u30 ~= nil)
	ModelUtils.resetPartOrientation(u30)
	ModelUtils.updateTransparency(u30, t2)
	ModelUtils.removeTags(u30)
	u30.Name = "SelfAvatar"
	ModelUtils.removeScripts(u30)
	ModelUtils.sanitizeCharacter(u30)
	Character.Archivable = Archivable
	u30.Parent = u29

	local HumanoidRootPart = u30:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		HumanoidRootPart.CFrame = CFrame.new((Vector3.new(0, 0, 0)))
		assert(Camera ~= nil)

		if v72 then
			local v74 = ModelUtils.getHead(u30)

			if v74 then
				assert(v74 ~= nil)

				local v75 = CFrameUtility.CalculateTargetCFrame(v74.CFrame)
				local v76, v77 = CharacterUtility.CalculateHeadExtents(u30, v75)
				local vector3_2 = Vector3.new(v76.X, v76.Y, v76.Z)

				vector3 = Vector3.new(v77.X, v77.Y, v77.Z) - vector3_2
				assert(vector3 ~= nil)
				n1 = v74.Size.Y
				math.min(vector3.X, vector3.Y)

				local v79 = math.min(vector3.X, vector3.Z)
				local Model = Instance.new("Model")

				Model.Parent = u30

				local v81 = ModelUtils.getHead(u30)

				Character.Archivable = true
				clone = v81:Clone()
				assert(clone ~= nil)
				clone.CanCollide = false
				clone.Parent = Model
				u33 = ModelUtils.getNeck(u30, clone)
				cloneCFrame = clone.CFrame
				clone:Destroy()
				assert(cloneCFrame ~= nil)

				local v82 = cloneCFrame.Position + cloneCFrame.LookVector * (v79 * 2)

				Camera.CFrame = CFrame.lookAt(v82 + Vector3.new(0, 0.10499999672174454, -0.25), cloneCFrame.Position)
				Camera.Focus = cloneCFrame
				Character.Archivable = Archivable
				Model:Destroy()
			end
		else
			local v83 = HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector * 2.5

			Camera.CFrame = CFrame.lookAt(v83 + Vector3.new(0, 1.5, 0), HumanoidRootPart.Position)
			Camera.CFrame = CFrame.new(Camera.CFrame.Position) * CFrame.Angles(-0.0006981317007977319, 3.141592653589793, 0)
		end
	end

	if u30 == nil then
		return
	end

	local Humanoid = u30:FindFirstChildWhichIsA("Humanoid")

	if Humanoid then
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end

	u21 = ModelUtils.getAnimator(u30, 0)

	if u21 then
		if not EngineFeature or not v11 then
			local PlayingAnimationTracks = u21:GetPlayingAnimationTracks()
			local PlayingAnimationTracksCoreScript = u21:GetPlayingAnimationTracksCoreScript()

			for _, v in ipairs(PlayingAnimationTracks) do
				if v ~= nil then
					v:Stop(0)
					v:Destroy()
				end
			end

			for _, v in ipairs(PlayingAnimationTracksCoreScript) do
				if v ~= nil then
					v:Stop(0)
					v:Destroy()
				end
			end

			if TrackerStreamAnimation then
				TrackerStreamAnimation:Destroy()
				TrackerStreamAnimation = nil
			end
		end

		if v70 then
			if EngineFeature and v11 then
				u21:SynchronizeWith(v70)
			else
				for _, v in ipairs(v70:GetPlayingAnimationTracksCoreScript()) do
					syncTrack(u21, v)
				end

				t5.AnimationPlayedCoreScript = v70.AnimationPlayedCoreScript:Connect(function(p4) -- line: 389
					-- upvalues: syncTrack (copy), u21 (ref)
					syncTrack(u21, p4)
				end)
			end

			setCloneDirty(false)

			return
		end
	end
end
local function hasProperty(p5, p6) -- line: 405
	local _ = p5[p6]
end

function updateCachedHeadColor(p7) -- line: 412
	-- upvalues: p7Color (ref), p7Size (ref)
	if p7 == nil then
		return
	end

	assert(p7 ~= nil)

	if pcall(function() -- line: 418
		-- upvalues: p7 (copy)
		local _ = p7.Color
	end) then
		p7Color = p7.Color

		if pcall(function() -- line: 424
			-- upvalues: p7 (copy)
			local _ = p7.Size
		end) then
			p7Size = p7.Size
		end
	end
end

local function addHumanoidStateChangedObserver(p8) -- line: 435
	-- upvalues: t5 (copy)
	if not p8 then
		return
	end

	if not t5.HumanoidStateChanged then
		t5.HumanoidStateChanged = p8.StateChanged:Connect(function(oldState, newState) -- line: 440
			if oldState == Enum.HumanoidStateType.PlatformStanding and newState == Enum.HumanoidStateType.Running then
				setCloneDirty(true)
			end

			if newState == Enum.HumanoidStateType.GettingUp then
				setCloneDirty(true)
			end
		end)
	end
end
local function addFaceControlsObserver(p9) -- line: 453
	-- upvalues: t5 (copy)
	if not t5.FaceControlsChanged then
		t5.FaceControlsChanged = p9.InternalFacsOverrideChanged:Connect(function() -- line: 455
			setCloneDirty(true)
		end)
	end
end
local function characterAdded(p10) -- line: 461
	-- upvalues: ViewportFrame (ref), u35 (ref), u31 (ref), ModelUtils (copy), t5 (copy), t6 (copy), u38 (ref)
	if ViewportFrame == nil or u35 == nil then
		return
	end

	if not p10 then
		return
	end

	u31 = ModelUtils.getHead(p10)
	updateCachedHeadColor(u31)

	if t5.DescendantAdded then
		t5.DescendantAdded:Disconnect()
		t5.DescendantAdded = nil
	end

	if t5.DescendantRemoving then
		t5.DescendantRemoving:Disconnect()
		t5.DescendantRemoving = nil
	end

	if t5.HeadSize then
		t5.HeadSize:Disconnect()
		t5.HeadSize = nil
	end

	if t5.Color then
		t5.Color:Disconnect()
		t5.Color = nil
	end

	local Humanoid = p10:FindFirstChildWhichIsA("Humanoid")

	if Humanoid then
		if Humanoid and not t5[t6.HumanoidStateChanged] then
			t5[t6.HumanoidStateChanged] = Humanoid.StateChanged:Connect(function(oldState, newState) -- line: 440
				if oldState == Enum.HumanoidStateType.PlatformStanding and newState == Enum.HumanoidStateType.Running then
					setCloneDirty(true)
				end

				if newState == Enum.HumanoidStateType.GettingUp then
					setCloneDirty(true)
				end
			end)
		end
	end

	local FaceControls = p10:FindFirstChildWhichIsA("FaceControls", true)

	if FaceControls and not t5[t6.FaceControlsChanged] then
		t5[t6.FaceControlsChanged] = FaceControls.InternalFacsOverrideChanged:Connect(function() -- line: 455
			setCloneDirty(true)
		end)
	end

	t5.DescendantAdded = p10.DescendantAdded:Connect(function(descendant) -- line: 491
		-- upvalues: ViewportFrame (ref), u35 (ref), u31 (ref), ModelUtils (copy), p10 (copy), t5 (copy), t6 (copy)
		if ViewportFrame == nil or u35 == nil then
			return
		end

		if descendant.Name == "Head" then
			u31 = ModelUtils.getHead(p10)
			updateCachedHeadColor(u31)
		end

		if descendant:IsA("Humanoid") and descendant and not t5[t6.HumanoidStateChanged] then
			t5[t6.HumanoidStateChanged] = descendant.StateChanged:Connect(function(oldState, newState) -- line: 440
				if oldState == Enum.HumanoidStateType.PlatformStanding and newState == Enum.HumanoidStateType.Running then
					setCloneDirty(true)
				end

				if newState == Enum.HumanoidStateType.GettingUp then
					setCloneDirty(true)
				end
			end)
		end

		if descendant:IsA("FaceControls") and not t5[t6.FaceControlsChanged] then
			t5[t6.FaceControlsChanged] = descendant.InternalFacsOverrideChanged:Connect(function() -- line: 455
				setCloneDirty(true)
			end)
		end

		if ModelUtils.shouldMarkCloneDirtyForDescendant(descendant) then
			setCloneDirty(true)
		end
	end)
	t5.DescendantRemoving = p10.DescendantRemoving:Connect(function(descendant) -- line: 514
		-- upvalues: ViewportFrame (ref), u35 (ref), ModelUtils (copy)
		if ViewportFrame == nil or u35 == nil then
			return
		end

		if descendant and (descendant:IsA("MeshPart") or descendant:IsA("Accessory")) then
			if descendant:IsA("MeshPart") and descendant.MeshId == "" then
				return
			end

			if ModelUtils.shouldMarkCloneDirtyForDescendant(descendant) then
				setCloneDirty(true)
			end
		end
	end)
	setCloneDirty(true)
	u38 = true
end
local function createViewport() -- line: 536
	-- upvalues: ViewportFrame (ref), u35 (ref), Camera (ref)
	if ViewportFrame then
		ViewportFrame:Destroy()
	end

	ViewportFrame = Instance.new("ViewportFrame")
	ViewportFrame.Position = UDim2.new(0, 0, 0, 0)
	ViewportFrame.Size = UDim2.new(1, 0, 1, 0)
	ViewportFrame.BackgroundTransparency = 1
	ViewportFrame.Parent = u35
	ViewportFrame.Ambient = Color3.new(0.7529411765, 0.7098039216, 0.7137254902)
	ViewportFrame.LightColor = Color3.new(1, 0.9960784314, 0.9960784314)
	ViewportFrame.LightDirection = Vector3.new(9.5, -12, 7.5)
	ViewportFrame.IsMirrored = true
	Instance.new("UICorner")
	Instance.new("UICorner").Parent = ViewportFrame
	createCloneAnchor()

	if u35 then
		u35.Destroying:Connect(clearViewportFrame)
	end

	Camera = Instance.new("Camera")
	assert(Camera ~= nil)
	Camera.FieldOfView = 70
	ViewportFrame.CurrentCamera = Camera
	Camera.Parent = ViewportFrame
end

function ReInit(p11) -- line: 570
	-- upvalues: GetFFlagSelfViewVisibilityFix (copy), u37 (ref), u44 (ref), u31 (ref), ModelUtils (copy), t5 (copy), clearClone (copy), createViewport (copy)
	assert(p11.Character ~= nil)

	if GetFFlagSelfViewVisibilityFix() and u37 and not u37.Visible then
		u44 = false

		return
	end

	u31 = ModelUtils.getHead(p11.Character)
	updateCachedHeadColor(u31)
	setCloneDirty(false)

	if t5.CharacterAdded then
		t5.CharacterAdded:Disconnect()
		t5.CharacterAdded = nil
	end

	if t5.CharacterRemoving then
		t5.CharacterRemoving:Disconnect()
		t5.CharacterRemoving = nil
	end

	clearClone()
	createViewport()
	playerAdded(p11)
	startRenderStepped(p11)
end

local function onCharacterAdded(p12) -- line: 592
	-- upvalues: u18 (ref), u38 (ref), characterAdded (copy), LocalPlayer (copy), t5 (copy), t6 (copy)
	if u18 then
		u18:Disconnect()
	end

	if not u38 then
		characterAdded(p12)
	else
		ReInit(LocalPlayer)
	end

	if t5.HumanoidStateChanged then
		t5.HumanoidStateChanged:Disconnect()
		t5.HumanoidStateChanged = nil
	end

	local Humanoid = p12:FindFirstChildWhichIsA("Humanoid")

	if Humanoid then
		if not Humanoid then
			return
		end

		if not t5[t6.HumanoidStateChanged] then
			t5[t6.HumanoidStateChanged] = Humanoid.StateChanged:Connect(function(oldState, newState) -- line: 440
				if oldState == Enum.HumanoidStateType.PlatformStanding and newState == Enum.HumanoidStateType.Running then
					setCloneDirty(true)
				end

				if newState == Enum.HumanoidStateType.GettingUp then
					setCloneDirty(true)
				end
			end)
		end
	end
end
local function FindInParents(s2: string?) -- line: 610
	-- upvalues: u35 (ref)
	if not s2 then
		return nil
	end

	if not u35 then
		return nil
	end

	assert(u35 ~= nil, "Wrapper Frame cannot be nil")
	assert(s2 ~= nil, "Frame name cannot be nil ")

	return u35:FindFirstAncestor(s2)
end

function clearViewportFrame() -- line: 625
	-- upvalues: ViewportFrame (ref), u35 (ref)
	if ViewportFrame then
		ViewportFrame:Destroy()
	end

	u35 = nil
	stopRenderStepped()
end

local function onOuterContainerVisibilityChanged() -- line: 633
	-- upvalues: u37 (ref), u38 (ref), u44 (ref)
	if u37 then
		if u37.Visible then
			if not u38 then
				return
			end

			u44 = true

			return
		end

		u44 = false
	end
end

function playerAdded(p13) -- line: 652
	-- upvalues: LocalPlayer (copy), u18 (ref), t5 (copy), onCharacterAdded (copy), characterAdded (copy), clearClone (copy)
	if p13 ~= nil and p13 == LocalPlayer then
		if u18 ~= nil then
			u18:Disconnect()
			u18 = nil

			if t5.CharacterAdded then
				t5.CharacterAdded:Disconnect()
				t5.CharacterAdded = nil
			end
		end

		local _ = p13.Character
		local Character = p13.Character

		u18 = p13.CharacterAdded:Connect(onCharacterAdded)

		if Character then
			characterAdded(Character)
		end

		t5.CharacterAdded = p13.CharacterAdded:Connect(characterAdded)
		t5.CharacterRemoving = p13.CharacterRemoving:Connect(function() -- line: 671
			-- upvalues: t5 (copy), clearClone (copy)
			if t5.DescendantAdded then
				t5.DescendantAdded:Disconnect()
				t5.DescendantAdded = nil
			end

			if t5.DescendantRemoving then
				t5.DescendantRemoving:Disconnect()
				t5.DescendantRemoving = nil
			end

			if t5.HeadSize then
				t5.HeadSize:Disconnect()
				t5.HeadSize = nil
			end

			if t5.Color then
				t5.Color:Disconnect()
				t5.Color = nil
			end

			clearClone()

			if t5.CharacterRemoving then
				t5.CharacterRemoving:Disconnect()
				t5.CharacterRemoving = nil
			end
		end)
	end
end
function stopRenderStepped() -- line: 682
	-- upvalues: u17 (ref)
	if u17 then
		u17:Disconnect()
		u17 = nil
	end
end
function updateClonePartsColor(p14) -- line: 689
	-- upvalues: u31 (ref), p7Color (ref), LocalPlayer (copy), u30 (ref)
	if pcall(function() -- line: 690
		-- upvalues: u31 (ref)
		local _ = u31.Color
	end) and (u31 and u31.Color ~= p7Color) then
		local Character = LocalPlayer.Character

		if not Character then
			return
		end

		assert(Character ~= nil)

		if not u30 then
			return
		end

		assert(u30 ~= nil)

		for _, child in pairs(Character:GetChildren()) do
			if child:IsA("MeshPart") then
				local childName = u30:FindFirstChild(child.Name)

				if childName and childName:IsA("MeshPart") and childName.Color and child.Color then
					childName.Color = child.Color
				end
			end
		end
	end

	p7Color = p14
end
function startRenderStepped(p15) -- line: 722
	-- upvalues: v12 (copy), RunService (copy), u17 (ref), GetFFlagSelfViewVisibilityFix (copy), u30 (ref), u37 (ref), u44 (ref), u21 (ref), LocalPlayer (copy), u31 (ref), ModelUtils (copy), t4 (ref), t3 (ref), UserInputService (copy), n3 (ref), clone (ref), u33 (ref), cloneCFrame (ref), Camera (ref), vector3 (ref), Service (copy), EngineFeature2 (copy), n1 (ref), p7Size (ref), p7Color (ref), n2 (ref), updateClone (copy)
	stopRenderStepped()
	u17 = ((if not v12 then RunService.RenderStepped else RunService.Heartbeat)):Connect(function(n4: number) -- line: 729
		-- upvalues: v12 (copy), GetFFlagSelfViewVisibilityFix (copy), u30 (ref), u37 (ref), u44 (ref), u21 (ref), LocalPlayer (copy), u31 (ref), ModelUtils (copy), t4 (ref), t3 (ref), UserInputService (copy), n3 (ref), clone (ref), u33 (ref), cloneCFrame (ref), Camera (ref), vector3 (ref), Service (copy), EngineFeature2 (copy), n1 (ref), p7Size (ref), p7Color (ref), n2 (ref), updateClone (copy), p15 (copy)
		if v12 then
			debug.profilebegin("faceclone")
		end

		if GetFFlagSelfViewVisibilityFix() and u30 and u37 and not u44 then
			if u21 ~= nil then
				local PlayingAnimationTracks = u21:GetPlayingAnimationTracks()

				for _, v in pairs(PlayingAnimationTracks) do
					if v ~= nil then
						v:Stop(0)
					end
				end
			end

			return
		end

		if LocalPlayer then
			local Character = LocalPlayer.Character

			if not Character or Character.Parent == nil then
				return
			end

			assert(Character ~= nil)

			if u31 == nil or Character ~= u31.Parent then
				u31 = ModelUtils.getHead(Character)
			end

			if u31 then
				local v137 = ModelUtils.getAnimator(Character, 0)

				if u21 ~= nil and v137 ~= nil then
					assert(u21 ~= nil)

					local PlayingAnimationTracks = u21:GetPlayingAnimationTracks()

					for _, v in pairs(PlayingAnimationTracks) do
						if v ~= nil then
							v:Stop(0)
						end
					end

					local PlayingAnimationTracks2 = v137:GetPlayingAnimationTracks()

					t4 = {}

					for _, v in ipairs(PlayingAnimationTracks2) do
						local Animation = v.Animation

						if Animation and Animation:IsA("Animation") and Animation.AnimationId ~= "" then
							t4[Animation.AnimationId] = v

							if not t3[Animation.AnimationId] then
								t3[Animation.AnimationId] = u21:LoadAnimation(Animation)
							end

							local v145 = t3[Animation.AnimationId]

							assert(v145 ~= nil)
							v145:Play()
							v145.TimePosition = v.TimePosition
							v145.Priority = v.Priority
							v145:AdjustWeight(v.WeightCurrent, 0.1)
						end
					end

					for v146 in t3 do
						local v147 = t3[v146]

						if v147 then
							local Animation = v147.Animation

							if Animation and not t4[Animation.AnimationId] then
								local v149 = t3[Animation.AnimationId]

								if v149 ~= nil then
									v149:Stop(0)
								end

								t3[Animation.AnimationId] = nil
							end
						end
					end

					for _, v in ipairs(v137:GetPlayingAnimationTracksCoreScript()) do
						local PlayingAnimationTracksCoreScript = u21:GetPlayingAnimationTracksCoreScript()

						for _, v2 in pairs(PlayingAnimationTracksCoreScript) do
							if v2.Animation:IsA("TrackerStreamAnimation") then
								v2.Priority = v.Priority
								v2:AdjustWeight(v.WeightCurrent, 0)
							end
						end
					end
				end
			end

			local v155 = nil
			local Platform = UserInputService:GetPlatform()

			if (Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android) and u21 ~= nil then
				local PlayingAnimationTracksCoreScript = u21:GetPlayingAnimationTracksCoreScript()

				for _, v in pairs(PlayingAnimationTracksCoreScript) do
					if v.Animation:IsA("TrackerStreamAnimation") then
						local TrackerData, v161

						TrackerData, v155, v161 = v:GetTrackerData()
					end
				end
			end

			n3 += 1

			if n3 == 1 then
				n3 = 0

				if u30 then
					if not clone then
						clone = ModelUtils.getHead(u30)

						if clone then
							u33 = ModelUtils.getNeck(u30, clone)
						end
					end

					if clone then
						cloneCFrame = clone.CFrame
					end
				end

				if Camera and clone then
					local clonePosition = clone.Position
					local clonePosition2 = clone.Position
					local _ = clone.CFrame

					if u33 then
						local Part0 = u33.Part0
						local _ = u33.Part1
						local C0 = u33.C0
						local C1 = u33.C1
						local Transform = u33.Transform

						if Part0 and C0 then
							local v170 = Part0.CFrame * C0 * Transform * C1:Inverse()

							clonePosition2 = Vector3.new(v170.Position.X * 0.25, (clone.CFrame.Position.Y + v170.Position.Y + v170.Position.Y * 0.75) * 0.33333, v170.Position.Z)
							clonePosition = Vector3.new(v170.Position.X * 0.6, (clone.CFrame.Position.Y + v170.Position.Y + v170.Position.Y * 0.75) * 0.33333, v170.Position.Z)
						end
					end

					if not vector3 then
						warn("boundsSize is nil, this shouldn't be possible")
					end

					assert(vector3 ~= nil)

					if Service and Service.VideoAnimationEnabled and (v155 ~= nil or EngineFeature2) then
						if EngineFeature2 then
							local DeviceCameraCFrameForSelfView = game:GetService("PlayerViewService"):GetDeviceCameraCFrameForSelfView()
							local DeviceCameraCFrameForSelfViewPosition = DeviceCameraCFrameForSelfView.Position
							local v173, v174, v175 = DeviceCameraCFrameForSelfView:ToEulerAnglesYXZ()
							local cFrame = CFrame.fromEulerAnglesYXZ(v173, v174, v175)
							local n5 = 0

							if DeviceCameraCFrameForSelfViewPosition.Z > 0 then
								n5 = math.clamp(0.5 - DeviceCameraCFrameForSelfViewPosition.Z * 3, -0.5, 0.5)
							end

							local v178 = -(vector3.Z + 1)
							local vector3_3 = Vector3.new(0, 0.105, math.floor((v178 + n5 * v178) * 100) / 100)

							Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(cFrame * (clonePosition + vector3_3), clonePosition2), 0.5)
						elseif v155 then
							local vector3_4 = Vector3.new(0, 0.105, -(vector3.Z + 1))
							local v181, v182, v183 = v155:ToEulerAnglesXYZ()
							local cFrame = CFrame.Angles(-v181 * 0.5, -v182 * 0.5, -v183 * 0.5)

							Camera.CFrame = CFrame.lookAt(cFrame * (clonePosition + vector3_4), clonePosition2)
						end
					else
						local vector3_5 = Vector3.new(0, n1 * 0.25 - 1.25, -(vector3.Z + 1) + 0.125)

						if Character then
							local Head = Character:FindFirstChild("Head")

							if Head then
								local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

								if HumanoidRootPart then
									local v188 = HumanoidRootPart.CFrame:Inverse() * Head.CFrame
									local vector3_6 = Vector3.new(v188.Position.X * 0.15 + 0.125, v188.Position.Y, v188.Position.Z * 0.05)

									Camera.CFrame = CFrame.lookAt(clonePosition + vector3_5 + vector3_6, clonePosition2)
									Camera.Focus = clone.CFrame
								end
							end
						end
					end
				end
			end

			if u31 then
				if u31.Size ~= p7Size then
					p7Size = u31.Size
					setCloneDirty(true)
				end

				if pcall(function() -- line: 983
					-- upvalues: u31 (ref)
					local _ = u31.Color
				end) and u31.Color ~= p7Color then
					updateClonePartsColor(u31.Color)
				end
			end
		end

		if n2 > 0 then
			n2 -= n4

			if n2 <= 0 then
				updateClone(p15)
				n2 = 0
			end
		end

		if v12 then
			debug.profileend()
		end
	end)
end

local function Initialize(p16, p17, s3: string?) -- line: 1007
	-- upvalues: u35 (ref), GetFFlagSelfViewVisibilityFix (copy), u36 (ref), u37 (ref), onOuterContainerVisibilityChanged (copy), createViewport (copy), Players (copy), LocalPlayer (copy), t5 (copy), clearClone (copy)
	if p17 then
		u35 = p17

		if GetFFlagSelfViewVisibilityFix() and s3 then
			u36 = s3

			local v118 = u36
			local v119

			if not v118 then
				v119 = nil
			elseif not u35 then
				v119 = nil
			else
				assert(u35 ~= nil, "Wrapper Frame cannot be nil")
				assert(v118 ~= nil, "Frame name cannot be nil ")
				v119 = u35:FindFirstAncestor(v118)
			end

			u37 = v119

			if u37 then
				u37:GetPropertyChangedSignal("Visible"):Connect(onOuterContainerVisibilityChanged)
			end
		end

		createViewport()
		playerAdded(p16)
		Players.PlayerAdded:Connect(playerAdded)
		Players.PlayerRemoving:Connect(function(player) -- line: 1035
			-- upvalues: LocalPlayer (copy), t5 (copy), clearClone (copy)
			if player == LocalPlayer then
				if t5.HumanoidStateChanged then
					t5.HumanoidStateChanged:Disconnect()
					t5.HumanoidStateChanged = nil
				end

				if t5.CharacterAdded then
					t5.CharacterAdded:Disconnect()
					t5.CharacterAdded = nil
				end

				if t5.CharacterRemoving then
					t5.CharacterRemoving:Disconnect()
					t5.CharacterRemoving = nil
				end

				if t5.FaceControlsChanged then
					t5.FaceControlsChanged:Disconnect()
					t5.FaceControlsChanged = nil
				end

				clearClone()
			end
		end)
		startRenderStepped(p16)

		return clearClone
	end
end

return Initialize
