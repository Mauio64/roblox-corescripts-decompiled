local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local IXPService = game:GetService("IXPService")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalyticsCommonGameEvents = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactAnalyticsCommonGameEvents
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AppPage = require(Modules.LuaApp.AppPage)
local Constants = require(Modules.LuaApp.Constants)
local FitChildren = require(Modules.LuaApp.FitChildren)
local withLocalization = require(Modules.LuaApp.withLocalization)
local ApiFetchGamesDataByPlaceIds = require(CorePackages.Workspace.Packages.GameDetailRodux).GamesByPlaceId.ApiFetchGamesDataByPlaceIds
local ConvertUniverseIdToString = require(CorePackages.Workspace.Packages.SharedFlags).ConvertUniverseIdToString
local SocialLuaAnalytics = require(CorePackages.Workspace.Packages.SocialLuaAnalytics)
local Enums = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums)
local initializeProfileAnalytics = require(CorePackages.Workspace.Packages.ProfilePlatform.initializeProfileAnalytics)
local EventNames = require(CorePackages.Workspace.Packages.ProfilePlatform.EventNames)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local FeatureContext = require(Modules.LuaApp.Enum.FeatureContext)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v29 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local User = require(Modules.LuaApp.Models.User)
local ListPicker = require(Modules.LuaApp.Components.ListPicker)
local UserActiveGame = require(Modules.LuaApp.Components.Home.UserActiveGame)
local FormBasedContextualMenu = require(Modules.LuaApp.Components.FormBasedContextualMenu)
local EnteredChatFromEntryPoint = require(CorePackages.Workspace.Packages.AppChat.EnteredChatFromEntryPoint)
local ChatEntryPointNames = require(CorePackages.Workspace.Packages.SocialCommon).Enums.ChatEntryPointNames
local GetFFlagLuaAppUseWithLocalization = require(Modules.LuaApp.Flags.GetFFlagLuaAppUseWithLocalization)
local SocialStopwatch = require(CorePackages.Workspace.Packages.SocialStopwatch)
local FFlagMobileGameJoinCardTTITracking = require(CorePackages.Workspace.Packages.SharedFlags).FFlagMobileGameJoinCardTTITracking
local v39 = if not FFlagMobileGameJoinCardTTITracking then nil else require(CorePackages.Workspace.Packages.GameJoinCard).Telemetry.GameJoinCardTTI
local FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel = require(CorePackages.Workspace.Packages.SharedFlags).FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel
local v41 = game:DefineFastFlag("JoinGameCardViewProfileNavigateToProfilePlatform", false)
local v42 = game:DefineFastString("JoinGameCardViewProfileExperimentLayer", "Social.ViewFriendSortInGameFriends")
local v43 = Roact.PureComponent:extend("PeopleListContextualMenu")
local DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH = Constants.DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH

v43.defaultProps = {
	positionIndex = 0,
	absolutePosition = 0
}

function v43.init(p1) -- line: 78
	-- upvalues: initializeProfileAnalytics (copy), ChatEntryPointNames (copy), NotificationType (copy), IXPService (copy), v42 (copy), v41 (copy), AppPage (copy), Enums (copy), User (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy)
	local analytics = p1.props.analytics
	local guiService = p1.props.guiService
	local closeCentralOverlay = p1.props.closeCentralOverlay
	local navigateDown = p1.props.navigateDown
	local user = p1.props.user
	local positionIndex = p1.props.positionIndex
	local absolutePosition = p1.props.absolutePosition
	local source = p1.props.source

	p1.profileAnalytics = if not p1.props.mockProfileAnalytics_dev then initializeProfileAnalytics() else p1.props.mockProfileAnalytics_dev

	function p1.chatWithUser(p2) -- line: 92
		-- upvalues: analytics (copy), positionIndex (copy), absolutePosition (copy), p1 (copy), source (copy), ChatEntryPointNames (copy), guiService (copy), NotificationType (copy)
		analytics.reportPeopleListInteraction("ChatDropdown", p2, positionIndex, absolutePosition, p1.props.analyticContext, {
			source = source
		})
		p1.props.enteredChatFromEntryPoint(ChatEntryPointNames.PeopleListDropdown)
		guiService:BroadcastNotification(p2, NotificationType.LAUNCH_CONVERSATION)
	end
	function p1.viewProfile(p3) -- line: 106
		-- upvalues: analytics (copy), positionIndex (copy), absolutePosition (copy), p1 (copy), IXPService (copy), v42 (copy), v41 (copy), navigateDown (copy), AppPage (copy), Enums (copy), closeCentralOverlay (copy)
		analytics.reportPeopleListInteraction("ProfileDropdown", p3, positionIndex, absolutePosition, p1.props.analyticContext)
		IXPService:LogFlagLinkedUserLayerExposure(v42)

		if v41 then
			navigateDown({
				name = AppPage.ProfilePlatform,
				detail = p3,
				extraProps = {
					source = Enums.Sources.JoinGameCard
				}
			})

			return
		end

		navigateDown({
			name = AppPage.ViewUserProfile,
			detail = p3,
			extraProps = {
				onClose = function() -- line: 130
					-- upvalues: closeCentralOverlay (copy), p1 (copy)
					closeCentralOverlay()

					if p1.props.onCloseProfileWebview then
						p1.props.onCloseProfileWebview()
					end
				end
			}
		})
	end

	local t1 = {
		source = p1.props.source,
		universeId = if user.presence ~= User.PresenceType.IN_GAME then nil else user.universeId
	}

	analytics.reportPeopleListInteraction("openPeopleList", user.id, positionIndex, absolutePosition, p1.props.analyticContext, t1)

	if FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel and (user.presence == User.PresenceType.IN_GAME and p1.props.universePlaceInfo == nil) then
		p1.props.requestGameData(p1.props.networking, p1.props.user.placeId)
	end
end
function v43.didMount(p4) -- line: 169
	-- upvalues: SocialStopwatch (copy), EventNames (copy), SocialLuaAnalytics (copy), FFlagMobileGameJoinCardTTITracking (copy), v39 (copy)
	local onOpen = p4.props.onOpen
	local v59 = SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.JoinGameCardOpened)

	p4.profileAnalytics.fireAnalyticsEvent(EventNames.ProfileInExperienceUserLoadingStage, {
		status = SocialLuaAnalytics.Analytics.Enums.LoadingStages.Done,
		statValue = v59 and v59.timeElapsed or nil
	})

	if FFlagMobileGameJoinCardTTITracking then
		v39.trackPeopleListMounted()
	end

	if onOpen then
		onOpen()
	end
end
function v43.createMenuItem(_, p6, p7, p8) -- line: 188
	return {
		displayIcon = p6,
		text = p7,
		onSelect = p8
	}
end
function v43.render(p9) -- line: 196
	-- upvalues: User (copy), FormFactor (copy), DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH (copy), Roact (copy), FormBasedContextualMenu (copy), FitChildren (copy), UserActiveGame (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), FeatureContext (copy), ListPicker (copy), GetFFlagLuaAppUseWithLocalization (copy), withLocalization (copy)
	local localization = p9.props.localization
	local screenSize = p9.props.screenSize
	local formFactor = p9.props.formFactor
	local closeCentralOverlay = p9.props.closeCentralOverlay
	local user = p9.props.user
	local positionIndex = p9.props.positionIndex
	local absolutePosition = p9.props.absolutePosition
	local anchorSpaceSize = p9.props.anchorSpaceSize
	local anchorSpacePosition = p9.props.anchorSpacePosition
	local combinedName = p9.props.combinedName
	local v75 = user.presence == User.PresenceType.IN_GAME and user.universeId
	local v76 = formFactor == FormFactor.COMPACT and screenSize.X or DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH

	local function v77(p10) -- line: 214
		-- upvalues: p9 (copy), user (copy), Roact (copy), FormBasedContextualMenu (copy), anchorSpaceSize (copy), anchorSpacePosition (copy), v76 (copy), FitChildren (copy), v75 (copy), UserActiveGame (copy), positionIndex (copy), absolutePosition (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), closeCentralOverlay (copy), FeatureContext (copy), ListPicker (copy), formFactor (copy)
		local t2 = {}

		if p9.props.canUsePlatformChat then
			table.insert(t2, p9:createMenuItem("LuaApp/icons/menu/menu_messages", p10.chatWithFriendText, function() -- line: 219
				-- upvalues: p9 (copy), user (copy)
				p9.chatWithUser(user.id)
			end))
		end

		if p9.props.areWebViewsSupported then
			table.insert(t2, p9:createMenuItem("LuaApp/icons/menu/menu_profile", p10.viewProfileText, function() -- line: 228
				-- upvalues: p9 (copy), user (copy)
				p9.viewProfile(user.id)
			end))
		end

		return Roact.createElement(FormBasedContextualMenu, {
			anchorSpaceSize = anchorSpaceSize,
			anchorSpacePosition = anchorSpacePosition,
			itemWidth = v76
		}, {
			Content = Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				fitAxis = FitChildren.FitAxis.Height,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				GameHeader = v75 and Roact.createElement(UserActiveGame, {
					layoutOrder = 1,
					friend = user,
					width = v76,
					index = positionIndex,
					absolutePosition = absolutePosition,
					universeId = user.universeId,
					universeRootPlaceId = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then nil else user.rootPlaceId,
					placeId = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then nil else user.placeId,
					dismissContextualMenu = closeCentralOverlay,
					featureContext = FeatureContext.PeopleList,
					onCloseGameDetails = p9.props.onCloseGameDetails,
					source = p9.props.source
				}),
				ListPicker = Roact.createElement(ListPicker, {
					layoutOrder = 2,
					maxHeight = 162,
					formFactor = formFactor,
					items = t2,
					width = v76
				})
			})
		})
	end

	if GetFFlagLuaAppUseWithLocalization() then
		return withLocalization({
			viewProfileText = "Feature.Chat.Label.ViewProfile",
			chatWithFriendText = {
				"Feature.Home.PeopleList.ChatWith",
				username = combinedName
			}
		})(v77)
	end

	return v77({
		chatWithFriendText = localization:Format("Feature.Home.PeopleList.ChatWith", {
			username = combinedName
		}),
		viewProfileText = localization:Format("Feature.Chat.Label.ViewProfile")
	})
end
function v43.willUnmount(p11) -- line: 290
	local onClose = p11.props.onClose

	if onClose then
		onClose()
	end
end

local v45 = RoactRodux.connect(function(p12, p13) -- line: 298
	-- upvalues: FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), User (copy), ConvertUniverseIdToString (copy)
	local v82 = nil

	if FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
		local user = p13.user

		if user.presence == User.PresenceType.IN_GAME then
			local v84 = ConvertUniverseIdToString(user.universeId)

			v82 = p12.UniversePlaceInfos[v84]
		end
	end

	return {
		universePlaceInfo = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then nil else v82,
		formFactor = p12.FormFactor,
		screenSize = p12.ScreenSize
	}
end, function(p14) -- line: 315
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v29 (copy), NavigateDown (copy), CloseCentralOverlay (copy), EnteredChatFromEntryPoint (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), ApiFetchGamesDataByPlaceIds (copy)
	return {
		navigateDown = function(p15) -- line: 317
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v29 (copy), p14 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v29.down(v29.fromLegacyPage(p15))

				return
			end

			p14(NavigateDown(p15))
		end,
		closeCentralOverlay = function() -- line: 324
			-- upvalues: p14 (copy), CloseCentralOverlay (copy)
			p14(CloseCentralOverlay())
		end,
		enteredChatFromEntryPoint = function(p16) -- line: 327
			-- upvalues: p14 (copy), EnteredChatFromEntryPoint (copy)
			p14(EnteredChatFromEntryPoint(p16))
		end,
		requestGameData = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then nil else function(p17, p18) -- line: 331
			-- upvalues: p14 (copy), ApiFetchGamesDataByPlaceIds (copy)
			return p14(ApiFetchGamesDataByPlaceIds(p17, { p18 }))
		end
	}
end)(v43)
local v46 = RoactServices.connect({
	analytics = RoactAnalyticsCommonGameEvents,
	localization = RoactLocalization,
	guiService = AppGuiService,
	networking = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then nil else RoactNetworking
})(v45)

return (RoactAppPolicy.connect(function(p19, _) -- line: 345
	return {
		enableDisplayNamePolicy = p19.getShowDisplayName(),
		areWebViewsSupported = p19.getWebViewSupport(),
		canUsePlatformChat = p19.getCanUsePlatformChat()
	}
end)(v46))
