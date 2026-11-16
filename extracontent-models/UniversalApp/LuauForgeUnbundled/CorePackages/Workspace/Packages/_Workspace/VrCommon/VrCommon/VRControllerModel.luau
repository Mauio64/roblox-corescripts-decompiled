local VRService = game:GetService("VRService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local ViveController = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/Controllers/ViveController")
local TouchController = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/Controllers/TouchController")
local RiftController = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/Controllers/RiftController")
local IndexController = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/Controllers/IndexController")
local VRUtil = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/VRUtil")

local localPlayer = Players.LocalPlayer

while not localPlayer do
	Players.Changed:wait()
	localPlayer = Players.LocalPlayer
end

local class = {}
class.__index = class

function class.new(userCFrame)
	local object = setmetatable({}, class)
	object.userCFrame = userCFrame
	object.enabled = false
	object.currentModel = nil
	object.currentVRDeviceName = VRService.VRDeviceName
	object.modelIsInWorkspace = false

	object.onVRDeviceChangedConn = nil
	object.onCurrentCameraChangedConn = nil
	object.onUserCFrameEnabledChangedConn = nil
	object.onInputBeganConn = nil
	object.onInputChangedConn = nil
	object.onInputEndedConn = nil

	object.controllerModel = nil

	return object
end

function class:createControllerModel()
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

function class:setCurrentModel()
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

function class:setModelInWorkspace(modelIsInWorkspace)
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

function class:setEnabled(enabled)
	if enabled ~= self.enabled then
		self.enabled = enabled

		if self.enabled then
			self:setCurrentModel()

			self.onCurrentCameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
				self:setModelInWorkspace(VRService:GetUserCFrameEnabled(self.userCFrame))
			end)

			self.onUserCFrameEnabledChangedConn = VRService.UserCFrameEnabled:connect(function(p2, p3)
				if p2 == self.userCFrame then
					self:setModelInWorkspace(p3)
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

function class.update(data, p2)
	if not data.enabled then
		return
	end

	if data.currentModel then
		local userCFrameWorldSpace = VRUtil.GetUserCFrameWorldSpace(data.userCFrame)
		data.currentModel:setCFrameAndScale(userCFrameWorldSpace, workspace.CurrentCamera.HeadScale)
	end
end

function class.onInputBegan(data, p2, p3)
	if data.enabled and data.modelIsInWorkspace and data.currentModel then
		data.currentModel:onInputBegan(p2)
	end
end

function class:onInputChanged(p2, p3)
	if self.enabled and self.modelIsInWorkspace and self.currentModel then
		self.currentModel:onInputChanged(p2)
	end
end

function class:onInputEnded(p3, p4)
	if self.currentModel then
		self.currentModel:onInputEnded(p3)
	end
end

function class:getButtonPosition(p3)
	local v5 = self.currentModel and self.currentModel.getButtonPart and self.currentModel:getButtonPart(p3)

	if v5 then
		return v5.Position
	end
end

return class
