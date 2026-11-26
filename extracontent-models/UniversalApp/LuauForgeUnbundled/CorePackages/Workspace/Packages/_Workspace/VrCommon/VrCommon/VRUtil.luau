local MockableProxyServices = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/MockableProxyServices")

local engineFeature = game:GetEngineFeature("EnableVRUpdate3")

local vrService = MockableProxyServices.VRService

return {
	RayPlaneIntersection = function(p2, p3, p4)
		local unit = p3.unit
		local unit2 = p2.Unit

		local dot = unit:Dot(unit2.Direction)

		if dot == 0 then
			return nil
		end

		local v5 = unit:Dot(p4 - unit2.Origin) / dot

		if v5 < 0 then
			return nil
		end

		return unit2.Origin + unit2.Direction * v5
	end,
	GetUserCFrameWorldSpace = function(p2)
		local userCFrame = vrService:GetUserCFrame(p2)

		if not workspace.CurrentCamera.HeadLocked then
			userCFrame = vrService:GetUserCFrame(Enum.UserCFrame.Head):Inverse() * userCFrame
		end

		return workspace.CurrentCamera.CFrame * (CFrame.new(userCFrame.p * workspace.CurrentCamera.HeadScale) * (userCFrame - userCFrame.p))
	end,
	getCurrentControllerType = function(): string
		local vrDeviceName = engineFeature and vrService.VRDeviceName or nil

		local v5 = vrDeviceName:match("Oculus")
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

		if v5 then
			return "Touch"
		end

		return "Rift"
	end
}
