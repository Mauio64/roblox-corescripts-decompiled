local StarterGui = game:GetService("StarterGui")
local VRService = game:GetService("VRService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local create = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/AppCommonLib").Create

local LaserPointer = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/LaserPointer")

local VRControllerModel = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/VRControllerModel")

local splashScreenManager = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/SplashScreenManager").SplashScreenManager

local SafetyBubble = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/SafetyBubble")

local v5 = {}
local v6 = {}
local v7 = {}

local guid = HttpService:GenerateGUID(true)

v5.LaserPointer = nil

v5.ControllerModelsEnabled = false
v5.LeftControllerModel = nil
v5.RightControllerModel = nil

v5.isFPSAtTarget = splashScreenManager.isFPSAtTarget()
v5.SafetyBubble = nil

v5.IsFirstPerson = false

StarterGui:RegisterSetCore("VRLaserPointerMode", function(p2)
	if not v5.LaserPointer then
		return
	end

	if p2 and tostring(p2) then
		v5.LaserPointer:setMode(LaserPointer.Mode[tostring(p2)] or LaserPointer.Mode.Disabled)
	end
end)

local function enableControllerModels(controllerModelsEnabled)
	if controllerModelsEnabled ~= v5.ControllerModelsEnabled then
		v5.ControllerModelsEnabled = controllerModelsEnabled

		if controllerModelsEnabled then
			if not v5.LeftControllerModel then
				v5.LeftControllerModel = VRControllerModel.new(Enum.UserCFrame.LeftHand)
			end

			v5.LeftControllerModel:setEnabled(true)

			if not v5.RightControllerModel then
				v5.RightControllerModel = VRControllerModel.new(Enum.UserCFrame.RightHand)
			end

			v5.RightControllerModel:setEnabled(true)
		else
			if v5.LeftControllerModel then
				v5.LeftControllerModel:setEnabled(false)
			end

			if v5.RightControllerModel then
				v5.RightControllerModel:setEnabled(false)
			end
		end
	end
end

StarterGui:RegisterSetCore("VREnableControllerModels", function(p2)
	if p2 then
		VRService.ControllerModels = Enum.VRControllerModelMode.Transparent
	else
		VRService.ControllerModels = Enum.VRControllerModelMode.Disabled
	end
end)

VRService:GetPropertyChangedSignal("ControllerModels"):Connect(function()
	enableControllerModels(VRService.ControllerModels == Enum.VRControllerModelMode.Transparent)
end)

local v8 = tick()
local function onRenderSteppedLast()
	local now = tick()
	local v9 = now - v8
	v8 = now

	if v5.LaserPointer then
		v5.LaserPointer:update(v9)
	end

	if v5.LeftControllerModel then
		v5.LeftControllerModel:update(v9)
	end

	if v5.RightControllerModel then
		v5.RightControllerModel:update(v9)
	end

	if v5.SafetyBubble then
		v5.SafetyBubble:update(v9)
	end
end

local function onCameraCFrameChanged()
	if v5.LaserPointer then
		v5.LaserPointer:update(0)
	end

	if v5.LeftControllerModel then
		v5.LeftControllerModel:update(0)
	end

	if v5.RightControllerModel then
		v5.RightControllerModel:update(0)
	end
end

local cFrameChangedConnection = nil
local function onCurrentCameraChanged()
	if cFrameChangedConnection then
		cFrameChangedConnection:disconnect()
	end

	if workspace.CurrentCamera then
		cFrameChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(onCameraCFrameChanged)
	end
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)

if cFrameChangedConnection then
	cFrameChangedConnection:disconnect()
end

if workspace.CurrentCamera then
	cFrameChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(onCameraCFrameChanged)
end

local function onVREnabledChanged()
	if VRService.VREnabled then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide

		if not v5.LaserPointer then
			v5.LaserPointer = LaserPointer.new()
		end

		if v5.LaserPointer then
			if v5.isFPSAtTarget then
				v5.LaserPointer:setMode(LaserPointer.Mode.Navigation)
			else
				v5.LaserPointer:setMode(LaserPointer.Mode.Disabled)
			end
		end

		enableControllerModels(VRService.ControllerModels == Enum.VRControllerModelMode.Transparent)

		RunService:BindToRenderStep(guid, Enum.RenderPriority.Last.Value, onRenderSteppedLast)

		if v5.LaserPointer then
			v5.LaserPointer:setForcePointer(true)
		end

		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide

		v5.SafetyBubble = SafetyBubble.new()

		ContextActionService:BindCoreActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
	else
		if v5.LaserPointer then
			v5.LaserPointer:setMode(LaserPointer.Mode.Disabled)
		end

		RunService:UnbindFromRenderStep(guid)
	end
end

local function onVRSessionStateChanged()
	if VRService.VRSessionState == Enum.VRSessionState.Focused then
		if v5.LaserPointer and v5.LaserPointer.Mode.Disabled then
			v5.LaserPointer:setMode(LaserPointer.Mode.Navigation)
			enableControllerModels(VRService.ControllerModels == Enum.VRControllerModelMode.Transparent)
		end

		if not v5.ControllerModelsEnabled then
			enableControllerModels(VRService.ControllerModels == Enum.VRControllerModelMode.Transparent)
		end
	else
		if v5.LaserPointer and v5.LaserPointer.Mode.Navigation then
			v5.LaserPointer:setMode(LaserPointer.Mode.Disabled)
		end

		if v5.ControllerModelsEnabled and v5.ControllerModelsEnabled ~= false then
			v5.ControllerModelsEnabled = false

			if v5.LeftControllerModel then
				v5.LeftControllerModel:setEnabled(false)
			end

			if v5.RightControllerModel then
				v5.RightControllerModel:setEnabled(false)
			end
		end
	end
end

local function onVRPropertyChanged(p2)
	if p2 == "VREnabled" then
		onVREnabledChanged()
	elseif p2 == "VRSessionState" then
		onVRSessionStateChanged()
	end
end

onVREnabledChanged()
VRService.Changed:connect(onVRPropertyChanged)

function v5.RegisterModule(p2, p3)
	v6[p3.ModuleName] = p3
end

function v5.GetModule(p2, p3)
	return v6[p3]
end

function v5.IsModuleOpened(p2, p3): boolean
	return v7[p3] ~= nil
end

function v5.GetOpenedModules(p2)
	local openedModules = {}

	for k, v9 in pairs(v7) do
		table.insert(openedModules, v9)
	end

	return openedModules
end

v5.ModuleOpened = create("BindableEvent")({ Name = "VRModuleOpened" })

function v5.FireModuleOpened(p2, p3)
	if not v6[p3] then
		error("Tried to open module that is not registered: " .. p3)
	end

	if v7[p3] ~= v6[p3] then
		v7[p3] = v6[p3]
		v5.ModuleOpened:Fire(p3)
	end
end

v5.ModuleClosed = create("BindableEvent")({ Name = "VRModuleClosed" })

function v5.FireModuleClosed(p2, p3)
	if not v6[p3] then
		error("Tried to close module that is not registered: " .. p3)
	end

	if v7[p3] ~= nil then
		v7[p3] = nil
		v5.ModuleClosed:Fire(p3)
	end
end

function v5.KeepVRTopbarOpen(p2): boolean
	for k, v9 in pairs(v7) do
		if v9.KeepVRTopbarOpen then
			return true
		end
	end

	return false
end

v5.ShowHighlightedLeaveGameIcon = false

v5.ShowHighlightedLeaveGameIconToggled = create("BindableEvent")({
	Name = "ShowHighlightedLeaveGameIconToggled"
})

function v5.SetShowHighlightedLeaveGameIconToggled(p2, showHighlightedLeaveGameIcon)
	if v5.ShowHighlightedLeaveGameIcon ~= showHighlightedLeaveGameIcon then
		v5.ShowHighlightedLeaveGameIcon = showHighlightedLeaveGameIcon
		v5.ShowHighlightedLeaveGameIconToggled:Fire()
	end
end

v5.ShowTopBar = true
v5.ShowMoreMenu = false

v5.ShowTopBarChanged = create("BindableEvent")({ Name = "ShowTopBarChanged" })

v5.ShowMoreMenuChanged = create("BindableEvent")({ Name = "ShowMoreMenuChanged" })

function v5.SetShowTopBar(p2, showTopBar)
	if v5.ShowTopBar ~= showTopBar then
		v5.ShowTopBar = showTopBar
		v5.ShowTopBarChanged:Fire()
	end
end

function v5.SetShowMoreMenu(p2, showMoreMenu)
	if v5.ShowMoreMenu ~= showMoreMenu then
		v5.ShowMoreMenu = showMoreMenu
		v5.ShowMoreMenuChanged:Fire()
	end
end

function v5.ToggleSafetyBubble(p2)
	if v5.SafetyBubble then
		v5.SafetyBubble:ToggleEnabled()
	end
end

function v5.GetControllerModel(p2, p3)
	if p3 == Enum.UserCFrame.LeftHand then
		return v5.LeftControllerModel
	end

	if p3 == Enum.UserCFrame.RightHand then
		return v5.RightControllerModel
	end

	return nil
end

function v5.GetControllerButtonPosition(p2, p3)
	return
		v5.LeftControllerModel and v5.LeftControllerModel:getButtonPosition(p3),
		v5.RightControllerModel and v5.RightControllerModel:getButtonPosition(p3)
end

splashScreenManager.addStatusChangeListener(function(isFPSAtTarget)
	v5.isFPSAtTarget = isFPSAtTarget
	onVREnabledChanged()
end)

return v5
