local CorePackages = game:GetService("CorePackages")
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local Otter = require(CorePackages.Packages.Otter)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local NavigateDown = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v20 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local UserIconList = require(CorePackages.Workspace.Packages.GameTile).UserIconList
local UrlBuilder = require(CorePackages.Packages.UrlBuilder).UrlBuilder
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local GameInfosReducer = require(CorePackages.Workspace.Packages.GameInfosRodux).GameInfosReducer
local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteModalManager = GameInvite.GameInviteModalManager
local GameInviteConstants = GameInvite.GameInviteConstants
local GameInviteAnalyticsManager = GameInvite.GameInviteAnalyticsManager
local GameDetailsEvents = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents
local CreatePrivateGame = GameDetailsEvents.CreatePrivateGame
local JoinFriendsInGame = GameDetailsEvents.JoinFriendsInGame
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local sortFriendsByPresenceAndRecency = require(Modules.LuaApp.sortFriendsByPresenceAndRecency)
local withTheme_DEPRECATED = require(Modules.LuaApp.withTheme_DEPRECATED)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local FFlagLuaAppRenameFriendsToConnectionsEdp = SharedFlags.FFlagLuaAppRenameFriendsToConnectionsEdp
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v42 = if not FFlagSignalsNavP3fGameDetails then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local v45 = game:DefineFastFlag("LuaAppCheckPlayabilityStatusPrivateServersEnabled", false)
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagEnableBlackbirdPageCloseCallback = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBlackbirdPageCloseCallback
local getSubscriptionPurchaseCloseCallback = require(CorePackages.Workspace.Packages.RobloxSubscriptionPurchaseApp).Utils.getSubscriptionPurchaseCloseCallback
local vector2 = Vector2.new(64, 24)
local v50 = memoize(function(p1, p2) -- line: 69
	-- upvalues: sortFriendsByPresenceAndRecency (copy)
	if not p1 or not p2 then
		return {}
	end

	local t1 = {}

	for _, v in pairs(p2) do
		local v61 = p1[v]

		if v61 and v61.isFriend then
			table.insert(t1, v61)
		end
	end

	table.sort(t1, sortFriendsByPresenceAndRecency)

	return t1
end)
local v51 = Roact.PureComponent:extend("GameDetailsPlayWithFriendsContextualMenu")

v51.validateProps = t.strictInterface({
	universeId = t.string,
	menuPosition = t.optional(t.UDim2),
	hideCloseButton = t.optional(t.boolean),
	shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else t.optional(t.boolean),
	closeCentralOverlayThunk = t.optional(t.callback),
	focusController = t.optional(t.table),
	defaultChildRef = t.optional(t.table),
	rootPlaceId = t.optional(t.string),
	currentPage = t.string,
	users = t.optional(t.table),
	inGameUsersByGame = t.optional(t.table),
	screenSize = t.optional(t.Vector2),
	deviceOrientation = t.string,
	privateServersEnabled = t.optional(t.boolean),
	closeCallback = t.callback,
	navigateDown = t.callback,
	appTheme = t.any,
	webViewSupport = t.optional(t.boolean),
	renameFriendsToConnections = if not FFlagLuaAppRenameFriendsToConnectionsEdp then nil else t.optional(t.boolean),
	networking = t.callback,
	localization = t.table,
	eventIngest = t.table
})

function v51.init(p3) -- line: 124
	function p3.getMenuPos() -- line: 125
		-- upvalues: p3 (copy)
		if p3.props.menuPosition == nil then
			return UDim2.fromOffset(0, 0)
		end

		return p3.props.menuPosition
	end
	function p3.getMenuSize() -- line: 132
		return UDim2.new(0, 300, 1, 0)
	end
	function p3.getMenuAnchor() -- line: 136
		-- upvalues: p3 (copy)
		if p3.props.menuPosition == nil or p3.props.screenSize == nil then
			return nil
		end

		return Vector2.new(0, 0)
	end
end
function v51.getItems(p4, p5) -- line: 144
	-- upvalues: v50 (copy), FFlagLuaAppRenameFriendsToConnectionsEdp (copy), Images (copy), GameInviteAnalyticsManager (copy), GameInviteModalManager (copy), GameInviteConstants (copy), FFlagEnableBlackbirdPageCloseCallback (copy), getSubscriptionPurchaseCloseCallback (copy), UrlBuilder (copy), AppPage (copy), CreatePrivateGame (copy), JoinFriendsInGame (copy), Roact (copy), UserIconList (copy), vector2 (copy)
	local closeCallback = p4.props.closeCallback
	local eventIngest = p4.props.eventIngest
	local rootPlaceId = p4.props.rootPlaceId
	local users = p4.props.users
	local inGameUsersByGame = p4.props.inGameUsersByGame
	local v70 = v50(users, inGameUsersByGame)
	local appTheme = p4.props.appTheme
	local privateServersEnabled = p4.props.privateServersEnabled
	local v73 = if not FFlagLuaAppRenameFriendsToConnectionsEdp then nil else p4.props.renameFriendsToConnections
	local t2 = {}

	table.insert(t2, {
		text = if not FFlagLuaAppRenameFriendsToConnectionsEdp or not v73 then p5.inviteFriends else p5.inviteConnections,
		icon = Images["icons/actions/friends/friendInvite"],
		onActivated = function() -- line: 165
			-- upvalues: p4 (copy), rootPlaceId (copy), GameInviteAnalyticsManager (copy), GameInviteModalManager (copy), GameInviteConstants (copy), closeCallback (copy)
			if not p4.isMounted or not rootPlaceId then
				return
			end

			GameInviteAnalyticsManager:withButtonName(GameInviteAnalyticsManager.ButtonName.GameDetailsPlayWithFriendsMenu)
			GameInviteAnalyticsManager:inputShareGameEntryPoint(rootPlaceId, p4.props.universeId)
			GameInviteModalManager:openModal({
				trigger = GameInviteConstants.Triggers.GameDetailsPlayWithFriendsMenu,
				rootPlaceId = rootPlaceId,
				universeId = p4.props.universeId,
				hideCloseButton = p4.props.hideCloseButton
			})
			closeCallback()
		end
	})

	local webViewSupport = p4.props.webViewSupport
	local v76 = if not FFlagEnableBlackbirdPageCloseCallback or not getSubscriptionPurchaseCloseCallback then nil else getSubscriptionPurchaseCloseCallback()

	if webViewSupport and privateServersEnabled then
		table.insert(t2, {
			text = p5.createPrivateGame,
			icon = Images["icons/actions/edit/add"],
			onActivated = function() -- line: 194
				-- upvalues: p4 (copy), rootPlaceId (copy), UrlBuilder (copy), AppPage (copy), p5 (copy), FFlagEnableBlackbirdPageCloseCallback (copy), v76 (copy), CreatePrivateGame (copy), eventIngest (copy), closeCallback (copy)
				if not p4.isMounted or not rootPlaceId then
					return
				end

				local universeId = p4.props.universeId
				local v102 = UrlBuilder.game.info.serversPreopenCreateVip({
					universeId = universeId
				})

				p4.props.navigateDown({
					name = AppPage.GenericWebPage,
					detail = v102,
					extraProps = {
						title = p5.createPrivateGame,
						onClose = if not FFlagEnableBlackbirdPageCloseCallback then nil else v76
					}
				})
				CreatePrivateGame(eventIngest, "GameDetailsPlayWithFriendsContextualMenu", rootPlaceId)
				closeCallback()
			end
		})
	end

	if p4.props.webViewSupport then
		table.insert(t2, {
			text = if not FFlagLuaAppRenameFriendsToConnectionsEdp or not v73 then p5.joinFriendsInGame else p5.joinConnections,
			icon = Images["icons/actions/friends/friendsplaying"],
			onActivated = function() -- line: 224
				-- upvalues: p4 (copy), rootPlaceId (copy), UrlBuilder (copy), AppPage (copy), FFlagLuaAppRenameFriendsToConnectionsEdp (copy), v73 (copy), p5 (copy), FFlagEnableBlackbirdPageCloseCallback (copy), v76 (copy), JoinFriendsInGame (copy), eventIngest (copy), closeCallback (copy)
				if not p4.isMounted or not rootPlaceId then
					return
				end

				local universeId = p4.props.universeId
				local v104 = UrlBuilder.game.info.servers({
					universeId = universeId
				})

				p4.props.navigateDown({
					name = AppPage.GenericWebPage,
					detail = v104,
					extraProps = {
						title = if not FFlagLuaAppRenameFriendsToConnectionsEdp or not v73 then p5.joinFriendsInGame else p5.joinConnections,
						onClose = if not FFlagEnableBlackbirdPageCloseCallback then nil else v76
					}
				})
				JoinFriendsInGame(eventIngest, "GameDetailsPlayWithFriendsContextualMenu", rootPlaceId)
				closeCallback()
			end,
			renderRightSideGadget = function() -- line: 247
				-- upvalues: Roact (copy), UserIconList (copy), v70 (copy), vector2 (copy), appTheme (copy)
				return {
					UserIconList = Roact.createElement(UserIconList, {
						users = v70,
						width = vector2.X,
						height = vector2.Y,
						maskColor = appTheme.Background and appTheme.Background.Color or nil
					})
				}
			end,
			rightSideGadgetSize = vector2
		})
	end

	return t2
end
function v51.renderLandscapeContextualMenu(p6) -- line: 264
	-- upvalues: Roact (copy), ContextualMenu (copy), Otter (copy), withLocalization (copy), FFlagLuaAppRenameFriendsToConnectionsEdp (copy)
	local closeCallback = p6.props.closeCallback
	local screenSize = p6.props.screenSize

	return withLocalization({
		inviteFriends = "Feature.GameDetails.Action.InviteFriends",
		joinFriendsInGame = "Feature.GameDetails.Action.JoinFriendsInGame",
		createPrivateGame = "Feature.GameDetails.Action.CreatePrivateGame",
		inviteConnections = if not FFlagLuaAppRenameFriendsToConnectionsEdp then nil else "CommonUI.Features.Label.InviteConnections",
		joinConnections = if not FFlagLuaAppRenameFriendsToConnectionsEdp then nil else "CommonUI.Features.Label.JoinConnections"
	})(function(p7) -- line: 268
		-- upvalues: p6 (copy), Roact (copy), ContextualMenu (copy), screenSize (copy), closeCallback (copy), Otter (copy)
		local v106 = p6:getItems(p7)
		local v107 = p6.getMenuPos()
		local v108 = p6:getMenuAnchor()
		local v109 = p6.getMenuSize()

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = v107,
			Size = v109
		}, {
			ContextMenu = Roact.createElement(ContextualMenu, {
				open = true,
				closeBackgroundVisible = false,
				buttonProps = v106,
				horizontalAlignment = Enum.HorizontalAlignment.Left,
				openPositionX = UDim.new(0, 0),
				openPositionY = UDim.new(0, 0),
				screenSize = screenSize,
				onDismiss = closeCallback,
				contextMenuWidthOverride = UDim.new(1, 0),
				anchorPointOverride = v108,
				motorOverrideOptions = {
					motorCallback = Otter.instant,
					open = {
						targetValue = 1
					},
					close = {
						targetValue = 0
					}
				}
			})
		})
	end)
end
function v51.didMount(p8) -- line: 316
	-- upvalues: AppPage (copy)
	p8.isMounted = true

	local currentPage = p8.props.currentPage
	local closeCallback = p8.props.closeCallback

	if currentPage ~= AppPage.GameDetail and currentPage ~= AppPage.ExperienceDetail then
		closeCallback()
	end
end
function v51.WillUnmount(p9) -- line: 326
	p9.isMounted = false
end
function v51.renderPortraitContextualMenu(p10) -- line: 330
	-- upvalues: DeviceOrientationMode (copy), Roact (copy), ContextualMenu (copy), MenuDirection (copy), withLocalization (copy), FFlagLuaAppRenameFriendsToConnectionsEdp (copy)
	local closeCallback = p10.props.closeCallback
	local screenSize = p10.props.screenSize

	return withLocalization({
		inviteFriends = "Feature.GameDetails.Action.InviteFriends",
		joinFriendsInGame = "Feature.GameDetails.Action.JoinFriendsInGame",
		createPrivateGame = "Feature.GameDetails.Action.CreatePrivateGame",
		inviteConnections = if not FFlagLuaAppRenameFriendsToConnectionsEdp then nil else "CommonUI.Features.Label.InviteConnections",
		joinConnections = if not FFlagLuaAppRenameFriendsToConnectionsEdp then nil else "CommonUI.Features.Label.JoinConnections"
	})(function(p11) -- line: 334
		-- upvalues: p10 (copy), DeviceOrientationMode (copy), screenSize (copy), Roact (copy), ContextualMenu (copy), MenuDirection (copy), closeCallback (copy)
		local v111 = p10:getItems(p11)
		local v112 = p10.props.deviceOrientation == DeviceOrientationMode.Portrait
		local v113 = screenSize ~= nil and (screenSize.X > 0 and p10.props.menuPosition.X.Offset / screenSize.X / 2) or 0

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(if not v112 then v113 else 0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			ContextMenu = Roact.createElement(ContextualMenu, {
				open = true,
				closeBackgroundVisible = false,
				buttonProps = v111,
				menuDirection = MenuDirection.Up,
				openPositionY = UDim.new(1, -76),
				screenSize = screenSize,
				onDismiss = closeCallback
			})
		})
	end)
end
function v51.render(p12) -- line: 375
	-- upvalues: DeviceOrientationMode (copy)
	if p12.props.deviceOrientation == DeviceOrientationMode.Portrait then
		return p12:renderPortraitContextualMenu()
	end

	return p12:renderLandscapeContextualMenu()
end

local v52 = RoactRodux.connect(function(p13, p14) -- line: 387
	-- upvalues: FFlagSignalsNavP3fGameDetails (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), GameInfosReducer (copy), v45 (copy)
	local v90 = if not FFlagSignalsNavP3fGameDetails then if not FFlagUseNavigationSelectors then p13.Navigation.history[#p13.Navigation.history] else Selectors.selectCurrentLegacyRoute(p13) else nil
	local v91 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not p14.shouldHydrateLegacyIxp) then p13.GameDetails[p14.universeId] else p13.GameDetailsV2[p14.universeId]
	local v92 = p13.Personalization[GameInfosReducer.key][p14.universeId]
	local v93 = if not v45 then p13.GamePrivateServersEnabled[p14.universeId] else p13.PlayabilityStatus[p14.universeId] and (p13.PlayabilityStatus[p14.universeId].isPlayable and p13.GamePrivateServersEnabled[p14.universeId])

	return {
		rootPlaceId = v91 and v91.rootPlaceId or (v92 and v92.placeId or nil),
		currentPage = if not FFlagSignalsNavP3fGameDetails then v90[#v90].name else nil,
		users = p13.Users,
		inGameUsersByGame = p13.InGameUsersByGame[p14.universeId],
		screenSize = p13.ScreenSize,
		deviceOrientation = p13.DeviceOrientation,
		privateServersEnabled = v93
	}
end, function(p15) -- line: 416
	-- upvalues: CloseCentralOverlay (copy), FFlagSignalsNavP3Dispatch (copy), v20 (copy), NavigateDown (copy)
	return {
		closeCallback = function() -- line: 418
			-- upvalues: p15 (copy), CloseCentralOverlay (copy)
			p15(CloseCentralOverlay())
		end,
		navigateDown = function(p16) -- line: 421
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v20 (copy), p15 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v20.down(v20.fromLegacyPage(p16))
			end

			return p15(NavigateDown(p16))
		end
	}
end)(v51)

if FFlagSignalsNavP3fGameDetails then
	local v53 = v52

	function v52(p17) -- line: 433
		-- upvalues: v42 (copy), useSignalState (copy), Roact (copy), v53 (copy), Cryo (copy)
		local v96 = v42(false)
		local v97 = useSignalState(v96.getCurrentPage)

		return Roact.createElement(v53, Cryo.Dictionary.union(p17, {
			currentPage = v97.name
		}))
	end
end

local v54 = withTheme_DEPRECATED(v52)
local v55 = RoactAppPolicy.connect(function(p18) -- line: 448
	-- upvalues: FFlagLuaAppRenameFriendsToConnectionsEdp (copy)
	local v99 = p18.getWebViewSupport()
	local v100 = if not FFlagLuaAppRenameFriendsToConnectionsEdp then nil else p18.getRenameFriendsToConnections()

	return {
		webViewSupport = v99,
		renameFriendsToConnections = if not FFlagLuaAppRenameFriendsToConnectionsEdp then nil else v100
	}
end)(v54)

return RoactServices.connect({
	networking = RoactNetworking,
	localization = RoactLocalization,
	eventIngest = AppEventIngestService
})(v55)
