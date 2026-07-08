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
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
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
local Modules = CoreGui:WaitForChild("RobloxGui").Modules
local TopBar = Modules.TopBar
local TenFootInterface = require(Modules.TenFootInterface)
local FFlagEnableNewBackpack = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNewBackpack
local v29 = if not FFlagEnableNewBackpack then nil else require(CorePackages.Workspace.Packages.System).Features
local v30 = if FFlagEnableNewBackpack then nil else require(Modules.BackpackScript)
local EmotesMenuMaster = require(Modules.EmotesMenu.EmotesMenuMaster)
local ChatSelector = require(Modules.ChatSelector)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local PlayerListManager = require(Modules.PlayerList.PlayerListManager)
local isNewInGameMenuEnabled = require(Modules.isNewInGameMenuEnabled)
local InGameMenuConstants = require(Modules.InGameMenuConstants)
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled
local FFlagTopBarSignalizeScreenSize = require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeScreenSize
local Telemetry = require(TopBar:WaitForChild("Telemetry"))
local LogGamepadOpenExperienceControlsMenu = Telemetry.LogGamepadOpenExperienceControlsMenu
local default = Telemetry.GamepadMenuTelemetry.default
local GameSettings = UserSettings().GameSettings
local Actions = script.Parent.Parent.Parent.Actions
local SetGamepadMenuOpen = require(Actions.SetGamepadMenuOpen)
local EnumGamepadMenuOptions = require(script.EnumGamepadMenuOptions)
local v46 = Images["icons/logo/block"]
local v47 = Images["icons/menu/AR"]
local v48 = Images["icons/actions/respawn"]
local v49 = Images["icons/navigation/close"]
local v50 = Images["component_assets/circle_17"]
local rect = Rect.new(8, 8, 9, 9)
local v52 = Roact.PureComponent:extend("GamepadMenu")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAddMenuNavigationToggleDialog = SharedFlags.FFlagAddMenuNavigationToggleDialog
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagExperienceMenuGamepadExposureEnabled = SharedFlags.FFlagExperienceMenuGamepadExposureEnabled
local FFlagMountCoreGuiBackpack = require(Modules.Flags.FFlagMountCoreGuiBackpack)
local FFlagPlayerListUseFocusNavHook = PlayerList.Flags.FFlagPlayerListUseFocusNavHook
local getFFlagExpChatAlwaysRunTCS = SharedFlags.getFFlagExpChatAlwaysRunTCS
local ToastNotification = nil
local u61 = nil
local u62 = nil

task.spawn(function() -- line: 111
	-- upvalues: ToastNotification (ref), CoreGui (copy), u61 (ref), u62 (ref)
	ToastNotification = CoreGui:WaitForChild("ToastNotification", 3)
	u61 = if ToastNotification == nil then nil else ToastNotification:WaitForChild("ToastNotificationWrapper", 3)
	u62 = if u61 == nil then nil else u61:FindFirstChild("Toast", true)
end)
v52.validateProps = t.strictInterface({
	screenSize = if not FFlagTopBarSignalizeScreenSize then t.Vector2 else nil,
	chatVersion = t.optional(t.EnumItem),
	chatEnabled = t.boolean,
	leaderboardEnabled = t.boolean,
	emotesEnabled = t.boolean,
	backpackEnabled = if not FFlagMountCoreGuiBackpack then t.boolean else nil,
	respawnEnabled = t.boolean,
	leaderboardOpen = t.boolean,
	backpackOpen = t.boolean,
	emotesOpen = t.boolean,
	menuOpen = t.boolean,
	topBarEnabled = if not FFlagMountCoreGuiBackpack then nil else t.boolean,
	setGamepadMenuOpen = t.callback,
	isGamepadMenuOpen = t.boolean
})

function v52.init(p1) -- line: 139
	-- upvalues: FFlagMountCoreGuiBackpack (copy), StarterGui (copy), FFlagExperienceMenuGamepadExposureEnabled (copy), default (copy), EnumGamepadMenuOptions (copy), ChatSelector (copy), u62 (ref), FFlagPlayerListUseFocusNavHook (copy), PlayerListManager (copy), LogGamepadOpenExperienceControlsMenu (copy), v52 (copy), GuiService (copy), FFlagTopBarSignalizeScreenSize (copy), Display (copy), Signals (copy)
	if FFlagMountCoreGuiBackpack then
		p1:setState({
			selectedIndex = 1,
			menuActions = {},
			mountBackpack = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
		})
		StarterGui.CoreGuiChangedSignal:Connect(function(p2, b1: boolean) -- line: 147
			-- upvalues: p1 (copy)
			if p2 == Enum.CoreGuiType.Backpack or p2 == Enum.CoreGuiType.All then
				p1:setState({
					mountBackpack = b1
				})
			end
		end)
	else
		p1:setState({
			selectedIndex = 1,
			menuActions = {}
		})
	end

	if FFlagExperienceMenuGamepadExposureEnabled then
		p1.loggedExperienceMenuGamepadExposure = false
	end

	p1.boundMenuOpenActions = false
	p1.lastMenuButtonPress = 0

	function p1.toggleChatVisibilityAction(_, p4, _) -- line: 169
		-- upvalues: p1 (copy), default (copy), EnumGamepadMenuOptions (copy), ChatSelector (copy)
		if p4 == Enum.UserInputState.Begin then
			p1.toggleChatVisible()
			default.onOptionSelected({
				usedShortcut = true,
				menuOptionName = EnumGamepadMenuOptions.Chat,
				isToggleOpen = ChatSelector:GetVisibility()
			})
		end
	end
	function p1.toggleMenuVisibleAction(_, p7, _) -- line: 180
		-- upvalues: p1 (copy), u62 (ref), FFlagPlayerListUseFocusNavHook (copy), PlayerListManager (copy), LogGamepadOpenExperienceControlsMenu (copy)
		if p1.props.menuOpen then
			return Enum.ContextActionResult.Pass
		end

		local v105 = u62 ~= nil and u62.Visible

		if p7 == Enum.UserInputState.Begin then
			p1.lastMenuButtonPress = tick()

			return Enum.ContextActionResult.Pass
		end

		if p7 == Enum.UserInputState.End and (not v105 or tick() - p1.lastMenuButtonPress < 1) then
			local v106 = not p1.props.isGamepadMenuOpen

			if FFlagPlayerListUseFocusNavHook and v106 and PlayerListManager:GetIsModal() and PlayerListManager:GetVisibility() then
				PlayerListManager:SetVisibility(false)
			end

			p1.props.setGamepadMenuOpen(v106)
			LogGamepadOpenExperienceControlsMenu(v106)
			p1:logExperienceMenuGamepadExposure()

			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end
	function p1.closeMenuAction(_, p10, _) -- line: 211
		-- upvalues: p1 (copy)
		if p10 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		p1.props.setGamepadMenuOpen(false)

		return Enum.ContextActionResult.Sink
	end
	function p1.leaveGameMenuAction(_, p13, _) -- line: 221
		-- upvalues: v52 (copy), p1 (copy), default (copy), EnumGamepadMenuOptions (copy)
		if p13 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		v52.leaveGame()
		p1.props.setGamepadMenuOpen(false)
		default.onOptionSelected({
			usedShortcut = true,
			isToggleOpen = true,
			menuOptionName = EnumGamepadMenuOptions.Leave
		})

		return Enum.ContextActionResult.Sink
	end
	function p1.respawnMenuAction(_, p16, _) -- line: 238
		-- upvalues: v52 (copy), p1 (copy), default (copy), EnumGamepadMenuOptions (copy)
		if p16 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		v52.respawnCharacter()
		p1.props.setGamepadMenuOpen(false)
		default.onOptionSelected({
			usedShortcut = true,
			isToggleOpen = true,
			menuOptionName = EnumGamepadMenuOptions.Respawn
		})

		return Enum.ContextActionResult.Sink
	end

	p1.lastThumbStickMove = 0

	function p1.moveSelectionAction(_, p19, p20) -- line: 257
		-- upvalues: p1 (copy)
		if p19 == Enum.UserInputState.Begin then
			if p20.KeyCode == Enum.KeyCode.DPadUp then
				if p1.state.selectedIndex > 1 then
					p1:setState({
						selectedIndex = p1.state.selectedIndex - 1
					})
				end

				return Enum.ContextActionResult.Sink
			end

			if p20.KeyCode == Enum.KeyCode.DPadDown then
				if p1.state.selectedIndex < #p1.state.menuActions then
					p1:setState({
						selectedIndex = p1.state.selectedIndex + 1
					})
				end

				return Enum.ContextActionResult.Sink
			end
		elseif p20.KeyCode == Enum.KeyCode.Thumbstick1 then
			if tick() - p1.lastThumbStickMove < 0.15 then
				return Enum.ContextActionResult.Pass
			end

			if p20.Position.Y > 0.8 then
				if p1.state.selectedIndex > 1 then
					p1:setState({
						selectedIndex = p1.state.selectedIndex - 1
					})
					p1.lastThumbStickMove = tick()
				end

				return Enum.ContextActionResult.Pass
			end

			if p20.Position.Y < -0.8 then
				if p1.state.selectedIndex < #p1.state.menuActions then
					p1:setState({
						selectedIndex = p1.state.selectedIndex + 1
					})
					p1.lastThumbStickMove = tick()
				end

				return Enum.ContextActionResult.Sink
			end
		end

		return Enum.ContextActionResult.Pass
	end
	function p1.goToTopAction(_, p22, _) -- line: 299
		-- upvalues: p1 (copy)
		if p22 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		p1:setState({
			selectedIndex = 1
		})
	end
	function p1.goToBottomAction(_, p25, _) -- line: 309
		-- upvalues: p1 (copy)
		if p25 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		p1:setState({
			selectedIndex = #p1.state.menuActions
		})
	end
	function p1.activateSelectionAction(_, p28, _) -- line: 319
		-- upvalues: p1 (copy), GuiService (copy), EnumGamepadMenuOptions (copy), PlayerListManager (copy), default (copy)
		if p28 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		local v128 = p1.state.menuActions[p1.state.selectedIndex]

		p1.props.setGamepadMenuOpen(false)
		GuiService:SetMenuIsOpen(false, "GamepadMenu")
		v128.onActivated()

		local function isMenuOptionToggleOpenOnSelect(p30) -- line: 333
			-- upvalues: EnumGamepadMenuOptions (copy), PlayerListManager (copy)
			if p30 == EnumGamepadMenuOptions.Leaderboard then
				return PlayerListManager:GetSetVisible()
			end

			return true
		end

		default.onOptionSelected({
			usedShortcut = false,
			menuOptionName = v128.name,
			isToggleOpen = v128.name ~= EnumGamepadMenuOptions.Leaderboard or PlayerListManager:GetSetVisible()
		})

		return Enum.ContextActionResult.Sink
	end
	function p1.overlayDismiss() -- line: 350
		-- upvalues: p1 (copy)
		p1.props.setGamepadMenuOpen(false)
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize

		p1.disposeScreenSize = Signals.createEffect(function(p31) -- line: 357
			-- upvalues: p1 (copy), getViewportSize (copy)
			p1:setState({
				screenSize = getViewportSize(p31)
			})
		end)
	end
end
function v52.openRootMenu() -- line: 365
	-- upvalues: isNewInGameMenuEnabled (copy), Modules (copy), InGameMenuConstants (copy)
	if isNewInGameMenuEnabled() then
		require(Modules.InGameMenuInit).openInGameMenu(InGameMenuConstants.MainPagePageKey)

		return
	end

	require(Modules.Settings.SettingsHub):SetVisibility(true, nil, nil, true, InGameMenuConstants.AnalyticsMenuOpenTypes.PlayersTriggered)
end
function v52.openUnibarMenu() -- line: 376
	-- upvalues: Modules (copy)
	require(Modules.Chrome.Service):enableFocusNav()
end
function v52.closeUnibarMenu() -- line: 381
	-- upvalues: Modules (copy)
	require(Modules.Chrome.Service):disableFocusNav()
end
function v52.toggleChatVisible() -- line: 386
	-- upvalues: ChatSelector (copy), GameSettings (copy)
	ChatSelector:ToggleVisibility()
	GameSettings.ChatVisible = ChatSelector:GetVisibility()
end
function v52.focusChatBar() -- line: 391
	-- upvalues: ChatSelector (copy), GameSettings (copy)
	ChatSelector:SetVisible(true)
	GameSettings.ChatVisible = true
	ChatSelector:FocusChatBar()
end
function v52.toggleLeaderboard() -- line: 397
	-- upvalues: isNewInGameMenuEnabled (copy), Modules (copy), PlayerListManager (copy)
	if isNewInGameMenuEnabled() then
		require(Modules.InGameMenuInit).openPlayersPage()

		return
	end

	PlayerListManager:SetVisibility(not PlayerListManager:GetSetVisible())
end
function v52.toggleEmotesMenu() -- line: 407
	-- upvalues: EmotesMenuMaster (copy)
	if EmotesMenuMaster:isOpen() then
		EmotesMenuMaster:close()

		return
	end

	EmotesMenuMaster:open()
end
function v52.toggleBackpack() -- line: 415
	-- upvalues: FFlagEnableNewBackpack (copy), v29 (copy), v30 (copy)
	if FFlagEnableNewBackpack then
		v29.toggleVisibility(v29.FeatureName.Backpack)

		return
	end

	v30:OpenClose()
end
function v52.leaveGame() -- line: 423
	-- upvalues: isNewInGameMenuEnabled (copy), Modules (copy), InGameMenuConstants (copy)
	if isNewInGameMenuEnabled() then
		require(Modules.InGameMenuInit).openGameLeavePage()

		return
	end

	local SettingsHub = require(Modules.Settings.SettingsHub)

	SettingsHub:SetVisibility(true, false, SettingsHub.Instance.LeaveGamePage, true, InGameMenuConstants.AnalyticsMenuOpenTypes.GamepadLeaveGame)
end
function v52.respawnCharacter() -- line: 440
	-- upvalues: isNewInGameMenuEnabled (copy), Modules (copy), InGameMenuConstants (copy)
	if isNewInGameMenuEnabled() then
		require(Modules.InGameMenuInit).openCharacterResetPage()

		return
	end

	local SettingsHub = require(Modules.Settings.SettingsHub)

	SettingsHub:SetVisibility(true, false, SettingsHub.Instance.ResetCharacterPage, true, InGameMenuConstants.AnalyticsMenuOpenTypes.GamepadResetCharacter)
end
function v52.shouldShowChatMenuOption(p32, p33) -- line: 456
	-- upvalues: TenFootInterface (copy), TextChatService (copy), getFFlagExpChatAlwaysRunTCS (copy)
	if not TenFootInterface:IsEnabled() then
		return p33
	end

	local v71 = p32 or TextChatService.ChatVersion

	if getFFlagExpChatAlwaysRunTCS() then
		return p33
	end

	if p33 then
		p33 = v71 == Enum.ChatVersion.TextChatService
	end

	return p33
end
function v52.getMenuActionsFromProps(p34, p35) -- line: 474
	-- upvalues: EnumGamepadMenuOptions (copy), v46 (copy), v52 (copy), ChatIcon (copy), Enabled (copy), v47 (copy), TenFootInterface (copy), FFlagMountCoreGuiBackpack (copy), v48 (copy), v49 (copy)
	local t1 = {}

	table.insert(t1, {
		iconComponent = nil,
		localizationKey = "CoreScripts.TopBar.Menu",
		name = EnumGamepadMenuOptions.Menu,
		icon = v46,
		onActivated = v52.openRootMenu
	})

	if v52.shouldShowChatMenuOption(p34.chatVersion, p34.chatEnabled) then
		table.insert(t1, {
			icon = nil,
			localizationKey = "CoreScripts.TopBar.Chat",
			name = EnumGamepadMenuOptions.Chat,
			iconComponent = ChatIcon,
			onActivated = v52.focusChatBar
		})
	end

	if Enabled() then
		table.insert(t1, {
			iconComponent = nil,
			localizationKey = "CoreScripts.TopBar.Title.ExperienceControls",
			name = EnumGamepadMenuOptions.Unibar,
			icon = v47,
			onActivated = v52.openUnibarMenu
		})
	end

	if p34.leaderboardEnabled or TenFootInterface:IsEnabled() then
		local v75 = not p34.leaderboardOpen and "rbxasset://textures/ui/TopBar/leaderboardOff.png" or "rbxasset://textures/ui/TopBar/leaderboardOn.png"

		table.insert(t1, {
			iconComponent = nil,
			localizationKey = "CoreScripts.TopBar.Leaderboard",
			name = EnumGamepadMenuOptions.Leaderboard,
			icon = v75,
			onActivated = v52.toggleLeaderboard
		})
	end

	if p34.emotesEnabled then
		local v76 = not p34.emotesOpen and "rbxasset://textures/ui/TopBar/emotesOff.png" or "rbxasset://textures/ui/TopBar/emotesOn.png"

		table.insert(t1, {
			iconComponent = nil,
			localizationKey = "CoreScripts.TopBar.Emotes",
			name = EnumGamepadMenuOptions.Emotes,
			icon = v76,
			onActivated = v52.toggleEmotesMenu
		})
	end

	if if not FFlagMountCoreGuiBackpack then p34.backpackEnabled else p34.topBarEnabled and p35.mountBackpack then
		local v77 = not p34.backpackOpen and "rbxasset://textures/ui/TopBar/inventoryOff.png" or "rbxasset://textures/ui/TopBar/inventoryOn.png"

		table.insert(t1, {
			iconComponent = nil,
			localizationKey = "CoreScripts.TopBar.Inventory",
			name = EnumGamepadMenuOptions.Inventory,
			icon = v77,
			onActivated = v52.toggleBackpack
		})
	end

	if p34.respawnEnabled then
		table.insert(t1, {
			iconComponent = nil,
			localizationKey = "CoreScripts.TopBar.Respawn",
			name = EnumGamepadMenuOptions.Respawn,
			icon = v48,
			onActivated = v52.respawnCharacter
		})
	end

	table.insert(t1, {
		iconComponent = nil,
		localizationKey = "CoreScripts.TopBar.Leave",
		name = EnumGamepadMenuOptions.Leave,
		icon = v49,
		onActivated = v52.leaveGame
	})

	return t1
end
function v52.getDerivedStateFromProps(p36, p37) -- line: 586
	-- upvalues: FFlagMountCoreGuiBackpack (copy), v52 (copy), Cryo (copy)
	local v80 = if not FFlagMountCoreGuiBackpack then v52.getMenuActionsFromProps(p36) else v52.getMenuActionsFromProps(p36, p37)
	local v81 = p37.selectedIndex or 1

	if v81 > #v80 then
		v81 = #v80
	end

	return Cryo.Dictionary.join(p37, {
		selectedIndex = v81,
		menuActions = v80
	})
end
function v52.render(p38) -- line: 605
	-- upvalues: withStyle (copy), Roact (copy), MenuHeader (copy), MenuCell (copy), FFlagTopBarSignalizeScreenSize (copy), QuickMenuControllerBar (copy), ImageSetLabel (copy), v50 (copy), rect (copy), Enabled (copy), FFlagEnableConsoleExpControls (copy), FFlagAddMenuNavigationToggleDialog (copy), MenuNavigationToggleDialog (copy)
	return withStyle(function(p39) -- line: 606
		-- upvalues: Roact (copy), MenuHeader (copy), p38 (copy), MenuCell (copy), FFlagTopBarSignalizeScreenSize (copy), QuickMenuControllerBar (copy), ImageSetLabel (copy), v50 (copy), rect (copy), Enabled (copy), FFlagEnableConsoleExpControls (copy), FFlagAddMenuNavigationToggleDialog (copy), MenuNavigationToggleDialog (copy)
		local Theme = p39.Theme
		local t2 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			MenuHeader = Roact.createElement(MenuHeader, {
				layoutOrder = 1,
				height = 120
			})
		}

		for i, v in ipairs(p38.state.menuActions) do
			t2[v.name] = Roact.createElement(MenuCell, {
				height = 56,
				layoutOrder = i + 1,
				icon = v.icon,
				iconComponent = v.iconComponent,
				localizationKey = v.localizationKey,
				hasDivider = i ~= #p38.state.menuActions,
				isSelected = i == p38.state.selectedIndex
			})
		end

		local v136 = #p38.state.menuActions * 56 + 120
		local n1 = 1
		local v138 = if not FFlagTopBarSignalizeScreenSize then p38.props.screenSize else p38.state.screenSize

		if v136 > v138.Y * 0.75 then
			n1 = v138.Y * 0.75 / v136
		end

		if v138.X * 0.75 < 336 then
			local v139 = v138.X * 0.75 / 336

			if v139 < n1 then
				n1 = v139
			end
		end

		if n1 < 1 then
			t2.UIScale = Roact.createElement("UIScale", {
				Scale = n1
			})
		end

		local isGamepadMenuOpen = p38.props.isGamepadMenuOpen
		local v141 = nil

		if isGamepadMenuOpen then
			v141 = Roact.createElement(QuickMenuControllerBar, {
				chatMenuEnabled = p38.shouldShowChatMenuOption(p38.props.chatVersion, p38.props.chatEnabled)
			})
		end

		local t3 = {
			Menu = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = v50,
				SliceCenter = rect,
				ScaleType = Enum.ScaleType.Slice,
				ImageTransparency = Theme.BackgroundUIContrast.Transparency,
				ImageColor3 = Theme.BackgroundUIContrast.Color,
				Size = UDim2.fromOffset(336, v136),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			}, t2),
			ControllerBar = v141,
			MenuNavigationToggleDialog = if Enabled() or (FFlagEnableConsoleExpControls or not FFlagAddMenuNavigationToggleDialog) then nil else Roact.createElement(MenuNavigationToggleDialog, {
				Position = UDim2.fromScale(0.5, 0.1)
			})
		}

		return Roact.createElement("TextButton", {
			Visible = isGamepadMenuOpen,
			Text = "",
			BackgroundTransparency = Theme.Overlay.Transparency,
			BackgroundColor3 = Theme.Overlay.Color,
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			ZIndex = 10,
			[Roact.Event.Activated] = p38.overlayDismiss
		}, t3)
	end)
end
function v52.didMount(p40) -- line: 703
	-- upvalues: VRService (copy), ContextActionService (copy)
	if not VRService.VREnabled then
		ContextActionService:BindCoreAction("TopBarGamepadToggleGamepadMenu", p40.toggleMenuVisibleAction, false, Enum.KeyCode.ButtonStart)
	end
end
function v52.bindMenuOpenActions(p41) -- line: 714
	-- upvalues: ContextActionService (copy)
	p41.boundMenuOpenActions = true
	ContextActionService:BindCoreAction("TopBarGamepadFreezeController", function() -- line: 719
	end, false, Enum.UserInputType.Gamepad1)
	ContextActionService:BindCoreAction("TopBarGamepadCloseMenu", p41.closeMenuAction, false, Enum.KeyCode.ButtonB)
	ContextActionService:BindCoreAction("TopBarGamepadLeaveGame", p41.leaveGameMenuAction, false, Enum.KeyCode.ButtonX)
	ContextActionService:BindCoreAction("TopBarGamepadRespawnAction", p41.respawnMenuAction, false, Enum.KeyCode.ButtonY)
	ContextActionService:BindCoreAction("TopBarGamepadActivateSelection", p41.activateSelectionAction, false, Enum.KeyCode.ButtonA)
	ContextActionService:BindCoreAction("TopBarGamepadMoveSelection", p41.moveSelectionAction, false, Enum.KeyCode.Thumbstick1, Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown)
	ContextActionService:BindCoreAction("TopBarGamepadMoveSelectionTop", p41.goToTopAction, false, Enum.KeyCode.ButtonL2)
	ContextActionService:BindCoreAction("TopBarGamepadMoveSelectionBottom", p41.goToBottomAction, false, Enum.KeyCode.ButtonR2)
	ContextActionService:BindCoreAction("TopBarGamepadToggleChatVisibility", p41.toggleChatVisibilityAction, false, Enum.KeyCode.ButtonR1)
	ContextActionService:BindCoreAction("TopBarGamepadToggleGamepadMenu", p41.toggleMenuVisibleAction, false, Enum.KeyCode.ButtonStart)
end
function v52.unbindMenuOpenActions(p42) -- line: 759
	-- upvalues: ContextActionService (copy)
	p42.boundMenuOpenActions = false
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
function v52.unbindAllActions(p43) -- line: 773
	-- upvalues: ContextActionService (copy)
	if p43.boundMenuOpenActions then
		p43:unbindMenuOpenActions()
	end

	ContextActionService:UnbindCoreAction("TopBarGamepadToggleGamepadMenu")
end
function v52.didUpdate(p44, p45, _) -- line: 781
	-- upvalues: GuiService (copy), Enabled (copy), v52 (copy)
	local v90 = p45.isGamepadMenuOpen ~= p44.props.isGamepadMenuOpen
	local isGamepadMenuOpen = p44.props.isGamepadMenuOpen

	if v90 then
		if isGamepadMenuOpen then
			p44:bindMenuOpenActions()

			if p44.state.selectedIndex ~= 1 then
				p44:setState({
					selectedIndex = 1
				})
			end

			p44.savedSelectedCoreObject = GuiService.SelectedCoreObject
			GuiService.SelectedCoreObject = nil
			p44.savedSelectedObject = GuiService.SelectedObject
			GuiService.SelectedObject = nil
			GuiService:SetMenuIsOpen(true, "GamepadMenu")

			if Enabled() then
				v52.closeUnibarMenu()

				return
			end
		else
			p44:unbindMenuOpenActions()
			GuiService:SetMenuIsOpen(false, "GamepadMenu")
		end
	end
end
function v52.willUnmount(p47) -- line: 814
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy)
	p47:unbindAllActions()

	if FFlagTopBarSignalizeScreenSize then
		p47.disposeScreenSize()
	end
end
function v52.logExperienceMenuGamepadExposure(p48) -- line: 822
	-- upvalues: FFlagExperienceMenuGamepadExposureEnabled (copy), IXPServiceWrapper (copy), AppUserLayers (copy)
	if FFlagExperienceMenuGamepadExposureEnabled and not p48.loggedExperienceMenuGamepadExposure then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.ExperienceMenuGamepadExposureLayer)
		p48.loggedExperienceMenuGamepadExposure = true
	end
end

local function mapStateToProps(p49) -- line: 829
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy), VRService (copy), FFlagMountCoreGuiBackpack (copy)
	local topbarEnabled = p49.displayOptions.topbarEnabled

	return {
		screenSize = if not FFlagTopBarSignalizeScreenSize then p49.displayOptions.screenSize else nil,
		chatEnabled = p49.coreGuiEnabled[Enum.CoreGuiType.Chat] and (topbarEnabled and not VRService.VREnabled),
		leaderboardEnabled = p49.coreGuiEnabled[Enum.CoreGuiType.PlayerList] and topbarEnabled,
		emotesEnabled = p49.moreMenu.emotesEnabled and (p49.coreGuiEnabled[Enum.CoreGuiType.EmotesMenu] and topbarEnabled),
		backpackEnabled = if not FFlagMountCoreGuiBackpack then p49.coreGuiEnabled[Enum.CoreGuiType.Backpack] and topbarEnabled else nil,
		respawnEnabled = p49.respawn.enabled,
		topBarEnabled = if not FFlagMountCoreGuiBackpack then nil else topbarEnabled,
		leaderboardOpen = p49.moreMenu.leaderboardOpen,
		backpackOpen = p49.moreMenu.backpackOpen,
		emotesOpen = p49.moreMenu.emotesOpen,
		menuOpen = p49.displayOptions.menuOpen,
		isGamepadMenuOpen = p49.displayOptions.isGamepadMenuOpen
	}
end
local function mapDispatchToProps(p50) -- line: 855
	-- upvalues: SetGamepadMenuOpen (copy)
	return {
		setGamepadMenuOpen = function(p51) -- line: 857
			-- upvalues: p50 (copy), SetGamepadMenuOpen (copy)
			return p50(SetGamepadMenuOpen(p51))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v52)
