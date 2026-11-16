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
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local ColorMode = Foundation.Enums.ColorMode
local Constants = UIBlox.App.Style.Constants
local ApolloClient = require(CoreGui.RobloxGui.Modules.ApolloClient)
local ApolloClient2 = require(CorePackages.Packages.ApolloClient)
local ApolloProvider = ApolloClient2.ApolloProvider
local parent = script.Parent
local Signals = require(CorePackages.Packages.Signals)
local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)

local Reducer = require(parent.Reducers.Reducer)
local GlobalConfig = require(parent.GlobalConfig)
local PlayerListSwitcher = require(parent.PlayerListSwitcher)
local MakePlayerInfoRequests = require(parent.Thunks.MakePlayerInfoRequests)

local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local PlatformLeaderboardsClient = require(CorePackages.Workspace.Packages.PlatformLeaderboardsClient)
local PlayerIconInfoStore = require(CorePackages.Workspace.Packages.PlayerIconInfoStore)
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local constants = PlayerList.Common.Constants
local PlayerRelationshipStore = PlayerList.PlayerRelationshipStore

local SetPlayerListEnabled = require(parent.Actions.SetPlayerListEnabled)
local SetPlayerListVisibility = require(parent.Actions.SetPlayerListVisibility)
local SetTempHideKey = require(parent.Actions.SetTempHideKey)
local SetTenFootInterface = require(parent.Actions.SetTenFootInterface)
local SetSmallTouchDevice = require(parent.Actions.SetSmallTouchDevice)
local SetIsUsingGamepad = require(parent.Actions.SetIsUsingGamepad)
local SetMinimized = require(parent.Actions.SetMinimized)
local SetSubjectToChinaPolicies = require(parent.Actions.SetSubjectToChinaPolicies)
local SetSettings = require(parent.Actions.SetSettings)

if not Players.LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end

local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav
local FStringPlayerListOverrideType = require(parent.Flags.FStringPlayerListOverrideType)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagReplacePlayerIconRoduxWithSignal = SharedFlags.FFlagReplacePlayerIconRoduxWithSignal

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagBadgeVisibilitySettingEnabled = SharedFlags2.FFlagBadgeVisibilitySettingEnabled

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags3.FFlagLuaSupportMicroGamepadPreferredInput
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local FFlagEnableMobilePlayerListOnGamepad = PlayerList.Flags.FFlagEnableMobilePlayerListOnGamepad
local isReskinConsoleMobileRoute = PlayerList.Common.isReskinConsoleMobileRoute
local FFlagPlayerListUseMobileOnSmallDisplay = PlayerList.Flags.FFlagPlayerListUseMobileOnSmallDisplay
local FFlagPlayerListIgnoreDevGamepadBindings = PlayerList.Flags.FFlagPlayerListIgnoreDevGamepadBindings

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagPlatformLeaderboardPersistStoreOnRemount = SharedFlags4.FFlagPlatformLeaderboardPersistStoreOnRemount

local FFlagPlayerListReskin = PlayerList.Flags.FFlagPlayerListReskin
local FFlagPlayerListPersistVisibility = require(parent.Flags.FFlagPlayerListPersistVisibility)

local PlayerListContainer = PlayerList.Container.PlayerListContainer
local LeaderboardStoreInstanceManager = PlayerList.LeaderboardStoreInstanceManager
local PlayerListVisibilityStore = PlayerList.PlayerListVisibilityStore
local PlayerContextualMenuStore = PlayerList.PlayerContextualMenuStore
local playerIconInfoStore = PlayerIconInfoStore.PlayerIconInfoStore

local FFlagTopBarSignalizeSetCores = InExperienceTopBar.Flags.FFlagTopBarSignalizeSetCores

local function isUnderTestEZ(): boolean -- 1 equivalent call inferred from this helper
	return _G.__TESTEZ_RUNNING_TEST__ == true
end

local function isTouchOrGamepadInput(p) -- 4 equivalent calls inferred from this helper
	return p == Enum.PreferredInput.Touch
		or p == Enum.PreferredInput.Gamepad
		or FFlagLuaSupportMicroGamepadPreferredInput and p == Enum.PreferredInput.MicroGamepad
end

local function isCurrentReskinConsoleMobileRoute(preferredInput) -- 2 equivalent calls inferred from this helper
	return isReskinConsoleMobileRoute({
		displaySize = GuiService.ViewportDisplaySize,
		preferredInput = preferredInput
	})
end

local function resolveIsTenFoot(preferredInput) -- 4 equivalent calls inferred from this helper
	if isCurrentReskinConsoleMobileRoute(preferredInput) or FFlagEnableMobilePlayerListOnConsole then -- inferred equivalent call
		return false
	end

	return (TenFootInterface:IsEnabled())
end

local function isLargeConsoleLayout(preferredInput) -- 6 equivalent calls inferred from this helper
	if isCurrentReskinConsoleMobileRoute(preferredInput) then -- inferred equivalent call
		return true
	end

	if
		GuiService.ViewportDisplaySize == Enum.DisplaySize.Large
		and (preferredInput == Enum.PreferredInput.Touch or preferredInput == Enum.PreferredInput.Gamepad or FFlagLuaSupportMicroGamepadPreferredInput and preferredInput == Enum.PreferredInput.MicroGamepad)
	then
		return FFlagEnableMobilePlayerListOnConsole
	end

	return false
end

local function isSmallTouchScreen(preferredInput) -- 1 equivalent call inferred from this helper
	local v = FFlagPlayerListUseMobileOnSmallDisplay and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small
	return Utility:IsSmallTouchScreen()
		or isLargeConsoleLayout(preferredInput) -- inferred equivalent call
		or v and isTouchOrGamepadInput(preferredInput) -- inferred equivalent call
		or FStringPlayerListOverrideType == "mobile"
end

local function setupSettings(store)
	local function updateSettings() -- 3 equivalent calls inferred from this helper
		store:dispatch(SetSettings({
			reducedMotion = UserGameSettings.ReducedMotion,
			preferredTransparency = UserGameSettings.PreferredTransparency
		}))
	end

	updateSettings() -- inferred equivalent call
	UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
		updateSettings() -- inferred equivalent call
	end)
	UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(function()
		updateSettings() -- inferred equivalent call
	end)
end

local PlayerListController = {}
PlayerListController.__index = PlayerListController

function PlayerListController.new()
	local object = setmetatable({}, PlayerListController)

	if FFlagPlayerListReskin then
		return object:_setupReskin()
	end

	if GlobalConfig.propValidation then
		Roact.setGlobalConfig({ propValidation = true })
	end

	if GlobalConfig.elementTracing then
		Roact.setGlobalConfig({ elementTracing = true })
	end

	object.layerCollectorRef = Roact.createRef()

	object.store = Rodux.Store.new(Reducer, nil, { Rodux.thunkMiddleware })

	setupSettings(object.store)

	if not StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) then
		object.store:dispatch(SetPlayerListEnabled(false))
	end

	coroutine.wrap(function()
		local store = object.store
		local preferredInput = UserInputService.PreferredInput
		local v = FFlagPlayerListUseMobileOnSmallDisplay and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small
		store:dispatch(SetSmallTouchDevice(Utility:IsSmallTouchScreen() or isLargeConsoleLayout(preferredInput) or v and isTouchOrGamepadInput(preferredInput) or FStringPlayerListOverrideType == "mobile")) -- inferred equivalent call
	end)()

	object.store:dispatch(SetTenFootInterface(resolveIsTenFoot(UserInputService.PreferredInput))) -- inferred equivalent call

	coroutine.wrap(function()
		object.store:dispatch(SetSubjectToChinaPolicies(CachedPolicyService:IsSubjectToChinaPolicies()))
	end)()

	object:_trackEnabled()

	local appStyleForUiModeStyleProvider = {
		themeName = ColorMode.Dark,
		fontName = Constants.FontName.Gotham
	}

	object.root = Roact.createElement(RoactRodux.StoreProvider, { store = object.store }, {
		Switcher = Roact.createElement(PlayerListSwitcher, {
			appStyleForUiModeStyleProvider = appStyleForUiModeStyleProvider,
			setLayerCollectorEnabled = function(enabled)
				if not object.layerCollectorRef.current then
					return
				end

				object.layerCollectorRef.current.Enabled = enabled
			end
		})
	})

	object.root = Roact.createElement(ApolloProvider, { client = ApolloClient }, {
		StoreProvider = object.root
	})

	function object._setIsUsingGamepad()
		local lastInputType = UserInputService:GetLastInputType()
		local v = lastInputType and lastInputType.Name:find("Gamepad")
		object.store:dispatch(SetIsUsingGamepad(v ~= nil))
	end

	function object._mountLeaderboardStore()
		LeaderboardStoreInstanceManager.createLeaderboardStoreInstance()
	end

	function object._unmountLeaderboardStore()
		LeaderboardStoreInstanceManager.cleanUpInstance()
	end

	object._unmountPlayerIconInfoStore = FFlagReplacePlayerIconRoduxWithSignal and function()
		playerIconInfoStore.cleanUp()
	end or nil

	object._mountLeaderboardStore()
	object._setIsUsingGamepad()
	object.root = Roact.createElement(
		PlayerListContainer,
		{
			leaderboardStore = LeaderboardStoreInstanceManager.getLeaderboardStoreInstance,
			TopBarConstants = require(RobloxGui.Modules.TopBar.Constants),
			isTenFoot = resolveIsTenFoot(UserInputService.PreferredInput) -- inferred equivalent call
		},
		{ PlayerListRoot = object.root }
	)

	object.root = Roact.createElement("ScreenGui", {
		AutoLocalize = false,
		IgnoreGuiInset = true,
		DisplayOrder = 1,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		[Roact.Ref] = object.layerCollectorRef
	}, { PlayerListRoot = object.root })

	object.element = Roact.mount(object.root, CoreGui, "PlayerList")

	object.topBarEnabled = true
	object.mounted = true
	object.coreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)
	object:_updateMounted()

	object.SetVisibleChangedEvent = Instance.new("BindableEvent")

	if FFlagAddNewPlayerListFocusNav then
		object.VisibilityChangedEvent = Instance.new("BindableEvent")
	end

	if FFlagTopBarSignalizeSetCores then
		object.disposeEffect = Signals.createEffect(function(p)
			local getTopBarStore = InExperienceTopBar.Stores.GetTopBarStore

			if getTopBarStore then
				object:SetTopBarEnabled(getTopBarStore(p).getTopBarCoreGuiEnabled(p))
			end
		end)
	end

	object.store.changed:connect(function(p, p2)
		if p.displayOptions.setVisible ~= p2.displayOptions.setVisible then
			object.SetVisibleChangedEvent:Fire(p.displayOptions.setVisible)
		end

		if FFlagAddNewPlayerListFocusNav and p.displayOptions.isVisible ~= p2.displayOptions.isVisible then
			object.VisibilityChangedEvent:Fire(p.displayOptions.isVisible)
		end
	end)

	return object
end

function PlayerListController:_updateMounted()
	if not resolveIsTenFoot(UserInputService.PreferredInput) then -- inferred equivalent call
		local topBarEnabled = self.coreGuiEnabled and self.topBarEnabled

		if topBarEnabled and not self.mounted then
			self._mountLeaderboardStore()
			self._setIsUsingGamepad()
			self.element = Roact.mount(self.root, CoreGui, "PlayerList")
			self.mounted = true
		elseif not topBarEnabled and self.mounted then
			Roact.unmount(self.element)
			self._unmountLeaderboardStore()

			if self._unmountPlayerIconInfoStore then
				self._unmountPlayerIconInfoStore()
			end

			self.mounted = false

			if self.inspector then
				self.inspector:destroy()
				self.inspector = nil
			end
		end
	end
end

function PlayerListController:_trackEnabled()
	StarterGui.CoreGuiChangedSignal:Connect(function(p, coreGuiEnabled)
		if p == Enum.CoreGuiType.All or p == Enum.CoreGuiType.PlayerList then
			self.coreGuiEnabled = coreGuiEnabled
			self:_updateMounted()
			self.store:dispatch(SetPlayerListEnabled(coreGuiEnabled))

			if FFlagPlayerListIgnoreDevGamepadBindings and not coreGuiEnabled then
				GuiService:SetMenuIsOpen(false, constants.PLAYER_LIST_MENU)
			end
		end
	end)
end

if FFlagAddNewPlayerListMobileFocusNav then
	function PlayerListController.GetIsModal(p)
		if not FFlagPlayerListReskin then
			return p.store:getState().displayOptions.isSmallTouchDevice
		end

		return isSmallTouchScreen(UserInputService.PreferredInput) -- inferred equivalent call
	end
end

function PlayerListController:_setupReskin()
	local React = require(CorePackages.Packages.React)
	local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
	local Constants2 = require(RobloxGui.Modules.TopBar.Constants)
	local Foundation2 = require(CorePackages.Packages.Foundation)
	local foundationProvider = Foundation2.FoundationProvider
	local colorMode = Foundation2.Enums.ColorMode
	local device = Foundation2.Enums.Device
	local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

	local playerListPanel = PlayerList.Presentation.PlayerListPanel
	local playerContextualMenuView = PlayerList.Presentation.PlayerContextualMenuView
	local leaderboardScrim = PlayerList.Presentation.LeaderboardScrim
	local ContextMenuController = require(parent.ContextMenuController)

	local function translate(p, p2) -- 1 equivalent call inferred from this helper
		local success, result = pcall(function()
			return RobloxTranslator:FormatByKey(p)
		end)

		if success and result and result ~= "" then
			return result
		end

		return p2
	end

	local title = translate("InGame.PlayerList.Leaderboard", "Leaderboard") -- inferred equivalent call
	local preferredInput = UserInputService.PreferredInput
	local isTenFoot = resolveIsTenFoot(preferredInput) -- inferred equivalent call
	local v = FFlagPlayerListUseMobileOnSmallDisplay and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small
	local isSmallTouchDevice = Utility:IsSmallTouchScreen()
		or isLargeConsoleLayout(preferredInput) -- inferred equivalent call
		or v and isTouchOrGamepadInput(preferredInput) -- inferred equivalent call
		or FStringPlayerListOverrideType == "mobile"
	local device2

	if isTenFoot then
		device2 = device.Console
	elseif isLargeConsoleLayout(preferredInput) then -- inferred equivalent call
		device2 = device.Console
	else
		device2 = device.Unknown
	end

	local function restoreVisibilityOnDismiss()
		if PlayerContextualMenuStore.takeSuppressNextDismissRestore() then
			return
		end

		PlayerListVisibilityStore.setVisible(true)
	end

	if isSmallTouchDevice then
		PlayerContextualMenuStore.setOnDismiss(restoreVisibilityOnDismiss)
	end

	PlayerContextualMenuStore.setContextMenuOpener(function(p, anchorPosition, p2, p3)
		task.spawn(function()
			local menuData = ContextMenuController.buildMenuData(
				p,
				PlayerContextualMenuStore.closeContextMenu,
				isSmallTouchDevice,
				p3
			)

			if p.Parent == nil then
				return
			end

			menuData.anchorPosition = anchorPosition
			PlayerContextualMenuStore.setMenuDataIfCurrent(menuData, p2)
		end)
	end)

	local PlayerListInitialVisibleState = require(parent.PlayerListInitialVisibleState)
	PlayerListVisibilityStore.reset()

	if FFlagPlatformLeaderboardPersistStoreOnRemount then
		PlatformLeaderboardsClient.reset()
	end

	local function setStorePersistVisibility() -- 3 equivalent calls inferred from this helper
		PlayerListVisibilityStore.setShouldPersistVisibility(FFlagPlayerListPersistVisibility and not (isSmallTouchDevice or isTenFoot))
	end

	setStorePersistVisibility() -- inferred equivalent call
	PlayerListVisibilityStore.setVisible(PlayerListInitialVisibleState())

	self.SetVisibleChangedEvent = Instance.new("BindableEvent")
	self.VisibilityChangedEvent = Instance.new("BindableEvent")

	local function setupVisibilityEffect()
		local flag = false
		self._reskinSetVisibleEffect = Signals.createEffect(function(p)
			local visible = PlayerListVisibilityStore.getVisible(p)

			if flag then
				self.SetVisibleChangedEvent:Fire(visible)
			else
				flag = true
			end
		end)

		local flag2 = false
		self._reskinVisibilityEffect = Signals.createEffect(function(p)
			local effectiveVisible = PlayerListVisibilityStore.getEffectiveVisible(p)

			if flag2 then
				self.VisibilityChangedEvent:Fire(effectiveVisible)
			else
				flag2 = true
			end
		end)
	end

	local topBarHeight = Constants2.TopBarHeight

	local function computeMobileTopInset() -- 1 equivalent call inferred from this helper
		local MOBILE_EDGE_GAP = constants.MOBILE_EDGE_GAP
		return (math.max(MOBILE_EDGE_GAP, Constants2.ApplyDisplayScale(MOBILE_EDGE_GAP)))
	end

	local function computeMobilePosition()
		return UDim2.new(0.5, 0, 0, topBarHeight + computeMobileTopInset()) -- inferred equivalent call
	end

	local binding, v2 = React.createBinding(computeMobilePosition())
	local function resolveContainerProps()
		if isSmallTouchDevice then
			return {
				AnchorPoint = Vector2.new(0.5, 0),
				Position = binding,
				Size = UDim2.fromOffset(0, 0),
				tag = "auto-xy"
			}
		end

		local v3 = math.max(4, Constants2.ApplyDisplayScale(4))
		return {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -v3, 0, v3 + topBarHeight),
			Size = UDim2.fromOffset(0, 0),
			tag = "auto-xy"
		}
	end

	local function buildReskinElement()
		return React.createElement(foundationProvider, {
			colorMode = colorMode.Dark,
			device = device2,
			preferences = { preferredTransparency = UserGameSettings.PreferredTransparency }
		}, {
			Scrim = React.createElement(leaderboardScrim, {
				isSmallTouchDevice = isSmallTouchDevice
			}),
			Container = React.createElement(Foundation2.View, resolveContainerProps(), {
				ReskinContainer = React.createElement(
					PlayerListContainer,
					{
						leaderboardStore = LeaderboardStoreInstanceManager.getLeaderboardStoreInstance,
						TopBarConstants = Constants2,
						isTenFoot = isTenFoot
					},
					{
						PlayerListPanel = React.createElement(playerListPanel, {
							isSmallTouchDevice = isSmallTouchDevice,
							title = title
						})
					}
				)
			}),
			ContextMenu = React.createElement(playerContextualMenuView, {
				isSmallTouchDevice = isSmallTouchDevice
			})
		})
	end

	local function setupPlayerInfoRequests()
		local v3 = {
			getState = function()
				return { players = Players:GetPlayers() }
			end,
			dispatch = function(self, data)
				if type(data) ~= "table" then
					return
				end

				if data.type == "SetPlayerIsBlocked" and data.userId then
					PlayerRelationshipStore.patchPlayerRelationship(data.userId, {
						isBlocked = data.isBlocked
					})
				elseif data.type == "SetPlayerFriendStatus" and data.userId then
					PlayerRelationshipStore.patchPlayerRelationship(data.userId, {
						friendStatus = data.friendStatus
					})
				end
			end
		}

		local function request(p) -- 2 equivalent calls inferred from this helper
			MakePlayerInfoRequests(p)(v3)
		end

		for _, v4 in ipairs(Players:GetPlayers()) do
			request(v4) -- inferred equivalent call
		end

		self._reskinPlayerAddedConn = Players.PlayerAdded:Connect(request)
		self._reskinPlayerRemovingConn = Players.PlayerRemoving:Connect(function(player)
			playerIconInfoStore.removePlayer(player.UserId)
			PlayerRelationshipStore.removePlayer(player.UserId)
		end)
		local function refreshOpenMenuForPlayer(p, p2) -- 1 equivalent call inferred from this helper
			local menuData = PlayerContextualMenuStore.getMenuData(false)

			if menuData ~= nil and menuData.player == p then
				PlayerContextualMenuStore.openContextMenu(p, menuData.anchorPosition, p2)
			end
		end

		self._reskinBlockedStatusConn = BlockingUtility:GetBlockedStatusChangedEvent():Connect(function(p, isBlocked)
			local v4 = tonumber(p)

			if v4 then
				PlayerRelationshipStore.patchPlayerRelationship(v4, { isBlocked = isBlocked })
			end
		end)
		self._reskinFriendStatusConn = Players.LocalPlayer.FriendStatusChanged:Connect(function(p, friendStatus)
			PlayerRelationshipStore.patchPlayerRelationship(p.UserId, {
				friendStatus = friendStatus
			})
			refreshOpenMenuForPlayer(p, friendStatus) -- inferred equivalent call
		end)

		if FFlagBadgeVisibilitySettingEnabled then
			task.spawn(function()
				self._reskinProfileSettingsConn = RobloxReplicatedStorage:WaitForChild(
					"SendPlayerProfileSettings",
					1e999
				).OnClientEvent:Connect(function(p)
					local playerByUserId = Players:GetPlayerByUserId((tonumber(p)))

					if playerByUserId then
						request(playerByUserId) -- inferred equivalent call
					end
				end)
			end)
		end
	end

	local function teardownPlayerInfoRequests()
		if self._reskinPlayerAddedConn then
			self._reskinPlayerAddedConn:Disconnect()
			self._reskinPlayerAddedConn = nil
		end

		if self._reskinPlayerRemovingConn then
			self._reskinPlayerRemovingConn:Disconnect()
			self._reskinPlayerRemovingConn = nil
		end

		if self._reskinBlockedStatusConn then
			self._reskinBlockedStatusConn:Disconnect()
			self._reskinBlockedStatusConn = nil
		end

		if self._reskinFriendStatusConn then
			self._reskinFriendStatusConn:Disconnect()
			self._reskinFriendStatusConn = nil
		end

		if self._reskinProfileSettingsConn then
			self._reskinProfileSettingsConn:Disconnect()
			self._reskinProfileSettingsConn = nil
		end

		PlayerRelationshipStore.cleanUp()
	end

	local function mountReskin()
		setStorePersistVisibility() -- inferred equivalent call
		local playerListReskin = Instance.new("ScreenGui")
		playerListReskin.Name = "PlayerListReskin"
		playerListReskin.AutoLocalize = false
		playerListReskin.IgnoreGuiInset = true

		playerListReskin.DisplayOrder = isUnderTestEZ() and -1 or 1 -- inferred equivalent call
		playerListReskin.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		playerListReskin.Parent = CoreGui
		local root = ReactRoblox.createRoot(playerListReskin)
		root:render(buildReskinElement())
		self._reskinRoot = root
		self._reskinScreenGui = playerListReskin

		if isSmallTouchDevice then
			local function connectViewport(currentCamera)
				if self._reskinViewportConn then
					self._reskinViewportConn:Disconnect()
					self._reskinViewportConn = nil
				end

				if currentCamera then
					self._reskinViewportConn = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
						v2(computeMobilePosition())
					end)
					v2(computeMobilePosition())
				end
			end
			self._reskinCameraConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
				connectViewport(workspace.CurrentCamera)
			end)
			connectViewport(workspace.CurrentCamera)
		end

		setupPlayerInfoRequests()
	end

	local function unmountReskin()
		PlayerListVisibilityStore.setShouldPersistVisibility(false)
		teardownPlayerInfoRequests()

		if self._reskinCameraConn then
			self._reskinCameraConn:Disconnect()
			self._reskinCameraConn = nil
		end

		if self._reskinViewportConn then
			self._reskinViewportConn:Disconnect()
			self._reskinViewportConn = nil
		end

		if self._reskinRoot then
			self._reskinRoot:unmount()
			self._reskinRoot = nil
		end

		if self._reskinScreenGui then
			self._reskinScreenGui:Destroy()
			self._reskinScreenGui = nil
		end

		if self._reskinVisibilityEffect then
			self._reskinVisibilityEffect()
			self._reskinVisibilityEffect = nil
		end

		if self._reskinSetVisibleEffect then
			self._reskinSetVisibleEffect()
			self._reskinSetVisibleEffect = nil
		end
	end

	self.topBarEnabled = true
	self.coreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)

	self._reskin = {
		mountReskin = mountReskin,
		unmountReskin = unmountReskin,
		setupVisibilityEffect = setupVisibilityEffect
	}

	if self.coreGuiEnabled then
		LeaderboardStoreInstanceManager.createLeaderboardStoreInstance()
		setupVisibilityEffect()
		mountReskin()
		self.mounted = true
	else
		self.mounted = false
	end

	if FFlagEnableMobilePlayerListOnGamepad then
		local function onPreferredInputChanged(preferredInput2)
			local v3 = FFlagPlayerListUseMobileOnSmallDisplay
				and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small
			local v4 = Utility:IsSmallTouchScreen()
				or isLargeConsoleLayout(preferredInput2) -- inferred equivalent call
				or v3 and isTouchOrGamepadInput(preferredInput2) -- inferred equivalent call
				or FStringPlayerListOverrideType == "mobile"

			if v4 == isSmallTouchDevice then
				return
			end

			if PlayerContextualMenuStore.getMenuData(false) ~= nil then
				PlayerContextualMenuStore.closeContextMenu()
			end

			isSmallTouchDevice = v4
			local largeConsoleLayout = isLargeConsoleLayout(preferredInput2) -- inferred equivalent call
			local v5

			if largeConsoleLayout then
				v5 = device.Console
			else
				v5 = device.Unknown
			end

			device2 = v5

			local setOnDismiss = PlayerContextualMenuStore.setOnDismiss
			local v6

			if isSmallTouchDevice then
				v6 = restoreVisibilityOnDismiss
			end

			setOnDismiss(v6)

			if self.mounted then
				unmountReskin()
				setupVisibilityEffect()
				mountReskin()
			end

			setStorePersistVisibility() -- inferred equivalent call
			local playerListInitialVisibleState = PlayerListInitialVisibleState(preferredInput2)
			PlayerListVisibilityStore.setVisible(playerListInitialVisibleState)
			PlayerListVisibilityStore.setTempHideSnapshot(playerListInitialVisibleState)
		end

		self._onPreferredInputChanged = onPreferredInputChanged
		self._reskinPreferredInputConn = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
			onPreferredInputChanged(UserInputService.PreferredInput)
		end)
	end

	self._reskinCoreGuiConn = StarterGui.CoreGuiChangedSignal:Connect(function(p, coreGuiEnabled)
		if p == Enum.CoreGuiType.All or p == Enum.CoreGuiType.PlayerList then
			self.coreGuiEnabled = coreGuiEnabled
			self:SetTopBarEnabled(self.topBarEnabled)
		end
	end)

	ContextActionService:BindCoreAction("RbxPlayerListToggle", function(_, p, _)
		if not self.mounted or isSmallTouchDevice or GuiService.MenuIsOpen or p ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		self:SetVisibility(not self:GetVisibility())
		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.Tab)

	if FFlagTopBarSignalizeSetCores then
		self._reskinTopBarEffect = Signals.createEffect(function(p)
			local getTopBarStore = InExperienceTopBar.Stores.GetTopBarStore

			if getTopBarStore then
				self:SetTopBarEnabled(getTopBarStore(p).getTopBarCoreGuiEnabled(p))
			end
		end)
	end

	return self
end

function PlayerListController:GetVisibility()
	if FFlagPlayerListReskin then
		return PlayerListVisibilityStore.getEffectiveVisible(false)
	end

	return self.store:getState().displayOptions.isVisible
end

if FFlagAddNewPlayerListFocusNav then
	function PlayerListController.GetVisibilityChangedEvent(p)
		return p.VisibilityChangedEvent
	end
end

function PlayerListController.GetSetVisible(p)
	if FFlagPlayerListReskin then
		return PlayerListVisibilityStore.getVisible(false)
	end

	return p.store:getState().displayOptions.setVisible
end

function PlayerListController.GetSetVisibleChangedEvent(p)
	return p.SetVisibleChangedEvent
end

function PlayerListController:SetVisibility(p)
	if not FFlagPlayerListReskin then
		self.store:dispatch(SetPlayerListVisibility(p))
		return
	end

	if not p then
		PlayerContextualMenuStore.closeContextMenu()
	end

	PlayerListVisibilityStore.setVisible(p)
end

function PlayerListController.HideTemp(p, p2, p3)
	if FFlagPlayerListReskin then
		if p3 and PlayerContextualMenuStore.getMenuData(false) ~= nil then
			PlayerContextualMenuStore.closeContextMenu()
		end

		PlayerListVisibilityStore.setTempHide(p2, p3)
	else
		if p3 == false then
			p3 = nil
		end

		p.store:dispatch(SetTempHideKey(p2, p3))
	end
end

function PlayerListController:SetTopBarEnabled(topBarEnabled)
	if FFlagPlayerListReskin then
		self.topBarEnabled = topBarEnabled
		local v = self.coreGuiEnabled and topBarEnabled

		if v and not self.mounted then
			LeaderboardStoreInstanceManager.createLeaderboardStoreInstance()
			self._reskin.setupVisibilityEffect()
			self._reskin.mountReskin()
			self.mounted = true
		elseif not v and self.mounted then
			self._reskin.unmountReskin()
			LeaderboardStoreInstanceManager.cleanUpInstance()
			self.mounted = false
		end
	else
		self.topBarEnabled = topBarEnabled
		self:_updateMounted()
	end
end

function PlayerListController.SetMinimized(p, p2)
	if FFlagPlayerListReskin then
		return
	end

	p.store:dispatch(SetMinimized(p2))
end

return PlayerListController
