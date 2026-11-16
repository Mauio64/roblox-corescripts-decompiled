local parent = script:FindFirstAncestor("VrSpatialUi").Parent
local VrCommon = require(parent.VrCommon)
local VRUtil = VrCommon.VRUtil

local v = game:DefineFastInt("SpatialUIHeadLookDotNoMovementThreshold", 990) / 1000

local StableCameraCache = {}

StableCameraCache.__index = StableCameraCache

function StableCameraCache.getCurrentStableCameraCFrame(p)
	return p.lastCameraCFrame
end

function StableCameraCache:updateAndCheckCameraMoved(): boolean
	local userCFrameWorldSpace = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head)

	if self.lastUserHeadCFrame then
		local v2 = workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable
		local v3 = self.lastUserHeadCFrame.LookVector:Dot(userCFrameWorldSpace.LookVector) < v

		if v2 and not v3 then
			return false
		end

		self.lastUserHeadCFrame = userCFrameWorldSpace
		self.lastCameraCFrame = workspace.CurrentCamera.CFrame
		return true
	end

	self.lastUserHeadCFrame = userCFrameWorldSpace
	self.lastCameraCFrame = workspace.CurrentCamera.CFrame
	return true
end

function StableCameraCache.new()
	local v2 = { lastUserHeadCFrame = nil, lastCameraCFrame = nil }

	setmetatable(v2, StableCameraCache)
	return v2
end

return StableCameraCache
