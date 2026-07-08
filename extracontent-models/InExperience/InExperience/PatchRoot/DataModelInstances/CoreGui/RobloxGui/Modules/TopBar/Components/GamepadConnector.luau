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
local isSpatial = AppCommonLib.isSpatial
local LogGamepadOpenExperienceControlsMenu = require(TopBar:WaitForChild("Telemetry")).LogGamepadOpenExperienceControlsMenu
local Chrome = ParentParent.Chrome
local v28 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local v29 = if not v28 then nil else require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local FocusUtils = require(CorePackages.Workspace.Packages.Chrome).FocusUtils
local v32 = if not v28 or not FFlagEnableConsoleExpControls then nil else ChromeUtils.ObservableValue
local v33 = if not v28 then nil else require(Chrome.ChromeShared.Unibar.Constants)
local ToastNotificationConstants = require(CorePackages.Workspace.Packages.ToastNotification).ToastNotificationConstants
local Constants = require(script.Parent.Parent.Constants)
local SettingsShowSignal = require(CorePackages.Workspace.Packages.CoreScriptsCommon).SettingsShowSignal
local PlayerList2 = ParentParent.PlayerList
local PlayerListManager = require(PlayerList2.PlayerListManager)
local MenuIconSelectedSignal = FocusUtils.MenuIconSelectedSignal
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagEnableUISelector = CoreGuiCommon.Flags.FFlagEnableUISelector
local v42 = if not FFlagEnableUISelector then nil else CoreGuiCommon.Stores.GetUiSelectorSignalStore
local v43 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetFocusNavigationStore(false)
local ToastNotification = nil
local u45 = nil
local u46 = nil

task.spawn(function() -- line: 67
	-- upvalues: ToastNotification (ref), CoreGui (copy), u45 (ref), u46 (ref)
	ToastNotification = CoreGui:WaitForChild("ToastNotification", 3)
	u45 = if ToastNotification == nil then nil else ToastNotification:WaitForChild("ToastNotificationWrapper", 3)
	u46 = if u45 == nil then nil else u45:FindFirstChild("Toast", true)
end)

local function createSelectedCoreObject() -- line: 125
	-- upvalues: v32 (copy), GuiService (copy)
	local v50 = v32.new(GuiService.SelectedCoreObject)

	GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 127
		-- upvalues: v50 (copy), GuiService (copy)
		v50:set(GuiService.SelectedCoreObject)
	end)

	return v50
end
local function isInputGamepad(p1) -- line: 134
	-- upvalues: Constants (copy)
	for _, v53 in Constants.GamepadInputTypes do
		if p1 == v53 then
			return true
		end
	end

	return false
end

local t1 = {}

t1.__index = t1

function t1.new() -- line: 147
	-- upvalues: GuiService (copy), v29 (copy), v28 (copy), FFlagEnableConsoleExpControls (copy), v32 (copy), UserInputService (copy), Constants (copy), FFlagAddNewPlayerListFocusNav (copy), SettingsShowSignal (copy), PlayerListManager (copy), FFlagAddNewPlayerListMobileFocusNav (copy), isSpatial (copy), FFlagEnableUISelector (copy), v42 (copy), FFlagShowUnibarOnVirtualCursor (copy), GamepadService (copy), MenuIconSelectedSignal (copy), FFlagAddTopBarScrim (copy), Signals (copy), t1 (copy)
	local t2 = {
		_loggedExperienceMenuGamepadExposure = false,
		_devSetCoreGuiNavEnabled = GuiService.CoreGuiNavigationEnabled,
		_chromeFocused = not not v29 and v29:inFocusNav(),
		_lastMenuButtonPress = 0,
		_dismissFocusConnections = {}
	}
	local g62 = nil
	local v61 = nil
	local v56

	if v28 and FFlagEnableConsoleExpControls then
		local v55 = v32.new(GuiService.SelectedCoreObject)

		GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 127
			-- upvalues: v55 (copy), GuiService (copy)
			v55:set(GuiService.SelectedCoreObject)
		end)
		v56 = v55
	else
		v56 = nil
	end

	t2._selectedCoreObject = v56
	t2._connections = {}

	if v28 and FFlagEnableConsoleExpControls then
		local new = v32.new
		local LastInputType = UserInputService:GetLastInputType()

		for _, v60 in Constants.GamepadInputTypes do
			if LastInputType == v60 then
				v61 = true
				g62 = true
			end

			if g62 then
				break
			end
		end

		if not g62 then
			v61 = false
		end

		g62 = false
		t2._gamepadActive = new(v61)
		t2._tiltMenuOpen = v32.new(false)
		t2._playerListModalOpen = if not FFlagAddNewPlayerListFocusNav then nil else v32.new(false)
		t2._showTopBar = v32.new(true)
		UserInputService.LastInputTypeChanged:Connect(function(p2) -- line: 166
			-- upvalues: t2 (copy), Constants (copy)
			local _gamepadActive = t2._gamepadActive
			local g107 = nil
			local v106 = nil

			for _, v105 in Constants.GamepadInputTypes do
				if p2 == v105 then
					v106 = true
					g107 = true
				end

				if g107 then
					break
				end
			end

			if not g107 then
				v106 = false
			end

			g107 = false
			_gamepadActive:set(v106)
		end)
		SettingsShowSignal:connect(function(p3) -- line: 170
			-- upvalues: t2 (copy)
			t2._tiltMenuOpen:set(p3)
		end)

		if FFlagAddNewPlayerListFocusNav then
			PlayerListManager:GetVisibilityChangedEvent().Event:Connect(function() -- line: 175
				-- upvalues: FFlagAddNewPlayerListMobileFocusNav (copy), PlayerListManager (copy), t2 (copy)
				local v109 = not FFlagAddNewPlayerListMobileFocusNav or PlayerListManager:GetIsModal()

				t2._playerListModalOpen:set(v109 and PlayerListManager:GetVisibility())
			end)
		end

		if not isSpatial() then
			local function v63() -- line: 182
				-- upvalues: t2 (copy), FFlagEnableUISelector (copy), v42 (copy), UserInputService (copy), FFlagAddNewPlayerListFocusNav (copy), FFlagShowUnibarOnVirtualCursor (copy), GamepadService (copy), GuiService (copy)
				local v110 = not t2._gamepadActive:get() or (t2._chromeFocused:get() or (t2._selectedCoreObject:get() ~= nil and (not FFlagEnableUISelector or not v42(false).getVisibility()) or (UserInputService.TouchEnabled or (t2._tiltMenuOpen:get() or (FFlagAddNewPlayerListFocusNav and t2._playerListModalOpen:get() or (FFlagShowUnibarOnVirtualCursor and GamepadService.GamepadCursorEnabled or GamepadService.GamepadCursorEnabled))))))

				t2._showTopBar:set(v110)

				if v110 then
					GuiService.CoreGuiNavigationEnabled = true

					return
				end

				GuiService.CoreGuiNavigationEnabled = t2._devSetCoreGuiNavEnabled
			end

			t2._selectedCoreObject:connect(v63)
			t2._chromeFocused:connect(v63)
			t2._tiltMenuOpen:connect(v63)
			GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(v63)
			t2._gamepadActive:connect(v63, true)
		end
	end

	if FFlagEnableConsoleExpControls then
		GuiService:GetPropertyChangedSignal("CoreGuiNavigationEnabled"):Connect(function() -- line: 208
			-- upvalues: t2 (copy), GuiService (copy)
			t2._devSetCoreGuiNavEnabled = GuiService.CoreGuiNavigationEnabled
		end)
	end

	function t2._isTopBarFocused() -- line: 212
		-- upvalues: GamepadService (copy), t2 (copy), MenuIconSelectedSignal (copy)
		if GamepadService.GamepadCursorEnabled then
			return false
		end

		return t2._chromeFocused:get() or MenuIconSelectedSignal:get()
	end

	if FFlagAddTopBarScrim then
		local v64 = t2._isTopBarFocused()
		local v65, v66 = Signals.createSignal(v64)

		t2._topBarFocused = v65
		t2._setTopBarFocused = v66
	end

	return (setmetatable(t2, t1))
end
function t1.connectToTopbar(p4) -- line: 227
	-- upvalues: v28 (copy), FFlagEnableConsoleExpControls (copy), ContextActionService (copy), EngineFeature (copy), GuiService (copy), FFlagAddTopBarScrim (copy), v29 (copy), v33 (copy), MenuIconSelectedSignal (copy)
	if v28 then
		if FFlagEnableConsoleExpControls then
			p4:disconnectFromTopbar()
		end

		ContextActionService:BindCoreAction("FocusGamepadToTopbar", p4:_bindSelf(p4._toggleTopbar), false, Enum.KeyCode.ButtonStart)

		if EngineFeature then
			ContextActionService:BindCoreAction("ToggleUISelector", p4:_bindSelf(p4._toggleUiSelector), false, Enum.KeyCode.ButtonB)
		end

		local function v68() -- line: 246
			-- upvalues: p4 (copy), GuiService (copy), FFlagAddTopBarScrim (copy), v29 (copy), v33 (copy)
			local v111 = p4:_isTopBarFocused()

			GuiService:SetMenuIsOpen(v111, "TopbarMenu")

			if FFlagAddTopBarScrim then
				p4._setTopBarFocused(v111)
			end

			if v111 then
				v29:setShortcutBar(v33.UNIBAR_SHORTCUTBAR_ID)
				p4:_addDismissFocusConnections()

				return
			end

			p4:_removeDismissFocusConnections()
		end

		table.insert(p4._connections, p4._chromeFocused:connect(v68))
		table.insert(p4._connections, MenuIconSelectedSignal:connect(v68))
	end
end
function t1.disconnectFromTopbar(p5) -- line: 266
	-- upvalues: ContextActionService (copy), EngineFeature (copy)
	for _, v71 in p5._connections do
		v71:disconnect()
	end

	p5._connections = {}
	p5:_removeDismissFocusConnections()
	ContextActionService:UnbindCoreAction("FocusGamepadToTopbar")

	if EngineFeature then
		ContextActionService:UnbindCoreAction("ToggleUISelector")
	end
end
function t1.getSelectedCoreObject(p6) -- line: 279
	return p6._selectedCoreObject
end
function t1.getShowTopBar(p7) -- line: 283
	return p7._showTopBar
end
function t1.getGamepadActive(p8) -- line: 287
	return p8._gamepadActive
end
function t1.topBarFocused(p9, p10) -- line: 291
	-- upvalues: FFlagAddTopBarScrim (copy)
	if not FFlagAddTopBarScrim then
		return
	end

	return p9._topBarFocused(p10)
end
function t1._addDismissFocusConnections(p11) -- line: 299
	-- upvalues: UserInputService (copy), v9 (copy), Responsive (copy)
	p11._dismissFocusConnections = { (UserInputService.InputEnded:Connect(function(input, gameProcessed: boolean) -- line: 301
		-- upvalues: v9 (copy), Responsive (copy), p11 (copy)
		local v114 = v9.getLastInputType(false)
		local v115 = v114 == Responsive.Input.Pointer and input.UserInputType ~= Enum.UserInputType.Keyboard
		local v116 = v114 == Responsive.Input.Touch

		if v115 or v116 and not gameProcessed then
			p11:_unfocusGamepadFromTopBar()
		end
	end)) }
end
function t1._removeDismissFocusConnections(p12) -- line: 317
	for _, v80 in p12._dismissFocusConnections do
		v80:Disconnect()
	end

	p12._dismissFocusConnections = {}
end
function t1._toggleTopbar(p13, p14, p15, p16) -- line: 324
	-- upvalues: v28 (copy), FFlagEnableConsoleExpControls (copy), EngineFeature (copy), FFlagEnableUISelector (copy), UserInputService (copy), v29 (copy), v43 (copy), LogGamepadOpenExperienceControlsMenu (copy), FFlagAddNewPlayerListMobileFocusNav (copy), PlayerListManager (copy)
	if v28 and not p13:_focusToastNotification(p15) and (not FFlagEnableConsoleExpControls and p15 == Enum.UserInputState.End or FFlagEnableConsoleExpControls and p15 == Enum.UserInputState.Begin) then
		if not EngineFeature and FFlagEnableUISelector and not UserInputService:GamepadSupports(UserInputService:GetLastInputType(), Enum.KeyCode.ButtonSelect) then
			return p13:_toggleUiSelector(p14, p15, p16)
		end

		if FFlagEnableConsoleExpControls then
			if v29:integrations().nine_dot == nil then
				return Enum.ContextActionResult.Pass
			end

			local v85 = not (p13:_isTopBarFocused() or v43.getChatInputBarFocused(false))

			if v85 then
				p13:_focusGamepadToTopBar()
			else
				p13:_unfocusGamepadFromTopBar()
			end

			p13:_logExperienceMenuGamepadExposure()
			LogGamepadOpenExperienceControlsMenu(v85)
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
function t1._toggleUiSelector(p17, _, p19, _) -- line: 367
	-- upvalues: FFlagEnableUISelector (copy), v28 (copy), FFlagEnableConsoleExpControls (copy), UserInputService (copy), GamepadService (copy), GuiService (copy), v42 (copy)
	if FFlagEnableUISelector and (v28 and not p17:_focusToastNotification(p19)) and ((not FFlagEnableConsoleExpControls and p19 == Enum.UserInputState.End or FFlagEnableConsoleExpControls and p19 == Enum.UserInputState.Begin) and not UserInputService:GamepadSupports(UserInputService:GetLastInputType(), Enum.KeyCode.ButtonSelect)) then
		if GamepadService.GamepadCursorEnabled or GuiService.SelectedObject ~= nil then
			GamepadService:DisableGamepadCursor()
			GuiService.SelectedObject = nil

			return Enum.ContextActionResult.Sink
		end

		local v90 = v42(false)

		if v90.getVisibility(false) then
			v90.setVisibility(false)

			return Enum.ContextActionResult.Sink
		end

		if not p17:_isTopBarFocused() then
			v90.setVisibility(true)

			return Enum.ContextActionResult.Sink
		end
	end

	return Enum.ContextActionResult.Pass
end
function t1._toggleUnibarMenu(p21) -- line: 395
	-- upvalues: FFlagEnableConsoleExpControls (copy), v29 (copy), LogGamepadOpenExperienceControlsMenu (copy)
	local v92 = p21._chromeFocused:get()

	if v92 then
		if FFlagEnableConsoleExpControls then
			p21:_unfocusGamepadFromTopBar()
		else
			v29:disableFocusNav()
		end
	elseif FFlagEnableConsoleExpControls then
		p21:_focusGamepadToTopBar()
	else
		v29:enableFocusNav()
	end

	p21:_logExperienceMenuGamepadExposure()
	LogGamepadOpenExperienceControlsMenu(v92)
end
function t1._focusGamepadToTopBar(_) -- line: 414
	-- upvalues: FocusUtils (copy)
	FocusUtils.FocusOnChrome()
end
function t1._unfocusGamepadFromTopBar(_) -- line: 418
	-- upvalues: FocusUtils (copy), FFlagConsoleChatUseChromeFocusUtils (copy), v43 (copy), GuiService (copy)
	FocusUtils.FocusOffChrome(function() -- line: 419
		-- upvalues: FFlagConsoleChatUseChromeFocusUtils (copy), v43 (copy), GuiService (copy)
		if FFlagConsoleChatUseChromeFocusUtils and v43.getChatInputBarFocused(false) then
			v43.unfocusChatInputBar()
		end

		GuiService.SelectedCoreObject = nil
	end)
end
function t1._focusToastNotification(p24, p25) -- line: 427
	-- upvalues: u46 (ref), ToastNotificationConstants (copy)
	local function buttonHoldTime() -- line: 428
		-- upvalues: p24 (copy)
		return tick() - p24._lastMenuButtonPress
	end

	local v98 = u46 ~= nil and u46.Visible

	if p25 == Enum.UserInputState.Begin then
		p24._lastMenuButtonPress = tick()

		return false
	end

	return p25 == Enum.UserInputState.End and (v98 and tick() - p24._lastMenuButtonPress < ToastNotificationConstants.MenuButtonPressHoldTime)
end
function t1._logExperienceMenuGamepadExposure(p26) -- line: 443
	-- upvalues: FFlagExperienceMenuGamepadExposureEnabled (copy), IXPServiceWrapper (copy), AppUserLayers (copy)
	if FFlagExperienceMenuGamepadExposureEnabled and not p26._loggedExperienceMenuGamepadExposure then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.ExperienceMenuGamepadExposureLayer)
		p26._loggedExperienceMenuGamepadExposure = true
	end
end
function t1._bindSelf(t3: {[any]: any}, p27: ((...any) -> ...any)) -- line: 450
	return function(...) -- line: 451
		-- upvalues: p27 (copy), t3 (copy)
		return p27(t3, ...)
	end
end

if FFlagEnableConsoleExpControls then
	return (t1.new())
end

return t1
