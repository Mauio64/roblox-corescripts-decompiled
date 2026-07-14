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
local FFlagPlayerListReskin = PlayerList.Flags.FFlagPlayerListReskin
local PlayerListContainer = PlayerList.Container.PlayerListContainer
local LeaderboardStoreInstanceManager = PlayerList.LeaderboardStoreInstanceManager
local PlayerListVisibilityStore = PlayerList.PlayerListVisibilityStore
local PlayerContextualMenuStore = PlayerList.PlayerContextualMenuStore
local PlayerIconInfoStore2 = PlayerIconInfoStore.PlayerIconInfoStore
local FFlagTopBarSignalizeSetCores = InExperienceTopBar.Flags.FFlagTopBarSignalizeSetCores

local function isUnderTestEZ() -- line: 78
	return _G.__TESTEZ_RUNNING_TEST__ == true
end
local function resolveIsTenFoot() -- line: 84
	-- upvalues: FFlagEnableMobilePlayerListOnConsole (copy), TenFootInterface (copy)
	if FFlagEnableMobilePlayerListOnConsole then
		return false
	end

	return (TenFootInterface:IsEnabled())
end
local function isTouchOrGamepadInput() -- line: 90
	-- upvalues: UserInputService (copy)
	return UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
end
local function isLargeConsoleLayout() -- line: 96
	-- upvalues: FFlagEnableMobilePlayerListOnConsole (copy), GuiService (copy), UserInputService (copy)
	return FFlagEnableMobilePlayerListOnConsole and (GuiService.ViewportDisplaySize == Enum.DisplaySize.Large and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad))
end
local function isSmallTouchScreen() -- line: 102
	-- upvalues: FFlagPlayerListUseMobileOnSmallDisplay (copy), GuiService (copy), Utility (copy), FFlagEnableMobilePlayerListOnConsole (copy), UserInputService (copy), FStringPlayerListOverrideType (copy)
	if _G.__TESTEZ_RUNNING_TEST__ == true then
		return false
	end

	local v63 = FFlagPlayerListUseMobileOnSmallDisplay and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small

	return Utility:IsSmallTouchScreen() or (FFlagEnableMobilePlayerListOnConsole and (GuiService.ViewportDisplaySize == Enum.DisplaySize.Large and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)) or (v63 and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) or FStringPlayerListOverrideType == "mobile"))
end
local function setupSettings(p1) -- line: 114
	-- upvalues: SetSettings (copy), UserGameSettings (copy)
	local function updateSettings() -- line: 115
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
	UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line: 124
		-- upvalues: p1 (copy), SetSettings (copy), UserGameSettings (copy)
		p1:dispatch(SetSettings({
			reducedMotion = UserGameSettings.ReducedMotion,
			preferredTransparency = UserGameSettings.PreferredTransparency
		}))
	end)
	UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(function() -- line: 127
		-- upvalues: p1 (copy), SetSettings (copy), UserGameSettings (copy)
		p1:dispatch(SetSettings({
			reducedMotion = UserGameSettings.ReducedMotion,
			preferredTransparency = UserGameSettings.PreferredTransparency
		}))
	end)
end

local t1 = {}

t1.__index = t1

function t1.new() -- line: 135
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

	coroutine.wrap(function() -- line: 165
		-- upvalues: self (copy), SetSmallTouchDevice (copy), FFlagPlayerListUseMobileOnSmallDisplay (copy), GuiService (copy), Utility (copy), FFlagEnableMobilePlayerListOnConsole (copy), UserInputService (copy), FStringPlayerListOverrideType (copy)
		local store = self.store
		local v120 = SetSmallTouchDevice
		local v121

		if _G.__TESTEZ_RUNNING_TEST__ == true then
			v121 = false
		else
			local v122 = FFlagPlayerListUseMobileOnSmallDisplay and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small

			v121 = Utility:IsSmallTouchScreen() or (FFlagEnableMobilePlayerListOnConsole and (GuiService.ViewportDisplaySize == Enum.DisplaySize.Large and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)) or (v122 and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) or FStringPlayerListOverrideType == "mobile"))
		end

		store:dispatch(v120(v121))
	end)()
	self.store:dispatch(SetTenFootInterface(not FFlagEnableMobilePlayerListOnConsole and TenFootInterface:IsEnabled()))
	coroutine.wrap(function() -- line: 171
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
			setLayerCollectorEnabled = function(p2) -- line: 187
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

	function self._setIsUsingGamepad() -- line: 201
		-- upvalues: UserInputService (copy), self (copy), SetIsUsingGamepad (copy)
		local LastInputType = UserInputService:GetLastInputType()
		local v125 = LastInputType and LastInputType.Name:find("Gamepad")

		self.store:dispatch(SetIsUsingGamepad(v125 ~= nil))
	end
	function self._mountLeaderboardStore() -- line: 207
		-- upvalues: LeaderboardStoreInstanceManager (copy)
		LeaderboardStoreInstanceManager.createLeaderboardStoreInstance()
	end
	function self._unmountLeaderboardStore() -- line: 211
		-- upvalues: LeaderboardStoreInstanceManager (copy)
		LeaderboardStoreInstanceManager.cleanUpInstance()
	end

	self._unmountPlayerIconInfoStore = if not FFlagReplacePlayerIconRoduxWithSignal then nil else function() -- line: 216
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
		self.disposeEffect = Signals.createEffect(function(p3) -- line: 254
			-- upvalues: InExperienceTopBar (copy), self (copy)
			local GetTopBarStore = InExperienceTopBar.Stores.GetTopBarStore

			if GetTopBarStore then
				self:SetTopBarEnabled(GetTopBarStore(p3).getTopBarCoreGuiEnabled(p3))
			end
		end)
	end

	self.store.changed:connect(function(p4, p5) -- line: 262
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
function t1._updateMounted(p6) -- line: 276
	-- upvalues: FFlagEnableMobilePlayerListOnConsole (copy), TenFootInterface (copy), Roact (copy), CoreGui (copy)
	if FFlagEnableMobilePlayerListOnConsole or not TenFootInterface:IsEnabled() then
		local v69 = p6.coreGuiEnabled and p6.topBarEnabled

		if v69 and not p6.mounted then
			p6._mountLeaderboardStore()
			p6._setIsUsingGamepad()
			p6.element = Roact.mount(p6.root, CoreGui, "PlayerList")
			p6.mounted = true

			return
		end

		if not v69 and p6.mounted then
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
function t1._trackEnabled(p7) -- line: 299
	-- upvalues: StarterGui (copy), SetPlayerListEnabled (copy), FFlagPlayerListIgnoreDevGamepadBindings (copy), GuiService (copy), Constants2 (copy)
	StarterGui.CoreGuiChangedSignal:Connect(function(p8, p9) -- line: 300
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
	function t1.GetIsModal(p10) -- line: 315
		-- upvalues: FFlagPlayerListReskin (copy), FFlagPlayerListUseMobileOnSmallDisplay (copy), GuiService (copy), Utility (copy), FFlagEnableMobilePlayerListOnConsole (copy), UserInputService (copy), FStringPlayerListOverrideType (copy)
		if FFlagPlayerListReskin then
			if _G.__TESTEZ_RUNNING_TEST__ == true then
				return false
			end

			local v72 = FFlagPlayerListUseMobileOnSmallDisplay and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small

			return Utility:IsSmallTouchScreen() or (FFlagEnableMobilePlayerListOnConsole and (GuiService.ViewportDisplaySize == Enum.DisplaySize.Large and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)) or (v72 and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) or FStringPlayerListOverrideType == "mobile"))
		end

		return p10.store:getState().displayOptions.isSmallTouchDevice
	end
end

function t1._setupReskin(p11) -- line: 324
	-- upvalues: CorePackages (copy), RobloxGui (copy), PlayerList (copy), scriptParent (copy), FFlagEnableMobilePlayerListOnConsole (copy), TenFootInterface (copy), FFlagPlayerListUseMobileOnSmallDisplay (copy), GuiService (copy), Utility (copy), UserInputService (copy), FStringPlayerListOverrideType (copy), PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy), Signals (copy), UserGameSettings (copy), PlayerListContainer (copy), LeaderboardStoreInstanceManager (copy), Players (copy), PlayerRelationshipStore (copy), MakePlayerInfoRequests (copy), PlayerIconInfoStore2 (copy), BlockingUtility (copy), FFlagBadgeVisibilitySettingEnabled (copy), RobloxReplicatedStorage (copy), CoreGui (copy), StarterGui (copy), ContextActionService (copy), FFlagTopBarSignalizeSetCores (copy), InExperienceTopBar (copy)
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

	local function translate(p12, p13) -- line: 339
		-- upvalues: RobloxTranslator (copy)
		local ok, result = pcall(function() -- line: 340
			-- upvalues: RobloxTranslator (copy), p12 (copy)
			return RobloxTranslator:FormatByKey(p12)
		end)

		if ok and (result and result ~= "") then
			return result
		end

		return p13
	end

	local s1 = "InGame.PlayerList.Leaderboard"
	local ok, result = pcall(function() -- line: 340
		-- upvalues: RobloxTranslator (copy), s1 (copy)
		return RobloxTranslator:FormatByKey(s1)
	end)
	local v90 = (not ok or (not result or result == "")) and "Leaderboard" or result
	local v91 = not FFlagEnableMobilePlayerListOnConsole and TenFootInterface:IsEnabled()
	local v92

	if _G.__TESTEZ_RUNNING_TEST__ == true then
		v92 = false
	else
		local v93 = FFlagPlayerListUseMobileOnSmallDisplay and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small

		v92 = Utility:IsSmallTouchScreen() or (FFlagEnableMobilePlayerListOnConsole and (GuiService.ViewportDisplaySize == Enum.DisplaySize.Large and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)) or (v93 and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) or FStringPlayerListOverrideType == "mobile"))
	end

	local v94 = v92
	local v95 = if not TenFootInterface:IsEnabled() and not (FFlagEnableMobilePlayerListOnConsole and (GuiService.ViewportDisplaySize == Enum.DisplaySize.Large and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad))) then Device.Unknown else Device.Console

	if v94 then
		PlayerContextualMenuStore.setOnDismiss(function() -- line: 362
			-- upvalues: PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy)
			if PlayerContextualMenuStore.takeSuppressNextDismissRestore() then
				return
			end

			PlayerListVisibilityStore.setVisible(true)
		end)
	end

	PlayerContextualMenuStore.setContextMenuOpener(function(p14, p15, p16) -- line: 370
		-- upvalues: ContextMenuController (copy), PlayerContextualMenuStore (copy), v94 (copy), PlayerListVisibilityStore (copy)
		task.spawn(function() -- line: 371
			-- upvalues: ContextMenuController (copy), p14 (copy), PlayerContextualMenuStore (copy), v94 (copy), p15 (copy), p16 (copy), PlayerListVisibilityStore (copy)
			local v157 = ContextMenuController.buildMenuData(p14, PlayerContextualMenuStore.closeContextMenu, v94)

			if p14.Parent == nil then
				return
			end

			v157.anchorPosition = p15

			if PlayerContextualMenuStore.setMenuDataIfCurrent(v157, p16) and v94 then
				PlayerListVisibilityStore.setVisible(false)
			end
		end)
	end)

	local PlayerListInitialVisibleState = require(scriptParent.PlayerListInitialVisibleState)

	PlayerListVisibilityStore.reset()
	PlayerListVisibilityStore.setVisible(PlayerListInitialVisibleState())
	p11.SetVisibleChangedEvent = Instance.new("BindableEvent")
	p11.VisibilityChangedEvent = Instance.new("BindableEvent")

	local function setupVisibilityEffect() -- line: 398
		-- upvalues: p11 (copy), Signals (copy), PlayerListVisibilityStore (copy)
		local u139 = false

		p11._reskinSetVisibleEffect = Signals.createEffect(function(p17) -- line: 400
			-- upvalues: PlayerListVisibilityStore (copy), u139 (ref), p11 (copy)
			local v159 = PlayerListVisibilityStore.getVisible(p17)

			if u139 then
				p11.SetVisibleChangedEvent:Fire(v159)

				return
			end

			u139 = true
		end)

		local u140 = false

		p11._reskinVisibilityEffect = Signals.createEffect(function(p18) -- line: 410
			-- upvalues: PlayerListVisibilityStore (copy), u140 (ref), p11 (copy)
			local v161 = PlayerListVisibilityStore.getEffectiveVisible(p18)

			if u140 then
				p11.VisibilityChangedEvent:Fire(v161)

				return
			end

			u140 = true
		end)
	end

	local TopBarHeight = Constants3.TopBarHeight

	local function resolveContainerProps() -- line: 423
		-- upvalues: v94 (copy), Constants3 (copy), TopBarHeight (copy)
		if v94 then
			local CurrentCamera = workspace.CurrentCamera
			local v142 = if not CurrentCamera then Vector2.new(0, 0) else CurrentCamera.ViewportSize

			if v142.Y > v142.X then
				local v143 = Constants3.ApplyDisplayScale(Constants3.ScreenSideOffset)

				return {
					tag = "auto-xy",
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, v143, 0.5, TopBarHeight / 2),
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

		return {
			tag = "auto-xy",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -4, 0, 4 + TopBarHeight),
			Size = UDim2.fromOffset(0, 0)
		}
	end

	local v100 = resolveContainerProps()
	local v101 = React.createElement(FoundationProvider, {
		theme = Theme.Dark,
		device = v95,
		preferences = {
			preferredTransparency = UserGameSettings.PreferredTransparency
		}
	}, {
		Scrim = React.createElement(LeaderboardScrim, {
			isSmallTouchDevice = v94
		}),
		Container = React.createElement(Foundation.View, v100, {
			ReskinContainer = React.createElement(PlayerListContainer, {
				leaderboardStore = LeaderboardStoreInstanceManager.getLeaderboardStoreInstance,
				TopBarConstants = Constants3,
				isTenFoot = v91
			}, {
				PlayerListPanel = React.createElement(PlayerListPanel, {
					isSmallTouchDevice = v94,
					title = v90
				})
			})
		}),
		ContextMenu = React.createElement(PlayerContextualMenuView, {
			isSmallTouchDevice = v94
		})
	})

	local function setupPlayerInfoRequests() -- line: 491
		-- upvalues: Players (copy), PlayerRelationshipStore (copy), MakePlayerInfoRequests (copy), p11 (copy), PlayerIconInfoStore2 (copy), BlockingUtility (copy), FFlagBadgeVisibilitySettingEnabled (copy), RobloxReplicatedStorage (copy)
		local t3 = {
			getState = function() -- line: 493
				-- upvalues: Players (copy)
				return {
					players = Players:GetPlayers()
				}
			end,
			dispatch = function(_, p20) -- line: 496
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

		local function request(p21) -- line: 511
			-- upvalues: MakePlayerInfoRequests (copy), t3 (copy)
			MakePlayerInfoRequests(p21)(t3)
		end

		for _, player in ipairs(Players:GetPlayers()) do
			MakePlayerInfoRequests(player)(t3)
		end

		p11._reskinPlayerAddedConn = Players.PlayerAdded:Connect(request)
		p11._reskinPlayerRemovingConn = Players.PlayerRemoving:Connect(function(player) -- line: 518
			-- upvalues: PlayerIconInfoStore2 (copy), PlayerRelationshipStore (copy)
			PlayerIconInfoStore2.removePlayer(player.UserId)
			PlayerRelationshipStore.removePlayer(player.UserId)
		end)
		p11._reskinBlockedStatusConn = BlockingUtility:GetBlockedStatusChangedEvent():Connect(function(p22, p23) -- line: 523
			-- upvalues: PlayerRelationshipStore (copy)
			local num = tonumber(p22)

			if num then
				PlayerRelationshipStore.patchPlayerRelationship(num, {
					isBlocked = p23
				})
			end
		end)
		p11._reskinFriendStatusConn = Players.LocalPlayer.FriendStatusChanged:Connect(function(p24, p25) -- line: 529
			-- upvalues: PlayerRelationshipStore (copy)
			PlayerRelationshipStore.patchPlayerRelationship(p24.UserId, {
				friendStatus = p25
			})
		end)

		if FFlagBadgeVisibilitySettingEnabled then
			task.spawn(function() -- line: 535
				-- upvalues: RobloxReplicatedStorage (copy), p11 (copy), Players (copy), MakePlayerInfoRequests (copy), t3 (copy)
				p11._reskinProfileSettingsConn = RobloxReplicatedStorage:WaitForChild("SendPlayerProfileSettings", 1e999).OnClientEvent:Connect(function(p26) -- line: 538
					-- upvalues: Players (copy), MakePlayerInfoRequests (copy), t3 (copy)
					local PlayerByUserId = Players:GetPlayerByUserId((tonumber(p26)))

					if PlayerByUserId then
						MakePlayerInfoRequests(PlayerByUserId)(t3)
					end
				end)
			end)
		end
	end
	local function teardownPlayerInfoRequests() -- line: 548
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
	local function mountReskin() -- line: 572
		-- upvalues: CoreGui (copy), ReactRoblox (copy), v101 (copy), p11 (copy), setupPlayerInfoRequests (copy)
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "PlayerListReskin"
		ScreenGui.AutoLocalize = false
		ScreenGui.IgnoreGuiInset = true
		ScreenGui.DisplayOrder = _G.__TESTEZ_RUNNING_TEST__ ~= true and 1 or -1
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		ScreenGui.Parent = CoreGui

		local v149 = ReactRoblox.createRoot(ScreenGui)

		v149:render(v101)
		p11._reskinRoot = v149
		p11._reskinScreenGui = ScreenGui
		setupPlayerInfoRequests()
	end

	p11.topBarEnabled = true
	p11.coreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)
	p11._reskin = {
		mountReskin = mountReskin,
		unmountReskin = function() -- line: 591
			-- upvalues: teardownPlayerInfoRequests (copy), p11 (copy)
			teardownPlayerInfoRequests()

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

	p11._reskinCoreGuiConn = StarterGui.CoreGuiChangedSignal:Connect(function(p27, p28) -- line: 629
		-- upvalues: p11 (copy)
		if p27 == Enum.CoreGuiType.All or p27 == Enum.CoreGuiType.PlayerList then
			p11.coreGuiEnabled = p28
			p11:SetTopBarEnabled(p11.topBarEnabled)
		end
	end)
	ContextActionService:BindCoreAction("RbxPlayerListToggle", function(_, p30, _) -- line: 636
		-- upvalues: p11 (copy), v94 (copy), GuiService (copy)
		if not p11.mounted then
			return Enum.ContextActionResult.Pass
		end

		if v94 then
			return Enum.ContextActionResult.Pass
		end

		if GuiService.MenuIsOpen then
			return Enum.ContextActionResult.Pass
		end

		if p30 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		p11:SetVisibility(not p11:GetVisibility())

		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.Tab)

	if FFlagTopBarSignalizeSetCores then
		p11._reskinTopBarEffect = Signals.createEffect(function(p32) -- line: 654
			-- upvalues: InExperienceTopBar (copy), p11 (copy)
			local GetTopBarStore = InExperienceTopBar.Stores.GetTopBarStore

			if GetTopBarStore then
				p11:SetTopBarEnabled(GetTopBarStore(p32).getTopBarCoreGuiEnabled(p32))
			end
		end)
	end

	return p11
end
function t1.GetVisibility(p33) -- line: 665
	-- upvalues: FFlagPlayerListReskin (copy), PlayerListVisibilityStore (copy)
	if FFlagPlayerListReskin then
		return PlayerListVisibilityStore.getEffectiveVisible(false)
	end

	return p33.store:getState().displayOptions.isVisible
end

if FFlagAddNewPlayerListFocusNav then
	function t1.GetVisibilityChangedEvent(p34) -- line: 673
		return p34.VisibilityChangedEvent
	end
end

function t1.GetSetVisible(p35) -- line: 678
	-- upvalues: FFlagPlayerListReskin (copy), PlayerListVisibilityStore (copy)
	if FFlagPlayerListReskin then
		return PlayerListVisibilityStore.getVisible(false)
	end

	return p35.store:getState().displayOptions.setVisible
end
function t1.GetSetVisibleChangedEvent(p36) -- line: 685
	return p36.SetVisibleChangedEvent
end
function t1.SetVisibility(p37, p38) -- line: 689
	-- upvalues: FFlagPlayerListReskin (copy), PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy), SetPlayerListVisibility (copy)
	if FFlagPlayerListReskin then
		if not p38 then
			PlayerContextualMenuStore.closeContextMenu()
		end

		PlayerListVisibilityStore.setVisible(p38)

		return
	end

	p37.store:dispatch(SetPlayerListVisibility(p38))
end
function t1.HideTemp(p39, p40, p41) -- line: 700
	-- upvalues: FFlagPlayerListReskin (copy), PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy), SetTempHideKey (copy)
	if FFlagPlayerListReskin then
		if p41 and PlayerContextualMenuStore.getMenuData(false) ~= nil then
			PlayerContextualMenuStore.closeContextMenu()
		end

		PlayerListVisibilityStore.setTempHide(p40, p41)

		return
	end

	if p41 == false then
		p41 = nil
	end

	p39.store:dispatch(SetTempHideKey(p40, p41))
end
function t1.SetTopBarEnabled(p42, p43) -- line: 719
	-- upvalues: FFlagPlayerListReskin (copy), LeaderboardStoreInstanceManager (copy)
	if FFlagPlayerListReskin then
		p42.topBarEnabled = p43

		local v116 = p42.coreGuiEnabled and p43

		if v116 and not p42.mounted then
			LeaderboardStoreInstanceManager.createLeaderboardStoreInstance()
			p42._reskin.setupVisibilityEffect()
			p42._reskin.mountReskin()
			p42.mounted = true

			return
		end

		if not v116 and p42.mounted then
			p42._reskin.unmountReskin()
			LeaderboardStoreInstanceManager.cleanUpInstance()
			p42.mounted = false
		end

		return
	end

	p42.topBarEnabled = p43
	p42:_updateMounted()
end
function t1.SetMinimized(p44, p45) -- line: 739
	-- upvalues: FFlagPlayerListReskin (copy), SetMinimized (copy)
	if FFlagPlayerListReskin then
		return
	end

	p44.store:dispatch(SetMinimized(p45))
end

return t1
