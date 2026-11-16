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

local VRControllerModel = {}
VRControllerModel.__index = VRControllerModel

function VRControllerModel.new(userCFrame)
	local self = setmetatable({}, VRControllerModel)
	self.userCFrame = userCFrame
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

function VRControllerModel:createControllerModel()
	local currentControllerType = VRUtil.getCurrentControllerType()

	if currentControllerType == "Vive" then
		self.controllerModel = ViveController.new(self.userCFrame)
	elseif currentControllerType == "Rift" then
		self.controllerModel = RiftController.new(self.userCFrame)
	elseif currentControllerType == "Index" then
		self.controllerModel = IndexController.new(self.userCFrame)
	elseif currentControllerType == "Touch" then
		self.controllerModel = TouchController.new(self.userCFrame)
	else
		self.controllerModel = RiftController.new(self.userCFrame)
	end
end

function VRControllerModel:setCurrentModel()
	if self.currentModel then
		self:setModelInWorkspace(false)
	end

	if not self.controllerModel then
		self:createControllerModel()
	end

	self.currentModel = self.controllerModel

	if self.enabled then
		self:setModelInWorkspace(VRService:GetUserCFrameEnabled(self.userCFrame))
	end
end

function VRControllerModel:setModelInWorkspace(modelIsInWorkspace)
	if not self.currentModel then
		return
	end

	if modelIsInWorkspace ~= self.modelIsInWorkspace then
		self.modelIsInWorkspace = modelIsInWorkspace

		if self.currentModel.model then
			if self.modelIsInWorkspace then
				self.currentModel.model.Parent = workspace
			else
				self.currentModel.model.Parent = nil
			end
		else
			self.currentModel:setInWorkspace(modelIsInWorkspace)
		end
	end
end

function VRControllerModel:setEnabled(enabled)
	if enabled ~= self.enabled then
		self.enabled = enabled

		if self.enabled then
			self:setCurrentModel()

			self.onCurrentCameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
				self:setModelInWorkspace(VRService:GetUserCFrameEnabled(self.userCFrame))
			end)

			self.onUserCFrameEnabledChangedConn = VRService.UserCFrameEnabled:connect(function(p, p2)
				if p == self.userCFrame then
					self:setModelInWorkspace(p2)
				end
			end)

			self.onInputBeganConn = UserInputService.InputBegan:connect(function(...)
				self:onInputBegan(...)
			end)
			self.onInputChangedConn = UserInputService.InputChanged:connect(function(...)
				self:onInputChanged(...)
			end)
			self.onInputEndedConn = UserInputService.InputEnded:connect(function(...)
				self:onInputEnded(...)
			end)

			self:setModelInWorkspace(VRService:GetUserCFrameEnabled(self.userCFrame))
		else
			if self.onVRDeviceChangedConn then
				self.onVRDeviceChangedConn:disconnect()
				self.onVRDeviceChangedConn = nil
			end

			if self.onCurrentCameraChangedConn then
				self.onCurrentCameraChangedConn:disconnect()
				self.onCurrentCameraChangedConn = nil
			end

			if self.onUserCFrameEnabledChangedConn then
				self.onUserCFrameEnabledChangedConn:disconnect()
				self.onUserCFrameEnabledChangedConn = nil
			end

			if self.onInputBeganConn then
				self.onInputBeganConn:disconnect()
				self.onInputBeganConn = nil
			end

			if self.onInputChangedConn then
				self.onInputChangedConn:disconnect()
				self.onInputChangedConn = nil
			end

			if self.onInputEndedConn then
				self.onInputEndedConn:disconnect()
				self.onInputEndedConn = nil
			end

			if self.currentModel then
				self:setModelInWorkspace(false)
			end
		end
	end
end

function VRControllerModel.update(data, _)
	if not data.enabled then
		return
	end

	if data.currentModel then
		local userCFrameWorldSpace = VRUtil.GetUserCFrameWorldSpace(data.userCFrame)
		data.currentModel:setCFrameAndScale(userCFrameWorldSpace, workspace.CurrentCamera.HeadScale)
	end
end

function VRControllerModel:onInputBegan(p, _)
	if self.enabled and self.modelIsInWorkspace and self.currentModel then
		self.currentModel:onInputBegan(p)
	end
end

function VRControllerModel:onInputChanged(p, _)
	if self.enabled and self.modelIsInWorkspace and self.currentModel then
		self.currentModel:onInputChanged(p)
	end
end

function VRControllerModel:onInputEnded(p, _)
	if self.currentModel then
		self.currentModel:onInputEnded(p)
	end
end

function VRControllerModel.getButtonPosition(p, p2)
	local v = p.currentModel and p.currentModel.getButtonPart and p.currentModel:getButtonPart(p2)

	if v then
		return v.Position
	end
end

return VRControllerModel
