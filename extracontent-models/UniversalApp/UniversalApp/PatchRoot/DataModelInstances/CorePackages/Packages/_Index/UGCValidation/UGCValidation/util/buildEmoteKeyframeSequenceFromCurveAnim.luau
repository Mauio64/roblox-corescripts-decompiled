local parent = script.Parent.Parent
local CurveAnimationHierarchyUtils = require(parent.util.CurveAnimationHierarchyUtils)

local function hasFloatCurveKeys(instance): boolean
	for _, floatCurve in instance:GetChildren() do
		if floatCurve:IsA("FloatCurve") and #floatCurve:GetKeys() > 0 then
			return true
		end
	end

	return false
end

local function rotationCurveHasKeys(instance)
	if instance:IsA("EulerRotationCurve") then
		return hasFloatCurveKeys(instance)
	end

	if instance:IsA("RotationCurve") then
		return instance:GetNumberOfKeys() > 0
	end

	return false
end

local function folderHasTracks(folder)
	local position = folder:FindFirstChild("Position")
	local rotation = folder:FindFirstChild("Rotation")
	local v = (position ~= nil and position:IsA("Vector3Curve") and true or false) and hasFloatCurveKeys(position)

	if v then
		return v
	end

	if rotation == nil then
		v = false
		return false
	end

	if rotation:IsA("EulerRotationCurve") then
		return hasFloatCurveKeys(rotation)
	end

	if rotation:IsA("RotationCurve") then
		return rotation:GetNumberOfKeys() > 0
	end

	v = false
	return false
end

local function subtreeHasTracks(folder): boolean
	if folderHasTracks(folder) then
		return true
	end

	for _, folder2 in folder:GetDescendants() do
		if folder2:IsA("Folder") and folderHasTracks(folder2) then
			return true
		end
	end

	return false
end

local function getFolderRoot(instance) -- 1 equivalent call inferred from this helper
	for _, folder in instance:GetChildren() do
		if folder:IsA("Folder") then
			return folder
		end
	end

	return nil
end

local function getAnimLength(folder)
	local animLength = 0

	for _, descendant in folder:GetDescendants() do
		if descendant:IsA("FloatCurve") then
			for _, v in descendant:GetKeys() do
				if animLength < v.Time then
					animLength = v.Time
				end
			end
		elseif descendant:IsA("RotationCurve") then
			local numberOfKeys = descendant:GetNumberOfKeys()

			if numberOfKeys > 0 then
				local keyAtIndex = descendant:GetKeyAtIndex(numberOfKeys)

				if animLength < keyAtIndex.Time then
					animLength = keyAtIndex.Time
				end
			end
		end
	end

	return animLength
end

local function samplePosition(instance, p: number)
	local position = instance:FindFirstChild("Position")

	if not (position and position:IsA("Vector3Curve")) then
		return Vector3.new(0, 0, 0)
	end

	local x = position:FindFirstChild("X")
	local y = position:FindFirstChild("Y")
	local z = position:FindFirstChild("Z")
	return (Vector3.new(
		not (x and x:IsA("FloatCurve")) and 0 or x:GetValueAtTime(p),
		not (y and y:IsA("FloatCurve")) and 0 or y:GetValueAtTime(p),
		not (z and z:IsA("FloatCurve")) and 0 or z:GetValueAtTime(p)
	))
end

local function sampleRotation(instance, p: number)
	local rotation = instance:FindFirstChild("Rotation")

	if not rotation then
		return CFrame.new()
	end

	if rotation:IsA("EulerRotationCurve") or rotation:IsA("RotationCurve") then
		return rotation:GetRotationAtTime(p)
	end

	return CFrame.new()
end

local function buildPoseAtTime(folderRoot, p: number, nameSet)
	local pose = Instance.new("Pose")
	pose.Name = folderRoot.Name
	pose.Weight = 1

	local v = samplePosition(folderRoot, p)
	pose.CFrame = sampleRotation(folderRoot, p) + v

	local nameSet2 = {}

	for _, folder in folderRoot:GetChildren() do
		if not folder:IsA("Folder") or nameSet[folder.Name] then
			continue
		end

		if not (CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(folder.Name) or folder.Name == CurveAnimationHierarchyUtils.humanoidRootPartName or subtreeHasTracks(folder)) then
			continue
		end

		nameSet[folder.Name] = true
		local poseAtTime = buildPoseAtTime(folder, p, nameSet)
		poseAtTime.Parent = pose
		nameSet2[folder.Name] = true
	end

	for _, v2 in CurveAnimationHierarchyUtils.calculateAcceptableChildBodyPartFolders(folderRoot.Name) do
		local name = v2.Name

		if not name or (nameSet2[name] or nameSet[name]) then
			continue
		end

		nameSet[name] = true
		local pose2 = Instance.new("Pose")
		pose2.Name = name
		pose2.CFrame = CFrame.new()
		pose2.Weight = 1
		pose2.Parent = pose
		nameSet2[name] = true
	end

	return pose
end

local function buildEmoteKeyframeSequenceFromCurveAnim(instance, value: number?)
	local v = value or 1 / 24
	local folderRoot = getFolderRoot(instance) -- inferred equivalent call

	if not folderRoot then
		warn("[buildEmoteKeyframeSequenceFromCurveAnim]: no folder root found in CurveAnimation")
		return Instance.new("KeyframeSequence")
	end

	local animLength = getAnimLength(folderRoot)

	if animLength <= 0 then
		warn("[buildEmoteKeyframeSequenceFromCurveAnim]: animation has no keyframes")
		return Instance.new("KeyframeSequence")
	end

	local emoteAnimation = Instance.new("KeyframeSequence")
	emoteAnimation.Name = "EmoteAnimation"
	local total = 0

	while total <= animLength + v * 0.5 do
		local time = math.min(total, animLength)
		local keyframe = Instance.new("Keyframe")
		keyframe.Time = time

		local nameSet = { [folderRoot.Name] = true }
		local poseAtTime = buildPoseAtTime(folderRoot, time, nameSet)
		poseAtTime.Parent = keyframe
		keyframe.Parent = emoteAnimation

		total += v
	end

	return emoteAnimation
end

return buildEmoteKeyframeSequenceFromCurveAnim
