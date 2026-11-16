local CorePackages = game:GetService("CorePackages")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local Roact = require(CorePackages.Packages.Roact)
local none = Roact.None
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local contextualMenu = UIBlox.App.Menu.ContextualMenu
local menuDirection = UIBlox.App.Menu.MenuDirection
local Otter = require(CorePackages.Packages.Otter)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local userIconList = require("@luauforge/bundled/fYU").UserIconList
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local gameInfosReducer = require("@luauforge/bundled/dzK").GameInfosReducer
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMigrateGameInfoToStore
local module2 = require("@luauforge/bundled/hJs")
local gameInviteModalManager = module2.GameInviteModalManager
local gameInviteConstants = module2.GameInviteConstants
local gameInviteAnalyticsManager = module2.GameInviteAnalyticsManager

local gameDetailsEvents = require("@luauforge/bundled/dpZ").Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents
local createPrivateGame = gameDetailsEvents.CreatePrivateGame
local joinFriendsInGame = gameDetailsEvents.JoinFriendsInGame

local module3 = require("@luauforge/bundled/edB")
local module4 = require("@luauforge/deferred/hLQ")
local module5 = require("@luauforge/bundled/fNO")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local getLegacyNavigationStore

if fFlagSignalsNavP3fGameDetails then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local fFlagUseSignalsForDeviceOrientation = SharedFlags.FFlagUseSignalsForDeviceOrientation
local getDeviceOrientationStore

if fFlagUseSignalsForDeviceOrientation then
	getDeviceOrientationStore = require("@luauforge/bundled/hMr").GetDeviceOrientationStore
else
	getDeviceOrientationStore = nil
end

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagLuaAppEdpBackendV2HydrateLegacyDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyDefault

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local defineFastFlag = game:DefineFastFlag("LuaAppCheckPlayabilityStatusPrivateServersEnabled", false)
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local fFlagEnableBlackbirdPageCloseCallback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBlackbirdPageCloseCallback

local getSubscriptionPurchaseCloseCallback = require("@luauforge/bundled/fzr").Utils.getSubscriptionPurchaseCloseCallback

local module7 = require("@luauforge/deferred/hLT")

local useGetOnlineFriendsByUniverseId = require("@luauforge/deferred/hLV").useGetOnlineFriendsByUniverseId

local vector2 = Vector2.new(64, 24)

local v5 = memoize(function(p2, items)
	if not (p2 and items) then
		return {}
	end

	local result = {}

	for k, item in pairs(items) do
		local v6 = p2[item]

		if v6 and v6.isFriend then
			table.insert(result, v6)
		end
	end

	table.sort(result, module4)
	return result
end)

local extended = Roact.PureComponent:extend("GameDetailsPlayWithFriendsContextualMenu")

local strictInterface = t.strictInterface
local v6 = {
	universeId = t.string,
	menuPosition = t.optional(t.UDim2),
	hideCloseButton = t.optional(t.boolean),
	shouldHydrateLegacyIxp = 0,
	closeCentralOverlayThunk = 0,
	focusController = 0,
	defaultChildRef = 0,
	rootPlaceId = 0,
	currentPage = 0,
	users = 0,
	inGameUsersByGame = 0,
	screenSize = 0,
	deviceOrientation = 0,
	privateServersEnabled = 0,
	onlineFriendsInGame = 0,
	closeCallback = 0,
	navigateDown = 0,
	appTheme = 0,
	webViewSupport = 0,
	networking = 0,
	localization = 0,
	eventIngest = 0
}
local v7 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then t.optional(t.boolean) else nil
v6.shouldHydrateLegacyIxp = v7

v6.closeCentralOverlayThunk = t.optional(t.callback)
v6.focusController = t.optional(t.table)
v6.defaultChildRef = t.optional(t.table)

v6.rootPlaceId = t.optional(t.string)
local v8 = if fFlagSignalsNavP3fGameDetails then t.optional(t.string) else t.string
v6.currentPage = v8
v6.users = t.optional(t.table)
v6.inGameUsersByGame = t.optional(t.table)
v6.screenSize = t.optional(t.Vector2)
v6.deviceOrientation = t.optional(t.string)
v6.privateServersEnabled = t.optional(t.boolean)

local v9 = if module7 then t.optional(t.table) else nil
v6.onlineFriendsInGame = v9

v6.closeCallback = t.callback
v6.navigateDown = t.callback

v6.appTheme = t.any

v6.webViewSupport = t.optional(t.boolean)

v6.networking = t.callback
v6.localization = t.table
v6.eventIngest = t.table
extended.validateProps = strictInterface(v6)

function extended:init()
	if fFlagMigrateGameInfoToStore then
		self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
			universeId = self.props.universeId,
			onChange = function(p2)
				self:setState({
					gameInfo = p2.gameInfo or none
				})
			end
		})
	end

	function self.getMenuPos()
		if self.props.menuPosition == nil then
			return UDim2.fromOffset(0, 0)
		end

		return self.props.menuPosition
	end

	function self.getMenuSize()
		return UDim2.new(0, 300, 1, 0)
	end

	function self.getMenuAnchor()
		if self.props.menuPosition == nil or self.props.screenSize == nil then
			return nil
		end

		return Vector2.new(0, 0)
	end
end

function extended:getItems(data2)
	local closeCallback = self.props.closeCallback
	local eventIngest = self.props.eventIngest
	local rootPlaceId

	if fFlagMigrateGameInfoToStore then
		rootPlaceId = self.props.rootPlaceId or self.state.gameInfo and self.state.gameInfo.rootPlaceId
	else
		rootPlaceId = self.props.rootPlaceId
	end

	local v10

	if module7 then
		v10 = self.props.onlineFriendsInGame or {}
	else
		v10 = v5(self.props.users, self.props.inGameUsersByGame)
	end

	local appTheme = self.props.appTheme
	local privateServersEnabled = self.props.privateServersEnabled

	local items = {}

	table.insert(items, {
		text = data2.inviteFriends,
		icon = images["icons/actions/friends/friendInvite"],
		onActivated = function()
			if not (self.isMounted and rootPlaceId) then
				return
			end

			gameInviteAnalyticsManager:withButtonName(gameInviteAnalyticsManager.ButtonName.GameDetailsPlayWithFriendsMenu)

			gameInviteAnalyticsManager:inputShareGameEntryPoint(rootPlaceId, self.props.universeId)
			gameInviteModalManager:openModal({
				trigger = gameInviteConstants.Triggers.GameDetailsPlayWithFriendsMenu,
				rootPlaceId = rootPlaceId,
				universeId = self.props.universeId,
				hideCloseButton = self.props.hideCloseButton
			})

			closeCallback()
		end
	})

	local webViewSupport = self.props.webViewSupport
	local v11

	if fFlagEnableBlackbirdPageCloseCallback and getSubscriptionPurchaseCloseCallback then
		v11 = getSubscriptionPurchaseCloseCallback()
	else
		v11 = nil
	end

	if webViewSupport and privateServersEnabled then
		table.insert(items, {
			text = data2.createPrivateGame,
			icon = images["icons/actions/edit/add"],
			onActivated = function()
				if not (self.isMounted and rootPlaceId) then
					return
				end

				local universeId = self.props.universeId
				local serversPreopenCreateVip = urlBuilder.game.info.serversPreopenCreateVip({
					universeId = universeId
				})

				self.props.navigateDown({
					name = appPage.GenericWebPage,
					detail = serversPreopenCreateVip,
					extraProps = {
						title = data2.createPrivateGame,
						onClose = if fFlagEnableBlackbirdPageCloseCallback then v11 else nil
					}
				})

				createPrivateGame(eventIngest, "GameDetailsPlayWithFriendsContextualMenu", rootPlaceId)
				closeCallback()
			end
		})
	end

	if self.props.webViewSupport then
		table.insert(items, {
			text = data2.joinFriendsInGame,
			icon = images["icons/actions/friends/friendsplaying"],
			onActivated = function()
				if not (self.isMounted and rootPlaceId) then
					return
				end

				local universeId = self.props.universeId
				local servers = urlBuilder.game.info.servers({ universeId = universeId })

				self.props.navigateDown({
					name = appPage.GenericWebPage,
					detail = servers,
					extraProps = {
						title = data2.joinFriendsInGame,
						onClose = if fFlagEnableBlackbirdPageCloseCallback then v11 else nil
					}
				})

				joinFriendsInGame(eventIngest, "GameDetailsPlayWithFriendsContextualMenu", rootPlaceId)
				closeCallback()
			end,
			renderRightSideGadget = function()
				return {
					UserIconList = Roact.createElement(userIconList, {
						users = v10,
						width = vector2.X,
						height = vector2.Y,
						maskColor = appTheme.Background and appTheme.Background.Color or nil
					})
				}
			end,
			rightSideGadgetSize = vector2
		})
	end

	return items
end

function extended:renderLandscapeContextualMenu()
	local closeCallback = self.props.closeCallback
	local screenSize = self.props.screenSize

	local function fn(p2)
		local items = self:getItems(p2)
		local menuPos = self.getMenuPos()
		local menuAnchor = self:getMenuAnchor()
		local menuSize = self.getMenuSize()

		return Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Position = menuPos, Size = menuSize },
			{
				ContextMenu = Roact.createElement(contextualMenu, {
					buttonProps = items,
					open = true,
					horizontalAlignment = Enum.HorizontalAlignment.Left,
					openPositionX = UDim.new(0, 0),
					openPositionY = UDim.new(0, 0),
					closeBackgroundVisible = false,
					screenSize = screenSize,
					onDismiss = closeCallback,
					contextMenuWidthOverride = UDim.new(1, 0),
					anchorPointOverride = menuAnchor,
					motorOverrideOptions = {
						motorCallback = Otter.instant,
						open = { targetValue = 1 },
						close = { targetValue = 0 }
					}
				})
			}
		)
	end

	return withLocalization({
		inviteFriends = "Feature.GameDetails.Action.InviteFriends",
		joinFriendsInGame = "Feature.GameDetails.Action.JoinFriendsInGame",
		createPrivateGame = "Feature.GameDetails.Action.CreatePrivateGame"
	})(fn)
end

function extended:didMount()
	self.isMounted = true
	local v10

	if fFlagSignalsNavP3fGameDetails then
		v10 = getLegacyNavigationStore(false).getCurrentPage(false).name
	else
		v10 = self.props.currentPage
	end

	local closeCallback = self.props.closeCallback

	if v10 ~= appPage.GameDetail and v10 ~= appPage.ExperienceDetail then
		closeCallback()
	end
end

function extended:WillUnmount()
	self.isMounted = false
end

function extended.didUpdate(p2)
	if fFlagMigrateGameInfoToStore then
		p2.gameInfoSubscription.update(p2.props.universeId)
	end
end

function extended.willUnmount(p2)
	if fFlagMigrateGameInfoToStore then
		p2.gameInfoSubscription.dispose()
	end
end

function extended:renderPortraitContextualMenu()
	local closeCallback = self.props.closeCallback
	local screenSize = self.props.screenSize

	local function fn(p2)
		local items = self:getItems(p2)

		local v10 = self.props.deviceOrientation == deviceOrientationMode.Portrait

		local v11 = (screenSize == nil or not (screenSize.X > 0)) and 0
			or self.props.menuPosition.X.Offset / screenSize.X / 2
			or 0

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(v10 and 0 or v11, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			ContextMenu = Roact.createElement(contextualMenu, {
				buttonProps = items,
				open = true,
				menuDirection = menuDirection.Up,
				openPositionY = UDim.new(1, -76),
				closeBackgroundVisible = false,
				screenSize = screenSize,
				onDismiss = closeCallback
			})
		})
	end

	return withLocalization({
		inviteFriends = "Feature.GameDetails.Action.InviteFriends",
		joinFriendsInGame = "Feature.GameDetails.Action.JoinFriendsInGame",
		createPrivateGame = "Feature.GameDetails.Action.CreatePrivateGame"
	})(fn)
end

function extended:render()
	if self.props.deviceOrientation == deviceOrientationMode.Portrait then
		return self:renderPortraitContextualMenu()
	end

	return self:renderLandscapeContextualMenu()
end

local v10 = module5((RoactRodux.connect(function(data, p2)
	local v11

	if not fFlagSignalsNavP3fGameDetails then
		if fFlagUseNavigationSelectors then
			v11 = selectors.selectCurrentLegacyRoute(data)
		else
			v11 = data.Navigation.history[#data.Navigation.history]
		end
	end

	local v12

	if
		fFlagLuaAppEdpBackendV2HydrateLegacyDefault
		or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p2.shouldHydrateLegacyIxp
	then
		v12 = data.GameDetailsV2[p2.universeId]
	else
		v12 = data.GameDetails[p2.universeId]
	end

	local v13

	if not fFlagMigrateGameInfoToStore then
		v13 = data.Personalization[gameInfosReducer.key][p2.universeId]
	end

	local v14

	if defineFastFlag then
		v14 = data.PlayabilityStatus[p2.universeId]
			and data.PlayabilityStatus[p2.universeId].isPlayable
			and data.GamePrivateServersEnabled[p2.universeId]
	else
		v14 = data.GamePrivateServersEnabled[p2.universeId]
	end

	local v15 = {
		rootPlaceId = v12 and v12.rootPlaceId or v13 and v13.placeId or nil,
		currentPage = 0,
		users = 0,
		inGameUsersByGame = 0,
		screenSize = 0,
		deviceOrientation = 0,
		privateServersEnabled = 0
	}

	local v16 = if not fFlagSignalsNavP3fGameDetails then v11[#v11].name else nil
	v15.currentPage = v16

	local v17 = if not module7 then data.Users else nil
	v15.users = v17

	local v18 = if not module7 then data.InGameUsersByGame[p2.universeId] else nil
	v15.inGameUsersByGame = v18

	v15.screenSize = data.ScreenSize
	local v19 = if not fFlagUseSignalsForDeviceOrientation then data.DeviceOrientation else nil
	v15.deviceOrientation = v19
	v15.privateServersEnabled = v14
	return v15
end, function(callback)
	return {
		closeCallback = function()
			callback(closeCentralOverlay())
		end,
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(navigateDown(p2))
		end
	}
end)(extended)))

local v11 = roactAppPolicy.connect(function(p2)
	return { webViewSupport = p2.getWebViewSupport() }
end)(v10)

local v12 = roactServices.connect({
	networking = roactNetworking,
	localization = module3,
	eventIngest = appEventIngestService
})(v11)

local function GameDetailsPlayWithFriendsContextualMenuWrapper(p2)
	local v13 = {}

	if module7 then
		v13.onlineFriendsInGame = useGetOnlineFriendsByUniverseId((tostring(p2.universeId)))
	end

	if fFlagUseSignalsForDeviceOrientation then
		v13.deviceOrientation = useSignalState(getDeviceOrientationStore(false).getDeviceOrientation)
	end

	return Roact.createElement(v12, Cryo.Dictionary.union(p2, v13))
end

if module7 or fFlagUseSignalsForDeviceOrientation then
	return (React.memo(GameDetailsPlayWithFriendsContextualMenuWrapper))
end

return v12
