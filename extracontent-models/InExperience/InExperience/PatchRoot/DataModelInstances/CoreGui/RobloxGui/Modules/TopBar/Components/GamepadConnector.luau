local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local v9 = Responsive.GetInputModeStore(false)
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local Signals = require(CorePackages.Packages.Signals)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagShowUnibarOnVirtualCursor = SharedFlags.FFlagShowUnibarOnVirtualCursor
local FFlagConsoleChatUseChromeFocusUtils = SharedFlags.FFlagConsoleChatUseChromeFocusUtils
local FFlagExperienceMenuGamepadExposureEnabled = SharedFlags.FFlagExperienceMenuGamepadExposureEnabled
local EngineFeature = game:GetEngineFeature("PTFBackButtonAlwaysAsButtonB")
local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local ParentParent = script.Parent.Parent.Parent
local TopBar = ParentParent.TopBar
local FFlagAddTopBarScrim = require(TopBar.Flags.FFlagAddTopBarScrim)
local FFlagUseObservableDefaultForChromeFocused = require(TopBar.Flags.FFlagUseObservableDefaultForChromeFocused)
local isSpatial = AppCommonLib.isSpatial
local LogGamepadOpenExperienceControlsMenu = require(TopBar:WaitForChild("Telemetry")).LogGamepadOpenExperienceControlsMenu
local Chrome = ParentParent.Chrome
local v29 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local v30 = if not v29 then nil else require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local FocusUtils = require(CorePackages.Workspace.Packages.Chrome).FocusUtils
local v33 = if not FFlagUseObservableDefaultForChromeFocused and (not v29 or not FFlagEnableConsoleExpControls) then nil else ChromeUtils.ObservableValue
local v34 = if not v29 then nil else require(Chrome.ChromeShared.Unibar.Constants)
local ToastNotificationConstants = require(CorePackages.Workspace.Packages.ToastNotification).ToastNotificationConstants
local Constants = require(script.Parent.Parent.Constants)
local SettingsShowSignal = require(CorePackages.Workspace.Packages.CoreScriptsCommon).SettingsShowSignal
local PlayerList2 = ParentParent.PlayerList
local PlayerListManager = require(PlayerList2.PlayerListManager)
local MenuIconSelectedSignal = FocusUtils.MenuIconSelectedSignal
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagEnableUISelector = CoreGuiCommon.Flags.FFlagEnableUISelector
local v43 = if not FFlagEnableUISelector then nil else CoreGuiCommon.Stores.GetUiSelectorSignalStore
local v44 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetFocusNavigationStore(false)
local ToastNotification = nil
local u46 = nil
local u47 = nil

task.spawn(function() -- line: 69
	-- upvalues: ToastNotification (ref), CoreGui (copy), u46 (ref), u47 (ref)
	ToastNotification = CoreGui:WaitForChild("ToastNotification", 3)
	u46 = if ToastNotification == nil then nil else ToastNotification:WaitForChild("ToastNotificationWrapper", 3)
	u47 = if u46 == nil then nil else u46:FindFirstChild("Toast", true)
end)

local function createSelectedCoreObject() -- line: 127
	-- upvalues: v33 (copy), GuiService (copy)
	local v51 = v33.new(GuiService.SelectedCoreObject)

	GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 129
		-- upvalues: v51 (copy), GuiService (copy)
		v51:set(GuiService.SelectedCoreObject)
	end)

	return v51
end
local function isInputGamepad(p1) -- line: 136
	-- upvalues: Constants (copy)
	for _, v54 in Constants.GamepadInputTypes do
		if p1 == v54 then
			return true
		end
	end

	return false
end

local t1 = {}

t1.__index = t1

function t1.new() -- line: 149
	-- upvalues: GuiService (copy), v30 (copy), FFlagUseObservableDefaultForChromeFocused (copy), v33 (copy), v29 (copy), FFlagEnableConsoleExpControls (copy), UserInputService (copy), Constants (copy), FFlagAddNewPlayerListFocusNav (copy), SettingsShowSignal (copy), PlayerListManager (copy), FFlagAddNewPlayerListMobileFocusNav (copy), isSpatial (copy), FFlagEnableUISelector (copy), v43 (copy), FFlagShowUnibarOnVirtualCursor (copy), GamepadService (copy), MenuIconSelectedSignal (copy), FFlagAddTopBarScrim (copy), Signals (copy), t1 (copy)
	local t2 = {
		_loggedExperienceMenuGamepadExposure = false,
		_devSetCoreGuiNavEnabled = GuiService.CoreGuiNavigationEnabled,
		_chromeFocused = if not v30 then not not FFlagUseObservableDefaultForChromeFocused and v33.new(false) else v30:inFocusNav(),
		_lastMenuButtonPress = 0,
		_dismissFocusConnections = {}
	}
	local g63 = nil
	local v62 = nil
	local v57

	if v29 and FFlagEnableConsoleExpControls then
		local v56 = v33.new(GuiService.SelectedCoreObject)

		GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 129
			-- upvalues: v56 (copy), GuiService (copy)
			v56:set(GuiService.SelectedCoreObject)
		end)
		v57 = v56
	else
		v57 = nil
	end

	t2._selectedCoreObject = v57
	t2._connections = {}

	if v29 and FFlagEnableConsoleExpControls then
		local new = v33.new
		local LastInputType = UserInputService:GetLastInputType()

		for _, v61 in Constants.GamepadInputTypes do
			if LastInputType == v61 then
				v62 = true
				g63 = true
			end

			if g63 then
				break
			end
		end

		if not g63 then
			v62 = false
		end

		g63 = false
		t2._gamepadActive = new(v62)
		t2._tiltMenuOpen = v33.new(false)
		t2._playerListModalOpen = if not FFlagAddNewPlayerListFocusNav then nil else v33.new(false)
		t2._showTopBar = v33.new(true)
		UserInputService.LastInputTypeChanged:Connect(function(p2) -- line: 171
			-- upvalues: t2 (copy), Constants (copy)
			local _gamepadActive = t2._gamepadActive
			local g108 = nil
			local v107 = nil

			for _, v106 in Constants.GamepadInputTypes do
				if p2 == v106 then
					v107 = true
					g108 = true
				end

				if g108 then
					break
				end
			end

			if not g108 then
				v107 = false
			end

			g108 = false
			_gamepadActive:set(v107)
		end)
		SettingsShowSignal:connect(function(p3) -- line: 175
			-- upvalues: t2 (copy)
			t2._tiltMenuOpen:set(p3)
		end)

		if FFlagAddNewPlayerListFocusNav then
			PlayerListManager:GetVisibilityChangedEvent().Event:Connect(function() -- line: 180
				-- upvalues: FFlagAddNewPlayerListMobileFocusNav (copy), PlayerListManager (copy), t2 (copy)
				local v110 = not FFlagAddNewPlayerListMobileFocusNav or PlayerListManager:GetIsModal()

				t2._playerListModalOpen:set(v110 and PlayerListManager:GetVisibility())
			end)
		end

		if not isSpatial() then
			local function v64() -- line: 187
				-- upvalues: t2 (copy), FFlagEnableUISelector (copy), v43 (copy), UserInputService (copy), FFlagAddNewPlayerListFocusNav (copy), FFlagShowUnibarOnVirtualCursor (copy), GamepadService (copy), GuiService (copy)
				local v111 = not t2._gamepadActive:get() or (t2._chromeFocused:get() or (t2._selectedCoreObject:get() ~= nil and (not FFlagEnableUISelector or not v43(false).getVisibility()) or (UserInputService.TouchEnabled or (t2._tiltMenuOpen:get() or (FFlagAddNewPlayerListFocusNav and t2._playerListModalOpen:get() or (FFlagShowUnibarOnVirtualCursor and GamepadService.GamepadCursorEnabled or GamepadService.GamepadCursorEnabled))))))

				t2._showTopBar:set(v111)

				if v111 then
					GuiService.CoreGuiNavigationEnabled = true

					return
				end

				GuiService.CoreGuiNavigationEnabled = t2._devSetCoreGuiNavEnabled
			end

			t2._selectedCoreObject:connect(v64)
			t2._chromeFocused:connect(v64)
			t2._tiltMenuOpen:connect(v64)
			GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(v64)
			t2._gamepadActive:connect(v64, true)
		end
	end

	if FFlagEnableConsoleExpControls then
		GuiService:GetPropertyChangedSignal("CoreGuiNavigationEnabled"):Connect(function() -- line: 213
			-- upvalues: t2 (copy), GuiService (copy)
			t2._devSetCoreGuiNavEnabled = GuiService.CoreGuiNavigationEnabled
		end)
	end

	function t2._isTopBarFocused() -- line: 217
		-- upvalues: GamepadService (copy), t2 (copy), MenuIconSelectedSignal (copy)
		if GamepadService.GamepadCursorEnabled then
			return false
		end

		return t2._chromeFocused:get() or MenuIconSelectedSignal:get()
	end

	if FFlagAddTopBarScrim then
		local v65 = t2._isTopBarFocused()
		local v66, v67 = Signals.createSignal(v65)

		t2._topBarFocused = v66
		t2._setTopBarFocused = v67
	end

	return (setmetatable(t2, t1))
end
function t1.connectToTopbar(p4) -- line: 232
	-- upvalues: v29 (copy), FFlagEnableConsoleExpControls (copy), ContextActionService (copy), EngineFeature (copy), GuiService (copy), FFlagAddTopBarScrim (copy), v30 (copy), v34 (copy), MenuIconSelectedSignal (copy)
	if v29 then
		if FFlagEnableConsoleExpControls then
			p4:disconnectFromTopbar()
		end

		ContextActionService:BindCoreAction("FocusGamepadToTopbar", p4:_bindSelf(p4._toggleTopbar), false, Enum.KeyCode.ButtonStart)

		if EngineFeature then
			ContextActionService:BindCoreAction("ToggleUISelector", p4:_bindSelf(p4._toggleUiSelector), false, Enum.KeyCode.ButtonB)
		end

		local function v69() -- line: 251
			-- upvalues: p4 (copy), GuiService (copy), FFlagAddTopBarScrim (copy), v30 (copy), v34 (copy)
			local v112 = p4:_isTopBarFocused()

			GuiService:SetMenuIsOpen(v112, "TopbarMenu")

			if FFlagAddTopBarScrim then
				p4._setTopBarFocused(v112)
			end

			if v112 then
				v30:setShortcutBar(v34.UNIBAR_SHORTCUTBAR_ID)
				p4:_addDismissFocusConnections()

				return
			end

			p4:_removeDismissFocusConnections()
		end

		table.insert(p4._connections, p4._chromeFocused:connect(v69))
		table.insert(p4._connections, MenuIconSelectedSignal:connect(v69))
	end
end
function t1.disconnectFromTopbar(p5) -- line: 271
	-- upvalues: ContextActionService (copy), EngineFeature (copy)
	for _, v72 in p5._connections do
		v72:disconnect()
	end

	p5._connections = {}
	p5:_removeDismissFocusConnections()
	ContextActionService:UnbindCoreAction("FocusGamepadToTopbar")

	if EngineFeature then
		ContextActionService:UnbindCoreAction("ToggleUISelector")
	end
end
function t1.getSelectedCoreObject(p6) -- line: 284
	return p6._selectedCoreObject
end
function t1.getShowTopBar(p7) -- line: 288
	return p7._showTopBar
end
function t1.getGamepadActive(p8) -- line: 292
	return p8._gamepadActive
end
function t1.topBarFocused(p9, p10) -- line: 296
	-- upvalues: FFlagAddTopBarScrim (copy)
	if not FFlagAddTopBarScrim then
		return
	end

	return p9._topBarFocused(p10)
end
function t1._addDismissFocusConnections(p11) -- line: 304
	-- upvalues: UserInputService (copy), v9 (copy), Responsive (copy)
	p11._dismissFocusConnections = { (UserInputService.InputEnded:Connect(function(input, gameProcessed: boolean) -- line: 306
		-- upvalues: v9 (copy), Responsive (copy), p11 (copy)
		local v115 = v9.getLastInputType(false)
		local v116 = v115 == Responsive.Input.Pointer and input.UserInputType ~= Enum.UserInputType.Keyboard
		local v117 = v115 == Responsive.Input.Touch

		if v116 or v117 and not gameProcessed then
			p11:_unfocusGamepadFromTopBar()
		end
	end)) }
end
function t1._removeDismissFocusConnections(p12) -- line: 322
	for _, v81 in p12._dismissFocusConnections do
		v81:Disconnect()
	end

	p12._dismissFocusConnections = {}
end
function t1._toggleTopbar(p13, p14, p15, p16) -- line: 329
	-- upvalues: v29 (copy), FFlagEnableConsoleExpControls (copy), EngineFeature (copy), FFlagEnableUISelector (copy), UserInputService (copy), v30 (copy), v44 (copy), LogGamepadOpenExperienceControlsMenu (copy), FFlagAddNewPlayerListMobileFocusNav (copy), PlayerListManager (copy)
	if v29 and not p13:_focusToastNotification(p15) and (not FFlagEnableConsoleExpControls and p15 == Enum.UserInputState.End or FFlagEnableConsoleExpControls and p15 == Enum.UserInputState.Begin) then
		if not EngineFeature and FFlagEnableUISelector and not UserInputService:GamepadSupports(UserInputService:GetLastInputType(), Enum.KeyCode.ButtonSelect) then
			return p13:_toggleUiSelector(p14, p15, p16)
		end

		if FFlagEnableConsoleExpControls then
			if v30:integrations().nine_dot == nil then
				return Enum.ContextActionResult.Pass
			end

			local v86 = not (p13:_isTopBarFocused() or v44.getChatInputBarFocused(false))

			if v86 then
				p13:_focusGamepadToTopBar()
			else
				p13:_unfocusGamepadFromTopBar()
			end

			p13:_logExperienceMenuGamepadExposure()
			LogGamepadOpenExperienceControlsMenu(v86)
		else
			p13:_toggleUnibarMenu()
		end

		if FFlagAddNewPlayerListMobileFocusNav and PlayerListManager:GetIsModal() and PlayerListManager:GetVisibility() then
			PlayerListManager:SetVisibility(false)
		end

		return Enum.ContextActionResult.Sink
	end

	return Enum.ContextActionResult.Pass
end
function t1._toggleUiSelector(p17, _, p19, _) -- line: 372
	-- upvalues: FFlagEnableUISelector (copy), v29 (copy), FFlagEnableConsoleExpControls (copy), UserInputService (copy), GamepadService (copy), GuiService (copy), v43 (copy)
	if FFlagEnableUISelector and (v29 and not p17:_focusToastNotification(p19)) and ((not FFlagEnableConsoleExpControls and p19 == Enum.UserInputState.End or FFlagEnableConsoleExpControls and p19 == Enum.UserInputState.Begin) and not UserInputService:GamepadSupports(UserInputService:GetLastInputType(), Enum.KeyCode.ButtonSelect)) then
		if GamepadService.GamepadCursorEnabled or GuiService.SelectedObject ~= nil then
			GamepadService:DisableGamepadCursor()
			GuiService.SelectedObject = nil

			return Enum.ContextActionResult.Sink
		end

		local v91 = v43(false)

		if v91.getVisibility(false) then
			v91.setVisibility(false)

			return Enum.ContextActionResult.Sink
		end

		if not p17:_isTopBarFocused() then
			v91.setVisibility(true)

			return Enum.ContextActionResult.Sink
		end
	end

	return Enum.ContextActionResult.Pass
end
function t1._toggleUnibarMenu(p21) -- line: 400
	-- upvalues: FFlagEnableConsoleExpControls (copy), v30 (copy), LogGamepadOpenExperienceControlsMenu (copy)
	local v93 = p21._chromeFocused:get()

	if v93 then
		if FFlagEnableConsoleExpControls then
			p21:_unfocusGamepadFromTopBar()
		else
			v30:disableFocusNav()
		end
	elseif FFlagEnableConsoleExpControls then
		p21:_focusGamepadToTopBar()
	else
		v30:enableFocusNav()
	end

	p21:_logExperienceMenuGamepadExposure()
	LogGamepadOpenExperienceControlsMenu(v93)
end
function t1._focusGamepadToTopBar(_) -- line: 419
	-- upvalues: FocusUtils (copy)
	FocusUtils.FocusOnChrome()
end
function t1._unfocusGamepadFromTopBar(_) -- line: 423
	-- upvalues: FocusUtils (copy), FFlagConsoleChatUseChromeFocusUtils (copy), v44 (copy), GuiService (copy)
	FocusUtils.FocusOffChrome(function() -- line: 424
		-- upvalues: FFlagConsoleChatUseChromeFocusUtils (copy), v44 (copy), GuiService (copy)
		if FFlagConsoleChatUseChromeFocusUtils and v44.getChatInputBarFocused(false) then
			v44.unfocusChatInputBar()
		end

		GuiService.SelectedCoreObject = nil
	end)
end
function t1._focusToastNotification(p24, p25) -- line: 432
	-- upvalues: u47 (ref), ToastNotificationConstants (copy)
	local function buttonHoldTime() -- line: 433
		-- upvalues: p24 (copy)
		return tick() - p24._lastMenuButtonPress
	end

	local v99 = u47 ~= nil and u47.Visible

	if p25 == Enum.UserInputState.Begin then
		p24._lastMenuButtonPress = tick()

		return false
	end

	return p25 == Enum.UserInputState.End and (v99 and tick() - p24._lastMenuButtonPress < ToastNotificationConstants.MenuButtonPressHoldTime)
end
function t1._logExperienceMenuGamepadExposure(p26) -- line: 448
	-- upvalues: FFlagExperienceMenuGamepadExposureEnabled (copy), IXPServiceWrapper (copy), AppUserLayers (copy)
	if FFlagExperienceMenuGamepadExposureEnabled and not p26._loggedExperienceMenuGamepadExposure then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.ExperienceMenuGamepadExposureLayer)
		p26._loggedExperienceMenuGamepadExposure = true
	end
end
function t1._bindSelf(t3: {[any]: any}, p27: ((...any) -> ...any)) -- line: 455
	return function(...) -- line: 456
		-- upvalues: p27 (copy), t3 (copy)
		return p27(t3, ...)
	end
end

if FFlagEnableConsoleExpControls then
	return (t1.new())
end

return t1
