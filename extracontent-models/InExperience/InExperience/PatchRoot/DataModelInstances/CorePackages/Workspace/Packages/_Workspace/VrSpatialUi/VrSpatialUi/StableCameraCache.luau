local Parent = script:FindFirstAncestor("VrSpatialUi").Parent
local VRUtil = require(Parent.VrCommon).VRUtil
local v3 = game:DefineFastInt("SpatialUIHeadLookDotNoMovementThreshold", 990) / 1000
local t1 = {}

t1.__index = t1

function t1.getCurrentStableCameraCFrame(p1) -- line: 18
	return p1.lastCameraCFrame
end
function t1.updateAndCheckCameraMoved(p2) -- line: 22
	-- upvalues: VRUtil (copy), v3 (copy)
	local v7 = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head)

	if not p2.lastUserHeadCFrame then
		p2.lastUserHeadCFrame = v7
		p2.lastCameraCFrame = workspace.CurrentCamera.CFrame

		return true
	end

	local v8 = workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable
	local v9 = p2.lastUserHeadCFrame.LookVector:Dot(v7.LookVector) < v3

	if not v8 or v9 then
		p2.lastUserHeadCFrame = v7
		p2.lastCameraCFrame = workspace.CurrentCamera.CFrame

		return true
	end

	return false
end
function t1.new() -- line: 44
	-- upvalues: t1 (copy)
	local t2 = {
		lastUserHeadCFrame = nil,
		lastCameraCFrame = nil
	}

	setmetatable(t2, t1)

	return t2
end

return t1
