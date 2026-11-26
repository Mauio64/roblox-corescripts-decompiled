local IXPService = game:GetService("IXPService")

local module = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactAnalyticsCommonGameEvents
local module3 = require("@luauforge/bundled/egY")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module4 = require("@luauforge/bundled/egx")

local module5 = require("@luauforge/bundled/dFu")
local module6 = require("@luauforge/bundled/dzD")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local module8 = require("@luauforge/bundled/egZ")

local apiFetchGamesDataByPlaceIds = require("@luauforge/bundled/dBl").GamesByPlaceId.ApiFetchGamesDataByPlaceIds
local convertUniverseIdToString = require("@game/CorePackages/Workspace/Packages/SharedFlags").ConvertUniverseIdToString
local module9 = require("@luauforge/bundled/ecs")
local module10 = require("@luauforge/bundled/ehC")

local module11 = require("@luauforge/bundled/ehn")
local module12 = require("@luauforge/bundled/ehy")
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local module13 = require("@luauforge/deferred/hWG")
local module14 = require("@luauforge/bundled/fvN")
local module15 = require("@luauforge/bundled/fCM")
local module16 = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local module17 = require("@luauforge/bundled/dAF")
local module18 = require("@luauforge/bundled/hPz")
local module19 = require("@luauforge/deferred/hWE")
local module20 = require("@luauforge/deferred/hWH")
local module21 = require("@luauforge/bundled/hWK")
local chatEntryPointNames = require("@luauforge/bundled/eoT").Enums.ChatEntryPointNames

local module22 = require("@luauforge/bundled/eha")

local module23 = require("@luauforge/bundled/ehz")

local fFlagMobileGameJoinCardTTITracking = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMobileGameJoinCardTTITracking
local gameJoinCardTTI

if fFlagMobileGameJoinCardTTITracking then
	gameJoinCardTTI = require("@luauforge/deferred/eYv").Telemetry.GameJoinCardTTI
else
	gameJoinCardTTI = nil
end

local fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel

local defineFastFlag = game:DefineFastFlag("JoinGameCardViewProfileNavigateToProfilePlatform", false)

local defineFastString = game:DefineFastString(
	"JoinGameCardViewProfileExperimentLayer",
	"Social.ViewFriendSortInGameFriends"
)

local extended = module.PureComponent:extend("PeopleListContextualMenu")

local DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH = module6.DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH

extended.defaultProps = { positionIndex = 0, absolutePosition = 0 }

function extended:init()
	local analytics = self.props.analytics
	local guiService = self.props.guiService
	local closeCentralOverlay = self.props.closeCentralOverlay
	local navigateDown = self.props.navigateDown
	local user = self.props.user
	local positionIndex = self.props.positionIndex
	local absolutePosition = self.props.absolutePosition
	local source = self.props.source

	local v5 = if self.props.mockProfileAnalytics_dev then self.props.mockProfileAnalytics_dev else module11()
	self.profileAnalytics = v5

	function self.chatWithUser(p3)
		analytics.reportPeopleListInteraction(
			"ChatDropdown",
			p3,
			positionIndex,
			absolutePosition,
			self.props.analyticContext,
			{ source = source }
		)

		self.props.enteredChatFromEntryPoint(chatEntryPointNames.PeopleListDropdown)
		guiService:BroadcastNotification(p3, module14.LAUNCH_CONVERSATION)
	end

	function self.viewProfile(p3)
		analytics.reportPeopleListInteraction(
			"ProfileDropdown",
			p3,
			positionIndex,
			absolutePosition,
			self.props.analyticContext
		)

		IXPService:LogFlagLinkedUserLayerExposure(defineFastString)

		if defineFastFlag then
			navigateDown({
				name = module5.ProfilePlatform,
				detail = p3,
				extraProps = { source = module10.Sources.JoinGameCard }
			})
		else
			navigateDown({
				name = module5.ViewUserProfile,
				detail = p3,
				extraProps = {
					onClose = function()
						closeCentralOverlay()

						if self.props.onCloseProfileWebview then
							self.props.onCloseProfileWebview()
						end
					end
				}
			})
		end
	end

	local v6 = { source = self.props.source, universeId = 0 }

	local v7 = if user.presence == module17.PresenceType.IN_GAME then user.universeId else nil
	v6.universeId = v7

	analytics.reportPeopleListInteraction(
		"openPeopleList",
		user.id,
		positionIndex,
		absolutePosition,
		self.props.analyticContext,
		v6
	)

	if
		fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel
		and user.presence == module17.PresenceType.IN_GAME
		and self.props.universePlaceInfo == nil
	then
		self.props.requestGameData(self.props.networking, self.props.user.placeId)
	end
end

function extended.didMount(p2)
	local onOpen = p2.props.onOpen

	local v5 = module23.Stopwatch.stop(module23.Events.JoinGameCardOpened)

	p2.profileAnalytics.fireAnalyticsEvent(module12.ProfileInExperienceUserLoadingStage, {
		status = module9.Analytics.Enums.LoadingStages.Done,
		statValue = v5 and v5.timeElapsed or nil
	})

	if fFlagMobileGameJoinCardTTITracking then
		gameJoinCardTTI.trackPeopleListMounted()
	end

	if onOpen then
		onOpen()
	end
end

function extended:createMenuItem(p3, p4, onSelect)
	return { displayIcon = p3, text = p4, onSelect = onSelect }
end

function extended:render()
	local localization = self.props.localization
	local screenSize = self.props.screenSize
	local formFactor2 = self.props.formFactor
	local closeCentralOverlay = self.props.closeCentralOverlay

	local user = self.props.user
	local positionIndex = self.props.positionIndex
	local absolutePosition = self.props.absolutePosition
	local anchorSpaceSize = self.props.anchorSpaceSize
	local anchorSpacePosition = self.props.anchorSpacePosition
	local combinedName = self.props.combinedName

	local v5 = user.presence == module17.PresenceType.IN_GAME and user.universeId

	local x = formFactor2 == formFactor.COMPACT and screenSize.X or DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH

	local function fn(p2)
		local v6 = {}

		if self.props.canUsePlatformChat then
			table.insert(
				v6,
				self:createMenuItem("LuaApp/icons/menu/menu_messages", p2.chatWithFriendText, function()
					self.chatWithUser(user.id)
				end)
			)
		end

		if self.props.areWebViewsSupported then
			table.insert(
				v6,
				self:createMenuItem("LuaApp/icons/menu/menu_profile", p2.viewProfileText, function()
					self.viewProfile(user.id)
				end)
			)
		end

		local createElement = module.createElement

		local createElement2 = module.createElement
		local fitFrame = FitChildren.FitFrame
		local v10 = {
			BackgroundTransparency = 1,
			fitAxis = FitChildren.FitAxis.Height,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local v11 = {
			ListLayout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			GameHeader = 0,
			ListPicker = 0
		}

		local v12 = v5

		if v12 then
			local createElement3 = module.createElement
			local v14 = {
				friend = user,
				layoutOrder = 1,
				width = x,
				index = positionIndex,
				absolutePosition = absolutePosition,
				universeId = user.universeId,
				universeRootPlaceId = 0,
				placeId = 0,
				dismissContextualMenu = 0,
				featureContext = 0,
				onCloseGameDetails = 0,
				source = 0
			}

			local v15 = if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then user.rootPlaceId else nil
			v14.universeRootPlaceId = v15

			local v16 = if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then user.placeId else nil
			v14.placeId = v16

			v14.dismissContextualMenu = closeCentralOverlay
			v14.featureContext = module13.PeopleList
			v14.onCloseGameDetails = self.props.onCloseGameDetails
			v14.source = self.props.source
			v12 = createElement3(module19, v14)
		end

		v11.GameHeader = v12

		v11.ListPicker = module.createElement(module18, {
			formFactor = formFactor2,
			items = v6,
			layoutOrder = 2,
			width = x,
			maxHeight = 162
		})
		return createElement(
			module20,
			{
				anchorSpaceSize = anchorSpaceSize,
				anchorSpacePosition = anchorSpacePosition,
				itemWidth = x
			},
			{
				Content = createElement2(fitFrame, v10, v11)
			}
		)
	end

	if module22() then
		return module8({
			chatWithFriendText = {
				"Feature.Home.PeopleList.ChatWith",
				username = combinedName
			},
			viewProfileText = "Feature.Chat.Label.ViewProfile"
		})(fn)
	end

	return fn({
		chatWithFriendText = localization:Format("Feature.Home.PeopleList.ChatWith", {
			username = combinedName
		}),
		viewProfileText = localization:Format("Feature.Chat.Label.ViewProfile")
	})
end

function extended.willUnmount(p2)
	local onClose = p2.props.onClose

	if onClose then
		onClose()
	end
end

local v5 = useSheetNavigation.connect(function(data, p2)
	local v6 = nil

	if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
		local user = p2.user

		if user.presence == module17.PresenceType.IN_GAME then
			local v7 = convertUniverseIdToString(user.universeId)
			v6 = data.UniversePlaceInfos[v7]
		end
	end

	if not fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
		v6 = nil
	end

	return {
		universePlaceInfo = v6,
		formFactor = data.FormFactor,
		screenSize = data.ScreenSize
	}
end, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(module16(p2))
			end
		end,
		closeCentralOverlay = function()
			callback(module15())
		end,
		enteredChatFromEntryPoint = function(p2)
			callback(module21(p2))
		end,
		requestGameData = fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel and function(p2, p3)
			return callback(apiFetchGamesDataByPlaceIds(p2, { p3 }))
		end or nil
	}
end)(extended)

local connect = roactServices.connect

if not fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
	module4 = nil
end

local v7 = connect({
	analytics = roactAnalyticsCommonGameEvents,
	localization = module3,
	guiService = appGuiService,
	networking = module4
})(v5)

return (roactAppPolicy.connect(function(data, p2)
	return {
		enableDisplayNamePolicy = data.getShowDisplayName(),
		areWebViewsSupported = data.getWebViewSupport(),
		canUsePlatformChat = data.getCanUsePlatformChat()
	}
end)(v7))
