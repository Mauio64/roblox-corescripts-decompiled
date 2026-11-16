local parent = script:FindFirstAncestor("VrCommon").Parent

local MockableProxyServices = require(parent.MockableProxyServices)

local engineFeature = game:GetEngineFeature("EnableVRUpdate3")

local VRService = MockableProxyServices.VRService
local VRUtil = {}

function VRUtil.RayPlaneIntersection(p, p2, p3)
	local unit = p2.unit
	local unit2 = p.Unit

	local dot = unit:Dot(unit2.Direction)

	if dot == 0 then
		return nil
	end

	local v = unit:Dot(p3 - unit2.Origin) / dot

	if v < 0 then
		return nil
	end

	return unit2.Origin + unit2.Direction * v
end

function VRUtil.GetUserCFrameWorldSpace(p)
	local userCFrame = VRService:GetUserCFrame(p)

	if not workspace.CurrentCamera.HeadLocked then
		userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head):Inverse() * userCFrame
	end

	return workspace.CurrentCamera.CFrame * (CFrame.new(userCFrame.p * workspace.CurrentCamera.HeadScale) * (userCFrame - userCFrame.p))
end

function VRUtil.getCurrentControllerType(): string
	local vrDeviceName = engineFeature and VRService.VRDeviceName or nil

	local v = vrDeviceName:match("Oculus")
		or vrDeviceName:match("Meta")
		or vrDeviceName:match("OpenXr")
		or vrDeviceName:match("OpenXR")

	if vrDeviceName:match("Vive") then
		return "Vive"
	end

	if vrDeviceName:match("Rift") then
		return "Rift"
	end

	if vrDeviceName:match("Index") then
		return "Index"
	end

	return if v then "Touch" else "Rift"
end

return VRUtil
