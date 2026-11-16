local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local VRService = game:GetService("VRService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
game:GetService("GamepadService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui.RobloxGui
local Modules = RobloxGui:WaitForChild("Modules")
local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local Panel3D = VrCommon.Panel3D
local VrCommon2 = require(CorePackages.Workspace.Packages.VrCommon)
local VRHub = VrCommon2.VRHub
local VirtualKeyboard = require(RobloxGui.Modules.VR.VirtualKeyboard)
local InGameMenuConstants = require(RobloxGui.Modules.InGameMenuConstants)
local IsSpatialRobloxGuiEnabled = require(RobloxGui.Modules.VR.IsSpatialRobloxGuiEnabled)

local CorePackages2 = game:GetService("CorePackages")
local VrCompatibility = require(CorePackages2.Workspace.Packages.VrCompatibility)
local VRConstants = VrCompatibility.VRConstants

game:GetService("UserInputService")
game:GetService("RunService")

local SharedExperimentDefinition = require(CorePackages2.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local SharedFlags = require(CorePackages2.Workspace.Packages.SharedFlags)
local panelType, v

if SharedFlags.FFlagEnableUIManagerPackgify then
	local VrSpatialUi = require(CorePackages2.Workspace.Packages.VrSpatialUi)
	panelType = VrSpatialUi.Constants.PanelType
	v = VrSpatialUi.UIManager
else
	local uiManager = Modules:WaitForChild("UIManager")
	local Constants = require(uiManager.Constants)
	panelType = Constants.PanelType
	v = require(uiManager.UIManager)
end

local GetFIntVRScaleGuiDistance = require(RobloxGui.Modules.Flags.GetFIntVRScaleGuiDistance)
local v2 = (GetFIntVRScaleGuiDistance or 100)() * 0.01
local defineFastFlag = game:DefineFastFlag("FixVRActionBinding", false)
local defineFastFlag2 = game:DefineFastFlag("FixUserGuiRenderingAfterVRDisabled", false)

if not VRService.VREnabled then
	warn("UserGui should not be required while not in VR")
	return nil
end

VRService.QuestDisplayRefreshRate = 90

local UserGui = {
	["ModuleName"] = nil,
	["ModuleName"] = nil,
	["ModuleName"] = nil,
	["ModuleName"] = nil,
	ModuleName = "UserGui",
	KeepVRTopbarOpen = false,
	VRIsExclusive = false,
	VRClosesNonExclusive = false,
	SetVisible = nil
}

VRHub:RegisterModule(UserGui)

Vector2.new(4, 3)
local vector2 = Vector2.new(2.66 * v2, 2 * v2)

local v3 = false

local v4 = Panel3D.Get(UserGui.ModuleName)
v4:SetType(Panel3D.Type.NewStandard)
local part = v4:GetPart()
part.CanQuery = false

local vector2_2 = Vector2.new(2.7978, 2.09835)
v4:ResizeStuds(vector2_2.x, vector2_2.y, 128)

v4:SetVisible(false)
local panel

if IsSpatialRobloxGuiEnabled then
	panel = Panel3D.Get(VRConstants.PositionLockedPanelName)
	config = {}
	local v5 = { panelType = panelType.RobloxGui }

	config.uiManagerPanelPart = v.getInstance():createUI(v5).panelObject
	panel:SetType(Panel3D.Type.UIManagerManaged, config)
else
	panel = Panel3D.Get(VRConstants.PositionLockedPanelName)
	panel:SetType(Panel3D.Type.PositionLocked)
end

local part_2 = panel:GetPart()
part_2.CanQuery = false

panel:ResizeStuds(vector2.x, vector2.y, 128)
panel:SetVisible(false)
panel.showCursor = true

VRHub.ModuleOpened.Event:connect(function(p)
	if p ~= UserGui.ModuleName and VRHub:GetModule(p).VRClosesNonExclusive and v4:IsVisible() then
		UserGui:SetVisible(false, nil)
	end
end)

local v5 = false
local v6 = false

function UserGui:SetVisible(p, object)
	v6 = p

	if object then
		object:SetVisible(v6)
	end

	if v6 then
		VRHub:FireModuleOpened(UserGui.ModuleName)
	else
		VRHub:FireModuleClosed(UserGui.ModuleName)
	end

	local v7 = v6 and not v5

	if IsSpatialRobloxGuiEnabled then
		CoreGui:SetUserGuiRendering(true, v7 and object and object:GetPart() or nil, Enum.NormalId.Back)
	else
		CoreGui:SetUserGuiRendering(true, v7 and object and object:GetPart() or nil, Enum.NormalId.Front)
	end
end

function UserGui:IsVisible()
	return v6
end

function UserGui:Update()
	self:SetVisible(v6)
end

local function onGuiSelection()
	if defineFastFlag2 and not VRService.VREnabled then
		return
	end

	VRHub.LaserPointer:updateInputUserCFrame()

	if VRHub.ShowTopBar then
		UserGui:SetVisible(true, panel)
		panel.initialCFLerp = 1
		panel:ForcePositionUpdate(true)
		panel.distance = 2.5 * v2

		if not v3 then
			panel:StartLerp(vector2)
			v3 = true
		end
	else
		panel:StartLerp(vector2 * 0.25)
		UserGui:SetVisible(false, panel)

		GuiService.SelectedObject = nil
		v3 = false
	end
end

VRHub.ShowTopBarChanged.Event:connect(onGuiSelection)
GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(onGuiSelection)
VRService.UserCFrameEnabled:Connect(onGuiSelection)
GuiService.PurchasePromptShown:Connect(function()
	if not VRHub.ShowTopBar then
		VRHub:SetShowTopBar(true)
	end
end)

local function onGuiSelectedObjectChanged(_)
	if (GuiService.SelectedObject or GuiService.SelectedCoreObject) and not VRHub.ShowTopBar then
		VRHub:SetShowTopBar(true)
	end

	GuiService.SelectedObject = nil
	GuiService.SelectedCoreObject = nil
end

GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(onGuiSelectedObjectChanged)
GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(onGuiSelectedObjectChanged)

local InGameMenu = require(RobloxGui.Modules.InGameMenu)

local function onVRMenuClicked(p)
	if p == "OpenVRMenu" then
		if VRHub.ShowTopBar then
			VRHub:SetShowTopBar(false)
			InGameMenu.closeInGameMenu()

			RbxAnalyticsService:ReportCounter("VR-BindAction-ToggleGui-Off")
		else
			VRHub:SetShowTopBar(true)

			RbxAnalyticsService:ReportCounter("VR-BindAction-ToggleGui-On")
		end
	end

	if p == "OpenIGMenu" then
		if not VRHub.ShowTopBar then
			VRHub:SetShowTopBar(true)
		end

		if not InGameMenu.getOpen() then
			InGameMenu.openInGameMenu(InGameMenuConstants.MainPagePageKey)
		end
	end
end

local function handleAction(p, p2, _)
	if p2 == Enum.UserInputState.Begin then
		onVRMenuClicked(p)
	end
end

if isInExperienceUIVREnabled then
	local InputHandlers = require(CorePackages2.Packages.InputHandlers)
	local v7 = false
	local v8 = false

	function UserGui.isInputNeededForOpenVRMenu(_, p): boolean
		return p.KeyCode == Enum.KeyCode.ButtonSelect
	end

	function UserGui:getOpenVRMenuHandler()
		local v9 = InputHandlers.handleInput({
			onPress = function()
				v7 = true
				v8 = false
			end,
			hold = {
				durationSeconds = 1,
				onComplete = function()
					v8 = true
					v.getInstance():resetDragAndDrop()
				end,
				allowReleaseAfterHold = true
			},
			onRelease = function()
				if not v8 then
					if VRHub.ShowTopBar then
						VRHub:SetShowTopBar(false)
						InGameMenu.closeInGameMenu()

						RbxAnalyticsService:ReportCounter("VR-BindAction-ToggleGui-Off")
					else
						VRHub:SetShowTopBar(true)

						RbxAnalyticsService:ReportCounter("VR-BindAction-ToggleGui-On")
					end
				end

				v7 = false
				v8 = false
			end
		})

		return function(_, userInputState, _)
			v9({
				eventData = { UserInputState = userInputState }
			})
		end
	end
end

if defineFastFlag or isInExperienceUIVREnabled then
	if isInExperienceUIVREnabled then
		ContextActionService:BindCoreAction(
			"OpenVRMenu",
			UserGui:getOpenVRMenuHandler(),
			false,
			Enum.KeyCode.ButtonSelect
		)
	else
		ContextActionService:BindCoreAction("OpenVRMenu", handleAction, false, Enum.KeyCode.ButtonSelect)
	end
else
	ContextActionService:BindAction("OpenVRMenu", handleAction, false, Enum.KeyCode.ButtonSelect)
end

ContextActionService:BindAction("OpenIGMenu", handleAction, false, Enum.KeyCode.ButtonStart)

local function OnVREnabledChanged()
	if VRService.VREnabled then
		UserGui:SetVisible(false, v4)
		UserGui:SetVisible(true, panel)
		VRHub:SetShowTopBar(true)
	else
		v4:SetVisible(false)
		CoreGui:SetUserGuiRendering(false, nil, Enum.NormalId.Front)
	end
end
VRService:GetPropertyChangedSignal("VREnabled"):connect(OnVREnabledChanged)
OnVREnabledChanged()

VirtualKeyboard.OpenedEvent:connect(function()
	v5 = true
	UserGui:Update()
end)

VirtualKeyboard.ClosedEvent:connect(function()
	v5 = false
	UserGui:Update()
end)

VRHub:SetShowTopBar(true)
onGuiSelection()

function UserGui.getPanel(_)
	return panel
end

return UserGui
