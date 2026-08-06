local AnimationClipProvider = game:GetService("AnimationClipProvider")
local InsertService = game:GetService("InsertService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local v4 = game:DefineFastString("EmoteUtilityFallbackKeyframeSequenceAssetId", "10921261056")
local v5 = game:DefineFastFlag("EmoteUtilityDefaultMoodFromCharacter", false)
local v6 = game:DefineFastFlag("EmoteUtilityUseIdleAnimationFallback", false)
local v7 = game:DefineFastFlag("EmoteUtilityReportPoseAnimationDownloadFailure", false)
local t1 = {
	FallbackKeyframeSequenceAssetId = v4,
	debugLoadAssetsFromFiles = false,
	mapAssetIdToFileName = nil,
	EmoteUtilitySupportAJU = true,
	FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL = "http://www.roblox.com/asset/?id=" .. v4
}
local t2 = {}

local function clearJointBlacklist() -- line: 75
	-- upvalues: t2 (ref)
	t2 = {}
end
local function blacklistJoint(p1) -- line: 79
	-- upvalues: t2 (ref)
	t2[p1] = true
end
local function jointIsBlacklisted(p2) -- line: 83
	-- upvalues: t2 (ref)
	if not t2[p2] then
		return false
	end

	return true
end
local function getCameraOffset(n1: number, vector3: Vector3) -- line: 90
	local vector3X = vector3.X
	local vector3Y = vector3.Y
	local vector3Z = vector3.Z
	local v46 = math.sqrt(vector3X ^ 2 + vector3Y ^ 2 + vector3Z ^ 2)
	local v47 = 1 / math.tan(math.rad(n1) / 2)

	return v46 / 2 * v47
end
local function isOnRCC() -- line: 100
	local ok, result = pcall(function() -- line: 106
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)

	return ok and result
end
local function getAnalyticsTarget() -- line: 115
	local ok, result = pcall(function() -- line: 106
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)

	if ok and result then
		return "RCC"
	end

	return "Client"
end
local function reportCounter(s1: string, b1: boolean) -- line: 124
	-- upvalues: RbxAnalyticsService (copy)
	local ok, result = pcall(function() -- line: 106
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)
	local v56 = (not (ok and result) and "Client" or "RCC") .. "_" .. s1 .. "_" .. (not b1 and "Failure" or "Success")

	RbxAnalyticsService:ReportCounter(v56)
end
local function getAnimationAndIsIdle(p3) -- line: 142
	-- upvalues: t1 (copy), RbxAnalyticsService (copy)
	assert(typeof(p3) == "number" or typeof(p3) == "string", "getAnimationAndIsIdle expects animationAssetIdOrUrl to be a number or string")

	local v58 = nil
	local v59, s2

	if typeof(p3) == "number" then
		local v60

		v59, v60 = t1.LoadAsset(p3)

		if v59 and v60 then
			v58 = v60:GetChildren()[1]
		end

		s2 = "EmoteUtility_LoadAsset"
	else
		local result

		v59, result = pcall(function() -- line: 161
			-- upvalues: p3 (copy)
			return game:GetObjects(p3)[1]
		end)

		if v59 and result then
			v58 = result
		end

		s2 = "EmoteUtility_GetObjects"
	end

	local ok, result = pcall(function() -- line: 106
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)
	local v65 = (not (ok and result) and "Client" or "RCC") .. "_" .. s2 .. "_" .. (not v59 and "Failure" or "Success")

	RbxAnalyticsService:ReportCounter(v65)

	if not v59 or not v58 then
		local v66 = s2 .. "_Failed"
		local v67 = RbxAnalyticsService
		local ok2, result2 = pcall(function() -- line: 106
			return game.GetService(game, "ThumbnailGenerator") ~= nil
		end)

		v67:SendEventDeferred(not (ok2 and result2) and "Client" or "RCC", "EmoteUtility_getPoseAsset", v66, {
			animationAssetIdOrUrl = p3
		})

		return nil, nil
	end

	assert(v58, "animation is non-nil. Silence type checker.")

	local v70 = false

	if v58.ClassName == "Folder" then
		v70 = true

		local v71 = v58:FindFirstChild("Pose", true) or v58:FindFirstChild("pose", true)

		if v71 == nil then
			v71 = v58:FindFirstChild("Idle", true) or v58:FindFirstChild("idle", true)
		end

		v58 = if not v71 then v58:FindFirstChildWhichIsA("Animation", true) else v71:FindFirstChildWhichIsA("Animation", true)
	end

	return v58, v70
end
local function getAnimationClipByAssetId(s3: string) -- line: 207
	-- upvalues: t1 (copy), AnimationClipProvider (copy), RbxAnalyticsService (copy)
	local v73 = nil
	local v77

	if t1.debugLoadAssetsFromFiles then
		local v74 = nil

		for match in string.gmatch(s3, ".*id=([0-9]+)") do
			v74 = match
		end

		assert(v74, "assetId should be non-nil")

		local num = tonumber(v74)

		assert(num, "assetIdAsNumber should be non-nil")

		local v78

		v77, v78 = t1.LoadAsset(num)

		if v77 and v78 then
			v73 = v78
		end
	else
		v77, v73 = pcall(function() -- line: 224
			-- upvalues: AnimationClipProvider (copy), s3 (copy)
			return AnimationClipProvider:GetAnimationClipAsync(s3)
		end)
	end

	local ok, result = pcall(function() -- line: 106
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)
	local v81 = (not (ok and result) and "Client" or "RCC") .. "_" .. "EmoteUtility_GetAnimationClipAsync" .. "_" .. (not v77 and "Failure" or "Success")

	RbxAnalyticsService:ReportCounter(v81)

	if not v77 then
		local v82 = RbxAnalyticsService
		local ok3, result3 = pcall(function() -- line: 106
			return game.GetService(game, "ThumbnailGenerator") ~= nil
		end)

		v82:SendEventDeferred(not (ok3 and result3) and "Client" or "RCC", "EmoteUtility_GetAnimationClip", "EmoteUtility_GetAnimationClip_GetAnimationClipAsyncFailed", {
			keyframeSequenceId = s3
		})

		return nil
	end

	return v73
end
local function getThumbnailKeyframeFromAnimationOrUrl(p4, n2: number, n3: number?) -- line: 243
	-- upvalues: getAnimationClipByAssetId (copy), t1 (copy)
	local v88 = nil
	local v89

	if typeof(p4) == "string" then
		v89 = getAnimationClipByAssetId(p4)
	else
		n3 = t1.GetNumberValueWithDefault(p4, "ThumbnailKeyframe", n3)
		v88 = t1.GetNumberValueWithDefault(p4, "ThumbnailTime", nil)
		v89 = t1.GetAnimationClip(p4)
	end

	if not v89 then
		return nil
	end

	if v89:IsA("KeyframeSequence") then
		return t1.GetThumbnailKeyframe(n3, v89, n2)
	end

	if v89:IsA("CurveAnimation") then
		return t1.GetThumbnailKeyframeFromCurve(v88, v89, n2)
	end

	error("Unsupported Animation type:" .. v89.ClassName)

	return nil
end
local function trySetProperty(p5, s4: string, p6) -- line: 275
	pcall(function() -- line: 276
		-- upvalues: p5 (copy), s4 (copy), p6 (copy)
		p5[s4] = p6
	end)
end
local function applyControlsFolder(p7, p8, p9) -- line: 284
	if not p8 then
		return
	end

	assert(p8, "parentPose is non-nil. Silence type checker.")

	local p8Name = p7:FindFirstChild(p8.Name)

	if not p8Name then
		return
	end

	local p9Name = p8Name:FindFirstChild(p9.Name)

	if not p9Name then
		return
	end

	for _, child in p9:GetChildren() do
		if child:IsA("NumberPose") then
			local childName = child.Name
			local childValue = child.Value

			pcall(function() -- line: 276
				-- upvalues: p9Name (copy), childName (copy), childValue (copy)
				p9Name[childName] = childValue
			end)
		end
	end
end
local function applyKeyframeInner(p10, p11) -- line: 313
	-- upvalues: t1 (copy), t2 (ref), applyControlsFolder (copy)
	local function recurApplyPoses(p12, p13) -- line: 314
		-- upvalues: p10 (copy), t1 (copy), t2 (ref), applyControlsFolder (copy), recurApplyPoses (copy)
		if p12 and p13:IsA("Pose") then
			local p12Name = p10:FindFirstChild(p12.Name)
			local p13Name = p10:FindFirstChild(p13.Name)
			local v330 = t1.GetJointBetween(p12Name, p13Name)

			if v330 and not (t2[v330] and true or false) then
				assert(v330, "joint is non-nil. Silence type checker.")
				v330.Transform = p13.CFrame
				t2[v330] = true
			end
		end

		if p13:IsA("Folder") then
			applyControlsFolder(p10, p12, p13)

			return
		end

		for _, child in p13:GetChildren() do
			recurApplyPoses(p13, child)
		end
	end

	if p11 then
		for _, v in pairs(p11:GetPoses()) do
			if not v:IsA("Folder") then
				for _, child in v:GetChildren() do
					recurApplyPoses(v, child)
				end
			end
		end
	end
end
local function getRotatedKeyframe(p14, n4: number?) -- line: 351
	if not n4 or n4 == 0 then
		return p14
	end

	assert(n4, "rotationDegrees is non-nil. Silence type checker.")

	local clone = p14:Clone()
	local v112 = clone:GetPoses()[1]

	if v112 then
		local v113 = v112:GetSubPoses()[1]

		if v113 then
			v113.CFrame = v113.CFrame * CFrame.Angles(0, math.rad(n4), 0)
		end
	end

	return clone
end
local function getRotationCFrame(p15, n5: number) -- line: 372
	if p15:IsA("EulerRotationCurve") then
		return p15:GetRotationAtTime(n5)
	end

	if p15:IsA("RotationCurve") then
		return p15:GetValueAtTime(n5)
	end

	error("Unsupported rotation type:" .. p15.ClassName)

	return nil
end
local function findAttachmentsRecur(p16, t3: {[any]: any}) -- line: 383
	-- upvalues: findAttachmentsRecur (copy)
	for _, child in pairs(p16:GetChildren()) do
		if child:IsA("Attachment") then
			t3[child.Name] = child
		elseif not child:IsA("Tool") and not child:IsA("Accoutrement") then
			findAttachmentsRecur(child, t3)
		end
	end
end
local function findAttachmentsInTool(p17) -- line: 394
	-- upvalues: findAttachmentsRecur (copy)
	local t4 = {}

	findAttachmentsRecur(p17, t4)

	return t4
end
local function findAttachmentsInCharacter(p18) -- line: 400
	-- upvalues: findAttachmentsRecur (copy)
	local t5 = {}

	findAttachmentsRecur(p18, t5)

	return t5
end
local function weldAttachments(p19, p20) -- line: 406
	local Weld = Instance.new("Weld")

	Weld.Part0 = p19.Parent
	Weld.Part1 = p20.Parent
	Weld.C0 = p19.CFrame
	Weld.C1 = p20.CFrame
	Weld.Parent = p19.Parent

	return Weld
end
local function attachToolToCharacter(p21, p22, p23) -- line: 416
	-- upvalues: findAttachmentsRecur (copy)
	local t6 = {}

	findAttachmentsRecur(p21, t6)

	local t7 = {}

	findAttachmentsRecur(p23, t7)

	local v132 = false

	for _, v in pairs(t7) do
		local v135 = t6[v.Name]

		if v135 then
			v132 = true

			local Weld = Instance.new("Weld")

			Weld.Part0 = v135.Parent
			Weld.Part1 = v.Parent
			Weld.C0 = v135.CFrame
			Weld.C1 = v.CFrame
			Weld.Parent = v135.Parent
		end
	end

	if v132 then
		p23.Parent = p21

		return
	end

	p23.Parent = nil

	local Handle = p23:FindFirstChild("Handle")
	local Grip = p23.Grip

	if Handle and Grip then
		local RightGripAttachment = t6.RightGripAttachment

		if RightGripAttachment then
			Handle.CFrame = RightGripAttachment.Parent.CFrame * RightGripAttachment.CFrame * Grip:Inverse()
		end
	end

	p22:EquipTool(p23)
end
local function applyR15KeyframeWithTool(p24, p25, p26, n6: number?, p27, p28, p29) -- line: 448
	-- upvalues: applyKeyframeInner (copy), attachToolToCharacter (copy)
	if p29 then
		applyKeyframeInner(p24, p29)
		applyKeyframeInner(p24, p27)
	else
		applyKeyframeInner(p24, p28)

		if n6 ~= nil then
			applyKeyframeInner(p24, p27)
		end
	end

	attachToolToCharacter(p24, p25, p26)
end
local function getMainThumbnailKeyframe(p30, p31, b2: boolean, b3: boolean?) -- line: 502
	-- upvalues: getAnimationAndIsIdle (copy), t1 (copy), getThumbnailKeyframeFromAnimationOrUrl (copy), v6 (copy)
	local v151 = nil
	local v152 = false
	local AnimationId = nil

	if p31 then
		local v154, v155 = getAnimationAndIsIdle(p31)

		if v154 == nil then
			return nil, v152, p31
		end

		assert(v154, "animation is non-nil. Silence type checker.")

		if not v155 then
			v152 = true
		end

		local n7 = 0

		if b2 then
			n7 = t1.GetNumberValueWithDefault(v154, "ThumbnailCharacterRotation", 0)
		end

		return getThumbnailKeyframeFromAnimationOrUrl(v154, n7), v152, p31
	end

	if b3 then
		local FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL = t1.FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL
		local Animate = p30:FindFirstChild("Animate")

		if Animate then
			local v159 = Animate:FindFirstChild("Pose") or Animate:FindFirstChild("pose") or (not v6 or (Animate:FindFirstChild("Idle") or Animate:FindFirstChild("idle")))
			local v160 = if not v159 then nil else v159:FindFirstChildOfClass("Animation")

			if v160 then
				FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL = v160
			end
		end

		v151 = getThumbnailKeyframeFromAnimationOrUrl(FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL, 0, 1)

		if typeof(FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL) == "string" then
			return v151, v152, FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL
		end

		AnimationId = FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL.AnimationId
	end

	return v151, v152, AnimationId
end
local function getMoodThumbnailKeyframe(p32) -- line: 570
	-- upvalues: getAnimationAndIsIdle (copy), getThumbnailKeyframeFromAnimationOrUrl (copy)
	if not p32 then
		return nil
	end

	assert(p32, "moodAssetId is non-nil. Silence type checker.")

	local v162, _ = getAnimationAndIsIdle(p32)

	if v162 == nil then
		return nil
	end

	assert(v162, "animation is non-nil. Silence type checker.")

	return getThumbnailKeyframeFromAnimationOrUrl(v162, 0)
end
local function getToolKeyframes(p33, b4: boolean) -- line: 602
	-- upvalues: t1 (copy)
	local ThumbnailPose = nil
	local v167 = nil
	local Tool = p33:FindFirstChildOfClass("Tool")

	if not Tool then
		return nil, nil
	end

	assert(Tool, "tool is non-nil. Silence type checker.")

	local v169 = false

	if not b4 then
		ThumbnailPose = Tool:FindFirstChild("ThumbnailPose")

		if ThumbnailPose and ThumbnailPose:IsA("Keyframe") then
			v169 = true
		end
	end

	if not v169 then
		ThumbnailPose = nil

		local Animate = p33:FindFirstChild("Animate")

		if not Animate then
			return nil, nil
		end

		assert(Animate, "animateScript is non-nil. Silence type checker.")

		local toolnone = Animate:FindFirstChild("toolnone")

		if not toolnone then
			return nil, nil
		end

		assert(toolnone, "toolNoneStringValue is non-nil. Silence type checker.")

		local ToolNoneAnim = toolnone:FindFirstChild("ToolNoneAnim")

		if ToolNoneAnim then
			local v173 = t1.GetAnimationClip(ToolNoneAnim)

			if not v173 then
				return nil, nil
			end

			assert(v173, "toolAnimationClip is non-nil. Silence type checker.")
			assert(v173:IsA("KeyframeSequence"), "ToolNoneAnim must be a KeyframeSequence")
			v167 = t1.GetThumbnailKeyframe(nil, v173, 0)

			if not Tool:IsDescendantOf(p33) then
				return nil, nil
			end
		end
	end

	return ThumbnailPose, v167
end
local function getAttachmentCFrame(p34) -- line: 661
	local p34CFrame = p34.CFrame
	local p34Parent = p34.Parent

	while p34Parent and p34Parent:IsA("Bone") do
		p34CFrame = p34Parent.CFrame * p34CFrame
		p34Parent = p34Parent.Parent
	end

	return p34CFrame
end
local function getJointParts(p35) -- line: 671
	if p35:IsA("JointInstance") then
		return p35.Part0, p35.Part1
	end

	if p35:IsA("Constraint") then
		local p35Attachment0 = p35.Attachment0
		local p35Attachment1 = p35.Attachment1

		return p35Attachment0 and p35Attachment0:FindFirstAncestorWhichIsA("BasePart"), p35Attachment1 and p35Attachment1:FindFirstAncestorWhichIsA("BasePart")
	end

	return nil, nil
end
local function applyCFrame(p36, p37, p38, cFrame: CFrame) -- line: 684
	-- upvalues: getAttachmentCFrame (copy)
	if p38:IsA("AnimationConstraint") then
		local p38Attachment0 = p38.Attachment0
		local p38Attachment1 = p38.Attachment1

		p37.CFrame = p36.CFrame * getAttachmentCFrame(p38Attachment0) * cFrame * getAttachmentCFrame(p38Attachment1):Inverse()

		return
	end

	if p38:IsA("Motor6D") then
		local p38C0 = p38.C0
		local p38C1 = p38.C1

		p37.Anchored = true
		p37.CFrame = p36.CFrame * p38C0 * cFrame * p38C1:Inverse()
	end
end
local function getJointPose(p39) -- line: 697
	if p39:IsA("AnimationConstraint") then
		return p39.Transform
	end

	if p39:IsA("Motor6D") then
		local p39Transform = p39.Transform

		if p39.CurrentAngle ~= 0 then
			p39Transform *= CFrame.Angles(0, 0, p39.CurrentAngle)
		end

		return p39Transform
	end

	error("Unsupported joint type:" .. p39.ClassName)

	return CFrame.new()
end

function t1.ForceAnimationToStep(p40) -- line: 717
	-- upvalues: getJointParts (copy), getJointPose (copy), applyCFrame (copy)
	local t8 = { (p40:FindFirstChild("HumanoidRootPart")) }
	local t9 = {}
	local t10 = {}

	while #t8 > 0 do
		local v194 = table.remove(t8, 1)

		if not t9[v194] then
			t9[v194] = true

			for _, v196 in v194:GetJoints() do
				if v196:IsA("Motor6D") or v196:IsA("AnimationConstraint") then
					local v197, v198 = getJointParts(v196)

					if v197 == v194 and v198 and not t9[v198] then
						table.insert(t10, {
							part0 = v194,
							part1 = v198,
							joint = v196
						})
						table.insert(t8, v198)
					end
				end
			end
		end
	end

	for _, descendant in p40:GetDescendants() do
		if descendant:IsA("AnimationConstraint") then
			descendant.Enabled = false
		end
	end

	for _, v202 in t10 do
		local joint = v202.joint

		if joint:IsA("Motor6D") or joint:IsA("AnimationConstraint") then
			local v204 = getJointPose(joint)

			applyCFrame(v202.part0, v202.part1, joint, v204)
		end
	end
end
function t1.LoadAsset(n8: number) -- line: 763
	-- upvalues: t1 (copy), InsertService (copy)
	local ok, result = pcall(function() -- line: 764
		-- upvalues: t1 (copy), n8 (copy), InsertService (copy)
		if t1.debugLoadAssetsFromFiles and t1.mapAssetIdToFileName then
			local v333 = "rbxasset://" .. t1.mapAssetIdToFileName(n8)

			return InsertService:LoadLocalAsset(v333)
		end

		return InsertService:LoadAsset(n8)
	end)

	return ok, result
end
function t1.SetDebugLoadAssetsFromFiles(b5: boolean, p41: ((...any) -> ...any)) -- line: 785
	-- upvalues: t1 (copy)
	t1.debugLoadAssetsFromFiles = b5
	t1.mapAssetIdToFileName = p41
end
function t1.GetJointBetween(p42, p43) -- line: 793
	if not p42 or not p43 then
		return nil
	end

	assert(p42, "part0 is non-nil. Silence type checker.")
	assert(p43, "part1 is non-nil. Silence type checker.")

	for _, child in p43:GetChildren() do
		if child:IsA("Motor6D") and p42 == child.Part0 then
			return child
		end

		if child:IsA("AnimationConstraint") and p42 == child.Part0 then
			return child
		end
	end

	return nil
end

t1.GetMotor6DBetween = t1.GetJointBetween

function t1.PoseKeyframeHasFaceAnimation(p44) -- line: 817
	if not p44 then
		return false
	end

	assert(p44, "poseKeyframe is non-nil. Silence type checker.")

	local function recurHasFaceAnimation(p45) -- line: 823
		-- upvalues: recurHasFaceAnimation (copy)
		if p45:IsA("Folder") then
			return true
		end

		for _, child in p45:GetChildren() do
			if recurHasFaceAnimation(child) then
				return true
			end
		end

		return false
	end

	for _, v in pairs(p44:GetPoses()) do
		if recurHasFaceAnimation(v) then
			return true
		end
	end

	return false
end
function t1.ApplyKeyframe(p46, p47) -- line: 848
	-- upvalues: t2 (ref), applyKeyframeInner (copy), t1 (copy)
	t2 = {}
	applyKeyframeInner(p46, p47)
	t2 = {}

	local ok, result = pcall(function() -- line: 106
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)

	if ok and result then
		t1.ForceAnimationToStep(p46)
	end
end
function t1.GetNumberValueWithDefault(p48, s5: string, n9: number?) -- line: 857
	local s5_2 = p48:FindFirstChild(s5)

	if s5_2 and s5_2:IsA("NumberValue") then
		n9 = s5_2.Value
	end

	return n9
end
function t1.GetAnimationClip(p49) -- line: 870
	-- upvalues: getAnimationClipByAssetId (copy)
	if p49:IsA("KeyframeSequence") then
		return p49
	end

	if p49:IsA("CurveAnimation") then
		return p49
	end

	if p49:IsA("Animation") then
		return (getAnimationClipByAssetId(p49.AnimationId))
	end

	error("Cannot get AnimationClip from type:" .. p49.ClassName)

	return nil
end
function t1.GetThumbnailKeyframe(n10: number?, p50, n11: number) -- line: 886
	-- upvalues: getRotatedKeyframe (copy)
	local Keyframes = p50:GetKeyframes()
	local v231 = if not n10 or (not (n10 > 0) or not (n10 <= #Keyframes)) then Keyframes[math.ceil(#Keyframes / 2)] else Keyframes[n10]

	return (getRotatedKeyframe(v231, n11))
end
function t1.GetCurveAnimationTimeLength(p51) -- line: 904
	local n12 = 0

	for _, descendant in p51:GetDescendants() do
		if descendant:IsA("FloatCurve") and descendant.Length ~= 0 then
			n12 = math.max(n12, descendant:GetKeyAtIndex(descendant.Length).Time)
		end
	end

	return n12
end
function t1.GetThumbnailKeyframeFromCurve(n13: number?, p52, n14: number) -- line: 922
	-- upvalues: t1 (copy), getRotationCFrame (copy), getRotatedKeyframe (copy)
	local v240 = t1.GetCurveAnimationTimeLength(p52)

	if not n13 or (n13 < 0 or v240 < n13) then
		n13 = v240 / 2
	end

	assert(n13, "thumbnailTime should be non-nil. Silence type checker")

	local t11 = {
		Position = true,
		Rotation = true
	}

	local function hasSubFolders(p53) -- line: 940
		for _, child in p53:GetChildren() do
			if child:IsA("Folder") then
				return true
			end
		end

		return false
	end
	local function recurGenerateKeyframe(p54, p55) -- line: 949
		-- upvalues: getRotationCFrame (copy), n13 (ref), t11 (copy), recurGenerateKeyframe (copy)
		local Pose = nil
		local Position = p55:FindFirstChild("Position")
		local Rotation = p55:FindFirstChild("Rotation")

		if Position and Rotation then
			local v345 = getRotationCFrame(Rotation, n13)

			if v345 then
				local v346 = v345 + Vector3.new(table.unpack(Position:GetValueAtTime(n13)))

				Pose = Instance.new("Pose")
				Pose.CFrame = v346
				Pose.Name = p55.Name
				Pose.Parent = p54
			end
		else
			local g350 = nil
			local v349 = nil

			for _, child in p55:GetChildren() do
				if child:IsA("Folder") then
					v349 = true
					g350 = true
				end

				if g350 then
					break
				end
			end

			if not g350 then
				v349 = false
			end

			g350 = false

			if v349 then
				local cFrame = CFrame.new()

				Pose = Instance.new("Pose")
				Pose.CFrame = cFrame
				Pose.Name = p55.Name
				Pose.Parent = p54
			else
				Pose = Instance.new("Folder")
				Pose.Name = p55.Name
				Pose.Parent = p54
			end
		end

		for _, child in p55:GetChildren() do
			if child:IsA("FloatCurve") and not t11[child] then
				local NumberPose = Instance.new("NumberPose")

				NumberPose.Name = child.Name

				local v355 = child:GetValueAtTime(n13) or 0

				assert(v355, "valueAtTime should be non-nil. Silence type checker.")
				NumberPose.Value = v355
				NumberPose.Parent = Pose
			elseif child:IsA("Folder") then
				recurGenerateKeyframe(Pose, child)
			end
		end
	end

	local Keyframe = Instance.new("Keyframe")

	Keyframe.Name = p52.Name
	Keyframe.Time = n13

	for _, child in p52:GetChildren() do
		if child:IsA("Folder") then
			recurGenerateKeyframe(Keyframe, child)
		end
	end

	return (getRotatedKeyframe(Keyframe, n14))
end
function t1.ClearPlayerCharacterFace(p56) -- line: 1015
	local FaceControls = p56:FindFirstChildWhichIsA("FaceControls", true)

	if FaceControls then
		local FaceControlsParent = FaceControls.Parent
		local children = FaceControls:GetChildren()
		local FaceControls2 = Instance.new("FaceControls")

		FaceControls2.Parent = FaceControlsParent

		for _, v253 in children do
			v253.Parent = FaceControls2
		end

		FaceControls:Destroy()
	end
end
function t1.AdjustArmOnR6ForTool(p57) -- line: 1032
	local Tool = p57:FindFirstChildOfClass("Tool")
	local Torso = p57:FindFirstChild("Torso")

	if Torso then
		local v257 = Torso:FindFirstChild("Right Shoulder")

		if v257 then
			if Tool then
				v257.CurrentAngle = 1.5707963267948966
				v257.DesiredAngle = 1.5707963267948966

				return
			end

			v257.CurrentAngle = 0
			v257.DesiredAngle = 0
		end
	end
end
function t1.SetPlayerCharacterFace(p58, p59) -- line: 1054
	-- upvalues: getAnimationAndIsIdle (copy), getThumbnailKeyframeFromAnimationOrUrl (copy), t1 (copy)
	if not p59 then
		return
	end

	if p59 == "" then
		return
	end

	if p59 == 0 then
		return
	end

	assert(typeof(p59) == "number" or typeof(p59) == "string", "EmoteUtility.SetPlayerCharacterFace expects animationAssetIdOrUrl to be a number or string")

	if not p58:FindFirstChildOfClass("Humanoid") then
		return
	end

	local v260

	if not p59 then
		v260 = nil
	else
		assert(p59, "moodAssetId is non-nil. Silence type checker.")

		local v261, _ = getAnimationAndIsIdle(p59)

		if v261 == nil then
			v260 = nil
		else
			assert(v261, "animation is non-nil. Silence type checker.")
			v260 = getThumbnailKeyframeFromAnimationOrUrl(v261, 0)
		end
	end

	if not v260 then
		return
	end

	t1.ClearPlayerCharacterFace(p58)
	t1.ApplyKeyframe(p58, v260)
end
function t1.SetPlayerCharacterNeutralPose(p60) -- line: 1095
	-- upvalues: t1 (copy)
	local Humanoid = p60:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	assert(Humanoid, "humanoid should be non-nil. Silence type checker.")
	Humanoid:BuildRigFromAttachments()

	if Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
		return
	end

	t1.ClearPlayerCharacterFace(p60)

	local function recurResetJoint(p61) -- line: 1110
		-- upvalues: recurResetJoint (copy)
		if p61:IsA("Motor6D") then
			p61.Transform = CFrame.new()
		elseif p61:IsA("AnimationConstraint") then
			p61.Transform = CFrame.new()
		end

		for _, child in (p61:GetChildren()) do
			recurResetJoint(child)
		end
	end

	recurResetJoint(p60)
end
function t1.FindDefaultMoodAnimationId(p62) -- line: 1127
	local Animate = p62:FindFirstChild("Animate")

	if not Animate then
		return nil
	end

	local mood = Animate:FindFirstChild("mood")

	if not mood then
		return nil
	end

	local Animation = mood:FindFirstChildOfClass("Animation")

	if not Animation or Animation.AnimationId == "" then
		return nil
	end

	return Animation.AnimationId
end

local function loadKeyframesForPoseR15(p63, n15: number?, n16: number?, b6: boolean?, b7: boolean?) -- line: 1146
	-- upvalues: getMainThumbnailKeyframe (copy), getToolKeyframes (copy), v5 (copy), t1 (copy), getAnimationAndIsIdle (copy), getThumbnailKeyframeFromAnimationOrUrl (copy), getAnimationClipByAssetId (copy)
	local t12 = {
		originalAnimationAssetId = n15
	}
	local v276, v277, v278 = getMainThumbnailKeyframe(p63, n15, not b6, not b7)
	local v279 = nil
	local v280 = nil

	if not b7 and v276 then
		v279, v280 = getToolKeyframes(p63, v277)
	end

	local v281 = nil
	local v282 = false

	if v5 or n16 and n16 ~= 0 then
		if n15 == nil then
			v282 = true
		elseif not t1.PoseKeyframeHasFaceAnimation(v276) then
			v282 = true
		end
	end

	if v282 then
		if v5 then
			if n16 and n16 ~= 0 then
				if not n16 then
					v281 = nil
				else
					assert(n16, "moodAssetId is non-nil. Silence type checker.")

					local v283, _ = getAnimationAndIsIdle(n16)

					if v283 == nil then
						v281 = nil
					else
						assert(v283, "animation is non-nil. Silence type checker.")
						v281 = getThumbnailKeyframeFromAnimationOrUrl(v283, 0)
					end
				end
			end

			if not v281 then
				local v285 = t1.FindDefaultMoodAnimationId(p63)

				if v285 then
					local v286 = getAnimationClipByAssetId(v285)

					if v286 and v286:IsA("KeyframeSequence") then
						v281 = t1.GetThumbnailKeyframe(nil, v286, 0)
					end
				end
			end
		elseif not n16 then
			v281 = nil
		else
			assert(n16, "moodAssetId is non-nil. Silence type checker.")

			local v287, _ = getAnimationAndIsIdle(n16)

			if v287 == nil then
				v281 = nil
			else
				assert(v287, "animation is non-nil. Silence type checker.")
				v281 = getThumbnailKeyframeFromAnimationOrUrl(v287, 0)
			end
		end
	end

	t12.poseKeyframe = v276
	t12.moodKeyframe = v281
	t12.defaultToolKeyframe = v280
	t12.suggestedKeyframeFromTool = v279
	t12.finalAnimationAssetIdOrUrl = v278

	return t12
end

function t1.LoadKeyframesForPose(p64, n17: number?, n18: number?, b8: boolean?, b9: boolean?) -- line: 1247
	-- upvalues: loadKeyframesForPoseR15 (copy)
	assert(p64, "character should be non-nil")

	if n17 ~= nil then
		assert(typeof(n17) == "number", "EmoteUtility.LoadKeyframesForPose expects animationAssetId to be a number or nil")
		assert(n17 > 0, "EmoteUtility.LoadKeyframesForPose expects animationAssetId to be a real asset ID (positive number)")
	end

	if n18 ~= nil then
		assert(typeof(n18) == "number", "EmoteUtility.LoadKeyframesForPose expects moodAssetId to be a number or nil")
	end

	local Humanoid = p64:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return nil
	end

	assert(Humanoid, "humanoid should be non-nil. Silence type checker.")

	if Humanoid.RigType == Enum.HumanoidRigType.R15 then
		return (loadKeyframesForPoseR15(p64, n17, n18, b8, b9))
	end

	return {
		originalAnimationAssetId = n17
	}
end
function t1.ApplyKeyframesForPose(p65, t13: {[any]: any}?) -- line: 1295
	-- upvalues: t1 (copy), t2 (ref), applyR15KeyframeWithTool (copy), applyKeyframeInner (copy)
	assert(p65, "character should be non-nil")

	if not t13 then
		return
	end

	assert(t13, "keyframesForPose should be non-nil. Silence type checker.")

	local Humanoid = p65:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	assert(Humanoid, "humanoid should be non-nil. Silence type checker.")
	t1.SetPlayerCharacterNeutralPose(p65)
	t2 = {}

	local Tool = p65:FindFirstChildOfClass("Tool")

	if Humanoid.RigType == Enum.HumanoidRigType.R15 then
		if Tool then
			local originalAnimationAssetId = t13.originalAnimationAssetId

			applyR15KeyframeWithTool(p65, Humanoid, Tool, originalAnimationAssetId, t13.poseKeyframe, t13.defaultToolKeyframe, t13.suggestedKeyframeFromTool)
		else
			applyKeyframeInner(p65, t13.poseKeyframe)
		end
	else
		t1.AdjustArmOnR6ForTool(p65)
	end

	if Humanoid.RigType == Enum.HumanoidRigType.R15 then
		applyKeyframeInner(p65, t13.moodKeyframe)
	end

	t2 = {}

	local ok, result = pcall(function() -- line: 106
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)

	if ok and result then
		t1.ForceAnimationToStep(p65)
	end
end
function t1.SetPlayerCharacterPoseWithMoodFallback(p66, n19: number?, n20: number?, b10: boolean?, b11: boolean?) -- line: 1361
	-- upvalues: t1 (copy), v7 (copy)
	local Humanoid = p66:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	assert(Humanoid, "humanoid should be non-nil.  Silence type checker.")

	local v308 = t1.LoadKeyframesForPose(p66, n19, n20, b10, b11)

	t1.ApplyKeyframesForPose(p66, v308)

	if not v7 or not v308 then
		return nil
	end

	if Humanoid.RigType == Enum.HumanoidRigType.R15 and n19 ~= nil and v308.poseKeyframe == nil then
		return "Failed to download requested pose animation"
	end

	return nil
end
function t1.ThumbnailZoomExtents(p67, n21: number, n22: number, n23: number, n24: number) -- line: 1394
	local ModelCFrame = p67:GetModelCFrame()
	local LookVector = ModelCFrame.LookVector
	local HumanoidRootPart = p67:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		LookVector = HumanoidRootPart.CFrame.LookVector
	end

	local cFrame = CFrame.new(ModelCFrame.Position + LookVector * 5, ModelCFrame.Position)
	local v318 = ModelCFrame.Position + Vector3.new(n22, -n23, 0)
	local ExtentsSize = p67:GetExtentsSize()
	local ExtentsSizeX = ExtentsSize.X
	local ExtentsSizeY = ExtentsSize.Y
	local ExtentsSizeZ = ExtentsSize.Z
	local v323 = math.sqrt(ExtentsSizeX ^ 2 + ExtentsSizeY ^ 2 + ExtentsSizeZ ^ 2)
	local v324 = 1 / math.tan(math.rad(n21) / 2)
	local v325 = v323 / 2 * v324 * (1 / n24)

	return cFrame - cFrame.Position + v318 + LookVector * v325
end

return t1
