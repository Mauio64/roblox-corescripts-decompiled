local t1 = {}
local CFrameUtility = require(script.Parent.CFrameUtility)
local VectorUtility = require(script.Parent.VectorUtility)
local CharacterUtility = require(script.Parent.CharacterUtility)

t1.DefaultHeadMarginScale = 1.1
t1.DefaultBodyMarginScale = 1.1
t1.DefaultBodyPartMarginScale = 1.2
t1.XRotForFullBody = 15
t1.XRotForCloseup = 0
t1.DistanceScaleForFullBody = 1

local cFrame = CFrame.fromEulerAnglesYXZ(-0.3490658503988659, 0.3490658503988659, 0)
local cFrame2 = CFrame.fromEulerAnglesYXZ(-0.3490658503988659, -0.3490658503988659, 0)
local cFrame3 = CFrame.Angles(0.4363323129985824, 0.4363323129985824, 0)
local cFrame4 = CFrame.Angles(0, 1.5707963267948966, 0)
local cFrame5 = CFrame.Angles(0, -1.5707963267948966, 0)

function t1.GetCameraCFrame(cFrame6: CFrame, vector3: Vector3) -- line: 59
	local v15 = cFrame6 * vector3

	return CFrame.lookAt(v15, cFrame6.Position)
end
function t1.CreateThumbnailCamera() -- line: 71
	local Camera = Instance.new("Camera")

	Camera.Name = "ThumbnailCamera"
	Camera.CameraType = Enum.CameraType.Scriptable
	Camera.Parent = workspace:GetChildren()[1]

	return Camera
end
function t1.CalculateBaseDistanceToCamera(n1: number, vector3: Vector3, vector3_2: Vector3, n2: number) -- line: 87
	local v21 = math.max((vector3_2.X - vector3.X) / 2, (vector3_2.Y - vector3.Y) / 2)
	local v22 = math.tan(n1 / 2)

	return v21 * n2 / v22
end
function t1.SetupCamera(p1, t2: {[any]: any}) -- line: 118
	-- upvalues: t1 (copy), CFrameUtility (copy), VectorUtility (copy)
	if t2.optFieldOfView then
		p1.FieldOfView = t2.optFieldOfView
	end

	local v25 = t2.optFieldOfViewForDistanceScale or p1.FieldOfView
	local v26 = t1.CalculateBaseDistanceToCamera(math.rad(v25), t2.minExtent, t2.maxExtent, t2.extentScale)

	if t2.optCameraDistanceScale then
		v26 *= t2.optCameraDistanceScale
	end

	local v27 = CFrameUtility.AdjustTargetCFrameWithExtents(t2.targetCFrame, t2.minExtent, t2.maxExtent)
	local v28 = t2.optCameraXRot or 0
	local v29 = t2.optCameraYRot or 0
	local v30 = VectorUtility.Vector3FromXYRotPlusDistance(v28, v29, v26)

	p1.CFrame = t1.GetCameraCFrame(v27, v30)
end
function t1.SetupBodyPartCamera(p2, b1: boolean, t3: {[any]: any}, p3) -- line: 157
	-- upvalues: cFrame2 (copy), cFrame (copy), CharacterUtility (copy), t1 (copy)
	local t4 = {}

	if #t3 > 0 then
		for _, v in pairs(t3) do
			local v2 = p2:FindFirstChild(v, true)

			if v2 then
				table.insert(t4, v2)
			end
		end
	end

	local CFrame2 = p2:FindFirstChild("HumanoidRootPart").CFrame
	local v40 = ((if not b1 then cFrame else cFrame2)) * CFrame2
	local v41, v42 = CharacterUtility.CalculateBodyPartsExtents(v40, t4)
	local t5 = {
		optFieldOfView = 30,
		targetCFrame = v40,
		minExtent = v41,
		maxExtent = v42,
		extentScale = t1.DefaultBodyPartMarginScale
	}

	t1.SetupCamera(p3, t5)
end
function t1.SetupHeadCamera(p4, p5) -- line: 195
	-- upvalues: CFrameUtility (copy), CharacterUtility (copy), t1 (copy)
	local Head = p4:FindFirstChild("Head")
	local v47 = CFrameUtility.CalculateTargetCFrame(Head.CFrame)
	local v48 = CFrame.fromEulerAnglesYXZ(0.2617993877991494, 0.5235987755982988, 0) * v47
	local v49, v50 = CharacterUtility.CalculateHeadExtents(p4, v48)
	local t6 = {
		optFieldOfView = 30,
		extentScale = 1.1,
		targetCFrame = v48,
		minExtent = v49,
		maxExtent = v50
	}

	t1.SetupCamera(p5, t6)
end

local function isLeftShoe(p6) -- line: 224
	local MeshPart = p6:FindFirstChildWhichIsA("MeshPart")

	if not MeshPart then
		return false
	end

	assert(MeshPart, "Assert handle is not nil to silence type checker")

	return MeshPart:FindFirstChild("LeftFootAttachment") ~= nil
end
local function isRightShoe(p7) -- line: 233
	local MeshPart = p7:FindFirstChildWhichIsA("MeshPart")

	if not MeshPart then
		return false
	end

	assert(MeshPart, "Assert handle is not nil to silence type checker")

	return MeshPart:FindFirstChild("RightFootAttachment") ~= nil
end
local function getAccessoryAngle(p8) -- line: 242
	-- upvalues: cFrame4 (copy), cFrame5 (copy), cFrame3 (copy)
	local MeshPart = p8:FindFirstChildWhichIsA("MeshPart")
	local v58

	if not MeshPart then
		v58 = false
	else
		assert(MeshPart, "Assert handle is not nil to silence type checker")
		v58 = MeshPart:FindFirstChild("LeftFootAttachment") ~= nil
	end

	if v58 then
		return cFrame4
	end

	local MeshPart2 = p8:FindFirstChildWhichIsA("MeshPart")
	local v60

	if not MeshPart2 then
		v60 = false
	else
		assert(MeshPart2, "Assert handle is not nil to silence type checker")
		v60 = MeshPart2:FindFirstChild("RightFootAttachment") ~= nil
	end

	if v60 then
		return cFrame5
	end

	return cFrame3
end

function t1.SetupAccessoryCamera(p9, p10) -- line: 251
	-- upvalues: cFrame4 (copy), cFrame5 (copy), cFrame3 (copy), CharacterUtility (copy), t1 (copy)
	local children = p9:GetChildren()

	assert(#children == 1, "Assert SetupMeshPartAccessoryCamera accessoryModel only has accessory as a child.")

	local v64 = children[1]
	local Handle = v64:FindFirstChild("Handle")

	assert(Handle, "Assert Accessory has handle for camera setup.")
	Handle.CFrame = CFrame.new()

	local HandleCFrame = Handle.CFrame
	local MeshPart = v64:FindFirstChildWhichIsA("MeshPart")
	local v68

	if not MeshPart then
		v68 = false
	else
		assert(MeshPart, "Assert handle is not nil to silence type checker")
		v68 = MeshPart:FindFirstChild("LeftFootAttachment") ~= nil
	end

	local v69

	if v68 then
		v69 = cFrame4
	else
		local MeshPart3 = v64:FindFirstChildWhichIsA("MeshPart")
		local v71

		if not MeshPart3 then
			v71 = false
		else
			assert(MeshPart3, "Assert handle is not nil to silence type checker")
			v71 = MeshPart3:FindFirstChild("RightFootAttachment") ~= nil
		end

		v69 = if not v71 then cFrame3 else cFrame5
	end

	local v72 = HandleCFrame * v69
	local v73, v74 = CharacterUtility.CalculateModelExtents(p9, v72)
	local t7 = {
		optFieldOfView = 20,
		extentScale = 1.1,
		targetCFrame = v72,
		minExtent = v73,
		maxExtent = v74
	}

	t1.SetupCamera(p10, t7)
end

return t1
