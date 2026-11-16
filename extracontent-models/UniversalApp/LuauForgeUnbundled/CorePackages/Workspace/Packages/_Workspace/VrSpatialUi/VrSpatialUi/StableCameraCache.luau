local vrUtil = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrCommon").VRUtil

local v5 = game:DefineFastInt("SpatialUIHeadLookDotNoMovementThreshold", 990) / 1000

local class = {}

class.__index = class

function class:getCurrentStableCameraCFrame()
	return self.lastCameraCFrame
end

function class:updateAndCheckCameraMoved(): boolean
	local userCFrameWorldSpace = vrUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head)

	if self.lastUserHeadCFrame then
		local v6 = workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable
		local v7 = self.lastUserHeadCFrame.LookVector:Dot(userCFrameWorldSpace.LookVector) < v5

		if v6 and not v7 then
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

function class.new()
	local v6 = { lastUserHeadCFrame = nil, lastCameraCFrame = nil }

	setmetatable(v6, class)
	return v6
end

return class
