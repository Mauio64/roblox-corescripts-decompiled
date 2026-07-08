local AnimationClipProvider = game:GetService("AnimationClipProvider")
local InsertService = game:GetService("InsertService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local v4 = game:DefineFastString("EmoteUtilityFallbackKeyframeSequenceAssetId", "10921261056")
local v5 = game:DefineFastFlag("EmoteUtilityDefaultMoodFromCharacter", false)
local v6 = game:DefineFastFlag("EmoteUtilityUseIdleAnimationFallback", false)
local t1 = {
	FallbackKeyframeSequenceAssetId = v4,
	debugLoadAssetsFromFiles = false,
	mapAssetIdToFileName = nil,
	EmoteUtilitySupportAJU = true,
	FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL = "http://www.roblox.com/asset/?id=" .. v4
}
local t2 = {}

local function clearJointBlacklist() -- line: 73
	-- upvalues: t2 (ref)
	t2 = {}
end
local function blacklistJoint(p1) -- line: 77
	-- upvalues: t2 (ref)
	t2[p1] = true
end
local function jointIsBlacklisted(p2) -- line: 81
	-- upvalues: t2 (ref)
	if not t2[p2] then
		return false
	end

	return true
end
local function getCameraOffset(n1: number, vector3: Vector3) -- line: 88
	local vector3X = vector3.X
	local vector3Y = vector3.Y
	local vector3Z = vector3.Z
	local v45 = math.sqrt(vector3X ^ 2 + vector3Y ^ 2 + vector3Z ^ 2)
	local v46 = 1 / math.tan(math.rad(n1) / 2)

	return v45 / 2 * v46
end
local function isOnRCC() -- line: 98
	local ok, result = pcall(function() -- line: 104
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)

	return ok and result
end
local function getAnalyticsTarget() -- line: 113
	local ok, result = pcall(function() -- line: 104
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)

	if ok and result then
		return "RCC"
	end

	return "Client"
end
local function reportCounter(s1: string, b1: boolean) -- line: 122
	-- upvalues: RbxAnalyticsService (copy)
	local ok, result = pcall(function() -- line: 104
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)
	local v55 = (not (ok and result) and "Client" or "RCC") .. "_" .. s1 .. "_" .. (not b1 and "Failure" or "Success")

	RbxAnalyticsService:ReportCounter(v55)
end
local function getAnimationAndIsIdle(p3) -- line: 140
	-- upvalues: t1 (copy), RbxAnalyticsService (copy)
	assert(typeof(p3) == "number" or typeof(p3) == "string", "getAnimationAndIsIdle expects animationAssetIdOrUrl to be a number or string")

	local v57 = nil
	local v58, s2

	if typeof(p3) == "number" then
		local v59

		v58, v59 = t1.LoadAsset(p3)

		if v58 and v59 then
			v57 = v59:GetChildren()[1]
		end

		s2 = "EmoteUtility_LoadAsset"
	else
		local result

		v58, result = pcall(function() -- line: 159
			-- upvalues: p3 (copy)
			return game:GetObjects(p3)[1]
		end)

		if v58 and result then
			v57 = result
		end

		s2 = "EmoteUtility_GetObjects"
	end

	local ok, result = pcall(function() -- line: 104
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)
	local v64 = (not (ok and result) and "Client" or "RCC") .. "_" .. s2 .. "_" .. (not v58 and "Failure" or "Success")

	RbxAnalyticsService:ReportCounter(v64)

	if not v58 or not v57 then
		local v65 = s2 .. "_Failed"
		local v66 = RbxAnalyticsService
		local ok2, result2 = pcall(function() -- line: 104
			return game.GetService(game, "ThumbnailGenerator") ~= nil
		end)

		v66:SendEventDeferred(not (ok2 and result2) and "Client" or "RCC", "EmoteUtility_getPoseAsset", v65, {
			animationAssetIdOrUrl = p3
		})

		return nil, nil
	end

	assert(v57, "animation is non-nil. Silence type checker.")

	local v69 = false

	if v57.ClassName == "Folder" then
		v69 = true

		local v70 = v57:FindFirstChild("Pose", true) or v57:FindFirstChild("pose", true)

		if v70 == nil then
			v70 = v57:FindFirstChild("Idle", true) or v57:FindFirstChild("idle", true)
		end

		v57 = if not v70 then v57:FindFirstChildWhichIsA("Animation", true) else v70:FindFirstChildWhichIsA("Animation", true)
	end

	return v57, v69
end
local function getAnimationClipByAssetId(s3: string) -- line: 205
	-- upvalues: t1 (copy), AnimationClipProvider (copy), RbxAnalyticsService (copy)
	local v72 = nil
	local v76

	if t1.debugLoadAssetsFromFiles then
		local v73 = nil

		for match in string.gmatch(s3, ".*id=([0-9]+)") do
			v73 = match
		end

		assert(v73, "assetId should be non-nil")

		local num = tonumber(v73)

		assert(num, "assetIdAsNumber should be non-nil")

		local v77

		v76, v77 = t1.LoadAsset(num)

		if v76 and v77 then
			v72 = v77
		end
	else
		v76, v72 = pcall(function() -- line: 222
			-- upvalues: AnimationClipProvider (copy), s3 (copy)
			return AnimationClipProvider:GetAnimationClipAsync(s3)
		end)
	end

	local ok, result = pcall(function() -- line: 104
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)
	local v80 = (not (ok and result) and "Client" or "RCC") .. "_" .. "EmoteUtility_GetAnimationClipAsync" .. "_" .. (not v76 and "Failure" or "Success")

	RbxAnalyticsService:ReportCounter(v80)

	if not v76 then
		local v81 = RbxAnalyticsService
		local ok3, result3 = pcall(function() -- line: 104
			return game.GetService(game, "ThumbnailGenerator") ~= nil
		end)

		v81:SendEventDeferred(not (ok3 and result3) and "Client" or "RCC", "EmoteUtility_GetAnimationClip", "EmoteUtility_GetAnimationClip_GetAnimationClipAsyncFailed", {
			keyframeSequenceId = s3
		})

		return nil
	end

	return v72
end
local function getThumbnailKeyframeFromAnimationOrUrl(p4, n2: number, n3: number?) -- line: 241
	-- upvalues: getAnimationClipByAssetId (copy), t1 (copy)
	local v87 = nil
	local v88

	if typeof(p4) == "string" then
		v88 = getAnimationClipByAssetId(p4)
	else
		n3 = t1.GetNumberValueWithDefault(p4, "ThumbnailKeyframe", n3)
		v87 = t1.GetNumberValueWithDefault(p4, "ThumbnailTime", nil)
		v88 = t1.GetAnimationClip(p4)
	end

	if not v88 then
		return nil
	end

	if v88:IsA("KeyframeSequence") then
		return t1.GetThumbnailKeyframe(n3, v88, n2)
	end

	if v88:IsA("CurveAnimation") then
		return t1.GetThumbnailKeyframeFromCurve(v87, v88, n2)
	end

	error("Unsupported Animation type:" .. v88.ClassName)

	return nil
end
local function trySetProperty(p5, s4: string, p6) -- line: 273
	pcall(function() -- line: 274
		-- upvalues: p5 (copy), s4 (copy), p6 (copy)
		p5[s4] = p6
	end)
end
local function applyControlsFolder(p7, p8, p9) -- line: 282
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

			pcall(function() -- line: 274
				-- upvalues: p9Name (copy), childName (copy), childValue (copy)
				p9Name[childName] = childValue
			end)
		end
	end
end
local function applyKeyframeInner(p10, p11) -- line: 311
	-- upvalues: t1 (copy), t2 (ref), applyControlsFolder (copy)
	local function recurApplyPoses(p12, p13) -- line: 312
		-- upvalues: p10 (copy), t1 (copy), t2 (ref), applyControlsFolder (copy), recurApplyPoses (copy)
		if p12 and p13:IsA("Pose") then
			local p12Name = p10:FindFirstChild(p12.Name)
			local p13Name = p10:FindFirstChild(p13.Name)
			local v329 = t1.GetJointBetween(p12Name, p13Name)

			if v329 and not (t2[v329] and true or false) then
				assert(v329, "joint is non-nil. Silence type checker.")
				v329.Transform = p13.CFrame
				t2[v329] = true
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
local function getRotatedKeyframe(p14, n4: number?) -- line: 349
	if not n4 or n4 == 0 then
		return p14
	end

	assert(n4, "rotationDegrees is non-nil. Silence type checker.")

	local clone = p14:Clone()
	local v111 = clone:GetPoses()[1]

	if v111 then
		local v112 = v111:GetSubPoses()[1]

		if v112 then
			v112.CFrame = v112.CFrame * CFrame.Angles(0, math.rad(n4), 0)
		end
	end

	return clone
end
local function getRotationCFrame(p15, n5: number) -- line: 370
	if p15:IsA("EulerRotationCurve") then
		return p15:GetRotationAtTime(n5)
	end

	if p15:IsA("RotationCurve") then
		return p15:GetValueAtTime(n5)
	end

	error("Unsupported rotation type:" .. p15.ClassName)

	return nil
end
local function findAttachmentsRecur(p16, t3: {[any]: any}) -- line: 381
	-- upvalues: findAttachmentsRecur (copy)
	for _, child in pairs(p16:GetChildren()) do
		if child:IsA("Attachment") then
			t3[child.Name] = child
		elseif not child:IsA("Tool") and not child:IsA("Accoutrement") then
			findAttachmentsRecur(child, t3)
		end
	end
end
local function findAttachmentsInTool(p17) -- line: 392
	-- upvalues: findAttachmentsRecur (copy)
	local t4 = {}

	findAttachmentsRecur(p17, t4)

	return t4
end
local function findAttachmentsInCharacter(p18) -- line: 398
	-- upvalues: findAttachmentsRecur (copy)
	local t5 = {}

	findAttachmentsRecur(p18, t5)

	return t5
end
local function weldAttachments(p19, p20) -- line: 404
	local Weld = Instance.new("Weld")

	Weld.Part0 = p19.Parent
	Weld.Part1 = p20.Parent
	Weld.C0 = p19.CFrame
	Weld.C1 = p20.CFrame
	Weld.Parent = p19.Parent

	return Weld
end
local function attachToolToCharacter(p21, p22, p23) -- line: 414
	-- upvalues: findAttachmentsRecur (copy)
	local t6 = {}

	findAttachmentsRecur(p21, t6)

	local t7 = {}

	findAttachmentsRecur(p23, t7)

	local v131 = false

	for _, v in pairs(t7) do
		local v134 = t6[v.Name]

		if v134 then
			v131 = true

			local Weld = Instance.new("Weld")

			Weld.Part0 = v134.Parent
			Weld.Part1 = v.Parent
			Weld.C0 = v134.CFrame
			Weld.C1 = v.CFrame
			Weld.Parent = v134.Parent
		end
	end

	if v131 then
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
local function applyR15KeyframeWithTool(p24, p25, p26, n6: number?, p27, p28, p29) -- line: 446
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
local function getMainThumbnailKeyframe(p30, p31, b2: boolean, b3: boolean?) -- line: 500
	-- upvalues: getAnimationAndIsIdle (copy), t1 (copy), getThumbnailKeyframeFromAnimationOrUrl (copy), v6 (copy)
	local v150 = nil
	local v151 = false
	local AnimationId = nil

	if p31 then
		local v153, v154 = getAnimationAndIsIdle(p31)

		if v153 == nil then
			return nil, v151, p31
		end

		assert(v153, "animation is non-nil. Silence type checker.")

		if not v154 then
			v151 = true
		end

		local n7 = 0

		if b2 then
			n7 = t1.GetNumberValueWithDefault(v153, "ThumbnailCharacterRotation", 0)
		end

		return getThumbnailKeyframeFromAnimationOrUrl(v153, n7), v151, p31
	end

	if b3 then
		local FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL = t1.FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL
		local Animate = p30:FindFirstChild("Animate")

		if Animate then
			local v158 = Animate:FindFirstChild("Pose") or Animate:FindFirstChild("pose") or (not v6 or (Animate:FindFirstChild("Idle") or Animate:FindFirstChild("idle")))
			local v159 = if not v158 then nil else v158:FindFirstChildOfClass("Animation")

			if v159 then
				FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL = v159
			end
		end

		v150 = getThumbnailKeyframeFromAnimationOrUrl(FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL, 0, 1)

		if typeof(FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL) == "string" then
			return v150, v151, FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL
		end

		AnimationId = FALLBACK_KEYFRAME_SEQUENCE_ASSET_URL.AnimationId
	end

	return v150, v151, AnimationId
end
local function getMoodThumbnailKeyframe(p32) -- line: 568
	-- upvalues: getAnimationAndIsIdle (copy), getThumbnailKeyframeFromAnimationOrUrl (copy)
	if not p32 then
		return nil
	end

	assert(p32, "moodAssetId is non-nil. Silence type checker.")

	local v161, _ = getAnimationAndIsIdle(p32)

	if v161 == nil then
		return nil
	end

	assert(v161, "animation is non-nil. Silence type checker.")

	return getThumbnailKeyframeFromAnimationOrUrl(v161, 0)
end
local function getToolKeyframes(p33, b4: boolean) -- line: 600
	-- upvalues: t1 (copy)
	local ThumbnailPose = nil
	local v166 = nil
	local Tool = p33:FindFirstChildOfClass("Tool")

	if not Tool then
		return nil, nil
	end

	assert(Tool, "tool is non-nil. Silence type checker.")

	local v168 = false

	if not b4 then
		ThumbnailPose = Tool:FindFirstChild("ThumbnailPose")

		if ThumbnailPose and ThumbnailPose:IsA("Keyframe") then
			v168 = true
		end
	end

	if not v168 then
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
			local v172 = t1.GetAnimationClip(ToolNoneAnim)

			if not v172 then
				return nil, nil
			end

			assert(v172, "toolAnimationClip is non-nil. Silence type checker.")
			assert(v172:IsA("KeyframeSequence"), "ToolNoneAnim must be a KeyframeSequence")
			v166 = t1.GetThumbnailKeyframe(nil, v172, 0)

			if not Tool:IsDescendantOf(p33) then
				return nil, nil
			end
		end
	end

	return ThumbnailPose, v166
end
local function getAttachmentCFrame(p34) -- line: 659
	local p34CFrame = p34.CFrame
	local p34Parent = p34.Parent

	while p34Parent and p34Parent:IsA("Bone") do
		p34CFrame = p34Parent.CFrame * p34CFrame
		p34Parent = p34Parent.Parent
	end

	return p34CFrame
end
local function getJointParts(p35) -- line: 669
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
local function applyCFrame(p36, p37, p38, cFrame: CFrame) -- line: 682
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
local function getJointPose(p39) -- line: 695
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

function t1.ForceAnimationToStep(p40) -- line: 715
	-- upvalues: getJointParts (copy), getJointPose (copy), applyCFrame (copy)
	local t8 = { (p40:FindFirstChild("HumanoidRootPart")) }
	local t9 = {}
	local t10 = {}

	while #t8 > 0 do
		local v193 = table.remove(t8, 1)

		if not t9[v193] then
			t9[v193] = true

			for _, v195 in v193:GetJoints() do
				if v195:IsA("Motor6D") or v195:IsA("AnimationConstraint") then
					local v196, v197 = getJointParts(v195)

					if v196 == v193 and v197 and not t9[v197] then
						table.insert(t10, {
							part0 = v193,
							part1 = v197,
							joint = v195
						})
						table.insert(t8, v197)
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

	for _, v201 in t10 do
		local joint = v201.joint

		if joint:IsA("Motor6D") or joint:IsA("AnimationConstraint") then
			local v203 = getJointPose(joint)

			applyCFrame(v201.part0, v201.part1, joint, v203)
		end
	end
end
function t1.LoadAsset(n8: number) -- line: 761
	-- upvalues: t1 (copy), InsertService (copy)
	local ok, result = pcall(function() -- line: 762
		-- upvalues: t1 (copy), n8 (copy), InsertService (copy)
		if t1.debugLoadAssetsFromFiles and t1.mapAssetIdToFileName then
			local v332 = "rbxasset://" .. t1.mapAssetIdToFileName(n8)

			return InsertService:LoadLocalAsset(v332)
		end

		return InsertService:LoadAsset(n8)
	end)

	return ok, result
end
function t1.SetDebugLoadAssetsFromFiles(b5: boolean, p41: ((...any) -> ...any)) -- line: 783
	-- upvalues: t1 (copy)
	t1.debugLoadAssetsFromFiles = b5
	t1.mapAssetIdToFileName = p41
end
function t1.GetJointBetween(p42, p43) -- line: 791
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

function t1.PoseKeyframeHasFaceAnimation(p44) -- line: 815
	if not p44 then
		return false
	end

	assert(p44, "poseKeyframe is non-nil. Silence type checker.")

	local function recurHasFaceAnimation(p45) -- line: 821
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
function t1.ApplyKeyframe(p46, p47) -- line: 846
	-- upvalues: t2 (ref), applyKeyframeInner (copy), t1 (copy)
	t2 = {}
	applyKeyframeInner(p46, p47)
	t2 = {}

	local ok, result = pcall(function() -- line: 104
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)

	if ok and result then
		t1.ForceAnimationToStep(p46)
	end
end
function t1.GetNumberValueWithDefault(p48, s5: string, n9: number?) -- line: 855
	local s5_2 = p48:FindFirstChild(s5)

	if s5_2 and s5_2:IsA("NumberValue") then
		n9 = s5_2.Value
	end

	return n9
end
function t1.GetAnimationClip(p49) -- line: 868
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
function t1.GetThumbnailKeyframe(n10: number?, p50, n11: number) -- line: 884
	-- upvalues: getRotatedKeyframe (copy)
	local Keyframes = p50:GetKeyframes()
	local v230 = if not n10 or (not (n10 > 0) or not (n10 <= #Keyframes)) then Keyframes[math.ceil(#Keyframes / 2)] else Keyframes[n10]

	return (getRotatedKeyframe(v230, n11))
end
function t1.GetCurveAnimationTimeLength(p51) -- line: 902
	local n12 = 0

	for _, descendant in p51:GetDescendants() do
		if descendant:IsA("FloatCurve") and descendant.Length ~= 0 then
			n12 = math.max(n12, descendant:GetKeyAtIndex(descendant.Length).Time)
		end
	end

	return n12
end
function t1.GetThumbnailKeyframeFromCurve(n13: number?, p52, n14: number) -- line: 920
	-- upvalues: t1 (copy), getRotationCFrame (copy), getRotatedKeyframe (copy)
	local v239 = t1.GetCurveAnimationTimeLength(p52)

	if not n13 or (n13 < 0 or v239 < n13) then
		n13 = v239 / 2
	end

	assert(n13, "thumbnailTime should be non-nil. Silence type checker")

	local t11 = {
		Position = true,
		Rotation = true
	}

	local function hasSubFolders(p53) -- line: 938
		for _, child in p53:GetChildren() do
			if child:IsA("Folder") then
				return true
			end
		end

		return false
	end
	local function recurGenerateKeyframe(p54, p55) -- line: 947
		-- upvalues: getRotationCFrame (copy), n13 (ref), t11 (copy), recurGenerateKeyframe (copy)
		local Pose = nil
		local Position = p55:FindFirstChild("Position")
		local Rotation = p55:FindFirstChild("Rotation")

		if Position and Rotation then
			local v344 = getRotationCFrame(Rotation, n13)

			if v344 then
				local v345 = v344 + Vector3.new(table.unpack(Position:GetValueAtTime(n13)))

				Pose = Instance.new("Pose")
				Pose.CFrame = v345
				Pose.Name = p55.Name
				Pose.Parent = p54
			end
		else
			local g349 = nil
			local v348 = nil

			for _, child in p55:GetChildren() do
				if child:IsA("Folder") then
					v348 = true
					g349 = true
				end

				if g349 then
					break
				end
			end

			if not g349 then
				v348 = false
			end

			g349 = false

			if v348 then
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

				local v354 = child:GetValueAtTime(n13) or 0

				assert(v354, "valueAtTime should be non-nil. Silence type checker.")
				NumberPose.Value = v354
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
function t1.ClearPlayerCharacterFace(p56) -- line: 1013
	local FaceControls = p56:FindFirstChildWhichIsA("FaceControls", true)

	if FaceControls then
		local FaceControlsParent = FaceControls.Parent
		local children = FaceControls:GetChildren()
		local FaceControls2 = Instance.new("FaceControls")

		FaceControls2.Parent = FaceControlsParent

		for _, v252 in children do
			v252.Parent = FaceControls2
		end

		FaceControls:Destroy()
	end
end
function t1.AdjustArmOnR6ForTool(p57) -- line: 1030
	local Tool = p57:FindFirstChildOfClass("Tool")
	local Torso = p57:FindFirstChild("Torso")

	if Torso then
		local v256 = Torso:FindFirstChild("Right Shoulder")

		if v256 then
			if Tool then
				v256.CurrentAngle = 1.5707963267948966
				v256.DesiredAngle = 1.5707963267948966

				return
			end

			v256.CurrentAngle = 0
			v256.DesiredAngle = 0
		end
	end
end
function t1.SetPlayerCharacterFace(p58, p59) -- line: 1052
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

	local v259

	if not p59 then
		v259 = nil
	else
		assert(p59, "moodAssetId is non-nil. Silence type checker.")

		local v260, _ = getAnimationAndIsIdle(p59)

		if v260 == nil then
			v259 = nil
		else
			assert(v260, "animation is non-nil. Silence type checker.")
			v259 = getThumbnailKeyframeFromAnimationOrUrl(v260, 0)
		end
	end

	if not v259 then
		return
	end

	t1.ClearPlayerCharacterFace(p58)
	t1.ApplyKeyframe(p58, v259)
end
function t1.SetPlayerCharacterNeutralPose(p60) -- line: 1093
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

	local function recurResetJoint(p61) -- line: 1108
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
function t1.FindDefaultMoodAnimationId(p62) -- line: 1125
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

local function loadKeyframesForPoseR15(p63, n15: number?, n16: number?, b6: boolean?, b7: boolean?) -- line: 1144
	-- upvalues: getMainThumbnailKeyframe (copy), getToolKeyframes (copy), v5 (copy), t1 (copy), getAnimationAndIsIdle (copy), getThumbnailKeyframeFromAnimationOrUrl (copy), getAnimationClipByAssetId (copy)
	local t12 = {
		originalAnimationAssetId = n15
	}
	local v275, v276, v277 = getMainThumbnailKeyframe(p63, n15, not b6, not b7)
	local v278 = nil
	local v279 = nil

	if not b7 and v275 then
		v278, v279 = getToolKeyframes(p63, v276)
	end

	local v280 = nil
	local v281 = false

	if v5 or n16 and n16 ~= 0 then
		if n15 == nil then
			v281 = true
		elseif not t1.PoseKeyframeHasFaceAnimation(v275) then
			v281 = true
		end
	end

	if v281 then
		if v5 then
			if n16 and n16 ~= 0 then
				if not n16 then
					v280 = nil
				else
					assert(n16, "moodAssetId is non-nil. Silence type checker.")

					local v282, _ = getAnimationAndIsIdle(n16)

					if v282 == nil then
						v280 = nil
					else
						assert(v282, "animation is non-nil. Silence type checker.")
						v280 = getThumbnailKeyframeFromAnimationOrUrl(v282, 0)
					end
				end
			end

			if not v280 then
				local v284 = t1.FindDefaultMoodAnimationId(p63)

				if v284 then
					local v285 = getAnimationClipByAssetId(v284)

					if v285 and v285:IsA("KeyframeSequence") then
						v280 = t1.GetThumbnailKeyframe(nil, v285, 0)
					end
				end
			end
		elseif not n16 then
			v280 = nil
		else
			assert(n16, "moodAssetId is non-nil. Silence type checker.")

			local v286, _ = getAnimationAndIsIdle(n16)

			if v286 == nil then
				v280 = nil
			else
				assert(v286, "animation is non-nil. Silence type checker.")
				v280 = getThumbnailKeyframeFromAnimationOrUrl(v286, 0)
			end
		end
	end

	t12.poseKeyframe = v275
	t12.moodKeyframe = v280
	t12.defaultToolKeyframe = v279
	t12.suggestedKeyframeFromTool = v278
	t12.finalAnimationAssetIdOrUrl = v277

	return t12
end

function t1.LoadKeyframesForPose(p64, n17: number?, n18: number?, b8: boolean?, b9: boolean?) -- line: 1245
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
function t1.ApplyKeyframesForPose(p65, t13: {[any]: any}?) -- line: 1293
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

	local ok, result = pcall(function() -- line: 104
		return game.GetService(game, "ThumbnailGenerator") ~= nil
	end)

	if ok and result then
		t1.ForceAnimationToStep(p65)
	end
end
function t1.SetPlayerCharacterPoseWithMoodFallback(p66, n19: number?, n20: number?, b10: boolean?, b11: boolean?) -- line: 1359
	-- upvalues: t1 (copy)
	local Humanoid = p66:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	assert(Humanoid, "humanoid should be non-nil.  Silence type checker.")

	local v307 = t1.LoadKeyframesForPose(p66, n19, n20, b10, b11)

	t1.ApplyKeyframesForPose(p66, v307)
end
function t1.ThumbnailZoomExtents(p67, n21: number, n22: number, n23: number, n24: number) -- line: 1383
	local ModelCFrame = p67:GetModelCFrame()
	local LookVector = ModelCFrame.LookVector
	local HumanoidRootPart = p67:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		LookVector = HumanoidRootPart.CFrame.LookVector
	end

	local cFrame = CFrame.new(ModelCFrame.Position + LookVector * 5, ModelCFrame.Position)
	local v317 = ModelCFrame.Position + Vector3.new(n22, -n23, 0)
	local ExtentsSize = p67:GetExtentsSize()
	local ExtentsSizeX = ExtentsSize.X
	local ExtentsSizeY = ExtentsSize.Y
	local ExtentsSizeZ = ExtentsSize.Z
	local v322 = math.sqrt(ExtentsSizeX ^ 2 + ExtentsSizeY ^ 2 + ExtentsSizeZ ^ 2)
	local v323 = 1 / math.tan(math.rad(n21) / 2)
	local v324 = v322 / 2 * v323 * (1 / n24)

	return cFrame - cFrame.Position + v317 + LookVector * v324
end

return t1
