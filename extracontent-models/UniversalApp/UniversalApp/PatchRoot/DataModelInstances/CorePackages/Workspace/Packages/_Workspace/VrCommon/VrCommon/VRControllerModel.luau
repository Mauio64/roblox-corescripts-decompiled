local VRService = game:GetService("VRService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VrCommon = script:FindFirstAncestor("VrCommon")
local ViveController = require(VrCommon.Controllers.ViveController)
local TouchController = require(VrCommon.Controllers.TouchController)
local RiftController = require(VrCommon.Controllers.RiftController)
local IndexController = require(VrCommon.Controllers.IndexController)
local VRUtil = require(VrCommon.VRUtil)
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.Changed:wait()
	LocalPlayer = Players.LocalPlayer
end

local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 23
	-- upvalues: t1 (copy), VRService (copy)
	local self = setmetatable({}, t1)

	self.userCFrame = p1
	self.enabled = false
	self.currentModel = nil
	self.currentVRDeviceName = VRService.VRDeviceName
	self.modelIsInWorkspace = false
	self.onVRDeviceChangedConn = nil
	self.onCurrentCameraChangedConn = nil
	self.onUserCFrameEnabledChangedConn = nil
	self.onInputBeganConn = nil
	self.onInputChangedConn = nil
	self.onInputEndedConn = nil
	self.controllerModel = nil

	return self
end
function t1.createControllerModel(p2) -- line: 45
	-- upvalues: VRUtil (copy), ViveController (copy), RiftController (copy), IndexController (copy), TouchController (copy)
	local v15 = VRUtil.getCurrentControllerType()

	if v15 == "Vive" then
		p2.controllerModel = ViveController.new(p2.userCFrame)

		return
	end

	if v15 == "Rift" then
		p2.controllerModel = RiftController.new(p2.userCFrame)

		return
	end

	if v15 == "Index" then
		p2.controllerModel = IndexController.new(p2.userCFrame)

		return
	end

	if v15 == "Touch" then
		p2.controllerModel = TouchController.new(p2.userCFrame)

		return
	end

	p2.controllerModel = RiftController.new(p2.userCFrame)
end
function t1.setCurrentModel(p3) -- line: 62
	-- upvalues: VRService (copy)
	if p3.currentModel then
		p3:setModelInWorkspace(false)
	end

	if not p3.controllerModel then
		p3:createControllerModel()
	end

	p3.currentModel = p3.controllerModel

	if p3.enabled then
		p3:setModelInWorkspace(VRService:GetUserCFrameEnabled(p3.userCFrame))
	end
end
function t1.setModelInWorkspace(p4, p5) -- line: 79
	if not p4.currentModel then
		return
	end

	if p5 ~= p4.modelIsInWorkspace then
		p4.modelIsInWorkspace = p5

		if p4.currentModel.model then
			if p4.modelIsInWorkspace then
				p4.currentModel.model.Parent = workspace

				return
			end

			p4.currentModel.model.Parent = nil

			return
		end

		p4.currentModel:setInWorkspace(p5)
	end
end
function t1.setEnabled(p6, p7) -- line: 98
	-- upvalues: VRService (copy), UserInputService (copy)
	if p7 ~= p6.enabled then
		p6.enabled = p7

		if p6.enabled then
			p6:setCurrentModel()
			p6.onCurrentCameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 105
				-- upvalues: p6 (copy), VRService (copy)
				p6:setModelInWorkspace(VRService:GetUserCFrameEnabled(p6.userCFrame))
			end)
			p6.onUserCFrameEnabledChangedConn = VRService.UserCFrameEnabled:connect(function(p8, p9) -- line: 109
				-- upvalues: p6 (copy)
				if p8 == p6.userCFrame then
					p6:setModelInWorkspace(p9)
				end
			end)
			p6.onInputBeganConn = UserInputService.InputBegan:connect(function(...) -- line: 115
				-- upvalues: p6 (copy)
				p6:onInputBegan(...)
			end)
			p6.onInputChangedConn = UserInputService.InputChanged:connect(function(...) -- line: 118
				-- upvalues: p6 (copy)
				p6:onInputChanged(...)
			end)
			p6.onInputEndedConn = UserInputService.InputEnded:connect(function(...) -- line: 121
				-- upvalues: p6 (copy)
				p6:onInputEnded(...)
			end)
			p6:setModelInWorkspace(VRService:GetUserCFrameEnabled(p6.userCFrame))

			return
		end

		if p6.onVRDeviceChangedConn then
			p6.onVRDeviceChangedConn:disconnect()
			p6.onVRDeviceChangedConn = nil
		end

		if p6.onCurrentCameraChangedConn then
			p6.onCurrentCameraChangedConn:disconnect()
			p6.onCurrentCameraChangedConn = nil
		end

		if p6.onUserCFrameEnabledChangedConn then
			p6.onUserCFrameEnabledChangedConn:disconnect()
			p6.onUserCFrameEnabledChangedConn = nil
		end

		if p6.onInputBeganConn then
			p6.onInputBeganConn:disconnect()
			p6.onInputBeganConn = nil
		end

		if p6.onInputChangedConn then
			p6.onInputChangedConn:disconnect()
			p6.onInputChangedConn = nil
		end

		if p6.onInputEndedConn then
			p6.onInputEndedConn:disconnect()
			p6.onInputEndedConn = nil
		end

		if p6.currentModel then
			p6:setModelInWorkspace(false)
		end
	end
end
function t1.update(p10, _) -- line: 162
	-- upvalues: VRUtil (copy)
	if not p10.enabled then
		return
	end

	if p10.currentModel then
		local v23 = VRUtil.GetUserCFrameWorldSpace(p10.userCFrame)

		p10.currentModel:setCFrameAndScale(v23, workspace.CurrentCamera.HeadScale)
	end
end
function t1.onInputBegan(p12, p13, _) -- line: 173
	if not p12.enabled or not p12.modelIsInWorkspace then
		return
	end

	if p12.currentModel then
		p12.currentModel:onInputBegan(p13)
	end
end
function t1.onInputChanged(p15, p16, _) -- line: 182
	if not p15.enabled or not p15.modelIsInWorkspace then
		return
	end

	if p15.currentModel then
		p15.currentModel:onInputChanged(p16)
	end
end
function t1.onInputEnded(p18, p19, _) -- line: 191
	if p18.currentModel then
		p18.currentModel:onInputEnded(p19)
	end
end
function t1.getButtonPosition(p21, p22) -- line: 197
	if p21.currentModel and p21.currentModel.getButtonPart then
		local v35 = p21.currentModel:getButtonPart(p22)

		if v35 then
			return v35.Position
		end
	end
end

return t1
