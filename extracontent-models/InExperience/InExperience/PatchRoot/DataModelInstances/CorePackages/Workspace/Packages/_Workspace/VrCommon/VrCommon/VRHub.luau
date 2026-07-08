local Parent = script:FindFirstAncestor("VrCommon").Parent
local StarterGui = game:GetService("StarterGui")
local VRService = game:GetService("VRService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Create = require(Parent.AppCommonLib).Create
local LaserPointer = require(script.Parent.LaserPointer)
local VRControllerModel = require(script.Parent.VRControllerModel)
local SplashScreenManager = require(Parent.SplashScreenManager).SplashScreenManager
local SafetyBubble = require(script.Parent.SafetyBubble)
local t1 = {}
local t2 = {}
local t3 = {}
local guid = HttpService:GenerateGUID(true)

t1.LaserPointer = nil
t1.ControllerModelsEnabled = false
t1.LeftControllerModel = nil
t1.RightControllerModel = nil
t1.isFPSAtTarget = SplashScreenManager.isFPSAtTarget()
t1.SafetyBubble = nil
t1.IsFirstPerson = false
StarterGui:RegisterSetCore("VRLaserPointerMode", function(p1) -- line: 44
	-- upvalues: t1 (copy), LaserPointer (copy)
	if not t1.LaserPointer then
		return
	end

	if not p1 or not tostring(p1) then
		return
	end

	t1.LaserPointer:setMode(LaserPointer.Mode[tostring(p1)] or LaserPointer.Mode.Disabled)
end)

local function enableControllerModels(p2) -- line: 54
	-- upvalues: t1 (copy), VRControllerModel (copy)
	if p2 ~= t1.ControllerModelsEnabled then
		t1.ControllerModelsEnabled = p2

		if p2 then
			if not t1.LeftControllerModel then
				t1.LeftControllerModel = VRControllerModel.new(Enum.UserCFrame.LeftHand)
			end

			t1.LeftControllerModel:setEnabled(true)

			if not t1.RightControllerModel then
				t1.RightControllerModel = VRControllerModel.new(Enum.UserCFrame.RightHand)
			end

			t1.RightControllerModel:setEnabled(true)

			return
		end

		if t1.LeftControllerModel then
			t1.LeftControllerModel:setEnabled(false)
		end

		if t1.RightControllerModel then
			t1.RightControllerModel:setEnabled(false)
		end
	end
end

StarterGui:RegisterSetCore("VREnableControllerModels", function(p3) -- line: 83
	-- upvalues: VRService (copy)
	if p3 then
		VRService.ControllerModels = Enum.VRControllerModelMode.Transparent

		return
	end

	VRService.ControllerModels = Enum.VRControllerModelMode.Disabled
end)
VRService:GetPropertyChangedSignal("ControllerModels"):Connect(function() -- line: 91
	-- upvalues: enableControllerModels (copy), VRService (copy)
	enableControllerModels(VRService.ControllerModels == Enum.VRControllerModelMode.Transparent)
end)

local timestamp = tick()

local function onRenderSteppedLast() -- line: 96
	-- upvalues: timestamp (ref), t1 (copy)
	local timestamp2 = tick()
	local v30 = timestamp2 - timestamp

	timestamp = timestamp2

	if t1.LaserPointer then
		t1.LaserPointer:update(v30)
	end

	if t1.LeftControllerModel then
		t1.LeftControllerModel:update(v30)
	end

	if t1.RightControllerModel then
		t1.RightControllerModel:update(v30)
	end

	if t1.SafetyBubble then
		t1.SafetyBubble:update(v30)
	end
end
local function onCameraCFrameChanged() -- line: 117
	-- upvalues: t1 (copy)
	if t1.LaserPointer then
		t1.LaserPointer:update(0)
	end

	if t1.LeftControllerModel then
		t1.LeftControllerModel:update(0)
	end

	if t1.RightControllerModel then
		t1.RightControllerModel:update(0)
	end
end

local connection = nil

local function onCurrentCameraChanged() -- line: 135
	-- upvalues: connection (ref), onCameraCFrameChanged (copy)
	if connection then
		connection:disconnect()
	end

	if workspace.CurrentCamera then
		connection = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(onCameraCFrameChanged)
	end
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)

if connection then
	connection:disconnect()
end

if workspace.CurrentCamera then
	connection = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(onCameraCFrameChanged)
end

local function onVREnabledChanged() -- line: 149
	-- upvalues: VRService (copy), UserInputService (copy), t1 (copy), LaserPointer (copy), enableControllerModels (copy), RunService (copy), guid (copy), onRenderSteppedLast (copy), SafetyBubble (copy), ContextActionService (copy)
	if VRService.VREnabled then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide

		if not t1.LaserPointer then
			t1.LaserPointer = LaserPointer.new()
		end

		if t1.LaserPointer then
			if t1.isFPSAtTarget then
				t1.LaserPointer:setMode(LaserPointer.Mode.Navigation)
			else
				t1.LaserPointer:setMode(LaserPointer.Mode.Disabled)
			end
		end

		enableControllerModels(VRService.ControllerModels == Enum.VRControllerModelMode.Transparent)
		RunService:BindToRenderStep(guid, Enum.RenderPriority.Last.Value, onRenderSteppedLast)

		if t1.LaserPointer then
			t1.LaserPointer:setForcePointer(true)
		end

		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
		t1.SafetyBubble = SafetyBubble.new()
		ContextActionService:BindCoreActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)

		return
	end

	if t1.LaserPointer then
		t1.LaserPointer:setMode(LaserPointer.Mode.Disabled)
	end

	RunService:UnbindFromRenderStep(guid)
end
local function onVRSessionStateChanged() -- line: 188
	-- upvalues: VRService (copy), t1 (copy), LaserPointer (copy), enableControllerModels (copy)
	if VRService.VRSessionState == Enum.VRSessionState.Focused then
		if t1.LaserPointer and t1.LaserPointer.Mode.Disabled then
			t1.LaserPointer:setMode(LaserPointer.Mode.Navigation)
			enableControllerModels(VRService.ControllerModels == Enum.VRControllerModelMode.Transparent)
		end

		if not t1.ControllerModelsEnabled then
			enableControllerModels(VRService.ControllerModels == Enum.VRControllerModelMode.Transparent)

			return
		end
	else
		if t1.LaserPointer and t1.LaserPointer.Mode.Navigation then
			t1.LaserPointer:setMode(LaserPointer.Mode.Disabled)
		end

		if t1.ControllerModelsEnabled and t1.ControllerModelsEnabled ~= false then
			t1.ControllerModelsEnabled = false

			if t1.LeftControllerModel then
				t1.LeftControllerModel:setEnabled(false)
			end

			if t1.RightControllerModel then
				t1.RightControllerModel:setEnabled(false)
			end
		end
	end
end
local function onVRPropertyChanged(p4) -- line: 207
	-- upvalues: onVREnabledChanged (copy), onVRSessionStateChanged (copy)
	if p4 == "VREnabled" then
		onVREnabledChanged()

		return
	end

	if p4 == "VRSessionState" then
		onVRSessionStateChanged()
	end
end

onVREnabledChanged()
VRService.Changed:connect(onVRPropertyChanged)

function t1.RegisterModule(_, p6) -- line: 219
	-- upvalues: t2 (copy)
	t2[p6.ModuleName] = p6
end
function t1.GetModule(_, p8) -- line: 223
	-- upvalues: t2 (copy)
	return t2[p8]
end
function t1.IsModuleOpened(_, p10) -- line: 227
	-- upvalues: t3 (copy)
	return t3[p10] ~= nil
end
function t1.GetOpenedModules(_) -- line: 231
	-- upvalues: t3 (copy)
	local t4 = {}

	for _, v in pairs(t3) do
		table.insert(t4, v)
	end

	return t4
end

t1.ModuleOpened = Create("BindableEvent")({
	Name = "VRModuleOpened"
})

function t1.FireModuleOpened(_, p13) -- line: 245
	-- upvalues: t2 (copy), t3 (copy), t1 (copy)
	if not t2[p13] then
		error("Tried to open module that is not registered: " .. p13)
	end

	if t3[p13] ~= t2[p13] then
		t3[p13] = t2[p13]
		t1.ModuleOpened:Fire(p13)
	end
end

t1.ModuleClosed = Create("BindableEvent")({
	Name = "VRModuleClosed"
})

function t1.FireModuleClosed(_, p15) -- line: 260
	-- upvalues: t2 (copy), t3 (copy), t1 (copy)
	if not t2[p15] then
		error("Tried to close module that is not registered: " .. p15)
	end

	if t3[p15] ~= nil then
		t3[p15] = nil
		t1.ModuleClosed:Fire(p15)
	end
end
function t1.KeepVRTopbarOpen(_) -- line: 271
	-- upvalues: t3 (copy)
	for _, v in pairs(t3) do
		if v.KeepVRTopbarOpen then
			return true
		end
	end

	return false
end

t1.ShowHighlightedLeaveGameIcon = false
t1.ShowHighlightedLeaveGameIconToggled = Create("BindableEvent")({
	Name = "ShowHighlightedLeaveGameIconToggled"
})

function t1.SetShowHighlightedLeaveGameIconToggled(_, p18) -- line: 286
	-- upvalues: t1 (copy)
	if p18 ~= t1.ShowHighlightedLeaveGameIcon then
		t1.ShowHighlightedLeaveGameIcon = p18
		t1.ShowHighlightedLeaveGameIconToggled:Fire()
	end
end

t1.ShowTopBar = true
t1.ShowMoreMenu = false
t1.ShowTopBarChanged = Create("BindableEvent")({
	Name = "ShowTopBarChanged"
})
t1.ShowMoreMenuChanged = Create("BindableEvent")({
	Name = "ShowMoreMenuChanged"
})

function t1.SetShowTopBar(_, p20) -- line: 304
	-- upvalues: t1 (copy)
	if p20 ~= t1.ShowTopBar then
		t1.ShowTopBar = p20
		t1.ShowTopBarChanged:Fire()
	end
end
function t1.SetShowMoreMenu(_, p22) -- line: 311
	-- upvalues: t1 (copy)
	if p22 ~= t1.ShowMoreMenu then
		t1.ShowMoreMenu = p22
		t1.ShowMoreMenuChanged:Fire()
	end
end
function t1.ToggleSafetyBubble(_) -- line: 318
	-- upvalues: t1 (copy)
	if t1.SafetyBubble then
		t1.SafetyBubble:ToggleEnabled()
	end
end
function t1.GetControllerModel(_, p25) -- line: 324
	-- upvalues: t1 (copy)
	if p25 == Enum.UserCFrame.LeftHand then
		return t1.LeftControllerModel
	end

	if p25 == Enum.UserCFrame.RightHand then
		return t1.RightControllerModel
	end

	return nil
end
function t1.GetControllerButtonPosition(_, p27) -- line: 334
	-- upvalues: t1 (copy)
	return t1.LeftControllerModel and t1.LeftControllerModel:getButtonPosition(p27), t1.RightControllerModel and t1.RightControllerModel:getButtonPosition(p27)
end

SplashScreenManager.addStatusChangeListener(function(p28) -- line: 341
	-- upvalues: t1 (copy), onVREnabledChanged (copy)
	t1.isFPSAtTarget = p28
	onVREnabledChanged()
end)

return t1
