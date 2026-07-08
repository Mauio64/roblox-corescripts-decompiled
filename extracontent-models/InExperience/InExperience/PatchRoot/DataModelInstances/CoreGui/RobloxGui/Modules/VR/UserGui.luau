local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local VRService = game:GetService("VRService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")

game:GetService("GamepadService")

local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui.RobloxGui
local Modules = RobloxGui:WaitForChild("Modules")
local Panel3D = require(CorePackages.Workspace.Packages.VrCommon).Panel3D
local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub
local VirtualKeyboard = require(RobloxGui.Modules.VR.VirtualKeyboard)
local InGameMenuConstants = require(RobloxGui.Modules.InGameMenuConstants)
local IsSpatialRobloxGuiEnabled = require(RobloxGui.Modules.VR.IsSpatialRobloxGuiEnabled)
local CorePackages2 = game:GetService("CorePackages")
local VRConstants = require(CorePackages2.Workspace.Packages.VrCompatibility).VRConstants

game:GetService("UserInputService")
game:GetService("RunService")

local isInExperienceUIVREnabled = require(CorePackages2.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local PanelType, UIManager

if require(CorePackages2.Workspace.Packages.SharedFlags).FFlagEnableUIManagerPackgify then
	local VrSpatialUi = require(CorePackages2.Workspace.Packages.VrSpatialUi)

	PanelType = VrSpatialUi.Constants.PanelType
	UIManager = VrSpatialUi.UIManager
else
	local UIManager2 = Modules:WaitForChild("UIManager")

	PanelType = require(UIManager2.Constants).PanelType
	UIManager = require(UIManager2.UIManager)
end

local v21 = (require(RobloxGui.Modules.Flags.GetFIntVRScaleGuiDistance) or 100)() * 0.01
local v22 = game:DefineFastFlag("FixVRActionBinding", false)

if not VRService.VREnabled then
	warn("UserGui should not be required while not in VR")

	return nil
end

VRService.QuestDisplayRefreshRate = 90

local t1 = {
	ModuleName = "UserGui",
	KeepVRTopbarOpen = false,
	VRIsExclusive = false,
	VRClosesNonExclusive = false,
	SetVisible = nil
}

VRHub:RegisterModule(t1)
Vector2.new(4, 3)

local vector2 = Vector2.new(2.66 * v21, 2 * v21)
local u25 = false
local v26 = Panel3D.Get(t1.ModuleName)

v26:SetType(Panel3D.Type.NewStandard)
v26:GetPart().CanQuery = false

local vector2_2 = Vector2.new(2.7978, 2.09835)

v26:ResizeStuds(vector2_2.x, vector2_2.y, 128)
v26:SetVisible(false)

local u28

if IsSpatialRobloxGuiEnabled then
	u28 = Panel3D.Get(VRConstants.PositionLockedPanelName)
	config = {}

	local t2 = {
		panelType = PanelType.RobloxGui
	}

	config.uiManagerPanelPart = UIManager.getInstance():createUI(t2).panelObject
	u28:SetType(Panel3D.Type.UIManagerManaged, config)
else
	u28 = Panel3D.Get(VRConstants.PositionLockedPanelName)
	u28:SetType(Panel3D.Type.PositionLocked)
end

u28:GetPart().CanQuery = false
u28:ResizeStuds(vector2.x, vector2.y, 128)
u28:SetVisible(false)
u28.showCursor = true
VRHub.ModuleOpened.Event:connect(function(p1) -- line: 105
	-- upvalues: t1 (copy), VRHub (copy), v26 (copy)
	if p1 ~= t1.ModuleName and (VRHub:GetModule(p1).VRClosesNonExclusive and v26:IsVisible()) then
		t1:SetVisible(false, nil)
	end
end)

local u30 = false
local u31 = false

function t1.SetVisible(_, p3, p4) -- line: 117
	-- upvalues: u31 (ref), VRHub (copy), t1 (copy), u30 (ref), IsSpatialRobloxGuiEnabled (copy), CoreGui (copy)
	u31 = p3

	if p4 then
		p4:SetVisible(u31)
	end

	if u31 then
		VRHub:FireModuleOpened(t1.ModuleName)
	else
		VRHub:FireModuleClosed(t1.ModuleName)
	end

	local v45 = u31 and not u30

	if IsSpatialRobloxGuiEnabled then
		CoreGui:SetUserGuiRendering(true, v45 and (not not p4 and p4:GetPart()) or nil, Enum.NormalId.Back)

		return
	end

	CoreGui:SetUserGuiRendering(true, v45 and (not not p4 and p4:GetPart()) or nil, Enum.NormalId.Front)
end
function t1.IsVisible(_) -- line: 138
	-- upvalues: u31 (ref)
	return u31
end
function t1.Update(p6) -- line: 142
	-- upvalues: u31 (ref)
	p6:SetVisible(u31)
end

local function onGuiSelection() -- line: 147
	-- upvalues: VRHub (copy), t1 (copy), u28 (ref), v21 (copy), u25 (ref), vector2 (copy), GuiService (copy)
	VRHub.LaserPointer:updateInputUserCFrame()

	if VRHub.ShowTopBar then
		t1:SetVisible(true, u28)
		u28.initialCFLerp = 1
		u28:ForcePositionUpdate(true)
		u28.distance = 2.5 * v21

		if not u25 then
			u28:StartLerp(vector2)
			u25 = true

			return
		end
	else
		u28:StartLerp(vector2 * 0.25)
		t1:SetVisible(false, u28)
		GuiService.SelectedObject = nil
		u25 = false
	end
end

VRHub.ShowTopBarChanged.Event:connect(onGuiSelection)
GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(onGuiSelection)
VRService.UserCFrameEnabled:Connect(onGuiSelection)
GuiService.PurchasePromptShown:Connect(function() -- line: 174
	-- upvalues: VRHub (copy)
	if not VRHub.ShowTopBar then
		VRHub:SetShowTopBar(true)
	end
end)

local function onGuiSelectedObjectChanged(_) -- line: 181
	-- upvalues: GuiService (copy), VRHub (copy)
	if (GuiService.SelectedObject or GuiService.SelectedCoreObject) and not VRHub.ShowTopBar then
		VRHub:SetShowTopBar(true)
	end

	GuiService.SelectedObject = nil
	GuiService.SelectedCoreObject = nil
end

GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(onGuiSelectedObjectChanged)
GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(onGuiSelectedObjectChanged)

local InGameMenu = require(RobloxGui.Modules.InGameMenu)

local function onVRMenuClicked(p8) -- line: 194
	-- upvalues: VRHub (copy), RbxAnalyticsService (copy), InGameMenu (copy), InGameMenuConstants (copy)
	if p8 == "OpenVRMenu" then
		if not VRHub.ShowTopBar then
			VRHub:SetShowTopBar(true)
			RbxAnalyticsService:ReportCounter("VR-BindAction-ToggleGui-On")
		else
			VRHub:SetShowTopBar(false)
			InGameMenu.closeInGameMenu()
			RbxAnalyticsService:ReportCounter("VR-BindAction-ToggleGui-Off")
		end
	end

	if p8 == "OpenIGMenu" then
		if not VRHub.ShowTopBar then
			VRHub:SetShowTopBar(true)
		end

		if not InGameMenu.getOpen() then
			InGameMenu.openInGameMenu(InGameMenuConstants.MainPagePageKey)
		end
	end
end
local function handleAction(p9, p10, _) -- line: 219
	-- upvalues: onVRMenuClicked (copy)
	if p10 == Enum.UserInputState.Begin then
		onVRMenuClicked(p9)
	end
end

if isInExperienceUIVREnabled then
	local InputHandlers = require(CorePackages2.Packages.InputHandlers)
	local u38 = false
	local u39 = false

	function t1.isInputNeededForOpenVRMenu(_, p13) -- line: 230
		return p13.KeyCode == Enum.KeyCode.ButtonSelect
	end
	function t1.getOpenVRMenuHandler(_) -- line: 234
		-- upvalues: InputHandlers (copy), u38 (ref), u39 (ref), UIManager (ref), VRHub (copy), RbxAnalyticsService (copy), InGameMenu (copy)
		local v56 = InputHandlers.handleInput({
			onPress = function() -- line: 236
				-- upvalues: u38 (ref), u39 (ref)
				u38 = true
				u39 = false
			end,
			hold = {
				durationSeconds = 1,
				allowReleaseAfterHold = true,
				onComplete = function() -- line: 242
					-- upvalues: u39 (ref), UIManager (ref)
					u39 = true
					UIManager.getInstance():resetDragAndDrop()
				end
			},
			onRelease = function() -- line: 248
				-- upvalues: u39 (ref), VRHub (copy), RbxAnalyticsService (copy), InGameMenu (copy), u38 (ref)
				if not u39 then
					if not VRHub.ShowTopBar then
						VRHub:SetShowTopBar(true)
						RbxAnalyticsService:ReportCounter("VR-BindAction-ToggleGui-On")
					else
						VRHub:SetShowTopBar(false)
						InGameMenu.closeInGameMenu()
						RbxAnalyticsService:ReportCounter("VR-BindAction-ToggleGui-Off")
					end
				end

				u38 = false
				u39 = false
			end
		})

		return function(_, p16, _) -- line: 256
			-- upvalues: v56 (copy)
			local t3 = {
				eventData = {
					UserInputState = p16
				}
			}

			v56(t3)
		end
	end
end

if v22 or isInExperienceUIVREnabled then
	if isInExperienceUIVREnabled then
		ContextActionService:BindCoreAction("OpenVRMenu", t1:getOpenVRMenuHandler(), false, Enum.KeyCode.ButtonSelect)
	else
		ContextActionService:BindCoreAction("OpenVRMenu", handleAction, false, Enum.KeyCode.ButtonSelect)
	end
else
	ContextActionService:BindAction("OpenVRMenu", handleAction, false, Enum.KeyCode.ButtonSelect)
end

ContextActionService:BindAction("OpenIGMenu", handleAction, false, Enum.KeyCode.ButtonStart)

local function OnVREnabledChanged() -- line: 283
	-- upvalues: VRService (copy), v26 (copy), CoreGui (copy), t1 (copy), u28 (ref), VRHub (copy)
	if not VRService.VREnabled then
		v26:SetVisible(false)
		CoreGui:SetUserGuiRendering(false, nil, Enum.NormalId.Front)

		return
	end

	t1:SetVisible(false, v26)
	t1:SetVisible(true, u28)
	VRHub:SetShowTopBar(true)
end

VRService:GetPropertyChangedSignal("VREnabled"):connect(OnVREnabledChanged)
OnVREnabledChanged()
VirtualKeyboard.OpenedEvent:connect(function() -- line: 296
	-- upvalues: u30 (ref), t1 (copy)
	u30 = true
	t1:Update()
end)
VirtualKeyboard.ClosedEvent:connect(function() -- line: 301
	-- upvalues: u30 (ref), t1 (copy)
	u30 = false
	t1:Update()
end)
VRHub:SetShowTopBar(true)
onGuiSelection()

function t1.getPanel(_) -- line: 309
	-- upvalues: u28 (ref)
	return u28
end

return t1
