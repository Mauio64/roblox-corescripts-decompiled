local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local Utility = require(RobloxGui.Modules.Settings.Utility)
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Constants = require(CorePackages.Packages.UIBlox).App.Style.Constants
local ApolloClient = require(CoreGui.RobloxGui.Modules.ApolloClient)
local ApolloProvider = require(CorePackages.Packages.ApolloClient).ApolloProvider
local scriptParent = script.Parent
local Signals = require(CorePackages.Packages.Signals)
local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local Reducer = require(scriptParent.Reducers.Reducer)
local GlobalConfig = require(scriptParent.GlobalConfig)
local PlayerListSwitcher = require(scriptParent.PlayerListSwitcher)
local MakePlayerInfoRequests = require(scriptParent.Thunks.MakePlayerInfoRequests)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local PlatformLeaderboardsClient = require(CorePackages.Workspace.Packages.PlatformLeaderboardsClient)
local PlayerIconInfoStore = require(CorePackages.Workspace.Packages.PlayerIconInfoStore)
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local Constants2 = PlayerList.Common.Constants
local PlayerRelationshipStore = PlayerList.PlayerRelationshipStore
local SetPlayerListEnabled = require(scriptParent.Actions.SetPlayerListEnabled)
local SetPlayerListVisibility = require(scriptParent.Actions.SetPlayerListVisibility)
local SetTempHideKey = require(scriptParent.Actions.SetTempHideKey)
local SetTenFootInterface = require(scriptParent.Actions.SetTenFootInterface)
local SetSmallTouchDevice = require(scriptParent.Actions.SetSmallTouchDevice)
local SetIsUsingGamepad = require(scriptParent.Actions.SetIsUsingGamepad)
local SetMinimized = require(scriptParent.Actions.SetMinimized)
local SetSubjectToChinaPolicies = require(scriptParent.Actions.SetSubjectToChinaPolicies)
local SetSettings = require(scriptParent.Actions.SetSettings)

if not Players.LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end

local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav
local FStringPlayerListOverrideType = require(scriptParent.Flags.FStringPlayerListOverrideType)
local FFlagReplacePlayerIconRoduxWithSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagReplacePlayerIconRoduxWithSignal
local FFlagBadgeVisibilitySettingEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagBadgeVisibilitySettingEnabled
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local FFlagPlayerListUseMobileOnSmallDisplay = PlayerList.Flags.FFlagPlayerListUseMobileOnSmallDisplay
local FFlagPlayerListIgnoreDevGamepadBindings = PlayerList.Flags.FFlagPlayerListIgnoreDevGamepadBindings
local FFlagPlatformLeaderboardPersistStoreOnRemount = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPlatformLeaderboardPersistStoreOnRemount
local FFlagPlayerListReskin = PlayerList.Flags.FFlagPlayerListReskin
local FFlagPlayerListReskinMobileLayoutFix = PlayerList.Flags.FFlagPlayerListReskinMobileLayoutFix
local PlayerListContainer = PlayerList.Container.PlayerListContainer
local LeaderboardStoreInstanceManager = PlayerList.LeaderboardStoreInstanceManager
local PlayerListVisibilityStore = PlayerList.PlayerListVisibilityStore
local PlayerContextualMenuStore = PlayerList.PlayerContextualMenuStore
local PlayerIconInfoStore2 = PlayerIconInfoStore.PlayerIconInfoStore
local FFlagTopBarSignalizeSetCores = InExperienceTopBar.Flags.FFlagTopBarSignalizeSetCores

local function isUnderTestEZ() -- line: 82
	return _G.__TESTEZ_RUNNING_TEST__ == true
end
local function resolveIsTenFoot() -- line: 88
	-- upvalues: FFlagEnableMobilePlayerListOnConsole (copy), TenFootInterface (copy)
	if FFlagEnableMobilePlayerListOnConsole then
		return false
	end

	return (TenFootInterface:IsEnabled())
end
local function isTouchOrGamepadInput() -- line: 94
	-- upvalues: UserInputService (copy)
	return UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
end
local function isLargeConsoleLayout() -- line: 100
	-- upvalues: FFlagEnableMobilePlayerListOnConsole (copy), GuiService (copy), UserInputService (copy)
	return FFlagEnableMobilePlayerListOnConsole and (GuiService.ViewportDisplaySize == Enum.DisplaySize.Large and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad))
end
local function isSmallTouchScreen() -- line: 106
	-- upvalues: FFlagPlayerListUseMobileOnSmallDisplay (copy), GuiService (copy), Utility (copy), FFlagEnableMobilePlayerListOnConsole (copy), UserInputService (copy), FStringPlayerListOverrideType (copy)
	if _G.__TESTEZ_RUNNING_TEST__ == true then
		return false
	end

	local v66 = FFlagPlayerListUseMobileOnSmallDisplay and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small

	return Utility:IsSmallTouchScreen() or (FFlagEnableMobilePlayerListOnConsole and (GuiService.ViewportDisplaySize == Enum.DisplaySize.Large and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)) or (v66 and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) or FStringPlayerListOverrideType == "mobile"))
end
local function setupSettings(p1) -- line: 118
	-- upvalues: SetSettings (copy), UserGameSettings (copy)
	local function updateSettings() -- line: 119
		-- upvalues: p1 (copy), SetSettings (copy), UserGameSettings (copy)
		p1:dispatch(SetSettings({
			reducedMotion = UserGameSettings.ReducedMotion,
			preferredTransparency = UserGameSettings.PreferredTransparency
		}))
	end

	p1:dispatch(SetSettings({
		reducedMotion = UserGameSettings.ReducedMotion,
		preferredTransparency = UserGameSettings.PreferredTransparency
	}))
	UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line: 128
		-- upvalues: p1 (copy), SetSettings (copy), UserGameSettings (copy)
		p1:dispatch(SetSettings({
			reducedMotion = UserGameSettings.ReducedMotion,
			preferredTransparency = UserGameSettings.PreferredTransparency
		}))
	end)
	UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(function() -- line: 131
		-- upvalues: p1 (copy), SetSettings (copy), UserGameSettings (copy)
		p1:dispatch(SetSettings({
			reducedMotion = UserGameSettings.ReducedMotion,
			preferredTransparency = UserGameSettings.PreferredTransparency
		}))
	end)
end

local t1 = {}

t1.__index = t1

function t1.new() -- line: 139
	-- upvalues: t1 (copy), FFlagPlayerListReskin (copy), GlobalConfig (copy), Roact (copy), Rodux (copy), Reducer (copy), setupSettings (copy), StarterGui (copy), SetPlayerListEnabled (copy), SetSmallTouchDevice (copy), FFlagPlayerListUseMobileOnSmallDisplay (copy), GuiService (copy), Utility (copy), FFlagEnableMobilePlayerListOnConsole (copy), UserInputService (copy), FStringPlayerListOverrideType (copy), SetTenFootInterface (copy), TenFootInterface (copy), SetSubjectToChinaPolicies (copy), CachedPolicyService (copy), Constants (copy), RoactRodux (copy), PlayerListSwitcher (copy), ApolloProvider (copy), ApolloClient (copy), SetIsUsingGamepad (copy), LeaderboardStoreInstanceManager (copy), FFlagReplacePlayerIconRoduxWithSignal (copy), PlayerIconInfoStore2 (copy), PlayerListContainer (copy), RobloxGui (copy), CoreGui (copy), FFlagAddNewPlayerListFocusNav (copy), FFlagTopBarSignalizeSetCores (copy), Signals (copy), InExperienceTopBar (copy)
	local self = setmetatable({}, t1)

	if FFlagPlayerListReskin then
		return self:_setupReskin()
	end

	if GlobalConfig.propValidation then
		Roact.setGlobalConfig({
			propValidation = true
		})
	end

	if GlobalConfig.elementTracing then
		Roact.setGlobalConfig({
			elementTracing = true
		})
	end

	self.layerCollectorRef = Roact.createRef()
	self.store = Rodux.Store.new(Reducer, nil, { Rodux.thunkMiddleware })
	setupSettings(self.store)

	if not StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) then
		self.store:dispatch(SetPlayerListEnabled(false))
	end

	coroutine.wrap(function() -- line: 169
		-- upvalues: self (copy), SetSmallTouchDevice (copy), FFlagPlayerListUseMobileOnSmallDisplay (copy), GuiService (copy), Utility (copy), FFlagEnableMobilePlayerListOnConsole (copy), UserInputService (copy), FStringPlayerListOverrideType (copy)
		local store = self.store
		local v128 = SetSmallTouchDevice
		local v129

		if _G.__TESTEZ_RUNNING_TEST__ == true then
			v129 = false
		else
			local v130 = FFlagPlayerListUseMobileOnSmallDisplay and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small

			v129 = Utility:IsSmallTouchScreen() or (FFlagEnableMobilePlayerListOnConsole and (GuiService.ViewportDisplaySize == Enum.DisplaySize.Large and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)) or (v130 and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) or FStringPlayerListOverrideType == "mobile"))
		end

		store:dispatch(v128(v129))
	end)()
	self.store:dispatch(SetTenFootInterface(not FFlagEnableMobilePlayerListOnConsole and TenFootInterface:IsEnabled()))
	coroutine.wrap(function() -- line: 175
		-- upvalues: self (copy), SetSubjectToChinaPolicies (copy), CachedPolicyService (copy)
		self.store:dispatch(SetSubjectToChinaPolicies(CachedPolicyService:IsSubjectToChinaPolicies()))
	end)()
	self:_trackEnabled()

	local t2 = {
		themeName = Constants.ThemeName.Dark,
		fontName = Constants.FontName.Gotham
	}

	self.root = Roact.createElement(RoactRodux.StoreProvider, {
		store = self.store
	}, {
		Switcher = Roact.createElement(PlayerListSwitcher, {
			appStyleForUiModeStyleProvider = t2,
			setLayerCollectorEnabled = function(p2) -- line: 191
				-- upvalues: self (copy)
				if not self.layerCollectorRef.current then
					return
				end

				self.layerCollectorRef.current.Enabled = p2
			end
		})
	})
	self.root = Roact.createElement(ApolloProvider, {
		client = ApolloClient
	}, {
		StoreProvider = self.root
	})

	function self._setIsUsingGamepad() -- line: 205
		-- upvalues: UserInputService (copy), self (copy), SetIsUsingGamepad (copy)
		local LastInputType = UserInputService:GetLastInputType()
		local v133 = LastInputType and LastInputType.Name:find("Gamepad")

		self.store:dispatch(SetIsUsingGamepad(v133 ~= nil))
	end
	function self._mountLeaderboardStore() -- line: 211
		-- upvalues: LeaderboardStoreInstanceManager (copy)
		LeaderboardStoreInstanceManager.createLeaderboardStoreInstance()
	end
	function self._unmountLeaderboardStore() -- line: 215
		-- upvalues: LeaderboardStoreInstanceManager (copy)
		LeaderboardStoreInstanceManager.cleanUpInstance()
	end

	self._unmountPlayerIconInfoStore = if not FFlagReplacePlayerIconRoduxWithSignal then nil else function() -- line: 220
		-- upvalues: PlayerIconInfoStore2 (copy)
		PlayerIconInfoStore2.cleanUp()
	end
	self._mountLeaderboardStore()
	self._setIsUsingGamepad()
	self.root = Roact.createElement(PlayerListContainer, {
		leaderboardStore = LeaderboardStoreInstanceManager.getLeaderboardStoreInstance,
		TopBarConstants = require(RobloxGui.Modules.TopBar.Constants),
		isTenFoot = not FFlagEnableMobilePlayerListOnConsole and TenFootInterface:IsEnabled()
	}, {
		PlayerListRoot = self.root
	})
	self.root = Roact.createElement("ScreenGui", {
		AutoLocalize = false,
		IgnoreGuiInset = true,
		DisplayOrder = 1,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		[Roact.Ref] = self.layerCollectorRef
	}, {
		PlayerListRoot = self.root
	})
	self.element = Roact.mount(self.root, CoreGui, "PlayerList")
	self.topBarEnabled = true
	self.mounted = true
	self.coreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)
	self:_updateMounted()
	self.SetVisibleChangedEvent = Instance.new("BindableEvent")

	if FFlagAddNewPlayerListFocusNav then
		self.VisibilityChangedEvent = Instance.new("BindableEvent")
	end

	if FFlagTopBarSignalizeSetCores then
		self.disposeEffect = Signals.createEffect(function(p3) -- line: 258
			-- upvalues: InExperienceTopBar (copy), self (copy)
			local GetTopBarStore = InExperienceTopBar.Stores.GetTopBarStore

			if GetTopBarStore then
				self:SetTopBarEnabled(GetTopBarStore(p3).getTopBarCoreGuiEnabled(p3))
			end
		end)
	end

	self.store.changed:connect(function(p4, p5) -- line: 266
		-- upvalues: self (copy), FFlagAddNewPlayerListFocusNav (copy)
		if p4.displayOptions.setVisible ~= p5.displayOptions.setVisible then
			self.SetVisibleChangedEvent:Fire(p4.displayOptions.setVisible)
		end

		if FFlagAddNewPlayerListFocusNav and p4.displayOptions.isVisible ~= p5.displayOptions.isVisible then
			self.VisibilityChangedEvent:Fire(p4.displayOptions.isVisible)
		end
	end)

	return self
end
function t1._updateMounted(p6) -- line: 280
	-- upvalues: FFlagEnableMobilePlayerListOnConsole (copy), TenFootInterface (copy), Roact (copy), CoreGui (copy)
	if FFlagEnableMobilePlayerListOnConsole or not TenFootInterface:IsEnabled() then
		local v72 = p6.coreGuiEnabled and p6.topBarEnabled

		if v72 and not p6.mounted then
			p6._mountLeaderboardStore()
			p6._setIsUsingGamepad()
			p6.element = Roact.mount(p6.root, CoreGui, "PlayerList")
			p6.mounted = true

			return
		end

		if not v72 and p6.mounted then
			Roact.unmount(p6.element)
			p6._unmountLeaderboardStore()

			if p6._unmountPlayerIconInfoStore then
				p6._unmountPlayerIconInfoStore()
			end

			p6.mounted = false

			if p6.inspector then
				p6.inspector:destroy()
				p6.inspector = nil
			end
		end
	end
end
function t1._trackEnabled(p7) -- line: 303
	-- upvalues: StarterGui (copy), SetPlayerListEnabled (copy), FFlagPlayerListIgnoreDevGamepadBindings (copy), GuiService (copy), Constants2 (copy)
	StarterGui.CoreGuiChangedSignal:Connect(function(p8, p9) -- line: 304
		-- upvalues: p7 (copy), SetPlayerListEnabled (copy), FFlagPlayerListIgnoreDevGamepadBindings (copy), GuiService (copy), Constants2 (copy)
		if p8 == Enum.CoreGuiType.All or p8 == Enum.CoreGuiType.PlayerList then
			p7.coreGuiEnabled = p9
			p7:_updateMounted()
			p7.store:dispatch(SetPlayerListEnabled(p9))

			if FFlagPlayerListIgnoreDevGamepadBindings and not p9 then
				GuiService:SetMenuIsOpen(false, Constants2.PLAYER_LIST_MENU)
			end
		end
	end)
end

if FFlagAddNewPlayerListMobileFocusNav then
	function t1.GetIsModal(p10) -- line: 319
		-- upvalues: FFlagPlayerListReskin (copy), FFlagPlayerListUseMobileOnSmallDisplay (copy), GuiService (copy), Utility (copy), FFlagEnableMobilePlayerListOnConsole (copy), UserInputService (copy), FStringPlayerListOverrideType (copy)
		if FFlagPlayerListReskin then
			if _G.__TESTEZ_RUNNING_TEST__ == true then
				return false
			end

			local v75 = FFlagPlayerListUseMobileOnSmallDisplay and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small

			return Utility:IsSmallTouchScreen() or (FFlagEnableMobilePlayerListOnConsole and (GuiService.ViewportDisplaySize == Enum.DisplaySize.Large and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)) or (v75 and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) or FStringPlayerListOverrideType == "mobile"))
		end

		return p10.store:getState().displayOptions.isSmallTouchDevice
	end
end

function t1._setupReskin(p11) -- line: 328
	-- upvalues: CorePackages (copy), RobloxGui (copy), PlayerList (copy), scriptParent (copy), FFlagEnableMobilePlayerListOnConsole (copy), TenFootInterface (copy), FFlagPlayerListUseMobileOnSmallDisplay (copy), GuiService (copy), Utility (copy), UserInputService (copy), FStringPlayerListOverrideType (copy), PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy), FFlagPlatformLeaderboardPersistStoreOnRemount (copy), PlatformLeaderboardsClient (copy), Signals (copy), FFlagPlayerListReskinMobileLayoutFix (copy), UserGameSettings (copy), PlayerListContainer (copy), LeaderboardStoreInstanceManager (copy), Players (copy), PlayerRelationshipStore (copy), MakePlayerInfoRequests (copy), PlayerIconInfoStore2 (copy), BlockingUtility (copy), FFlagBadgeVisibilitySettingEnabled (copy), RobloxReplicatedStorage (copy), CoreGui (copy), StarterGui (copy), ContextActionService (copy), FFlagTopBarSignalizeSetCores (copy), InExperienceTopBar (copy)
	local React = require(CorePackages.Packages.React)
	local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
	local Constants3 = require(RobloxGui.Modules.TopBar.Constants)
	local Foundation = require(CorePackages.Packages.Foundation)
	local FoundationProvider = Foundation.FoundationProvider
	local Theme = Foundation.Enums.Theme
	local Device = Foundation.Enums.Device
	local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
	local PlayerListPanel = PlayerList.Presentation.PlayerListPanel
	local PlayerContextualMenuView = PlayerList.Presentation.PlayerContextualMenuView
	local LeaderboardScrim = PlayerList.Presentation.LeaderboardScrim
	local ContextMenuController = require(scriptParent.ContextMenuController)

	local function translate(p12, p13) -- line: 343
		-- upvalues: RobloxTranslator (copy)
		local ok, result = pcall(function() -- line: 344
			-- upvalues: RobloxTranslator (copy), p12 (copy)
			return RobloxTranslator:FormatByKey(p12)
		end)

		if ok and (result and result ~= "") then
			return result
		end

		return p13
	end

	local s1 = "InGame.PlayerList.Leaderboard"
	local ok, result = pcall(function() -- line: 344
		-- upvalues: RobloxTranslator (copy), s1 (copy)
		return RobloxTranslator:FormatByKey(s1)
	end)
	local v93 = (not ok or (not result or result == "")) and "Leaderboard" or result
	local v94 = not FFlagEnableMobilePlayerListOnConsole and TenFootInterface:IsEnabled()
	local v95

	if _G.__TESTEZ_RUNNING_TEST__ == true then
		v95 = false
	else
		local v96 = FFlagPlayerListUseMobileOnSmallDisplay and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small

		v95 = Utility:IsSmallTouchScreen() or (FFlagEnableMobilePlayerListOnConsole and (GuiService.ViewportDisplaySize == Enum.DisplaySize.Large and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)) or (v96 and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) or FStringPlayerListOverrideType == "mobile"))
	end

	local v97 = v95
	local v98 = if not TenFootInterface:IsEnabled() and not (FFlagEnableMobilePlayerListOnConsole and (GuiService.ViewportDisplaySize == Enum.DisplaySize.Large and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad))) then Device.Unknown else Device.Console

	if v97 then
		PlayerContextualMenuStore.setOnDismiss(function() -- line: 366
			-- upvalues: PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy)
			if PlayerContextualMenuStore.takeSuppressNextDismissRestore() then
				return
			end

			PlayerListVisibilityStore.setVisible(true)
		end)
	end

	PlayerContextualMenuStore.setContextMenuOpener(function(p14, p15, p16) -- line: 374
		-- upvalues: ContextMenuController (copy), PlayerContextualMenuStore (copy), v97 (copy), PlayerListVisibilityStore (copy)
		task.spawn(function() -- line: 375
			-- upvalues: ContextMenuController (copy), p14 (copy), PlayerContextualMenuStore (copy), v97 (copy), p15 (copy), p16 (copy), PlayerListVisibilityStore (copy)
			local v167 = ContextMenuController.buildMenuData(p14, PlayerContextualMenuStore.closeContextMenu, v97)

			if p14.Parent == nil then
				return
			end

			v167.anchorPosition = p15

			if PlayerContextualMenuStore.setMenuDataIfCurrent(v167, p16) and v97 then
				PlayerListVisibilityStore.setVisible(false)
			end
		end)
	end)

	local PlayerListInitialVisibleState = require(scriptParent.PlayerListInitialVisibleState)

	PlayerListVisibilityStore.reset()

	if FFlagPlatformLeaderboardPersistStoreOnRemount then
		PlatformLeaderboardsClient.reset()
	end

	PlayerListVisibilityStore.setVisible(PlayerListInitialVisibleState())
	p11.SetVisibleChangedEvent = Instance.new("BindableEvent")
	p11.VisibilityChangedEvent = Instance.new("BindableEvent")

	local function setupVisibilityEffect() -- line: 405
		-- upvalues: p11 (copy), Signals (copy), PlayerListVisibilityStore (copy)
		local u147 = false

		p11._reskinSetVisibleEffect = Signals.createEffect(function(p17) -- line: 407
			-- upvalues: PlayerListVisibilityStore (copy), u147 (ref), p11 (copy)
			local v169 = PlayerListVisibilityStore.getVisible(p17)

			if u147 then
				p11.SetVisibleChangedEvent:Fire(v169)

				return
			end

			u147 = true
		end)

		local u148 = false

		p11._reskinVisibilityEffect = Signals.createEffect(function(p18) -- line: 417
			-- upvalues: PlayerListVisibilityStore (copy), u148 (ref), p11 (copy)
			local v171 = PlayerListVisibilityStore.getEffectiveVisible(p18)

			if u148 then
				p11.VisibilityChangedEvent:Fire(v171)

				return
			end

			u148 = true
		end)
	end

	local TopBarHeight = Constants3.TopBarHeight

	local function computeMobileTopInset() -- line: 430
		-- upvalues: Constants3 (copy)
		return (math.max(8, Constants3.ApplyDisplayScale(8)))
	end
	local function computeMobilePosition() -- line: 433
		-- upvalues: TopBarHeight (copy), Constants3 (copy)
		return UDim2.new(0.5, 0, 0, TopBarHeight + math.max(8, Constants3.ApplyDisplayScale(8)))
	end

	local u104 = nil
	local u105 = nil

	if FFlagPlayerListReskinMobileLayoutFix then
		local v106, v107 = React.createBinding(computeMobilePosition())

		u104 = v106
		u105 = v107
	end

	local function resolveContainerProps() -- line: 440
		-- upvalues: v97 (copy), FFlagPlayerListReskinMobileLayoutFix (copy), u104 (ref), Constants3 (copy), TopBarHeight (copy)
		if v97 then
			if FFlagPlayerListReskinMobileLayoutFix then
				return {
					tag = "auto-xy",
					AnchorPoint = Vector2.new(0.5, 0),
					Position = u104,
					Size = UDim2.fromOffset(0, 0)
				}
			end

			local CurrentCamera = workspace.CurrentCamera
			local v150 = if not CurrentCamera then Vector2.new(0, 0) else CurrentCamera.ViewportSize

			if v150.Y > v150.X then
				local v151 = Constants3.ApplyDisplayScale(Constants3.ScreenSideOffset)

				return {
					tag = "auto-xy",
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, v151, 0.5, TopBarHeight / 2),
					Size = UDim2.fromOffset(0, 0)
				}
			end

			return {
				tag = "auto-xy",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, TopBarHeight / 2),
				Size = UDim2.fromOffset(0, 0)
			}
		end

		local v152 = not FFlagPlayerListReskinMobileLayoutFix and 4 or math.max(4, Constants3.ApplyDisplayScale(4))

		return {
			tag = "auto-xy",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -v152, 0, v152 + TopBarHeight),
			Size = UDim2.fromOffset(0, 0)
		}
	end
	local function buildReskinElement() -- line: 480
		-- upvalues: React (copy), FoundationProvider (copy), Theme (copy), v98 (copy), UserGameSettings (copy), LeaderboardScrim (copy), v97 (copy), Foundation (copy), resolveContainerProps (copy), PlayerListContainer (copy), LeaderboardStoreInstanceManager (copy), Constants3 (copy), v94 (copy), PlayerListPanel (copy), v93 (copy), PlayerContextualMenuView (copy)
		return React.createElement(FoundationProvider, {
			theme = Theme.Dark,
			device = v98,
			preferences = {
				preferredTransparency = UserGameSettings.PreferredTransparency
			}
		}, {
			Scrim = React.createElement(LeaderboardScrim, {
				isSmallTouchDevice = v97
			}),
			Container = React.createElement(Foundation.View, resolveContainerProps(), {
				ReskinContainer = React.createElement(PlayerListContainer, {
					leaderboardStore = LeaderboardStoreInstanceManager.getLeaderboardStoreInstance,
					TopBarConstants = Constants3,
					isTenFoot = v94
				}, {
					PlayerListPanel = React.createElement(PlayerListPanel, {
						isSmallTouchDevice = v97,
						title = v93
					})
				})
			}),
			ContextMenu = React.createElement(PlayerContextualMenuView, {
				isSmallTouchDevice = v97
			})
		})
	end
	local function setupPlayerInfoRequests() -- line: 515
		-- upvalues: Players (copy), PlayerRelationshipStore (copy), MakePlayerInfoRequests (copy), p11 (copy), PlayerIconInfoStore2 (copy), BlockingUtility (copy), FFlagBadgeVisibilitySettingEnabled (copy), RobloxReplicatedStorage (copy)
		local t3 = {
			getState = function() -- line: 517
				-- upvalues: Players (copy)
				return {
					players = Players:GetPlayers()
				}
			end,
			dispatch = function(_, p20) -- line: 520
				-- upvalues: PlayerRelationshipStore (copy)
				if type(p20) ~= "table" then
					return
				end

				if p20.type == "SetPlayerIsBlocked" and p20.userId then
					PlayerRelationshipStore.patchPlayerRelationship(p20.userId, {
						isBlocked = p20.isBlocked
					})

					return
				end

				if p20.type == "SetPlayerFriendStatus" and p20.userId then
					PlayerRelationshipStore.patchPlayerRelationship(p20.userId, {
						friendStatus = p20.friendStatus
					})
				end
			end
		}

		local function request(p21) -- line: 535
			-- upvalues: MakePlayerInfoRequests (copy), t3 (copy)
			MakePlayerInfoRequests(p21)(t3)
		end

		for _, player in ipairs(Players:GetPlayers()) do
			MakePlayerInfoRequests(player)(t3)
		end

		p11._reskinPlayerAddedConn = Players.PlayerAdded:Connect(request)
		p11._reskinPlayerRemovingConn = Players.PlayerRemoving:Connect(function(player) -- line: 542
			-- upvalues: PlayerIconInfoStore2 (copy), PlayerRelationshipStore (copy)
			PlayerIconInfoStore2.removePlayer(player.UserId)
			PlayerRelationshipStore.removePlayer(player.UserId)
		end)
		p11._reskinBlockedStatusConn = BlockingUtility:GetBlockedStatusChangedEvent():Connect(function(p22, p23) -- line: 547
			-- upvalues: PlayerRelationshipStore (copy)
			local num = tonumber(p22)

			if num then
				PlayerRelationshipStore.patchPlayerRelationship(num, {
					isBlocked = p23
				})
			end
		end)
		p11._reskinFriendStatusConn = Players.LocalPlayer.FriendStatusChanged:Connect(function(p24, p25) -- line: 553
			-- upvalues: PlayerRelationshipStore (copy)
			PlayerRelationshipStore.patchPlayerRelationship(p24.UserId, {
				friendStatus = p25
			})
		end)

		if FFlagBadgeVisibilitySettingEnabled then
			task.spawn(function() -- line: 559
				-- upvalues: RobloxReplicatedStorage (copy), p11 (copy), Players (copy), MakePlayerInfoRequests (copy), t3 (copy)
				p11._reskinProfileSettingsConn = RobloxReplicatedStorage:WaitForChild("SendPlayerProfileSettings", 1e999).OnClientEvent:Connect(function(p26) -- line: 562
					-- upvalues: Players (copy), MakePlayerInfoRequests (copy), t3 (copy)
					local PlayerByUserId = Players:GetPlayerByUserId((tonumber(p26)))

					if PlayerByUserId then
						MakePlayerInfoRequests(PlayerByUserId)(t3)
					end
				end)
			end)
		end
	end
	local function teardownPlayerInfoRequests() -- line: 572
		-- upvalues: p11 (copy), PlayerRelationshipStore (copy)
		if p11._reskinPlayerAddedConn then
			p11._reskinPlayerAddedConn:Disconnect()
			p11._reskinPlayerAddedConn = nil
		end

		if p11._reskinPlayerRemovingConn then
			p11._reskinPlayerRemovingConn:Disconnect()
			p11._reskinPlayerRemovingConn = nil
		end

		if p11._reskinBlockedStatusConn then
			p11._reskinBlockedStatusConn:Disconnect()
			p11._reskinBlockedStatusConn = nil
		end

		if p11._reskinFriendStatusConn then
			p11._reskinFriendStatusConn:Disconnect()
			p11._reskinFriendStatusConn = nil
		end

		if p11._reskinProfileSettingsConn then
			p11._reskinProfileSettingsConn:Disconnect()
			p11._reskinProfileSettingsConn = nil
		end

		PlayerRelationshipStore.cleanUp()
	end
	local function mountReskin() -- line: 596
		-- upvalues: CoreGui (copy), ReactRoblox (copy), buildReskinElement (copy), p11 (copy), FFlagPlayerListReskinMobileLayoutFix (copy), v97 (copy), u105 (ref), computeMobilePosition (copy), setupPlayerInfoRequests (copy)
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "PlayerListReskin"
		ScreenGui.AutoLocalize = false
		ScreenGui.IgnoreGuiInset = true
		ScreenGui.DisplayOrder = _G.__TESTEZ_RUNNING_TEST__ ~= true and 1 or -1
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		ScreenGui.Parent = CoreGui

		local v158 = ReactRoblox.createRoot(ScreenGui)

		v158:render(buildReskinElement())
		p11._reskinRoot = v158
		p11._reskinScreenGui = ScreenGui

		if FFlagPlayerListReskinMobileLayoutFix and v97 then
			local function connectViewport(p27) -- line: 613
				-- upvalues: p11 (copy), u105 (ref), computeMobilePosition (copy)
				if p11._reskinViewportConn then
					p11._reskinViewportConn:Disconnect()
					p11._reskinViewportConn = nil
				end

				if p27 then
					p11._reskinViewportConn = p27:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 619
						-- upvalues: u105 (ref), computeMobilePosition (copy)
						u105(computeMobilePosition())
					end)
					u105(computeMobilePosition())
				end
			end

			p11._reskinCameraConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 625
				-- upvalues: connectViewport (copy)
				connectViewport(workspace.CurrentCamera)
			end)
			connectViewport(workspace.CurrentCamera)
		end

		setupPlayerInfoRequests()
	end

	p11.topBarEnabled = true
	p11.coreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)
	p11._reskin = {
		mountReskin = mountReskin,
		unmountReskin = function() -- line: 633
			-- upvalues: teardownPlayerInfoRequests (copy), p11 (copy)
			teardownPlayerInfoRequests()

			if p11._reskinCameraConn then
				p11._reskinCameraConn:Disconnect()
				p11._reskinCameraConn = nil
			end

			if p11._reskinViewportConn then
				p11._reskinViewportConn:Disconnect()
				p11._reskinViewportConn = nil
			end

			if p11._reskinRoot then
				p11._reskinRoot:unmount()
				p11._reskinRoot = nil
			end

			if p11._reskinScreenGui then
				p11._reskinScreenGui:Destroy()
				p11._reskinScreenGui = nil
			end

			if p11._reskinVisibilityEffect then
				p11._reskinVisibilityEffect()
				p11._reskinVisibilityEffect = nil
			end

			if p11._reskinSetVisibleEffect then
				p11._reskinSetVisibleEffect()
				p11._reskinSetVisibleEffect = nil
			end
		end,
		setupVisibilityEffect = setupVisibilityEffect
	}

	if p11.coreGuiEnabled then
		LeaderboardStoreInstanceManager.createLeaderboardStoreInstance()
		setupVisibilityEffect()
		mountReskin()
		p11.mounted = true
	else
		p11.mounted = false
	end

	p11._reskinCoreGuiConn = StarterGui.CoreGuiChangedSignal:Connect(function(p28, p29) -- line: 679
		-- upvalues: p11 (copy)
		if p28 == Enum.CoreGuiType.All or p28 == Enum.CoreGuiType.PlayerList then
			p11.coreGuiEnabled = p29
			p11:SetTopBarEnabled(p11.topBarEnabled)
		end
	end)
	ContextActionService:BindCoreAction("RbxPlayerListToggle", function(_, p31, _) -- line: 686
		-- upvalues: p11 (copy), v97 (copy), GuiService (copy)
		if not p11.mounted then
			return Enum.ContextActionResult.Pass
		end

		if v97 then
			return Enum.ContextActionResult.Pass
		end

		if GuiService.MenuIsOpen then
			return Enum.ContextActionResult.Pass
		end

		if p31 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		p11:SetVisibility(not p11:GetVisibility())

		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.Tab)

	if FFlagTopBarSignalizeSetCores then
		p11._reskinTopBarEffect = Signals.createEffect(function(p33) -- line: 704
			-- upvalues: InExperienceTopBar (copy), p11 (copy)
			local GetTopBarStore = InExperienceTopBar.Stores.GetTopBarStore

			if GetTopBarStore then
				p11:SetTopBarEnabled(GetTopBarStore(p33).getTopBarCoreGuiEnabled(p33))
			end
		end)
	end

	return p11
end
function t1.GetVisibility(p34) -- line: 715
	-- upvalues: FFlagPlayerListReskin (copy), PlayerListVisibilityStore (copy)
	if FFlagPlayerListReskin then
		return PlayerListVisibilityStore.getEffectiveVisible(false)
	end

	return p34.store:getState().displayOptions.isVisible
end

if FFlagAddNewPlayerListFocusNav then
	function t1.GetVisibilityChangedEvent(p35) -- line: 723
		return p35.VisibilityChangedEvent
	end
end

function t1.GetSetVisible(p36) -- line: 728
	-- upvalues: FFlagPlayerListReskin (copy), PlayerListVisibilityStore (copy)
	if FFlagPlayerListReskin then
		return PlayerListVisibilityStore.getVisible(false)
	end

	return p36.store:getState().displayOptions.setVisible
end
function t1.GetSetVisibleChangedEvent(p37) -- line: 735
	return p37.SetVisibleChangedEvent
end
function t1.SetVisibility(p38, p39) -- line: 739
	-- upvalues: FFlagPlayerListReskin (copy), PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy), SetPlayerListVisibility (copy)
	if FFlagPlayerListReskin then
		if not p39 then
			PlayerContextualMenuStore.closeContextMenu()
		end

		PlayerListVisibilityStore.setVisible(p39)

		return
	end

	p38.store:dispatch(SetPlayerListVisibility(p39))
end
function t1.HideTemp(p40, p41, p42) -- line: 750
	-- upvalues: FFlagPlayerListReskin (copy), PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy), SetTempHideKey (copy)
	if FFlagPlayerListReskin then
		if p42 and PlayerContextualMenuStore.getMenuData(false) ~= nil then
			PlayerContextualMenuStore.closeContextMenu()
		end

		PlayerListVisibilityStore.setTempHide(p41, p42)

		return
	end

	if p42 == false then
		p42 = nil
	end

	p40.store:dispatch(SetTempHideKey(p41, p42))
end
function t1.SetTopBarEnabled(p43, p44) -- line: 769
	-- upvalues: FFlagPlayerListReskin (copy), LeaderboardStoreInstanceManager (copy)
	if FFlagPlayerListReskin then
		p43.topBarEnabled = p44

		local v124 = p43.coreGuiEnabled and p44

		if v124 and not p43.mounted then
			LeaderboardStoreInstanceManager.createLeaderboardStoreInstance()
			p43._reskin.setupVisibilityEffect()
			p43._reskin.mountReskin()
			p43.mounted = true

			return
		end

		if not v124 and p43.mounted then
			p43._reskin.unmountReskin()
			LeaderboardStoreInstanceManager.cleanUpInstance()
			p43.mounted = false
		end

		return
	end

	p43.topBarEnabled = p44
	p43:_updateMounted()
end
function t1.SetMinimized(p45, p46) -- line: 789
	-- upvalues: FFlagPlayerListReskin (copy), SetMinimized (copy)
	if FFlagPlayerListReskin then
		return
	end

	p45.store:dispatch(SetMinimized(p46))
end

return t1
