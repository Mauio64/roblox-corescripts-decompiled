local AnimationClipProvider = game:GetService("AnimationClipProvider")
local InsertService = game:GetService("InsertService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local defineFastString = game:DefineFastString("EmoteUtilityFallbackKeyframeSequenceAssetId", "10921261056")
local defineFastFlag = game:DefineFastFlag("EmoteUtilityDefaultMoodFromCharacter", false)
local defineFastFlag2 = game:DefineFastFlag("EmoteUtilityUseIdleAnimationFallback", false)

local defineFastFlag3 = game:DefineFastFlag("EmoteUtilityReportPoseAnimationDownloadFailure", false)
local defineFastFlag4 = game:DefineFastFlag("EmoteUtilityRetargetPoses", false)

local defineFastString2 = game:DefineFastString("EmoteUtilityCanonicalR15RigUri", "rbxasset://avatar/characterR15.rbxm")
local defineFastFlag5 = game:DefineFastFlag("EmoteUtilityCurveRotationOnlyJoints", false)

local EmoteUtility = {}
EmoteUtility.FallbackKeyframeSequenceAssetId = defineFastString
EmoteUtility.debugLoadAssetsFromFiles = false
EmoteUtility.mapAssetIdToFileName = nil
EmoteUtility.EmoteUtilitySupportAJU = true
EmoteUtility.FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL = "http://www.roblox.com/asset/?id=" .. defineFastString

local set = {}

local function clearJointBlacklist() -- 4 equivalent calls inferred from this helper
	set = {}
end

local function blacklistJoint(jointBetween) -- 1 equivalent call inferred from this helper
	set[jointBetween] = true
end

local function jointIsBlacklisted(jointBetween): boolean -- 1 equivalent call inferred from this helper
	return if set[jointBetween] then true else false
end

local function getCameraOffset(p: number, extentsSize: Vector3) -- 1 equivalent call inferred from this helper
	local x = extentsSize.X
	local y = extentsSize.Y
	local z = extentsSize.Z

	local v = math.sqrt(x ^ 2 + y ^ 2 + z ^ 2)
	local v2 = 1 / math.tan(math.rad(p) / 2)

	return v / 2 * v2
end

local function isOnRCC()
	local success, result = pcall(function(): boolean
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)

	return success and result
end

local function getAnalyticsTarget(): string
	local success, result = pcall(function(): boolean
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)
	return if success and result then "RCC" else "Client"
end

local function reportCounter(p: string, flag: boolean)
	local success, result = pcall(function(): boolean
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)

	RbxAnalyticsService:ReportCounter((success and result and "RCC" or "Client") .. "_" .. p .. "_" .. (flag and "Success" or "Failure"))
end

local function getAnimationAndIsIdle(animationAssetIdOrUrl)
	assert(
		typeof(animationAssetIdOrUrl) == "number" or typeof(animationAssetIdOrUrl) == "string",
		"getAnimationAndIsIdle expects animationAssetIdOrUrl to be a number or string"
	)

	local v = nil
	local success, v2

	if typeof(animationAssetIdOrUrl) == "number" then
		local v3
		success, v3 = EmoteUtility.LoadAsset(animationAssetIdOrUrl)

		if success and v3 then
			v = v3:GetChildren()[1]
		end

		v2 = "EmoteUtility_LoadAsset"
	else
		local result
		success, result = pcall(function()
			return game:GetObjects(animationAssetIdOrUrl)[1]
		end)
		v = success and result or v
		v2 = "EmoteUtility_GetObjects"
	end

	local function fn(): boolean
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end

	local success2, result = pcall(fn)

	RbxAnalyticsService:ReportCounter((success2 and result and "RCC" or "Client") .. "_" .. v2 .. "_" .. (success and "Success" or "Failure"))

	if success and v then
		assert(v, "animation is non-nil. Silence type checker.")
		local v3

		if v.ClassName == "Folder" then
			v3 = true
			local v4 = v:FindFirstChild("Pose", true) or v:FindFirstChild("pose", true)

			if v4 == nil then
				v4 = v:FindFirstChild("Idle", true) or v:FindFirstChild("idle", true)
			end

			if v4 then
				v = v4:FindFirstChildWhichIsA("Animation", true)
			else
				v = v:FindFirstChildWhichIsA("Animation", true)
			end
		else
			v3 = false
		end

		return v, v3
	else
		local v3 = v2 .. "_Failed"
		local success3, result2 = pcall(fn)

		RbxAnalyticsService:SendEventDeferred(
			success3 and result2 and "RCC" or "Client",
			"EmoteUtility_getPoseAsset",
			v3,
			{ animationAssetIdOrUrl = animationAssetIdOrUrl }
		)

		return nil, nil
	end
end

local function getAnimationClipByAssetId(keyframeSequenceId: string)
	local result = nil
	local success

	if EmoteUtility.debugLoadAssetsFromFiles then
		local v = nil

		for k in string.gmatch(keyframeSequenceId, ".*id=([0-9]+)") do
			v = k
		end

		assert(v, "assetId should be non-nil")
		local v2 = tonumber(v)
		assert(v2, "assetIdAsNumber should be non-nil")
		local v3
		success, v3 = EmoteUtility.LoadAsset(v2)

		if success and v3 then
			result = v3
		end
	else
		success, result = pcall(function()
			return AnimationClipProvider:GetAnimationClipAsync(keyframeSequenceId)
		end)
	end

	local function fn(): boolean
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end

	local success2, result2 = pcall(fn)

	RbxAnalyticsService:ReportCounter((success2 and result2 and "RCC" or "Client") .. "_" .. "EmoteUtility_GetAnimationClipAsync" .. "_" .. (success and "Success" or "Failure"))

	if success then
		return result
	end

	local success3, result3 = pcall(fn)

	RbxAnalyticsService:SendEventDeferred(
		success3 and result3 and "RCC" or "Client",
		"EmoteUtility_GetAnimationClip",
		"EmoteUtility_GetAnimationClip_GetAnimationClipAsyncFailed",
		{ keyframeSequenceId = keyframeSequenceId }
	)

	return nil
end

local function getThumbnailKeyframeFromAnimationOrUrl(keyframeSequenceId, p: number, p2: number?)
	local v = nil
	local instance

	if typeof(keyframeSequenceId) == "string" then
		instance = getAnimationClipByAssetId(keyframeSequenceId)
	else
		p2 = EmoteUtility.GetNumberValueWithDefault(keyframeSequenceId, "ThumbnailKeyframe", p2)
		v = EmoteUtility.GetNumberValueWithDefault(keyframeSequenceId, "ThumbnailTime", nil)
		instance = EmoteUtility.GetAnimationClip(keyframeSequenceId)
	end

	if not instance then
		return nil
	end

	local animationRigData = instance:FindFirstChildOfClass("AnimationRigData")

	if instance:IsA("KeyframeSequence") then
		return EmoteUtility.GetThumbnailKeyframe(p2, instance, p), animationRigData
	end

	if instance:IsA("CurveAnimation") then
		return EmoteUtility.GetThumbnailKeyframeFromCurve(v, instance, p), animationRigData
	end

	error("Unsupported Animation type:" .. instance.ClassName)
	return nil
end

local function trySetProperty(child, name: string, value) -- 1 equivalent call inferred from this helper
	pcall(function()
		child[name] = value
	end)
end

local function applyControlsFolder(instance, p, instance2)
	if not p then
		return
	end

	assert(p, "parentPose is non-nil. Silence type checker.")

	local child = instance:FindFirstChild(p.Name)

	if not child then
		return
	end

	local child2 = child:FindFirstChild(instance2.Name)

	if not child2 then
		return
	end

	for _, numberPose in instance2:GetChildren() do
		if numberPose:IsA("NumberPose") then
			trySetProperty(child2, numberPose.Name, numberPose.Value) -- inferred equivalent call
		end
	end
end

local function applyKeyframeControls(instance, moodKeyframe)
	local function recurApplyControls(p, folder)
		if folder:IsA("Folder") then
			applyControlsFolder(instance, p, folder)
			return
		end

		for _, child in folder:GetChildren() do
			recurApplyControls(folder, child)
		end
	end

	if moodKeyframe then
		for _, v in moodKeyframe:GetPoses() do
			recurApplyControls(nil, v)
		end
	end
end

local function applyKeyframeInner(instance, object)
	local function recurApplyPoses(folder, child)
		if folder and child:IsA("Pose") then
			local child2 = instance:FindFirstChild(folder.Name)
			local child3 = instance:FindFirstChild(child.Name)
			local jointBetween = EmoteUtility.GetJointBetween(child2, child3)
			local v

			if jointBetween then
				v = not jointIsBlacklisted(jointBetween) -- inferred equivalent call
			else
				v = jointBetween
			end

			if v then
				assert(jointBetween, "joint is non-nil. Silence type checker.")

				jointBetween.Transform = child.CFrame
				blacklistJoint(jointBetween) -- inferred equivalent call
			end
		end

		if child:IsA("Folder") then
			applyControlsFolder(instance, folder, child)
			return
		end

		for _, child2 in child:GetChildren() do
			recurApplyPoses(child, child2)
		end
	end

	if object then
		for _, folder in pairs(object:GetPoses()) do
			if folder:IsA("Folder") then
				continue
			end

			for _, child in folder:GetChildren() do
				recurApplyPoses(folder, child)
			end
		end
	end
end

local function getRotatedKeyframe(instance, p: number?)
	if not p or p == 0 then
		return instance
	end

	assert(p, "rotationDegrees is non-nil. Silence type checker.")

	local clone = instance:Clone()

	local v = clone:GetPoses()[1]

	local v2 = v and v:GetSubPoses()[1]

	if v2 then
		v2.CFrame *= CFrame.Angles(0, math.rad(p), 0)
	end

	return clone
end

local function getRotationCFrame(rotation, time: number)
	if rotation:IsA("EulerRotationCurve") then
		return rotation:GetRotationAtTime(time)
	end

	if rotation:IsA("RotationCurve") then
		return rotation:GetValueAtTime(time)
	end

	error("Unsupported rotation type:" .. rotation.ClassName)
	return nil
end

local function findAttachmentsRecur(instance, childrenByName)
	for _, child in pairs(instance:GetChildren()) do
		if child:IsA("Attachment") then
			childrenByName[child.Name] = child
		elseif not (child:IsA("Tool") or child:IsA("Accoutrement")) then
			findAttachmentsRecur(child, childrenByName)
		end
	end
end

local function findAttachmentsInTool(instance) -- 1 equivalent call inferred from this helper
	local attachmentsInTool = {}
	findAttachmentsRecur(instance, attachmentsInTool)
	return attachmentsInTool
end

local function findAttachmentsInCharacter(parent) -- 1 equivalent call inferred from this helper
	local attachmentsInCharacter = {}
	findAttachmentsRecur(parent, attachmentsInCharacter)
	return attachmentsInCharacter
end

local function weldAttachments(instance, instance2) -- 1 equivalent call inferred from this helper
	local weld = Instance.new("Weld")
	weld.Part0 = instance.Parent
	weld.Part1 = instance2.Parent
	weld.C0 = instance.CFrame
	weld.C1 = instance2.CFrame
	weld.Parent = instance.Parent
	return weld
end

local function attachToolToCharacter(parent, object, instance)
	local attachmentsInCharacter = findAttachmentsInCharacter(parent) -- inferred equivalent call
	local attachmentsInTool = findAttachmentsInTool(instance) -- inferred equivalent call
	local flag = false

	for _, v in pairs(attachmentsInTool) do
		local v2 = attachmentsInCharacter[v.Name]

		if not v2 then
			continue
		end

		weldAttachments(v2, v) -- inferred equivalent call
		flag = true
	end

	if flag then
		instance.Parent = parent
		return
	end

	instance.Parent = nil
	local handle = instance:FindFirstChild("Handle")
	local grip = instance.Grip

	local rightGripAttachment = handle and grip and attachmentsInCharacter.RightGripAttachment

	if rightGripAttachment then
		handle.CFrame = rightGripAttachment.Parent.CFrame * rightGripAttachment.CFrame * grip:Inverse()
	end

	object:EquipTool(instance)
end

local function getToolBodyLayersInPriorityOrder(data)
	local toolBodyLayersInPriorityOrder = {}
	local function addLayer(keyframe, sourceRig) -- 3 equivalent calls inferred from this helper
		if keyframe then
			table.insert(toolBodyLayersInPriorityOrder, {
				keyframe = keyframe,
				sourceRig = sourceRig
			})
		end
	end

	if data.suggestedKeyframeFromTool then
		addLayer(data.suggestedKeyframeFromTool, data.suggestedToolSourceRig) -- inferred equivalent call

		local poseKeyframe = data.poseKeyframe
		local poseSourceRig = data.poseSourceRig

		if poseKeyframe then
			table.insert(toolBodyLayersInPriorityOrder, {
				keyframe = poseKeyframe,
				sourceRig = poseSourceRig
			})
			return toolBodyLayersInPriorityOrder
		end
	else
		addLayer(data.defaultToolKeyframe, data.defaultToolSourceRig) -- inferred equivalent call

		if data.originalAnimationAssetId ~= nil then
			addLayer(data.poseKeyframe, data.poseSourceRig) -- inferred equivalent call
		end
	end

	return toolBodyLayersInPriorityOrder
end

local function applyR15KeyframeWithTool(instance, humanoid, tool, data)
	for _, v in getToolBodyLayersInPriorityOrder(data) do
		applyKeyframeInner(instance, v.keyframe)
	end

	attachToolToCharacter(instance, humanoid, tool)
end

local function rotationBetween(vector: Vector3, vector3: Vector3)
	local cross = vector:Cross(vector3)

	if cross.Magnitude < 1e-6 then
		return CFrame.new()
	end

	return CFrame.fromAxisAngle(cross.Unit, (math.atan2(cross.Magnitude, (vector:Dot(vector3)))))
end

local function asAnimatableJoint(instance) -- 2 equivalent calls inferred from this helper
	if
		instance and instance:IsA("Motor6D")
		or instance and instance:IsA("AnimationConstraint") and instance.Attachment0 and instance.Attachment1
	then
		return instance
	end

	return nil
end

local function findJointInPart(instance, childName: string, childName2: string) -- 3 equivalent calls inferred from this helper
	local child = instance:FindFirstChild(childName)
	local child2 = child and child:FindFirstChild(childName2)
	return asAnimatableJoint(child2) -- inferred equivalent call
end

local function findBodyJoint(parent, name: string)
	for _, part in parent:GetChildren() do
		if not part:IsA("BasePart") then
			continue
		end

		local bone = part:FindFirstChild(name, true)

		if bone then
			if not bone:IsA("Bone") and not asAnimatableJoint(bone) then -- inferred equivalent call
				continue
			end

			return bone
		end
	end

	return nil
end

local function getJointLocalFrames(motor6D) -- 2 equivalent calls inferred from this helper
	if motor6D:IsA("Motor6D") then
		return motor6D.C0, motor6D.C1
	end

	local function inPart(instance)
		local cframe = instance.CFrame
		local parent = instance.Parent

		while parent and parent:IsA("Bone") do
			cframe = parent.CFrame * cframe
			parent = parent.Parent
		end

		return cframe
	end

	return inPart(motor6D.Attachment0), inPart(motor6D.Attachment1)
end

local function getArmRestGeometry(instance, p: string)
	local jointInPart = findJointInPart(instance, p .. "UpperArm", p .. "Shoulder") -- inferred equivalent call
	local jointInPart2 = findJointInPart(instance, p .. "LowerArm", p .. "Elbow") -- inferred equivalent call
	local jointInPart3 = findJointInPart(instance, p .. "Hand", p .. "Wrist") -- inferred equivalent call

	if not (jointInPart and jointInPart2 and jointInPart3) then
		return nil
	end

	local jointLocalFrames, cframe = getJointLocalFrames(jointInPart) -- inferred equivalent call
	local jointLocalFrames2, cframe2 = getJointLocalFrames(jointInPart2) -- inferred equivalent call
	local v

	if jointInPart3:IsA("Motor6D") then
		v = jointInPart3.C0
		local _c1 = jointInPart3.C1
	else
		local function inPart(instance2)
			local cframe3 = instance2.CFrame
			local parent = instance2.Parent

			while parent and parent:IsA("Bone") do
				cframe3 = parent.CFrame * cframe3
				parent = parent.Parent
			end

			return cframe3
		end

		v = inPart(jointInPart3.Attachment0)
		inPart(jointInPart3.Attachment1)
	end

	local v2 = jointLocalFrames * cframe:Inverse()
	local elbowFrame = v2 * jointLocalFrames2
	local v3 = elbowFrame * cframe2:Inverse()
	local v4 = v3 * v
	return {
		shoulderFrame = jointLocalFrames,
		elbowFrame = elbowFrame,
		upperDirection = (elbowFrame.Position - v2.Position).Unit,
		lowerDirection = (v4.Position - v3.Position).Unit
	}
end

local function ensureRigDescription(parent): boolean
	if parent:FindFirstChildWhichIsA("HumanoidRigDescription", true) then
		return false
	end

	local humanoidRigDescription = Instance.new("HumanoidRigDescription")

	local jointNames = humanoidRigDescription:GetJointNames()

	for _, v in Enum.RigLabel:GetEnumItems() do
		if not table.find(jointNames, v.Name) then
			continue
		end

		local bodyJoint = findBodyJoint(parent, v.Name)

		if bodyJoint then
			humanoidRigDescription:SetJoint(v, bodyJoint)
		end
	end

	for _, v in {
		{
			name = "Right",
			outward = Vector3.new(1, 0, 0),
			shoulder = Enum.RigLabel.RightShoulder,
			elbow = Enum.RigLabel.RightElbow
		},
		{
			name = "Left",
			outward = -Vector3.new(1, 0, 0),
			shoulder = Enum.RigLabel.LeftShoulder,
			elbow = Enum.RigLabel.LeftElbow
		}
	} do
		local armRestGeometry = getArmRestGeometry(parent, v.name)

		if not armRestGeometry then
			continue
		end

		humanoidRigDescription:SetTposeAdjustment(
			v.shoulder,
			rotationBetween(
				armRestGeometry.shoulderFrame:VectorToObjectSpace(armRestGeometry.upperDirection),
				armRestGeometry.shoulderFrame:VectorToObjectSpace(v.outward)
			)
		)

		humanoidRigDescription:SetTposeAdjustment(
			v.elbow,
			rotationBetween(
				armRestGeometry.elbowFrame:VectorToObjectSpace(armRestGeometry.lowerDirection),
				armRestGeometry.elbowFrame:VectorToObjectSpace(armRestGeometry.upperDirection)
			)
		)
	end

	humanoidRigDescription.Parent = parent
	return true
end

local function restsArmsDown(instance): boolean
	for _, v in { "Right", "Left" } do
		local armRestGeometry = getArmRestGeometry(instance, v)

		if
			armRestGeometry
			and math.deg((math.acos((math.clamp(armRestGeometry.upperDirection:Dot(-Vector3.new(0, 1, 0)), -1, 1))))) > 30
		then
			return false
		end
	end

	return true
end

EmoteUtility.RestsArmsDown = restsArmsDown
EmoteUtility.EnsureRigDescription = ensureRigDescription

local v = nil

local function loadCanonicalR15Rig()
	if v then
		return
	end

	local success, result = pcall(function()
		return game:GetObjects(defineFastString2)[1]
	end)

	local v2 = nil

	if success and result and result:IsA("Model") then
		ensureRigDescription(result)
		local animationRigData = Instance.new("AnimationRigData")

		if animationRigData:LoadFromModel(result) then
			v2 = animationRigData
		end
	end

	local v3 = v2 ~= nil
	local success2, result2 = pcall(function(): boolean
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)

	RbxAnalyticsService:ReportCounter((success2 and result2 and "RCC" or "Client") .. "_" .. "EmoteUtility_GetCanonicalR15Rig" .. "_" .. (v3 and "Success" or "Failure"))

	v = v2
end

local v2 = {
	Enum.AnimationPriority.Action4,
	Enum.AnimationPriority.Action3,
	Enum.AnimationPriority.Action2,
	Enum.AnimationPriority.Action,
	Enum.AnimationPriority.Movement,
	Enum.AnimationPriority.Idle
}

local object = setmetatable({}, { __mode = "k" })

local function stopRetargetedTracks(folder)
	local v3 = object[folder]

	if not v3 then
		return
	end

	for _, v4 in v3 do
		v4:Stop(0)
		v4:Destroy()
	end

	object[folder] = nil
end

local function applyKeyframesRetargeted(folder, humanoid, items): boolean
	local sourceRigs = {}

	for k, item in items do
		local sourceRig = item.sourceRig or v

		if not sourceRig then
			return false
		end

		sourceRigs[k] = sourceRig
	end

	for _, animationConstraint in folder:GetDescendants() do
		if animationConstraint:IsA("AnimationConstraint") then
			animationConstraint.Enabled = true
		end
	end

	local v3 = humanoid:FindFirstChildOfClass("Animator")

	if ensureRigDescription(folder) and v3 then
		v3:Destroy()
		v3 = nil
	end

	if not v3 then
		v3 = Instance.new("Animator")
		v3.Parent = humanoid
	end

	assert(v3, "animator is non-nil. Silence type checker.")

	stopRetargetedTracks(folder)
	local tracks = {}
	object[folder] = tracks
	local v4 = 1

	for k, item in items do
		local keyframeSequence = Instance.new("KeyframeSequence")

		for _, time in { 0, 1 } do
			local clone = item.keyframe:Clone()
			clone.Time = time
			clone.Parent = keyframeSequence
		end

		local clone = sourceRigs[k]:Clone()
		clone.Parent = keyframeSequence

		local animation = Instance.new("Animation")
		animation.AnimationId = AnimationClipProvider:RegisterActiveAnimationClip(keyframeSequence)
		local track = v3:LoadAnimation(animation)
		track.Priority = v2[math.min(v4, #v2)]
		track:Play(0)
		table.insert(tracks, track)
		v4 += 1
	end

	v3:StepAnimations(1 / 30)
	return true
end

local function getMainThumbnailKeyframe(instance, animationAssetIdOrUrl, flag: boolean, flag2: boolean?)
	local v3 = nil
	local v4 = nil
	local v5 = false
	local v6 = nil

	if animationAssetIdOrUrl then
		local animationAndIsIdle, v7 = getAnimationAndIsIdle(animationAssetIdOrUrl)

		if animationAndIsIdle == nil then
			return nil, false, animationAssetIdOrUrl
		end

		assert(animationAndIsIdle, "animation is non-nil. Silence type checker.")

		v3, v4 = getThumbnailKeyframeFromAnimationOrUrl(
			animationAndIsIdle,
			not flag and 0 or EmoteUtility.GetNumberValueWithDefault(
				animationAndIsIdle,
				"ThumbnailCharacterRotation",
				0
			)
		)
		v6 = animationAssetIdOrUrl
		v5 = not v7 or v5
		return v3, v5, v6, v4
	else
		if not flag2 then
			return v3, false, v6, v4
		end

		v6 = EmoteUtility.FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL
		local animate = instance:FindFirstChild("Animate")

		if animate then
			local v7 = animate:FindFirstChild("Pose") or animate:FindFirstChild("pose")

			if not v7 and defineFastFlag2 then
				v7 = animate:FindFirstChild("Idle") or animate:FindFirstChild("idle")
			end

			local v8

			if v7 then
				v8 = v7:FindFirstChildOfClass("Animation")
			end

			v6 = v8 or v6
		end

		v3, v4 = getThumbnailKeyframeFromAnimationOrUrl(v6, 0, 1)

		if typeof(v6) ~= "string" then
			v6 = v6.AnimationId
		end

		return v3, v5, v6, v4
	end
end

local function getMoodThumbnailKeyframe(animationAssetIdOrUrl) -- 1 equivalent call inferred from this helper
	if not animationAssetIdOrUrl then
		return nil
	end

	assert(animationAssetIdOrUrl, "moodAssetId is non-nil. Silence type checker.")

	local animationAndIsIdle, _ = getAnimationAndIsIdle(animationAssetIdOrUrl)

	if animationAndIsIdle == nil then
		return nil
	end

	assert(animationAndIsIdle, "animation is non-nil. Silence type checker.")

	return getThumbnailKeyframeFromAnimationOrUrl(animationAndIsIdle, 0)
end

local function getToolKeyframes(instance, flag: boolean)
	local thumbnailPose = nil
	local v3 = nil
	local animationRigData = nil
	local animationRigData2 = nil
	local tool = instance:FindFirstChildOfClass("Tool")

	if not tool then
		return nil, nil
	end

	assert(tool, "tool is non-nil. Silence type checker.")

	local flag2 = false

	if not flag then
		thumbnailPose = tool:FindFirstChild("ThumbnailPose")

		if thumbnailPose and thumbnailPose:IsA("Keyframe") then
			animationRigData = thumbnailPose:FindFirstChildOfClass("AnimationRigData")
			flag2 = true
		end
	end

	if flag2 then
		return thumbnailPose, v3, animationRigData, animationRigData2
	end

	thumbnailPose = nil
	local animate = instance:FindFirstChild("Animate")

	if not animate then
		return nil, nil
	end

	assert(animate, "animateScript is non-nil. Silence type checker.")
	local toolnone = animate:FindFirstChild("toolnone")

	if not toolnone then
		return nil, nil
	end

	assert(toolnone, "toolNoneStringValue is non-nil. Silence type checker.")
	local toolNoneAnim = toolnone:FindFirstChild("ToolNoneAnim")

	if not toolNoneAnim then
		return thumbnailPose, v3, animationRigData, animationRigData2
	end

	local keyframeSequence = EmoteUtility.GetAnimationClip(toolNoneAnim)

	if not keyframeSequence then
		return nil, nil
	end

	assert(keyframeSequence, "toolAnimationClip is non-nil. Silence type checker.")
	assert(keyframeSequence:IsA("KeyframeSequence"), "ToolNoneAnim must be a KeyframeSequence")

	v3 = EmoteUtility.GetThumbnailKeyframe(nil, keyframeSequence, 0)
	animationRigData2 = keyframeSequence:FindFirstChildOfClass("AnimationRigData")

	if not tool:IsDescendantOf(instance) then
		return nil, nil
	end

	return thumbnailPose, v3, animationRigData, animationRigData2
end

local function getAttachmentCFrame(instance)
	local cframe = instance.CFrame
	local parent = instance.Parent

	while parent and parent:IsA("Bone") do
		if defineFastFlag4 then
			cframe = parent.CFrame * parent.Transform * cframe
		else
			cframe = parent.CFrame * cframe
		end

		parent = parent.Parent
	end

	return cframe
end

local function getJointParts(instance)
	if instance:IsA("JointInstance") then
		return instance.Part0, instance.Part1
	end

	if not instance:IsA("Constraint") then
		return nil, nil
	end

	local attachment0 = instance.Attachment0
	local attachment1 = instance.Attachment1
	return
		attachment0 and attachment0:FindFirstAncestorWhichIsA("BasePart"),
		attachment1 and attachment1:FindFirstAncestorWhichIsA("BasePart")
end

local function applyCFrame(part0, part1, joint, jointPose: CFrame)
	if joint:IsA("AnimationConstraint") then
		local attachment0 = joint.Attachment0
		local attachment1 = joint.Attachment1
		part1.CFrame = part0.CFrame * getAttachmentCFrame(attachment0) * jointPose * getAttachmentCFrame(attachment1):Inverse()
	elseif joint:IsA("Motor6D") then
		local c0 = joint.C0
		local c1 = joint.C1
		part1.Anchored = true
		part1.CFrame = part0.CFrame * c0 * jointPose * c1:Inverse()
	end
end

local function getJointPose(joint)
	if joint:IsA("AnimationConstraint") then
		return joint.Transform
	end

	if not joint:IsA("Motor6D") then
		error("Unsupported joint type:" .. joint.ClassName)
		return CFrame.new()
	end

	local transform = joint.Transform

	if joint.CurrentAngle ~= 0 then
		transform *= CFrame.Angles(0, 0, joint.CurrentAngle)
	end

	return transform
end

function EmoteUtility.ForceAnimationToStep(folder)
	local v3 = { (folder:FindFirstChild("HumanoidRootPart")) }
	local set2 = {}
	local v4 = {}

	while #v3 > 0 do
		local part = table.remove(v3, 1)

		if set2[part] then
			continue
		end

		set2[part] = true

		for _, instance in part:GetJoints() do
			if not (instance:IsA("Motor6D") or instance:IsA("AnimationConstraint")) then
				continue
			end

			local jointParts, part2 = getJointParts(instance)

			if jointParts ~= part or not part2 or set2[part2] then
				continue
			end

			table.insert(v4, { part0 = part, part1 = part2, joint = instance })
			table.insert(v3, part2)
		end
	end

	for _, animationConstraint in folder:GetDescendants() do
		if animationConstraint:IsA("AnimationConstraint") then
			animationConstraint.Enabled = false
		end
	end

	for _, v5 in v4 do
		local joint = v5.joint

		if not (joint:IsA("Motor6D") or joint:IsA("AnimationConstraint")) then
			continue
		end

		local jointPose = getJointPose(joint)
		applyCFrame(v5.part0, v5.part1, joint, jointPose)
	end
end

function EmoteUtility.LoadAsset(p: number)
	local success, result = pcall(function()
		if EmoteUtility.debugLoadAssetsFromFiles and EmoteUtility.mapAssetIdToFileName then
			return InsertService:LoadLocalAsset("rbxasset://" .. EmoteUtility.mapAssetIdToFileName(p))
		end

		return InsertService:LoadAsset(p)
	end)

	return success, result
end

function EmoteUtility.SetDebugLoadAssetsFromFiles(debugLoadAssetsFromFiles: boolean, mapAssetIdToFileName)
	EmoteUtility.debugLoadAssetsFromFiles = debugLoadAssetsFromFiles
	EmoteUtility.mapAssetIdToFileName = mapAssetIdToFileName
end

function EmoteUtility.GetJointBetween(p, instance)
	if not (p and instance) then
		return nil
	end

	assert(p, "part0 is non-nil. Silence type checker.")
	assert(instance, "part1 is non-nil. Silence type checker.")

	for _, child in instance:GetChildren() do
		if child:IsA("Motor6D") and child.Part0 == p or child:IsA("AnimationConstraint") and child.Part0 == p then
			return child
		end
	end

	return nil
end

EmoteUtility.GetMotor6DBetween = EmoteUtility.GetJointBetween

function EmoteUtility.PoseKeyframeHasFaceAnimation(object2): boolean
	if not object2 then
		return false
	end

	assert(object2, "poseKeyframe is non-nil. Silence type checker.")
	local function recurHasFaceAnimation(folder): boolean
		if folder:IsA("Folder") then
			return true
		end

		for _, child in folder:GetChildren() do
			if recurHasFaceAnimation(child) then
				return true
			end
		end

		return false
	end

	for _, v3 in pairs(object2:GetPoses()) do
		if recurHasFaceAnimation(v3) then
			return true
		end
	end

	return false
end

function EmoteUtility.ApplyKeyframe(p, p2)
	clearJointBlacklist() -- inferred equivalent call
	applyKeyframeInner(p, p2)
	clearJointBlacklist() -- inferred equivalent call
	local success, result = pcall(function(): boolean
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)

	if success and result then
		EmoteUtility.ForceAnimationToStep(p)
	end
end

function EmoteUtility.GetNumberValueWithDefault(instance, childName: string, p: number?)
	local numberValue = instance:FindFirstChild(childName)

	if numberValue and numberValue:IsA("NumberValue") then
		p = numberValue.Value
	end

	return p
end

function EmoteUtility.GetAnimationClip(instance)
	if instance:IsA("KeyframeSequence") or instance:IsA("CurveAnimation") then
		return instance
	end

	if instance:IsA("Animation") then
		return getAnimationClipByAssetId(instance.AnimationId)
	end

	error("Cannot get AnimationClip from type:" .. instance.ClassName)
	return nil
end

function EmoteUtility.GetThumbnailKeyframe(p: number?, object2, p2: number)
	local keyframes = object2:GetKeyframes()
	local v3

	if p and p > 0 and p <= #keyframes then
		v3 = keyframes[p]
	else
		v3 = keyframes[math.ceil(#keyframes / 2)]
	end

	return getRotatedKeyframe(v3, p2)
end

function EmoteUtility.GetCurveAnimationTimeLength(folder)
	local maxTime = 0

	for _, floatCurve in folder:GetDescendants() do
		if floatCurve:IsA("FloatCurve") and floatCurve.Length ~= 0 then
			maxTime = math.max(maxTime, floatCurve:GetKeyAtIndex(floatCurve.Length).Time)
		end
	end

	return maxTime
end

function EmoteUtility.GetThumbnailKeyframeFromCurve(time: number?, instance, p: number)
	local curveAnimationTimeLength = EmoteUtility.GetCurveAnimationTimeLength(instance)

	if not time or time < 0 or curveAnimationTimeLength < time then
		time = curveAnimationTimeLength / 2
	end

	assert(time, "thumbnailTime should be non-nil. Silence type checker")

	local v3 = { Position = true, Rotation = true }

	local function hasSubFolders(instance2): boolean -- 1 equivalent call inferred from this helper
		for _, folder in instance2:GetChildren() do
			if folder:IsA("Folder") then
				return true
			end
		end

		return false
	end

	local function recurGenerateKeyframe(keyframe, folder)
		local parent = nil

		local position = folder:FindFirstChild("Position")
		local rotation = folder:FindFirstChild("Rotation")
		local v4

		if defineFastFlag5 then
			v4 = position or rotation
		else
			v4 = position and rotation
		end

		if v4 then
			local cframe

			if rotation then
				cframe = getRotationCFrame(rotation, time)
			else
				cframe = CFrame.new()
			end

			if not cframe and defineFastFlag5 then
				cframe = CFrame.new()
			end

			if cframe then
				if position then
					cframe += Vector3.new(table.unpack(position:GetValueAtTime(time)))
				end

				parent = Instance.new("Pose")
				parent.CFrame = cframe
				parent.Name = folder.Name
				parent.Parent = keyframe
			end
		elseif hasSubFolders(folder) then -- inferred equivalent call
			local cframe = CFrame.new()

			parent = Instance.new("Pose")
			parent.CFrame = cframe
			parent.Name = folder.Name
			parent.Parent = keyframe
		else
			parent = Instance.new("Folder")
			parent.Name = folder.Name
			parent.Parent = keyframe
		end

		for _, child in folder:GetChildren() do
			if child:IsA("FloatCurve") and not v3[child] then
				local numberPose = Instance.new("NumberPose")
				numberPose.Name = child.Name
				local valueAtTime = child:GetValueAtTime(time) or 0

				assert(valueAtTime, "valueAtTime should be non-nil. Silence type checker.")
				numberPose.Value = valueAtTime
				numberPose.Parent = parent
			elseif child:IsA("Folder") then
				recurGenerateKeyframe(parent, child)
			end
		end
	end

	local keyframe = Instance.new("Keyframe")
	keyframe.Name = instance.Name
	keyframe.Time = time

	for _, folder in instance:GetChildren() do
		if folder:IsA("Folder") then
			recurGenerateKeyframe(keyframe, folder)
		end
	end

	return getRotatedKeyframe(keyframe, p)
end

function EmoteUtility.ClearPlayerCharacterFace(instance)
	local faceControls = instance:FindFirstChildWhichIsA("FaceControls", true)

	if faceControls then
		local parent = faceControls.Parent
		local children = faceControls:GetChildren()
		local faceControls2 = Instance.new("FaceControls")
		faceControls2.Parent = parent

		for _, child in children do
			child.Parent = faceControls2
		end

		faceControls:Destroy()
	end
end

function EmoteUtility.AdjustArmOnR6ForTool(instance)
	local tool = instance:FindFirstChildOfClass("Tool")
	local torso = instance:FindFirstChild("Torso")

	local rightShoulder = torso and torso:FindFirstChild("Right Shoulder")

	if rightShoulder then
		if tool then
			rightShoulder.CurrentAngle = 1.5707963267948966
			rightShoulder.DesiredAngle = 1.5707963267948966
		else
			rightShoulder.CurrentAngle = 0
			rightShoulder.DesiredAngle = 0
		end
	end
end

function EmoteUtility.SetPlayerCharacterFace(instance, animationAssetIdOrUrl)
	if not animationAssetIdOrUrl then
		return
	end

	if animationAssetIdOrUrl == "" then
		return
	elseif animationAssetIdOrUrl == 0 then
		return
	end

	assert(
		typeof(animationAssetIdOrUrl) == "number" or typeof(animationAssetIdOrUrl) == "string",
		"EmoteUtility.SetPlayerCharacterFace expects animationAssetIdOrUrl to be a number or string"
	)

	if not instance:FindFirstChildOfClass("Humanoid") then
		return
	end

	local moodThumbnailKeyframe = getMoodThumbnailKeyframe(animationAssetIdOrUrl) -- inferred equivalent call

	if not moodThumbnailKeyframe then
		return
	end

	EmoteUtility.ClearPlayerCharacterFace(instance)
	EmoteUtility.ApplyKeyframe(instance, moodThumbnailKeyframe)
end

function EmoteUtility.SetPlayerCharacterNeutralPose(instance)
	local humanoid = instance:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	assert(humanoid, "humanoid should be non-nil. Silence type checker.")

	humanoid:BuildRigFromAttachments()

	if humanoid.RigType ~= Enum.HumanoidRigType.R15 then
		return
	end

	EmoteUtility.ClearPlayerCharacterFace(instance)
	local function recurResetJoint(instance2)
		if instance2:IsA("Motor6D") then
			instance2.Transform = CFrame.new()
		elseif instance2:IsA("AnimationConstraint") then
			instance2.Transform = CFrame.new()
		elseif defineFastFlag4 and instance2:IsA("Bone") then
			instance2.Transform = CFrame.new()
		end

		local children = instance2:GetChildren()

		for _, child in children do
			recurResetJoint(child)
		end
	end

	recurResetJoint(instance)
end

function EmoteUtility.FindDefaultMoodAnimationId(instance)
	local animate = instance:FindFirstChild("Animate")

	if not animate then
		return nil
	end

	local mood = animate:FindFirstChild("mood")

	if not mood then
		return nil
	end

	local animation = mood:FindFirstChildOfClass("Animation")

	if animation and animation.AnimationId ~= "" then
		return animation.AnimationId
	end

	return nil
end

local function loadKeyframesForPoseR15(instance, originalAnimationAssetId: number?, value: number?, flag: boolean?, flag2: boolean?)
	if defineFastFlag4 then
		local success, result = pcall(function(): boolean
			return game.GetService(game, "ThumbnailGenerator") ~= nil
		end)

		if success and result then
			loadCanonicalR15Rig()
		end
	end

	local mainThumbnailKeyframe, v3, finalAnimationAssetIdOrUrl, poseSourceRig = getMainThumbnailKeyframe(
		instance,
		originalAnimationAssetId,
		not flag,
		not flag2
	)
	local defaultToolKeyframe, suggestedKeyframeFromTool, defaultToolSourceRig, suggestedToolSourceRig

	if not (flag2 or not mainThumbnailKeyframe) then
		suggestedKeyframeFromTool, defaultToolKeyframe, suggestedToolSourceRig, defaultToolSourceRig = getToolKeyframes(instance, v3)
	end

	local moodKeyframe = nil
	local moodSourceRig = nil

	local v4 = false

	if defineFastFlag or value and value ~= 0 then
		v4 = originalAnimationAssetId == nil
			or (not EmoteUtility.PoseKeyframeHasFaceAnimation(mainThumbnailKeyframe) or false)
	end

	if v4 then
		if defineFastFlag then
			if value and value ~= 0 and value then
				assert(value, "moodAssetId is non-nil. Silence type checker.")

				local animationAndIsIdle, _ = getAnimationAndIsIdle(value)

				if animationAndIsIdle ~= nil then
					assert(animationAndIsIdle, "animation is non-nil. Silence type checker.")

					moodKeyframe, moodSourceRig = getThumbnailKeyframeFromAnimationOrUrl(animationAndIsIdle, 0)
				end
			end

			if not moodKeyframe then
				local defaultMoodAnimationId = EmoteUtility.FindDefaultMoodAnimationId(instance)

				if defaultMoodAnimationId then
					local animationClipByAssetId = getAnimationClipByAssetId(defaultMoodAnimationId)

					if animationClipByAssetId and animationClipByAssetId:IsA("KeyframeSequence") then
						moodKeyframe = EmoteUtility.GetThumbnailKeyframe(nil, animationClipByAssetId, 0)
						moodSourceRig = animationClipByAssetId:FindFirstChildOfClass("AnimationRigData")
					end
				end
			end
		elseif value then
			assert(value, "moodAssetId is non-nil. Silence type checker.")

			local animationAndIsIdle, _ = getAnimationAndIsIdle(value)

			if animationAndIsIdle ~= nil then
				assert(animationAndIsIdle, "animation is non-nil. Silence type checker.")

				moodKeyframe, moodSourceRig = getThumbnailKeyframeFromAnimationOrUrl(animationAndIsIdle, 0)
			end
		end
	end

	return {
		["originalAnimationAssetId"] = originalAnimationAssetId,
		poseKeyframe = mainThumbnailKeyframe,
		moodKeyframe = moodKeyframe,
		defaultToolKeyframe = defaultToolKeyframe,
		suggestedKeyframeFromTool = suggestedKeyframeFromTool,
		finalAnimationAssetIdOrUrl = finalAnimationAssetIdOrUrl,
		poseSourceRig = poseSourceRig,
		moodSourceRig = moodSourceRig,
		defaultToolSourceRig = defaultToolSourceRig,
		suggestedToolSourceRig = suggestedToolSourceRig
	}
end

function EmoteUtility.LoadKeyframesForPose(instance, originalAnimationAssetId: number?, value: number?, flag: boolean?, flag2: boolean?)
	assert(instance, "character should be non-nil")

	if originalAnimationAssetId ~= nil then
		assert(
			typeof(originalAnimationAssetId) == "number",
			"EmoteUtility.LoadKeyframesForPose expects animationAssetId to be a number or nil"
		)

		assert(
			originalAnimationAssetId > 0,
			"EmoteUtility.LoadKeyframesForPose expects animationAssetId to be a real asset ID (positive number)"
		)
	end

	if value ~= nil then
		assert(typeof(value) == "number", "EmoteUtility.LoadKeyframesForPose expects moodAssetId to be a number or nil")
	end

	local humanoid = instance:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return nil
	end

	assert(humanoid, "humanoid should be non-nil. Silence type checker.")

	if humanoid.RigType == Enum.HumanoidRigType.R15 then
		return loadKeyframesForPoseR15(instance, originalAnimationAssetId, value, flag, flag2)
	end

	return { originalAnimationAssetId = originalAnimationAssetId }
end

function EmoteUtility.ApplyKeyframesForPose(instance, data)
	assert(instance, "character should be non-nil")

	if not data then
		return
	end

	assert(data, "keyframesForPose should be non-nil. Silence type checker.")

	local humanoid = instance:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	assert(humanoid, "humanoid should be non-nil. Silence type checker.")

	EmoteUtility.SetPlayerCharacterNeutralPose(instance)
	clearJointBlacklist() -- inferred equivalent call
	local tool = instance:FindFirstChildOfClass("Tool")
	local v3 = false

	local v4 = defineFastFlag4

	local function fn(): boolean
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end

	if v4 then
		if humanoid.RigType == Enum.HumanoidRigType.R15 then
			local success, result = pcall(fn)

			v4 = success and result

			if v4 then
				v4 = not restsArmsDown(instance)

				if not v4 then
					if tool == nil or data.suggestedKeyframeFromTool == nil then
						v4 = false
					else
						v4 = data.suggestedToolSourceRig ~= nil
					end
				end
			end
		else
			v4 = false
		end
	end

	if v4 then
		local v5 = not tool and {} or getToolBodyLayersInPriorityOrder(data)

		if not tool and data.poseKeyframe then
			table.insert(v5, { keyframe = data.poseKeyframe, sourceRig = data.poseSourceRig })
		end

		if data.moodKeyframe then
			table.insert(v5, { keyframe = data.moodKeyframe, sourceRig = data.moodSourceRig })
		end

		v3 = applyKeyframesRetargeted(instance, humanoid, v5)

		if v3 and tool then
			attachToolToCharacter(instance, humanoid, tool)
		end
	end

	if humanoid.RigType == Enum.HumanoidRigType.R15 and not v3 then
		if tool then
			applyR15KeyframeWithTool(instance, humanoid, tool, data)
		else
			applyKeyframeInner(instance, data.poseKeyframe)
		end
	elseif humanoid.RigType ~= Enum.HumanoidRigType.R15 then
		EmoteUtility.AdjustArmOnR6ForTool(instance)
	end

	if humanoid.RigType == Enum.HumanoidRigType.R15 then
		if v3 then
			applyKeyframeControls(instance, data.moodKeyframe)
		else
			applyKeyframeInner(instance, data.moodKeyframe)
		end
	end

	clearJointBlacklist() -- inferred equivalent call
	local success, result = pcall(fn)

	if success and result then
		EmoteUtility.ForceAnimationToStep(instance)
	end
end

function EmoteUtility.SetPlayerCharacterPoseWithMoodFallback(instance, p: number?, p2: number?, flag: boolean?, flag2: boolean?)
	local humanoid = instance:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	assert(humanoid, "humanoid should be non-nil.  Silence type checker.")

	local keyframesForPose = EmoteUtility.LoadKeyframesForPose(instance, p, p2, flag, flag2)
	EmoteUtility.ApplyKeyframesForPose(instance, keyframesForPose)

	if
		defineFastFlag3
		and keyframesForPose
		and humanoid.RigType == Enum.HumanoidRigType.R15
		and p ~= nil
		and keyframesForPose.poseKeyframe == nil
	then
		return "Failed to download requested pose animation"
	end

	return nil
end

function EmoteUtility.ThumbnailZoomExtents(instance, p: number, p2: number, p3: number, p4: number)
	local modelCFrame = instance:GetModelCFrame()
	local lookVector = modelCFrame.LookVector

	local humanoidRootPart = instance:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		lookVector = humanoidRootPart.CFrame.LookVector
	end

	local cframe = CFrame.new(modelCFrame.Position + lookVector * 5, modelCFrame.Position)

	local v3 = modelCFrame.Position + Vector3.new(p2, -p3, 0)

	local v4 = getCameraOffset(p, instance:GetExtentsSize()) * (1 / p4) -- inferred equivalent call

	return cframe - cframe.Position + v3 + lookVector * v4
end

return EmoteUtility
