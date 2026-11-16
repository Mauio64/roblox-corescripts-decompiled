local CameraUtility = require(script.Parent.CameraUtility)
local CFrameUtility = require(script.Parent.CFrameUtility)
local CharacterUtility = require(script.Parent.CharacterUtility)
local MannequinUtility = require(script.Parent.MannequinUtility)

local defineFastInt = game:DefineFastInt("CameraPresetHeadshotExtentScaleHundredths", 130)

local CameraPresetsUtility = {}
CameraPresetsUtility.GOLDEN_RATIO = game:DefineFastInt("AvatarGoldenRatio", 618) / 1000
CameraPresetsUtility.UPVECTOR_ORENTATION_TRESHOLD = game:DefineFastInt("UpVectorOrentationThreshold1", -60) / 100
CameraPresetsUtility.AVATAR_ROTATION_DEGREE = game:DefineFastInt("LookAvatarRotationDegree1", 23)

local function getTorsoOrUpperTorso(instance) -- 2 equivalent calls inferred from this helper
	return instance:FindFirstChild("Torso") or instance:FindFirstChild("UpperTorso")
end

local function getMannequinBodyParts(instance, humanoid)
	local mannequinBodyParts = {}

	if humanoid.RigType == Enum.HumanoidRigType.R6 then
		for childName, _ in MannequinUtility.CharacterPartNames.R6 do
			if childName ~= "CharacterMesh" and childName ~= "HumanoidRootPart" then
				table.insert(mannequinBodyParts, (instance:FindFirstChild(childName)))
			end
		end
	elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
		for childName, _ in MannequinUtility.CharacterPartNames.R15 do
			if childName ~= "HumanoidRootPart" then
				table.insert(mannequinBodyParts, (instance:FindFirstChild(childName)))
			end
		end
	end

	return mannequinBodyParts
end

function CameraPresetsUtility.GetCharacterTorsoCFrame(instance)
	return getTorsoOrUpperTorso(instance).CFrame -- inferred equivalent call
end

function CameraPresetsUtility.GetFullBodyCameraCFrame(instance, callback, flag: boolean?, value: number?, cframe: CFrame?)
	local v = cframe or CameraPresetsUtility.GetCharacterTorsoCFrame(instance)
	local lookVector = v.LookVector

	if type(callback) == "function" then
		callback()
	end

	local humanoid = instance:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	local mannequinBodyParts = getMannequinBodyParts(instance, humanoid)

	local cframe2 = getTorsoOrUpperTorso(instance).CFrame -- inferred equivalent call
	local upVector = cframe2.UpVector

	local eulerAnglesXYZ, v2, v3 = instance:FindFirstChild("Head").CFrame:ToEulerAnglesXYZ()

	if flag then
		instance:PivotTo(v * CFrame.Angles(0, math.rad(CameraPresetsUtility.AVATAR_ROTATION_DEGREE * -1), 0))
	end

	local bodyPartsExtents, v4 = CharacterUtility.CalculateBodyPartsExtents(cframe2, mannequinBodyParts)

	local v5 = math.tan((math.rad((value or 56) / 2)))

	local lerped = bodyPartsExtents:Lerp(v4, CameraPresetsUtility.GOLDEN_RATIO)
	local lerped2 = bodyPartsExtents:Lerp(v4, 0.5)
	local vector3 = Vector3.new(lerped2.X, lerped.Y, lerped2.Z)

	local pointToWorldSpace = cframe2:PointToWorldSpace(vector3)

	local v6 = cframe2 - cframe2.Position + pointToWorldSpace

	if not flag then
		local cframe3 = CFrame.fromEulerAnglesXYZ(eulerAnglesXYZ, v2, v3)
		v6 = cframe3 - cframe3.Position + pointToWorldSpace
	end

	local v7 = math.max(vector3.X - bodyPartsExtents.X, vector3.Y - bodyPartsExtents.Y)
	local v8 = math.max(v4.X - vector3.X, v4.Y - vector3.Y)

	local v9 = v7 * CameraUtility.DefaultBodyMarginScale / v5
	local v10 = v8 * CameraUtility.DefaultBodyMarginScale / v5

	local v11 = upVector.Y < CameraPresetsUtility.UPVECTOR_ORENTATION_TRESHOLD
	local v12 = upVector.X < CameraPresetsUtility.UPVECTOR_ORENTATION_TRESHOLD

	if v11 or v12 then
		v9 = math.max(v9, v10)
	end

	local v13 = v9 * CameraUtility.DistanceScaleForFullBody * lookVector
	return CameraUtility.GetCameraCFrame(v6, v13)
end

CameraPresetsUtility.GetCameraCFrame_ForAvatarR15Action_LookAtGoldenRatioOfTheHumanoid = CameraPresetsUtility.GetFullBodyCameraCFrame

function CameraPresetsUtility.GetHeadshotCameraCFrame(instance, callback, flag: boolean?, value: number?)
	if type(callback) == "function" then
		callback()
	end

	if flag then
		instance:PivotTo(CameraPresetsUtility.GetCharacterTorsoCFrame(instance) * CFrame.Angles(
			0,
			math.rad(CameraPresetsUtility.AVATAR_ROTATION_DEGREE * -1),
			0
		))
	end

	local head = instance:FindFirstChild("Head")

	if not head then
		error("Character is missing a Head, cannot apply upper body camera preset.")
	end

	local v = head.CFrame
	local faceFrontAttachment = head:FindFirstChild("FaceFrontAttachment")

	if faceFrontAttachment then
		v = faceFrontAttachment.WorldCFrame
	end

	local targetCFrame = CFrameUtility.CalculateTargetCFrame(v)

	local headExtents, maxExtent = CharacterUtility.CalculateHeadExtents(instance, targetCFrame)

	local thumbnailCamera = CameraUtility.CreateThumbnailCamera()
	local v2 = {
		extentScale = defineFastInt / 100,
		maxExtent = maxExtent,
		minExtent = headExtents,
		optCameraXRot = CameraUtility.XRotForCloseup,
		optFieldOfView = value or 30,
		targetCFrame = targetCFrame
	}

	CameraUtility.SetupCamera(thumbnailCamera, v2)
end

return CameraPresetsUtility
