local CameraUtility = {}

local CFrameUtility = require(script.Parent.CFrameUtility)
local VectorUtility = require(script.Parent.VectorUtility)
local CharacterUtility = require(script.Parent.CharacterUtility)

CameraUtility.DefaultHeadMarginScale = 1.1

CameraUtility.DefaultBodyMarginScale = 1.1

CameraUtility.DefaultBodyPartMarginScale = 1.2

CameraUtility.XRotForFullBody = 15
CameraUtility.XRotForCloseup = 0
CameraUtility.DistanceScaleForFullBody = 1

local cframe = CFrame.fromEulerAnglesYXZ(-0.3490658503988659, 0.3490658503988659, 0)
local cframe2 = CFrame.fromEulerAnglesYXZ(-0.3490658503988659, -0.3490658503988659, 0)

local cframe3 = CFrame.Angles(0.4363323129985824, 0.4363323129985824, 0)

local cframe4 = CFrame.Angles(0, 1.5707963267948966, 0)

local cframe5 = CFrame.Angles(0, -1.5707963267948966, 0)

function CameraUtility.GetCameraCFrame(cframe6: CFrame, vector3: Vector3)
	local v = cframe6 * vector3
	return CFrame.lookAt(v, cframe6.Position)
end

function CameraUtility.CreateThumbnailCamera()
	local thumbnailCamera = Instance.new("Camera")
	thumbnailCamera.Name = "ThumbnailCamera"
	thumbnailCamera.CameraType = Enum.CameraType.Scriptable
	thumbnailCamera.Parent = workspace:GetChildren()[1]
	return thumbnailCamera
end

function CameraUtility.CalculateBaseDistanceToCamera(p: number, vector3: Vector3, vector3_2: Vector3, p2: number)
	local v = math.max((vector3_2.X - vector3.X) / 2, (vector3_2.Y - vector3.Y) / 2)
	local v2 = math.tan(p / 2)
	return v * p2 / v2
end

function CameraUtility:SetupCamera(data)
	if data.optFieldOfView then
		self.FieldOfView = data.optFieldOfView
	end

	local optFieldOfViewForDistanceScale = data.optFieldOfViewForDistanceScale or self.FieldOfView
	local baseDistanceToCamera = CameraUtility.CalculateBaseDistanceToCamera(
		math.rad(optFieldOfViewForDistanceScale),
		data.minExtent,
		data.maxExtent,
		data.extentScale
	)

	if data.optCameraDistanceScale then
		baseDistanceToCamera *= data.optCameraDistanceScale
	end

	local adjustTargetCFrameWithExtents = CFrameUtility.AdjustTargetCFrameWithExtents(
		data.targetCFrame,
		data.minExtent,
		data.maxExtent
	)

	local optCameraXRot = data.optCameraXRot or 0
	local optCameraYRot = data.optCameraYRot or 0

	local vector3FromXYRotPlusDistance = VectorUtility.Vector3FromXYRotPlusDistance(
		optCameraXRot,
		optCameraYRot,
		baseDistanceToCamera
	)
	self.CFrame = CameraUtility.GetCameraCFrame(adjustTargetCFrameWithExtents, vector3FromXYRotPlusDistance)
end

function CameraUtility.SetupBodyPartCamera(instance, flag: boolean, list, p)
	local children = {}

	if #list > 0 then
		for _, childName in pairs(list) do
			local child = instance:FindFirstChild(childName, true)

			if child then
				table.insert(children, child)
			end
		end
	end

	local cframe6 = instance:FindFirstChild("HumanoidRootPart").CFrame
	local v = if flag then cframe2 else cframe
	local targetCFrame = v * cframe6

	local bodyPartsExtents, maxExtent = CharacterUtility.CalculateBodyPartsExtents(targetCFrame, children)

	local v2 = {
		optFieldOfView = 30,
		targetCFrame = targetCFrame,
		minExtent = bodyPartsExtents,
		maxExtent = maxExtent,
		extentScale = CameraUtility.DefaultBodyPartMarginScale
	}

	CameraUtility.SetupCamera(p, v2)
end

function CameraUtility.SetupHeadCamera(instance, p)
	local head = instance:FindFirstChild("Head")

	local targetCFrame = CFrameUtility.CalculateTargetCFrame(head.CFrame)

	local targetCFrame2 = CFrame.fromEulerAnglesYXZ(0.2617993877991494, 0.5235987755982988, 0) * targetCFrame

	local headExtents, maxExtent = CharacterUtility.CalculateHeadExtents(instance, targetCFrame2)

	CameraUtility.SetupCamera(p, {
		optFieldOfView = 30,
		targetCFrame = targetCFrame2,
		minExtent = headExtents,
		maxExtent = maxExtent,
		extentScale = 1.1
	})
end

local function isLeftShoe(instance): boolean -- 1 equivalent call inferred from this helper
	local meshPart = instance:FindFirstChildWhichIsA("MeshPart")

	if not meshPart then
		return false
	end

	assert(meshPart, "Assert handle is not nil to silence type checker")
	return meshPart:FindFirstChild("LeftFootAttachment") ~= nil
end

local function isRightShoe(instance): boolean -- 1 equivalent call inferred from this helper
	local meshPart = instance:FindFirstChildWhichIsA("MeshPart")

	if not meshPart then
		return false
	end

	assert(meshPart, "Assert handle is not nil to silence type checker")
	return meshPart:FindFirstChild("RightFootAttachment") ~= nil
end

local function getAccessoryAngle(child) -- 1 equivalent call inferred from this helper
	if isLeftShoe(child) then -- inferred equivalent call
		return cframe4
	end

	if isRightShoe(child) then -- inferred equivalent call
		return cframe5
	end

	return cframe3
end

function CameraUtility.SetupAccessoryCamera(instance, p)
	local children = instance:GetChildren()
	assert(#children == 1, "Assert SetupMeshPartAccessoryCamera accessoryModel only has accessory as a child.")
	local child = children[1]
	local handle = child:FindFirstChild("Handle")
	assert(handle, "Assert Accessory has handle for camera setup.")
	handle.CFrame = CFrame.new()
	local targetCFrame = handle.CFrame * getAccessoryAngle(child) -- inferred equivalent call

	local modelExtents, maxExtent = CharacterUtility.CalculateModelExtents(instance, targetCFrame)

	CameraUtility.SetupCamera(p, {
		optFieldOfView = 20,
		targetCFrame = targetCFrame,
		minExtent = modelExtents,
		maxExtent = maxExtent,
		extentScale = 1.1
	})
end

return CameraUtility
