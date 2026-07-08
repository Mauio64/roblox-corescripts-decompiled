local CameraUtility = require(script.Parent.CameraUtility)
local CFrameUtility = require(script.Parent.CFrameUtility)
local CharacterUtility = require(script.Parent.CharacterUtility)
local MannequinUtility = require(script.Parent.MannequinUtility)
local v5 = game:DefineFastInt("CameraPresetHeadshotExtentScaleHundredths", 130)
local t1 = {
	GOLDEN_RATIO = game:DefineFastInt("AvatarGoldenRatio", 618) / 1000,
	UPVECTOR_ORENTATION_TRESHOLD = game:DefineFastInt("UpVectorOrentationThreshold1", -60) / 100,
	AVATAR_ROTATION_DEGREE = game:DefineFastInt("LookAvatarRotationDegree1", 23)
}

local function getTorsoOrUpperTorso(p1) -- line: 18
	return p1:FindFirstChild("Torso") or p1:FindFirstChild("UpperTorso")
end
local function getMannequinBodyParts(p2, p3) -- line: 22
	-- upvalues: MannequinUtility (copy)
	local t2 = {}

	if p3.RigType == Enum.HumanoidRigType.R6 then
		for v13, _ in MannequinUtility.CharacterPartNames.R6 do
			if v13 ~= "CharacterMesh" and v13 ~= "HumanoidRootPart" then
				table.insert(t2, (p2:FindFirstChild(v13)))
			end
		end

		return t2
	end

	if p3.RigType == Enum.HumanoidRigType.R15 then
		for v15, _ in MannequinUtility.CharacterPartNames.R15 do
			if v15 ~= "HumanoidRootPart" then
				table.insert(t2, (p2:FindFirstChild(v15)))
			end
		end
	end

	return t2
end

function t1.GetCharacterTorsoCFrame(p4) -- line: 43
	return (p4:FindFirstChild("Torso") or p4:FindFirstChild("UpperTorso")).CFrame
end
function t1.GetFullBodyCameraCFrame(p5, p6: ((...any) -> ...any)?, b1: boolean?, n1: number?, cFrame: CFrame?) -- line: 61
	-- upvalues: t1 (copy), getMannequinBodyParts (copy), CharacterUtility (copy), CameraUtility (copy)
	local v23 = n1 or 56
	local v24 = cFrame or t1.GetCharacterTorsoCFrame(p5)
	local LookVector = v24.LookVector

	if type(p6) == "function" then
		p6()
	end

	local Humanoid = p5:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	local v27 = getMannequinBodyParts(p5, Humanoid)
	local CFrame2 = (p5:FindFirstChild("Torso") or p5:FindFirstChild("UpperTorso")).CFrame
	local UpVector = CFrame2.UpVector
	local v30, v31, v32 = p5:FindFirstChild("Head").CFrame:ToEulerAnglesXYZ()

	if b1 then
		p5:PivotTo(v24 * CFrame.Angles(0, math.rad(t1.AVATAR_ROTATION_DEGREE * -1), 0))
	end

	local v33, v34 = CharacterUtility.CalculateBodyPartsExtents(CFrame2, v27)
	local v35 = math.tan((math.rad(v23 / 2)))
	local v36 = v33:Lerp(v34, t1.GOLDEN_RATIO)
	local v37 = v33:Lerp(v34, 0.5)
	local vector3 = Vector3.new(v37.X, v36.Y, v37.Z)
	local v39 = CFrame2:PointToWorldSpace(vector3)
	local v40 = CFrame2 - CFrame2.Position + v39

	if not b1 then
		local cFrame2 = CFrame.fromEulerAnglesXYZ(v30, v31, v32)

		v40 = cFrame2 - cFrame2.Position + v39
	end

	local v42 = math.max(vector3.X - v33.X, vector3.Y - v33.Y)
	local v43 = math.max(v34.X - vector3.X, v34.Y - vector3.Y)
	local v44 = v42 * CameraUtility.DefaultBodyMarginScale / v35
	local v45 = v43 * CameraUtility.DefaultBodyMarginScale / v35
	local v46 = UpVector.Y < t1.UPVECTOR_ORENTATION_TRESHOLD
	local v47 = UpVector.X < t1.UPVECTOR_ORENTATION_TRESHOLD

	if v46 or v47 then
		v44 = math.max(v44, v45)
	end

	local v48 = v44 * CameraUtility.DistanceScaleForFullBody * LookVector

	return CameraUtility.GetCameraCFrame(v40, v48)
end

t1.GetCameraCFrame_ForAvatarR15Action_LookAtGoldenRatioOfTheHumanoid = t1.GetFullBodyCameraCFrame

function t1.GetHeadshotCameraCFrame(p7, p8: ((...any) -> ...any)?, b2: boolean?, n2: number?) -- line: 163
	-- upvalues: t1 (copy), CFrameUtility (copy), CharacterUtility (copy), CameraUtility (copy), v5 (copy)
	local v53 = n2 or 30

	if type(p8) == "function" then
		p8()
	end

	if b2 then
		p7:PivotTo(t1.GetCharacterTorsoCFrame(p7) * CFrame.Angles(0, math.rad(t1.AVATAR_ROTATION_DEGREE * -1), 0))
	end

	local Head = p7:FindFirstChild("Head")

	if not Head then
		error("Character is missing a Head, cannot apply upper body camera preset.")
	end

	local HeadCFrame = Head.CFrame
	local FaceFrontAttachment = Head:FindFirstChild("FaceFrontAttachment")

	if FaceFrontAttachment then
		HeadCFrame = FaceFrontAttachment.WorldCFrame
	end

	local v57 = CFrameUtility.CalculateTargetCFrame(HeadCFrame)
	local v58, v59 = CharacterUtility.CalculateHeadExtents(p7, v57)
	local v60 = CameraUtility.CreateThumbnailCamera()
	local t3 = {
		extentScale = v5 / 100,
		maxExtent = v59,
		minExtent = v58,
		optCameraXRot = CameraUtility.XRotForCloseup,
		optFieldOfView = v53,
		targetCFrame = v57
	}

	CameraUtility.SetupCamera(v60, t3)
end

return t1
