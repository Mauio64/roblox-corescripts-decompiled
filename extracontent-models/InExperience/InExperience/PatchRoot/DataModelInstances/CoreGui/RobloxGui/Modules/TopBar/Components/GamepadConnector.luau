local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local inputModeStore = Responsive.GetInputModeStore(false)
local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local ExperimentLayers = require(CorePackages.Workspace.Packages.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local Signals = require(CorePackages.Packages.Signals)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagShowUnibarOnVirtualCursor = SharedFlags.FFlagShowUnibarOnVirtualCursor
local FFlagConsoleChatUseChromeFocusUtils = SharedFlags.FFlagConsoleChatUseChromeFocusUtils
local FFlagExperienceMenuGamepadExposureEnabled = SharedFlags.FFlagExperienceMenuGamepadExposureEnabled
local engineFeature = game:GetEngineFeature("PTFBackButtonAlwaysAsButtonB")

local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav

local parent = script.Parent.Parent.Parent
local topBar = parent.TopBar

local FFlagAddTopBarScrim = require(topBar.Flags.FFlagAddTopBarScrim)
local FFlagUseObservableDefaultForChromeFocused = require(topBar.Flags.FFlagUseObservableDefaultForChromeFocused)

local isSpatial = AppCommonLib.isSpatial
local Telemetry = require(topBar:WaitForChild("Telemetry"))
local LogGamepadOpenExperienceControlsMenu = Telemetry.LogGamepadOpenExperienceControlsMenu
local chrome = parent.Chrome
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome.Enabled()
local Service

if enabled then
	Service = require(chrome.Service)
else
	Service = nil
end

local ChromeUtils = require(chrome.ChromeShared.Service.ChromeUtils)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local FocusUtils = Chrome2.FocusUtils
local observableValue

if FFlagUseObservableDefaultForChromeFocused or enabled and FFlagEnableConsoleExpControls then
	observableValue = ChromeUtils.ObservableValue
else
	observableValue = nil
end

local Constants

if enabled then
	Constants = require(chrome.ChromeShared.Unibar.Constants)
else
	Constants = nil
end

local ToastNotification = require(CorePackages.Workspace.Packages.ToastNotification)
local ToastNotificationConstants = ToastNotification.ToastNotificationConstants
local Constants2 = require(script.Parent.Parent.Constants)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal
local playerList = parent.PlayerList
local PlayerListManager = require(playerList.PlayerListManager)
local MenuIconSelectedSignal = FocusUtils.MenuIconSelectedSignal
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagEnableUISelector = CoreGuiCommon.Flags.FFlagEnableUISelector
local getUiSelectorSignalStore

if FFlagEnableUISelector then
	getUiSelectorSignalStore = CoreGuiCommon.Stores.GetUiSelectorSignalStore
else
	getUiSelectorSignalStore = nil
end

local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local focusNavigationStore = ExpChat.Stores.GetFocusNavigationStore(false)

local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local getSideSheetVisibility = InExperienceSideSheet.getSideSheetVisibility

local toastNotification = nil
local v = nil
local v2 = nil
task.spawn(function()
	toastNotification = CoreGui:WaitForChild("ToastNotification", 3)
	local v3

	if toastNotification ~= nil then
		v3 = toastNotification:WaitForChild("ToastNotificationWrapper", 3)
	end

	v = v3
	local v4

	if v ~= nil then
		v4 = v:FindFirstChild("Toast", true)
	end

	v2 = v4
end)

local function createSelectedCoreObject()
	local selectedCoreObject = observableValue.new(GuiService.SelectedCoreObject)
	GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
		selectedCoreObject:set(GuiService.SelectedCoreObject)
	end)

	return selectedCoreObject
end

local function isInputGamepad(p): boolean -- 2 equivalent calls inferred from this helper
	for _, gamepadInputType in Constants2.GamepadInputTypes do
		if p == gamepadInputType then
			return true
		end
	end

	return false
end

local GamepadConnector = {}
GamepadConnector.__index = GamepadConnector

function GamepadConnector.new()
	local v3 = {}
	v3._loggedExperienceMenuGamepadExposure = false
	v3._devSetCoreGuiNavEnabled = GuiService.CoreGuiNavigationEnabled
	local chromeFocused

	if Service then
		chromeFocused = Service:inFocusNav()
	elseif FFlagUseObservableDefaultForChromeFocused then
		chromeFocused = observableValue.new(false)
	else
		chromeFocused = false
	end

	v3._chromeFocused = chromeFocused

	v3._lastMenuButtonPress = 0
	v3._dismissFocusConnections = {}
	local selectedCoreObject

	if enabled and FFlagEnableConsoleExpControls then
		selectedCoreObject = observableValue.new(GuiService.SelectedCoreObject)
		GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
			selectedCoreObject:set(GuiService.SelectedCoreObject)
		end)
	else
		selectedCoreObject = nil
	end

	v3._selectedCoreObject = selectedCoreObject

	v3._connections = {}

	if enabled and FFlagEnableConsoleExpControls then
		v3._gamepadActive = observableValue.new(isInputGamepad(UserInputService:GetLastInputType())) -- inferred equivalent call
		v3._tiltMenuOpen = observableValue.new(false)
		local playerListModalOpen

		if FFlagAddNewPlayerListFocusNav then
			playerListModalOpen = observableValue.new(false)
		end

		v3._playerListModalOpen = playerListModalOpen

		v3._showTopBar = observableValue.new(true)

		UserInputService.LastInputTypeChanged:Connect(function(p)
			v3._gamepadActive:set(isInputGamepad(p)) -- inferred equivalent call
		end)

		SettingsShowSignal:connect(function(p)
			v3._tiltMenuOpen:set(p)
		end)

		if FFlagAddNewPlayerListFocusNav then
			PlayerListManager:GetVisibilityChangedEvent().Event:Connect(function()
				local v4 = not FFlagAddNewPlayerListMobileFocusNav or PlayerListManager:GetIsModal()
				v3._playerListModalOpen:set(v4 and PlayerListManager:GetVisibility())
			end)
		end

		if not isSpatial() then
			local function fn()
				local v4 = not v3._gamepadActive:get()
					or v3._chromeFocused:get()
					or v3._selectedCoreObject:get() ~= nil
					and not (FFlagEnableUISelector and getUiSelectorSignalStore(false).getVisibility())
					or UserInputService.TouchEnabled
					or v3._tiltMenuOpen:get()
					or FFlagAddNewPlayerListFocusNav and v3._playerListModalOpen:get()
					or FFlagShowUnibarOnVirtualCursor and GamepadService.GamepadCursorEnabled
					or GamepadService.GamepadCursorEnabled
				v3._showTopBar:set(v4)

				if v4 then
					GuiService.CoreGuiNavigationEnabled = true
				else
					GuiService.CoreGuiNavigationEnabled = v3._devSetCoreGuiNavEnabled
				end
			end

			v3._selectedCoreObject:connect(fn)
			v3._chromeFocused:connect(fn)
			v3._tiltMenuOpen:connect(fn)
			GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(fn)
			v3._gamepadActive:connect(fn, true)
		end
	end

	if FFlagEnableConsoleExpControls then
		GuiService:GetPropertyChangedSignal("CoreGuiNavigationEnabled"):Connect(function()
			v3._devSetCoreGuiNavEnabled = GuiService.CoreGuiNavigationEnabled
		end)
	end

	function v3._isTopBarFocused()
		return not GamepadService.GamepadCursorEnabled and (v3._chromeFocused:get() or MenuIconSelectedSignal:get())
	end

	if FFlagAddTopBarScrim then
		local topBarFocused = v3._isTopBarFocused()
		local signal, setTopBarFocused = Signals.createSignal(topBarFocused)
		v3._topBarFocused = signal
		v3._setTopBarFocused = setTopBarFocused
	end

	return (setmetatable(v3, GamepadConnector))
end

function GamepadConnector:connectToTopbar()
	if enabled then
		if FFlagEnableConsoleExpControls then
			self:disconnectFromTopbar()
		end

		ContextActionService:BindCoreAction(
			"FocusGamepadToTopbar",
			self:_bindSelf(self._toggleTopbar),
			false,
			Enum.KeyCode.ButtonStart
		)

		if engineFeature then
			ContextActionService:BindCoreAction(
				"ToggleUISelector",
				self:_bindSelf(self._toggleUiSelector),
				false,
				Enum.KeyCode.ButtonB
			)
		end

		local function fn()
			local topBarFocused = self:_isTopBarFocused()
			GuiService:SetMenuIsOpen(topBarFocused, "TopbarMenu")

			if FFlagAddTopBarScrim then
				self._setTopBarFocused(topBarFocused)
			end

			if not topBarFocused then
				self:_removeDismissFocusConnections()

				return
			end

			Service:setShortcutBar(Constants.UNIBAR_SHORTCUTBAR_ID)
			self:_addDismissFocusConnections()
		end
		table.insert(self._connections, self._chromeFocused:connect(fn))
		table.insert(self._connections, MenuIconSelectedSignal:connect(fn))
	end
end

function GamepadConnector:disconnectFromTopbar()
	for _, connection in self._connections do
		connection:disconnect()
	end

	self._connections = {}
	self:_removeDismissFocusConnections()

	ContextActionService:UnbindCoreAction("FocusGamepadToTopbar")

	if engineFeature then
		ContextActionService:UnbindCoreAction("ToggleUISelector")
	end
end

function GamepadConnector:getSelectedCoreObject()
	return self._selectedCoreObject
end

function GamepadConnector:getShowTopBar()
	return self._showTopBar
end

function GamepadConnector:getGamepadActive()
	return self._gamepadActive
end

function GamepadConnector:topBarFocused(p)
	if FFlagAddTopBarScrim then
		return self._topBarFocused(p)
	end
end

function GamepadConnector:_addDismissFocusConnections()
	self._dismissFocusConnections = { (UserInputService.InputEnded:Connect(function(input, gameProcessed: boolean)
			local lastInputType = inputModeStore.getLastInputType(false)
			local v3

			if lastInputType == Responsive.Input.Pointer then
				v3 = input.UserInputType ~= Enum.UserInputType.Keyboard
			else
				v3 = false
			end

			local v4 = lastInputType == Responsive.Input.Touch

			if v3 or v4 and not gameProcessed then
				self:_unfocusGamepadFromTopBar()
			end
		end)) }
end

function GamepadConnector:_removeDismissFocusConnections()
	for _, dismissFocusConnection in self._dismissFocusConnections do
		dismissFocusConnection:Disconnect()
	end

	self._dismissFocusConnections = {}
end

function GamepadConnector:_toggleTopbar(p, p2, p3)
	if
		not enabled
		or self:_focusToastNotification(p2)
		or (FFlagEnableConsoleExpControls or p2 ~= Enum.UserInputState.End)
		and (not FFlagEnableConsoleExpControls or p2 ~= Enum.UserInputState.Begin)
	then
		return Enum.ContextActionResult.Pass
	end

	if
		not engineFeature
		and FFlagEnableUISelector
		and not UserInputService:GamepadSupports(UserInputService:GetLastInputType(), Enum.KeyCode.ButtonSelect)
	then
		return self:_toggleUiSelector(p, p2, p3)
	end

	if FFlagEnableConsoleExpControls then
		if
			Service:integrations().nine_dot == nil
			or isSideSheetEnabled and FFlagSideSheetFocusNav and getSideSheetVisibility()
		then
			return Enum.ContextActionResult.Pass
		end

		local v3 = not (self:_isTopBarFocused() or focusNavigationStore.getChatInputBarFocused(false))

		if v3 then
			self:_focusGamepadToTopBar()
		else
			self:_unfocusGamepadFromTopBar()
		end

		self:_logExperienceMenuGamepadExposure()
		LogGamepadOpenExperienceControlsMenu(v3)
	else
		self:_toggleUnibarMenu()
	end

	if FFlagAddNewPlayerListMobileFocusNav and PlayerListManager:GetIsModal() and PlayerListManager:GetVisibility() then
		PlayerListManager:SetVisibility(false)
	end

	return Enum.ContextActionResult.Sink
end

function GamepadConnector:_toggleUiSelector(_, p, _)
	if
		not FFlagEnableUISelector
		or not enabled
		or self:_focusToastNotification(p)
		or (FFlagEnableConsoleExpControls or p ~= Enum.UserInputState.End)
		and (not FFlagEnableConsoleExpControls or p ~= Enum.UserInputState.Begin)
		or UserInputService:GamepadSupports(UserInputService:GetLastInputType(), Enum.KeyCode.ButtonSelect)
	then
		return Enum.ContextActionResult.Pass
	end

	if GamepadService.GamepadCursorEnabled or GuiService.SelectedObject ~= nil then
		GamepadService:DisableGamepadCursor()
		GuiService.SelectedObject = nil
		return Enum.ContextActionResult.Sink
	else
		local uiSelectorSignalStore = getUiSelectorSignalStore(false)

		if uiSelectorSignalStore.getVisibility(false) then
			uiSelectorSignalStore.setVisibility(false)
			return Enum.ContextActionResult.Sink
		end

		if not self:_isTopBarFocused() then
			uiSelectorSignalStore.setVisibility(true)
			return Enum.ContextActionResult.Sink
		end
	end

	return Enum.ContextActionResult.Pass
end

function GamepadConnector:_toggleUnibarMenu()
	local v3 = self._chromeFocused:get()

	if v3 then
		if FFlagEnableConsoleExpControls then
			self:_unfocusGamepadFromTopBar()
		else
			Service:disableFocusNav()
		end
	elseif FFlagEnableConsoleExpControls then
		self:_focusGamepadToTopBar()
	else
		Service:enableFocusNav()
	end

	self:_logExperienceMenuGamepadExposure()
	LogGamepadOpenExperienceControlsMenu(v3)
end

function GamepadConnector:_focusGamepadToTopBar()
	FocusUtils.FocusOnChrome()
end

function GamepadConnector:_unfocusGamepadFromTopBar()
	FocusUtils.FocusOffChrome(function()
		if FFlagConsoleChatUseChromeFocusUtils and focusNavigationStore.getChatInputBarFocused(false) then
			focusNavigationStore.unfocusChatInputBar()
		end

		GuiService.SelectedCoreObject = nil
	end)
end

function GamepadConnector:_focusToastNotification(p)
	local function buttonHoldTime() -- 1 equivalent call inferred from this helper
		return tick() - self._lastMenuButtonPress
	end

	local v3 = not (v2 == nil) and v2.Visible

	if p == Enum.UserInputState.Begin then
		self._lastMenuButtonPress = tick()
		return false
	end

	return p == Enum.UserInputState.End and v3 and buttonHoldTime() < ToastNotificationConstants.MenuButtonPressHoldTime -- inferred equivalent call
end

function GamepadConnector:_logExperienceMenuGamepadExposure()
	if FFlagExperienceMenuGamepadExposureEnabled and not self._loggedExperienceMenuGamepadExposure then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.ExperienceMenuGamepadExposureLayer)
		self._loggedExperienceMenuGamepadExposure = true
	end
end

function GamepadConnector:_bindSelf(callback)
	return function(...)
		return callback(self, ...)
	end
end

if FFlagEnableConsoleExpControls then
	return (GamepadConnector.new())
end

return GamepadConnector
