local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local ExperimentLayers = require(CorePackages.Workspace.Packages.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)

local withStyle = UIBlox.Core.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local MenuHeader = require(script.MenuHeader)
local ChatIcon = require(script.ChatIcon)
local MenuCell = require(script.MenuCell)
local QuickMenuControllerBar = require(script.QuickMenuControllerBar)
local MenuNavigationToggleDialog = require(script.MenuNavigationToggleDialog)

local modules = CoreGui:WaitForChild("RobloxGui").Modules
local topBar = modules.TopBar
local TenFootInterface = require(modules.TenFootInterface)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableNewBackpack = SharedFlags.FFlagEnableNewBackpack
local features

if FFlagEnableNewBackpack then
	local System = require(CorePackages.Workspace.Packages.System)
	features = System.Features
else
	features = nil
end

local BackpackScript

if FFlagEnableNewBackpack then
	BackpackScript = nil
else
	BackpackScript = require(modules.BackpackScript)
end

local EmotesMenuMaster = require(modules.EmotesMenu.EmotesMenuMaster)
local ChatSelector = require(modules.ChatSelector)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local PlayerListManager = require(modules.PlayerList.PlayerListManager)

local isNewInGameMenuEnabled = require(modules.isNewInGameMenuEnabled)
local InGameMenuConstants = require(modules.InGameMenuConstants)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome.Enabled

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize

local Telemetry = require(topBar:WaitForChild("Telemetry"))
local LogGamepadOpenExperienceControlsMenu = Telemetry.LogGamepadOpenExperienceControlsMenu
local default = Telemetry.GamepadMenuTelemetry.default
local gameSettings = UserSettings().GameSettings
local Actions = script.Parent.Parent.Parent.Actions
local SetGamepadMenuOpen = require(Actions.SetGamepadMenuOpen)
local EnumGamepadMenuOptions = require(script.EnumGamepadMenuOptions)

local iconslogoblock = Images["icons/logo/block"]
local iconsmenuAR = Images["icons/menu/AR"]

local iconsactionsrespawn = Images["icons/actions/respawn"]
local iconsnavigationclose = Images["icons/navigation/close"]

local component_assetscircle_17 = Images["component_assets/circle_17"]
local rect = Rect.new(8, 8, 9, 9)

local extended = Roact.PureComponent:extend("GamepadMenu")
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAddMenuNavigationToggleDialog = SharedFlags2.FFlagAddMenuNavigationToggleDialog
local FFlagEnableConsoleExpControls = SharedFlags2.FFlagEnableConsoleExpControls
local FFlagExperienceMenuGamepadExposureEnabled = SharedFlags2.FFlagExperienceMenuGamepadExposureEnabled
local FFlagMountCoreGuiBackpack = require(modules.Flags.FFlagMountCoreGuiBackpack)
local FFlagPlayerListUseFocusNavHook = PlayerList.Flags.FFlagPlayerListUseFocusNavHook

local getFFlagExpChatAlwaysRunTCS = SharedFlags2.getFFlagExpChatAlwaysRunTCS

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

local strictInterface = t.strictInterface
local screenSize2

if not FFlagTopBarSignalizeScreenSize then
	screenSize2 = t.Vector2
end

local v3 = {
	screenSize = screenSize2,
	chatVersion = t.optional(t.EnumItem),
	chatEnabled = t.boolean,
	leaderboardEnabled = t.boolean,
	emotesEnabled = t.boolean,
	backpackEnabled = 0,
	respawnEnabled = 0,
	leaderboardOpen = 0,
	backpackOpen = 0,
	emotesOpen = 0,
	menuOpen = 0,
	topBarEnabled = 0,
	setGamepadMenuOpen = 0,
	isGamepadMenuOpen = 0
}
local backpackEnabled

if not FFlagMountCoreGuiBackpack then
	backpackEnabled = t.boolean
end

v3.backpackEnabled = backpackEnabled

v3.respawnEnabled = t.boolean

v3.leaderboardOpen = t.boolean
v3.backpackOpen = t.boolean
v3.emotesOpen = t.boolean

v3.menuOpen = t.boolean
local topBarEnabled

if FFlagMountCoreGuiBackpack then
	topBarEnabled = t.boolean
end

v3.topBarEnabled = topBarEnabled

v3.setGamepadMenuOpen = t.callback
v3.isGamepadMenuOpen = t.boolean
extended.validateProps = strictInterface(v3)

function extended:init()
	if FFlagMountCoreGuiBackpack then
		self:setState({
			selectedIndex = 1,
			menuActions = {},
			mountBackpack = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
		})

		StarterGui.CoreGuiChangedSignal:Connect(function(p, mountBackpack: boolean)
			if p == Enum.CoreGuiType.Backpack or p == Enum.CoreGuiType.All then
				self:setState({ mountBackpack = mountBackpack })
			end
		end)
	else
		self:setState({ selectedIndex = 1, menuActions = {} })
	end

	if FFlagExperienceMenuGamepadExposureEnabled then
		self.loggedExperienceMenuGamepadExposure = false
	end

	self.boundMenuOpenActions = false

	self.lastMenuButtonPress = 0

	function self.toggleChatVisibilityAction(_, p, _)
		if p == Enum.UserInputState.Begin then
			self.toggleChatVisible()
			default.onOptionSelected({
				menuOptionName = EnumGamepadMenuOptions.Chat,
				usedShortcut = true,
				isToggleOpen = ChatSelector:GetVisibility()
			})
		end
	end

	function self.toggleMenuVisibleAction(_, p, _)
		if self.props.menuOpen then
			return Enum.ContextActionResult.Pass
		end

		local v4 = not (v2 == nil) and v2.Visible

		if p == Enum.UserInputState.Begin then
			self.lastMenuButtonPress = tick()
			return Enum.ContextActionResult.Pass
		end

		if p ~= Enum.UserInputState.End or v4 and not (tick() - self.lastMenuButtonPress < 1) then
			return Enum.ContextActionResult.Pass
		end

		local v5 = not self.props.isGamepadMenuOpen

		if
			FFlagPlayerListUseFocusNavHook
			and v5
			and PlayerListManager:GetIsModal()
			and PlayerListManager:GetVisibility()
		then
			PlayerListManager:SetVisibility(false)
		end

		self.props.setGamepadMenuOpen(v5)
		LogGamepadOpenExperienceControlsMenu(v5)
		self:logExperienceMenuGamepadExposure()

		return Enum.ContextActionResult.Sink
	end

	function self.closeMenuAction(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		self.props.setGamepadMenuOpen(false)

		return Enum.ContextActionResult.Sink
	end

	function self.leaveGameMenuAction(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		extended.leaveGame()

		self.props.setGamepadMenuOpen(false)
		default.onOptionSelected({
			menuOptionName = EnumGamepadMenuOptions.Leave,
			usedShortcut = true,
			isToggleOpen = true
		})

		return Enum.ContextActionResult.Sink
	end

	function self.respawnMenuAction(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		extended.respawnCharacter()

		self.props.setGamepadMenuOpen(false)
		default.onOptionSelected({
			menuOptionName = EnumGamepadMenuOptions.Respawn,
			usedShortcut = true,
			isToggleOpen = true
		})

		return Enum.ContextActionResult.Sink
	end

	self.lastThumbStickMove = 0

	function self.moveSelectionAction(_, p, p2)
		if p == Enum.UserInputState.Begin then
			if p2.KeyCode == Enum.KeyCode.DPadUp then
				if self.state.selectedIndex > 1 then
					self:setState({
						selectedIndex = self.state.selectedIndex - 1
					})
				end

				return Enum.ContextActionResult.Sink
			elseif p2.KeyCode == Enum.KeyCode.DPadDown then
				if self.state.selectedIndex < #self.state.menuActions then
					self:setState({
						selectedIndex = self.state.selectedIndex + 1
					})
				end

				return Enum.ContextActionResult.Sink
			end
		elseif p2.KeyCode == Enum.KeyCode.Thumbstick1 then
			if tick() - self.lastThumbStickMove < 0.15 then
				return Enum.ContextActionResult.Pass
			end

			if p2.Position.Y > 0.8 then
				if self.state.selectedIndex > 1 then
					self:setState({
						selectedIndex = self.state.selectedIndex - 1
					})

					self.lastThumbStickMove = tick()
				end

				return Enum.ContextActionResult.Pass
			elseif p2.Position.Y < -0.8 then
				if self.state.selectedIndex < #self.state.menuActions then
					self:setState({
						selectedIndex = self.state.selectedIndex + 1
					})

					self.lastThumbStickMove = tick()
				end

				return Enum.ContextActionResult.Sink
			end
		end

		return Enum.ContextActionResult.Pass
	end

	function self.goToTopAction(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		self:setState({ selectedIndex = 1 })
	end

	function self.goToBottomAction(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		self:setState({
			selectedIndex = #self.state.menuActions
		})
	end

	function self.activateSelectionAction(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		local menuAction = self.state.menuActions[self.state.selectedIndex]
		self.props.setGamepadMenuOpen(false)

		GuiService:SetMenuIsOpen(false, "GamepadMenu")

		menuAction.onActivated()
		local function isMenuOptionToggleOpenOnSelect(name) -- 1 equivalent call inferred from this helper
			if name == EnumGamepadMenuOptions.Leaderboard then
				return PlayerListManager:GetSetVisible()
			end

			return true
		end

		default.onOptionSelected({
			menuOptionName = menuAction.name,
			usedShortcut = false,
			isToggleOpen = isMenuOptionToggleOpenOnSelect(menuAction.name) -- inferred equivalent call
		})

		return Enum.ContextActionResult.Sink
	end

	function self.overlayDismiss()
		self.props.setGamepadMenuOpen(false)
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize

		self.disposeScreenSize = Signals.createEffect(function(p)
			self:setState({ screenSize = getViewportSize(p) })
		end)
	end
end

function extended.openRootMenu()
	if isNewInGameMenuEnabled() then
		local InGameMenuInit = require(modules.InGameMenuInit)
		InGameMenuInit.openInGameMenu(InGameMenuConstants.MainPagePageKey)
	else
		local SettingsHub = require(modules.Settings.SettingsHub)
		SettingsHub:SetVisibility(true, nil, nil, true, InGameMenuConstants.AnalyticsMenuOpenTypes.PlayersTriggered)
	end
end

function extended.openUnibarMenu()
	local Service = require(modules.Chrome.Service)
	Service:enableFocusNav()
end

function extended.closeUnibarMenu()
	local Service = require(modules.Chrome.Service)
	Service:disableFocusNav()
end

function extended.toggleChatVisible()
	ChatSelector:ToggleVisibility()
	gameSettings.ChatVisible = ChatSelector:GetVisibility()
end

function extended.focusChatBar()
	ChatSelector:SetVisible(true)
	gameSettings.ChatVisible = true
	ChatSelector:FocusChatBar()
end

function extended.toggleLeaderboard()
	if not isNewInGameMenuEnabled() then
		PlayerListManager:SetVisibility(not PlayerListManager:GetSetVisible())

		return
	end

	local InGameMenuInit = require(modules.InGameMenuInit)
	InGameMenuInit.openPlayersPage()
end

function extended.toggleEmotesMenu()
	if EmotesMenuMaster:isOpen() then
		EmotesMenuMaster:close()
	else
		EmotesMenuMaster:open()
	end
end

function extended.toggleBackpack()
	if FFlagEnableNewBackpack then
		features.toggleVisibility(features.FeatureName.Backpack)
	else
		BackpackScript:OpenClose()
	end
end

function extended.leaveGame()
	if isNewInGameMenuEnabled() then
		local InGameMenuInit = require(modules.InGameMenuInit)
		InGameMenuInit.openGameLeavePage()
	else
		local SettingsHub = require(modules.Settings.SettingsHub)
		SettingsHub:SetVisibility(
			true,
			false,
			SettingsHub.Instance.LeaveGamePage,
			true,
			InGameMenuConstants.AnalyticsMenuOpenTypes.GamepadLeaveGame
		)
	end
end

function extended.respawnCharacter()
	if isNewInGameMenuEnabled() then
		local InGameMenuInit = require(modules.InGameMenuInit)
		InGameMenuInit.openCharacterResetPage()
	else
		local SettingsHub = require(modules.Settings.SettingsHub)
		SettingsHub:SetVisibility(
			true,
			false,
			SettingsHub.Instance.ResetCharacterPage,
			true,
			InGameMenuConstants.AnalyticsMenuOpenTypes.GamepadResetCharacter
		)
	end
end

function extended.shouldShowChatMenuOption(p, p2)
	if not TenFootInterface:IsEnabled() then
		return p2
	end

	local v4 = p or TextChatService.ChatVersion

	if getFFlagExpChatAlwaysRunTCS() then
		return p2
	end

	return p2 and v4 == Enum.ChatVersion.TextChatService
end

function extended.getMenuActionsFromProps(data, p)
	local localizationEntries = {}

	table.insert(localizationEntries, {
		name = EnumGamepadMenuOptions.Menu,
		icon = iconslogoblock,
		iconComponent = nil,
		localizationKey = "CoreScripts.TopBar.Menu",
		onActivated = extended.openRootMenu
	})

	if extended.shouldShowChatMenuOption(data.chatVersion, data.chatEnabled) then
		table.insert(localizationEntries, {
			name = EnumGamepadMenuOptions.Chat,
			icon = nil,
			iconComponent = ChatIcon,
			localizationKey = "CoreScripts.TopBar.Chat",
			onActivated = extended.focusChatBar
		})
	end

	if Enabled() then
		table.insert(localizationEntries, {
			name = EnumGamepadMenuOptions.Unibar,
			icon = iconsmenuAR,
			iconComponent = nil,
			localizationKey = "CoreScripts.TopBar.Title.ExperienceControls",
			onActivated = extended.openUnibarMenu
		})
	end

	if data.leaderboardEnabled or TenFootInterface:IsEnabled() then
		local icon = data.leaderboardOpen and "rbxasset://textures/ui/TopBar/leaderboardOn.png"
			or "rbxasset://textures/ui/TopBar/leaderboardOff.png"

		table.insert(localizationEntries, {
			name = EnumGamepadMenuOptions.Leaderboard,
			icon = icon,
			iconComponent = nil,
			localizationKey = "CoreScripts.TopBar.Leaderboard",
			onActivated = extended.toggleLeaderboard
		})
	end

	if data.emotesEnabled then
		local icon = data.emotesOpen and "rbxasset://textures/ui/TopBar/emotesOn.png"
			or "rbxasset://textures/ui/TopBar/emotesOff.png"

		table.insert(localizationEntries, {
			name = EnumGamepadMenuOptions.Emotes,
			icon = icon,
			iconComponent = nil,
			localizationKey = "CoreScripts.TopBar.Emotes",
			onActivated = extended.toggleEmotesMenu
		})
	end

	local v4

	if FFlagMountCoreGuiBackpack then
		v4 = data.topBarEnabled and p.mountBackpack
	else
		v4 = data.backpackEnabled
	end

	if v4 then
		local icon = data.backpackOpen and "rbxasset://textures/ui/TopBar/inventoryOn.png"
			or "rbxasset://textures/ui/TopBar/inventoryOff.png"

		table.insert(localizationEntries, {
			name = EnumGamepadMenuOptions.Inventory,
			icon = icon,
			iconComponent = nil,
			localizationKey = "CoreScripts.TopBar.Inventory",
			onActivated = extended.toggleBackpack
		})
	end

	if data.respawnEnabled then
		table.insert(localizationEntries, {
			name = EnumGamepadMenuOptions.Respawn,
			icon = iconsactionsrespawn,
			iconComponent = nil,
			localizationKey = "CoreScripts.TopBar.Respawn",
			onActivated = extended.respawnCharacter
		})
	end

	table.insert(localizationEntries, {
		name = EnumGamepadMenuOptions.Leave,
		icon = iconsnavigationclose,
		iconComponent = nil,
		localizationKey = "CoreScripts.TopBar.Leave",
		onActivated = extended.leaveGame
	})

	return localizationEntries
end

function extended.getDerivedStateFromProps(p, p2)
	local menuActions

	if FFlagMountCoreGuiBackpack then
		menuActions = extended.getMenuActionsFromProps(p, p2)
	else
		menuActions = extended.getMenuActionsFromProps(p)
	end

	local selectedIndex = p2.selectedIndex or 1
	local selectedIndex2 = #menuActions < selectedIndex and #menuActions or selectedIndex

	return Cryo.Dictionary.join(p2, { selectedIndex = selectedIndex2, menuActions = menuActions })
end

function extended.render(data)
	return withStyle(function(p)
		local theme = p.Theme

		local children = {}

		children.Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		children.MenuHeader = Roact.createElement(MenuHeader, { layoutOrder = 1, height = 120 })

		for i, menuAction in ipairs(data.state.menuActions) do
			children[menuAction.name] = Roact.createElement(MenuCell, {
				layoutOrder = i + 1,
				icon = menuAction.icon,
				iconComponent = menuAction.iconComponent,
				localizationKey = menuAction.localizationKey,
				height = 56,
				hasDivider = i ~= #data.state.menuActions,
				isSelected = i == data.state.selectedIndex
			})
		end

		local v4 = #data.state.menuActions * 56 + 120

		local scale = 1
		local screenSize

		if FFlagTopBarSignalizeScreenSize then
			screenSize = data.state.screenSize
		else
			screenSize = data.props.screenSize
		end

		if screenSize.Y * 0.75 < v4 then
			scale = screenSize.Y * 0.75 / v4
		end

		if screenSize.X * 0.75 < 336 then
			local v5 = screenSize.X * 0.75 / 336

			if v5 < scale then
				scale = v5
			end
		end

		if scale < 1 then
			children.UIScale = Roact.createElement("UIScale", { Scale = scale })
		end

		local isGamepadMenuOpen = data.props.isGamepadMenuOpen
		local controllerBar

		if isGamepadMenuOpen then
			controllerBar = Roact.createElement(QuickMenuControllerBar, {
				chatMenuEnabled = data.shouldShowChatMenuOption(data.props.chatVersion, data.props.chatEnabled)
			})
		end

		local v5 = {
			Menu = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = component_assetscircle_17,
				SliceCenter = rect,
				ScaleType = Enum.ScaleType.Slice,
				ImageTransparency = theme.BackgroundUIContrast.Transparency,
				ImageColor3 = theme.BackgroundUIContrast.Color,
				Size = UDim2.fromOffset(336, v4),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			}, children),
			ControllerBar = controllerBar,
			MenuNavigationToggleDialog = 0
		}
		local menuNavigationToggleDialog

		if not (Enabled() or FFlagEnableConsoleExpControls or not FFlagAddMenuNavigationToggleDialog) then
			menuNavigationToggleDialog = Roact.createElement(MenuNavigationToggleDialog, {
				Position = UDim2.fromScale(0.5, 0.1)
			})
		end

		v5.MenuNavigationToggleDialog = menuNavigationToggleDialog

		return Roact.createElement("TextButton", {
			Visible = isGamepadMenuOpen,
			Text = "",
			BackgroundTransparency = theme.Overlay.Transparency,
			BackgroundColor3 = theme.Overlay.Color,
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			ZIndex = 10,
			[Roact.Event.Activated] = data.overlayDismiss
		}, v5)
	end)
end

function extended.didMount(p)
	if not VRService.VREnabled then
		ContextActionService:BindCoreAction(
			"TopBarGamepadToggleGamepadMenu",
			p.toggleMenuVisibleAction,
			false,
			Enum.KeyCode.ButtonStart
		)
	end
end

function extended:bindMenuOpenActions()
	self.boundMenuOpenActions = true

	ContextActionService:BindCoreAction(
		"TopBarGamepadFreezeController",
		function() end,
		false,
		Enum.UserInputType.Gamepad1
	)

	ContextActionService:BindCoreAction("TopBarGamepadCloseMenu", self.closeMenuAction, false, Enum.KeyCode.ButtonB)
	ContextActionService:BindCoreAction("TopBarGamepadLeaveGame", self.leaveGameMenuAction, false, Enum.KeyCode.ButtonX)
	ContextActionService:BindCoreAction(
		"TopBarGamepadRespawnAction",
		self.respawnMenuAction,
		false,
		Enum.KeyCode.ButtonY
	)
	ContextActionService:BindCoreAction(
		"TopBarGamepadActivateSelection",
		self.activateSelectionAction,
		false,
		Enum.KeyCode.ButtonA
	)

	ContextActionService:BindCoreAction(
		"TopBarGamepadMoveSelection",
		self.moveSelectionAction,
		false,
		Enum.KeyCode.Thumbstick1,
		Enum.KeyCode.DPadUp,
		Enum.KeyCode.DPadDown
	)

	ContextActionService:BindCoreAction(
		"TopBarGamepadMoveSelectionTop",
		self.goToTopAction,
		false,
		Enum.KeyCode.ButtonL2
	)
	ContextActionService:BindCoreAction(
		"TopBarGamepadMoveSelectionBottom",
		self.goToBottomAction,
		false,
		Enum.KeyCode.ButtonR2
	)

	ContextActionService:BindCoreAction(
		"TopBarGamepadToggleChatVisibility",
		self.toggleChatVisibilityAction,
		false,
		Enum.KeyCode.ButtonR1
	)

	ContextActionService:BindCoreAction(
		"TopBarGamepadToggleGamepadMenu",
		self.toggleMenuVisibleAction,
		false,
		Enum.KeyCode.ButtonStart
	)
end

function extended:unbindMenuOpenActions()
	self.boundMenuOpenActions = false

	ContextActionService:UnbindCoreAction("TopBarGamepadFreezeController")
	ContextActionService:UnbindCoreAction("TopBarGamepadCloseMenu")
	ContextActionService:UnbindCoreAction("TopBarGamepadActivateSelection")
	ContextActionService:UnbindCoreAction("TopBarGamepadLeaveGame")
	ContextActionService:UnbindCoreAction("TopBarGamepadRespawnAction")
	ContextActionService:UnbindCoreAction("TopBarGamepadMoveSelection")
	ContextActionService:UnbindCoreAction("TopBarGamepadMoveSelectionTop")
	ContextActionService:UnbindCoreAction("TopBarGamepadMoveSelectionBottom")
	ContextActionService:UnbindCoreAction("TopBarGamepadToggleChatVisibility")
end

function extended:unbindAllActions()
	if self.boundMenuOpenActions then
		self:unbindMenuOpenActions()
	end

	ContextActionService:UnbindCoreAction("TopBarGamepadToggleGamepadMenu")
end

function extended:didUpdate(p, _)
	local v4 = p.isGamepadMenuOpen ~= self.props.isGamepadMenuOpen
	local isGamepadMenuOpen = self.props.isGamepadMenuOpen

	if v4 then
		if isGamepadMenuOpen then
			self:bindMenuOpenActions()

			if self.state.selectedIndex ~= 1 then
				self:setState({ selectedIndex = 1 })
			end

			self.savedSelectedCoreObject = GuiService.SelectedCoreObject
			GuiService.SelectedCoreObject = nil
			self.savedSelectedObject = GuiService.SelectedObject
			GuiService.SelectedObject = nil

			GuiService:SetMenuIsOpen(true, "GamepadMenu")

			if Enabled() then
				extended.closeUnibarMenu()
			end
		else
			self:unbindMenuOpenActions()

			GuiService:SetMenuIsOpen(false, "GamepadMenu")
		end
	end
end

function extended:willUnmount()
	self:unbindAllActions()

	if FFlagTopBarSignalizeScreenSize then
		self.disposeScreenSize()
	end
end

function extended:logExperienceMenuGamepadExposure()
	if FFlagExperienceMenuGamepadExposureEnabled and not self.loggedExperienceMenuGamepadExposure then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.ExperienceMenuGamepadExposureLayer)
		self.loggedExperienceMenuGamepadExposure = true
	end
end

local function mapStateToProps(data)
	local topbarEnabled = data.displayOptions.topbarEnabled
	local screenSize

	if not FFlagTopBarSignalizeScreenSize then
		screenSize = data.displayOptions.screenSize
	end

	local v4 = {
		screenSize = screenSize,
		chatEnabled = data.coreGuiEnabled[Enum.CoreGuiType.Chat] and topbarEnabled and not VRService.VREnabled,
		leaderboardEnabled = data.coreGuiEnabled[Enum.CoreGuiType.PlayerList] and topbarEnabled,
		emotesEnabled = data.moreMenu.emotesEnabled and data.coreGuiEnabled[Enum.CoreGuiType.EmotesMenu] and topbarEnabled,
		backpackEnabled = 0,
		respawnEnabled = 0,
		topBarEnabled = 0,
		leaderboardOpen = 0,
		backpackOpen = 0,
		emotesOpen = 0,
		menuOpen = 0,
		isGamepadMenuOpen = 0
	}
	local backpackEnabled2

	if not FFlagMountCoreGuiBackpack then
		backpackEnabled2 = data.coreGuiEnabled[Enum.CoreGuiType.Backpack] and topbarEnabled
	end

	v4.backpackEnabled = backpackEnabled2

	v4.respawnEnabled = data.respawn.enabled

	if not FFlagMountCoreGuiBackpack then
		topbarEnabled = nil
	end

	v4.topBarEnabled = topbarEnabled
	v4.leaderboardOpen = data.moreMenu.leaderboardOpen
	v4.backpackOpen = data.moreMenu.backpackOpen
	v4.emotesOpen = data.moreMenu.emotesOpen

	v4.menuOpen = data.displayOptions.menuOpen

	v4.isGamepadMenuOpen = data.displayOptions.isGamepadMenuOpen
	return v4
end

local function mapDispatchToProps(callback)
	return {
		setGamepadMenuOpen = function(p)
			return callback(SetGamepadMenuOpen(p))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
