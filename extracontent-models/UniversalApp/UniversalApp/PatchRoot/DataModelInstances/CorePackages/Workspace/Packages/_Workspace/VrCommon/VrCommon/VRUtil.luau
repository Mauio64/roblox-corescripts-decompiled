local Parent = script:FindFirstAncestor("VrCommon").Parent
local MockableProxyServices = require(Parent.MockableProxyServices)
local EngineFeature = game:GetEngineFeature("EnableVRUpdate3")
local VRService = MockableProxyServices.VRService

return {
	RayPlaneIntersection = function(p1, p2, p3) -- line: 17
		local unit = p2.unit
		local Unit = p1.Unit
		local v10 = unit:Dot(Unit.Direction)

		if v10 == 0 then
			return nil
		end

		local v11 = unit:Dot(p3 - Unit.Origin) / v10

		if v11 < 0 then
			return nil
		end

		return Unit.Origin + Unit.Direction * v11
	end,
	GetUserCFrameWorldSpace = function(p4) -- line: 35
		-- upvalues: VRService (copy)
		local UserCFrame = VRService:GetUserCFrame(p4)

		if not workspace.CurrentCamera.HeadLocked then
			UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head):Inverse() * UserCFrame
		end

		return workspace.CurrentCamera.CFrame * (CFrame.new(UserCFrame.p * workspace.CurrentCamera.HeadScale) * (UserCFrame - UserCFrame.p))
	end,
	getCurrentControllerType = function() -- line: 47
		-- upvalues: EngineFeature (copy), VRService (copy)
		local v14 = EngineFeature and VRService.VRDeviceName or nil
		local v15 = v14:match("Oculus") or (v14:match("Meta") or (v14:match("OpenXr") or v14:match("OpenXR")))

		if v14:match("Vive") then
			return "Vive"
		end

		if v14:match("Rift") then
			return "Rift"
		end

		if v14:match("Index") then
			return "Index"
		end

		if v15 then
			return "Touch"
		end

		return "Rift"
	end
}
