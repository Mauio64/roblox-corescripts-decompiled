local parent = script:FindFirstAncestor("VrCommon").Parent

local StarterGui = game:GetService("StarterGui")
local VRService = game:GetService("VRService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local AppCommonLib = require(parent.AppCommonLib)
local Create = AppCommonLib.Create

local LaserPointer = require(script.Parent.LaserPointer)

local VRControllerModel = require(script.Parent.VRControllerModel)

local SplashScreenManager = require(parent.SplashScreenManager)
local splashScreenManager = SplashScreenManager.SplashScreenManager

local SafetyBubble = require(script.Parent.SafetyBubble)

local VRHub = {}
local v = {}
local v2 = {}

local guid = HttpService:GenerateGUID(true)

VRHub.LaserPointer = nil

VRHub.ControllerModelsEnabled = false
VRHub.LeftControllerModel = nil
VRHub.RightControllerModel = nil

VRHub.isFPSAtTarget = splashScreenManager.isFPSAtTarget()
VRHub.SafetyBubble = nil

VRHub.IsFirstPerson = false

StarterGui:RegisterSetCore("VRLaserPointerMode", function(p)
	if not VRHub.LaserPointer then
		return
	end

	if p and tostring(p) then
		VRHub.LaserPointer:setMode(LaserPointer.Mode[tostring(p)] or LaserPointer.Mode.Disabled)
	end
end)

local function enableControllerModels(controllerModelsEnabled)
	if controllerModelsEnabled ~= VRHub.ControllerModelsEnabled then
		VRHub.ControllerModelsEnabled = controllerModelsEnabled

		if controllerModelsEnabled then
			if not VRHub.LeftControllerModel then
				VRHub.LeftControllerModel = VRControllerModel.new(Enum.UserCFrame.LeftHand)
			end

			VRHub.LeftControllerModel:setEnabled(true)

			if not VRHub.RightControllerModel then
				VRHub.RightControllerModel = VRControllerModel.new(Enum.UserCFrame.RightHand)
			end

			VRHub.RightControllerModel:setEnabled(true)
		else
			if VRHub.LeftControllerModel then
				VRHub.LeftControllerModel:setEnabled(false)
			end

			if VRHub.RightControllerModel then
				VRHub.RightControllerModel:setEnabled(false)
			end
		end
	end
end

StarterGui:RegisterSetCore("VREnableControllerModels", function(p)
	if p then
		VRService.ControllerModels = Enum.VRControllerModelMode.Transparent
	else
		VRService.ControllerModels = Enum.VRControllerModelMode.Disabled
	end
end)

VRService:GetPropertyChangedSignal("ControllerModels"):Connect(function()
	enableControllerModels(VRService.ControllerModels == Enum.VRControllerModelMode.Transparent)
end)

local v3 = tick()
local function onRenderSteppedLast()
	local now = tick()
	local v4 = now - v3
	v3 = now

	if VRHub.LaserPointer then
		VRHub.LaserPointer:update(v4)
	end

	if VRHub.LeftControllerModel then
		VRHub.LeftControllerModel:update(v4)
	end

	if VRHub.RightControllerModel then
		VRHub.RightControllerModel:update(v4)
	end

	if VRHub.SafetyBubble then
		VRHub.SafetyBubble:update(v4)
	end
end

local function onCameraCFrameChanged()
	if VRHub.LaserPointer then
		VRHub.LaserPointer:update(0)
	end

	if VRHub.LeftControllerModel then
		VRHub.LeftControllerModel:update(0)
	end

	if VRHub.RightControllerModel then
		VRHub.RightControllerModel:update(0)
	end
end

local cFrameChangedConnection = nil
local function onCurrentCameraChanged() -- 1 equivalent call inferred from this helper
	if cFrameChangedConnection then
		cFrameChangedConnection:disconnect()
	end

	if workspace.CurrentCamera then
		cFrameChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(onCameraCFrameChanged)
	end
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)
onCurrentCameraChanged() -- inferred equivalent call

local function onVREnabledChanged()
	if VRService.VREnabled then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide

		if not VRHub.LaserPointer then
			VRHub.LaserPointer = LaserPointer.new()
		end

		if VRHub.LaserPointer then
			if VRHub.isFPSAtTarget then
				VRHub.LaserPointer:setMode(LaserPointer.Mode.Navigation)
			else
				VRHub.LaserPointer:setMode(LaserPointer.Mode.Disabled)
			end
		end

		enableControllerModels(VRService.ControllerModels == Enum.VRControllerModelMode.Transparent)

		RunService:BindToRenderStep(guid, Enum.RenderPriority.Last.Value, onRenderSteppedLast)

		if VRHub.LaserPointer then
			VRHub.LaserPointer:setForcePointer(true)
		end

		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide

		VRHub.SafetyBubble = SafetyBubble.new()

		ContextActionService:BindCoreActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
	else
		if VRHub.LaserPointer then
			VRHub.LaserPointer:setMode(LaserPointer.Mode.Disabled)
		end

		RunService:UnbindFromRenderStep(guid)
	end
end

local function onVRSessionStateChanged()
	if VRService.VRSessionState == Enum.VRSessionState.Focused then
		if VRHub.LaserPointer and VRHub.LaserPointer.Mode.Disabled then
			VRHub.LaserPointer:setMode(LaserPointer.Mode.Navigation)
			enableControllerModels(VRService.ControllerModels == Enum.VRControllerModelMode.Transparent)
		end

		if not VRHub.ControllerModelsEnabled then
			enableControllerModels(VRService.ControllerModels == Enum.VRControllerModelMode.Transparent)
		end
	else
		if VRHub.LaserPointer and VRHub.LaserPointer.Mode.Navigation then
			VRHub.LaserPointer:setMode(LaserPointer.Mode.Disabled)
		end

		if VRHub.ControllerModelsEnabled and VRHub.ControllerModelsEnabled ~= false then
			VRHub.ControllerModelsEnabled = false

			if VRHub.LeftControllerModel then
				VRHub.LeftControllerModel:setEnabled(false)
			end

			if VRHub.RightControllerModel then
				VRHub.RightControllerModel:setEnabled(false)
			end
		end
	end
end

local function onVRPropertyChanged(p)
	if p == "VREnabled" then
		onVREnabledChanged()
	elseif p == "VRSessionState" then
		onVRSessionStateChanged()
	end
end

onVREnabledChanged()
VRService.Changed:connect(onVRPropertyChanged)

function VRHub.RegisterModule(_, p)
	v[p.ModuleName] = p
end

function VRHub.GetModule(_, p)
	return v[p]
end

function VRHub.IsModuleOpened(_, p): boolean
	return v2[p] ~= nil
end

function VRHub.GetOpenedModules(_)
	local openedModules = {}

	for _, v4 in pairs(v2) do
		table.insert(openedModules, v4)
	end

	return openedModules
end

VRHub.ModuleOpened = Create("BindableEvent")({ Name = "VRModuleOpened" })

function VRHub.FireModuleOpened(_, p)
	if not v[p] then
		error("Tried to open module that is not registered: " .. p)
	end

	if v2[p] ~= v[p] then
		v2[p] = v[p]
		VRHub.ModuleOpened:Fire(p)
	end
end

VRHub.ModuleClosed = Create("BindableEvent")({ Name = "VRModuleClosed" })

function VRHub.FireModuleClosed(_, p)
	if not v[p] then
		error("Tried to close module that is not registered: " .. p)
	end

	if v2[p] ~= nil then
		v2[p] = nil
		VRHub.ModuleClosed:Fire(p)
	end
end

function VRHub.KeepVRTopbarOpen(_): boolean
	for _, v4 in pairs(v2) do
		if v4.KeepVRTopbarOpen then
			return true
		end
	end

	return false
end

VRHub.ShowHighlightedLeaveGameIcon = false

VRHub.ShowHighlightedLeaveGameIconToggled = Create("BindableEvent")({
	Name = "ShowHighlightedLeaveGameIconToggled"
})

function VRHub.SetShowHighlightedLeaveGameIconToggled(_, showHighlightedLeaveGameIcon)
	if VRHub.ShowHighlightedLeaveGameIcon ~= showHighlightedLeaveGameIcon then
		VRHub.ShowHighlightedLeaveGameIcon = showHighlightedLeaveGameIcon
		VRHub.ShowHighlightedLeaveGameIconToggled:Fire()
	end
end

VRHub.ShowTopBar = true
VRHub.ShowMoreMenu = false

VRHub.ShowTopBarChanged = Create("BindableEvent")({ Name = "ShowTopBarChanged" })

VRHub.ShowMoreMenuChanged = Create("BindableEvent")({ Name = "ShowMoreMenuChanged" })

function VRHub.SetShowTopBar(_, showTopBar)
	if VRHub.ShowTopBar ~= showTopBar then
		VRHub.ShowTopBar = showTopBar
		VRHub.ShowTopBarChanged:Fire()
	end
end

function VRHub.SetShowMoreMenu(_, showMoreMenu)
	if VRHub.ShowMoreMenu ~= showMoreMenu then
		VRHub.ShowMoreMenu = showMoreMenu
		VRHub.ShowMoreMenuChanged:Fire()
	end
end

function VRHub.ToggleSafetyBubble(_)
	if VRHub.SafetyBubble then
		VRHub.SafetyBubble:ToggleEnabled()
	end
end

function VRHub.GetControllerModel(_, p)
	if p == Enum.UserCFrame.LeftHand then
		return VRHub.LeftControllerModel
	end

	if p == Enum.UserCFrame.RightHand then
		return VRHub.RightControllerModel
	end

	return nil
end

function VRHub.GetControllerButtonPosition(_, p)
	return
		VRHub.LeftControllerModel and VRHub.LeftControllerModel:getButtonPosition(p),
		VRHub.RightControllerModel and VRHub.RightControllerModel:getButtonPosition(p)
end

splashScreenManager.addStatusChangeListener(function(isFPSAtTarget)
	VRHub.isFPSAtTarget = isFPSAtTarget
	onVREnabledChanged()
end)

return VRHub
