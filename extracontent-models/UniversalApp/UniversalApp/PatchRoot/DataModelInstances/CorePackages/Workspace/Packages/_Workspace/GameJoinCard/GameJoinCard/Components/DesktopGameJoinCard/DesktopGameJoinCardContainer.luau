local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local GameJoinCardParent = GameJoinCard.Parent
local HttpService = game:GetService("HttpService")
local React = require(GameJoinCardParent.React)
local Foundation = require(GameJoinCardParent.Foundation)
local Responsive = require(GameJoinCardParent.Responsive)
local GameDetail = require(GameJoinCardParent.GameDetail)

require(GameJoinCardParent.SocialCommon)

local DiscoveryAnalytics = require(GameJoinCardParent.DiscoveryAnalytics)
local SocialExperienceJoin = require(GameJoinCardParent.SocialExperienceJoin)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local gameDetailReferral = DiscoveryAnalytics.Events.gameDetailReferral
local PeopleListInHomePage = DiscoveryAnalytics.Constants.Context.PeopleListInHomePage
local RobloxAppEnums = require(GameJoinCardParent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NotificationType = RobloxAppEnums.NotificationType
local RoactServiceTags = require(GameJoinCardParent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local AppSessionService = RoactServiceTags.AppSessionService
local AppGuiService = RoactServiceTags.AppGuiService
local SetGamePlaySession = require(GameJoinCardParent.RobloxAppSessionization).SetGamePlaySession
local SessionType = require(GameJoinCardParent.RobloxAppSessionization).SessionType
local useRoactService = require(GameJoinCardParent.RobloxAppHooks).useRoactService
local ContentProvider = game:GetService("ContentProvider")
local DesktopGameJoinCard = require(script.Parent.DesktopGameJoinCard)
local GamepadJoinFocusBehavior = require(script.Parent.GamepadJoinFocusBehavior)
local OpenGameDetails = GameDetail.OpenGameDetails
local useNavigation = require(GameJoinCardParent.Navigation).useNavigation
local useNavigationFocus = require(GameJoinCardParent.Navigation).useNavigationFocus
local Hooks = require(GameJoinCardParent.RoactUtils).Hooks
local dependencyArray = Hooks.dependencyArray
local useDispatch = Hooks.RoactRodux.useDispatch
local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailType = Foundation.Enums.ThumbnailType
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience
local usePreferredInput = Responsive.usePreferredInput
local useAppPolicy = require(GameJoinCardParent.UniversalAppPolicy).useAppPolicy
local FocusNavigationUtils = require(GameJoinCardParent.FocusNavigationUtils)
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local SharedFlags = require(GameJoinCardParent.SharedFlags)
local FFlagEnableConsoleGameJoinCard = SharedFlags.FFlagEnableConsoleGameJoinCard
local FFlagJoinCardAgeCheckUpsell = SharedFlags.FFlagJoinCardAgeCheckUpsell
local getPlatformFriendsService = require(GameJoinCard.Utils.getPlatformFriendsService)
local AnalyticsConstants = require(script.Parent.Parent.Parent.Analytics.AnalyticsConstants)
local GameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction
local viewEDPsourceValues = AnalyticsConstants.viewEDPsourceValues
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local useGameJoinCardAnalytics = require(script.Parent.Parent.Parent.Analytics.useGameJoinCardAnalytics)
local useAgeCheckUpsellAnalytics = require(script.Parent.Parent.Parent.Analytics.useAgeCheckUpsellAnalytics)
local useAgeCheckCompletionLogger = useAgeCheckUpsellAnalytics.useAgeCheckCompletionLogger
local useAgeCheckPressLogger = useAgeCheckUpsellAnalytics.useAgeCheckPressLogger

local function DesktopGameJoinCardContainer(t1: {[any]: any}) -- line: 90
	-- upvalues: useDispatch (copy), useNavigation (copy), useNavigationFocus (copy), React (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy), ContentProvider (copy), FFlagJoinCardAgeCheckUpsell (copy), useAgeCheckCompletionLogger (copy), useJoinUserInExperience (copy), useAgeCheckPressLogger (copy), useGameJoinCardAnalytics (copy), dependencyArray (copy), usePreferredInput (copy), Responsive (copy), FFlagEnableConsoleGameJoinCard (copy), getPlatformFriendsService (copy), useAppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), useRoactService (copy), AppEventIngestService (copy), AppSessionService (copy), AppGuiService (copy), useAppPolicy (copy), gamePlayIntent (copy), PeopleListInHomePage (copy), HttpService (copy), SetGamePlaySession (copy), SessionType (copy), gameDetailReferral (copy), OpenGameDetails (copy), viewEDPsourceValues (copy), GameJoinCardButtonAction (copy), viewProfileSourceValues (copy), AppPage (copy), NotificationType (copy), DesktopGameJoinCard (copy), GamepadJoinFocusBehavior (copy)
	local v55 = useDispatch()
	local v56 = useNavigation()
	local v57 = useNavigationFocus() ~= false
	local layoutOrder = t1.layoutOrder
	local playerName = t1.playerName
	local platformName = t1.platformName
	local presence = t1.presence
	local str = tostring(presence.universeId)
	local lastLocation = presence.lastLocation
	local v64 = React.useMemo(function() -- line: 100
		-- upvalues: getRbxThumb (copy), ThumbnailType (copy), str (copy), ThumbnailSize (copy)
		return getRbxThumb(ThumbnailType.GameIcon, str, ThumbnailSize.Small)
	end, { str })
	local v65, v66 = React.useState(Enum.AssetFetchStatus.None)

	React.useEffect(function() -- line: 104
		-- upvalues: v66 (copy), ContentProvider (copy), v64 (copy)
		v66(ContentProvider:GetAssetFetchStatus(v64))
	end, { v64 })
	React.useEffect(function() -- line: 107
		-- upvalues: ContentProvider (copy), v64 (copy), v66 (copy)
		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(v64):Connect(v66)

		return function() -- line: 110
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v64 })

	local v67 = if not FFlagJoinCardAgeCheckUpsell then nil else useAgeCheckCompletionLogger(str)
	local v68 = useJoinUserInExperience(t1.userId, {
		isHomePageCarousel = true,
		homepageCarouselAbsolutePosition = t1.homepageCarouselAbsolutePosition,
		presence = t1.presence,
		onAgeCheckCompletion = v67
	})
	local v69 = if not FFlagJoinCardAgeCheckUpsell then nil else useAgeCheckPressLogger({
		userId = t1.userId,
		universeId = str,
		absolutePosition = t1.homepageCarouselAbsolutePosition,
		joinAgeCheckUpsellFlow = v68.joinAgeCheckUpsellFlow
	})
	local v70 = FFlagJoinCardAgeCheckUpsell and v68.ageCheckRequired == true
	local v71 = React.useRef(false)

	React.useEffect(function() -- line: 137
		-- upvalues: t1 (copy), v57 (copy), v71 (copy), useGameJoinCardAnalytics (copy)
		local v91 = t1.isOpen == true and v57

		if v91 and not v71.current then
			local universeId = t1.presence.universeId

			useGameJoinCardAnalytics.logGameJoinCardPageLoaded({
				friendId = t1.userId,
				universeId = if universeId == nil or tostring(universeId) == "" then nil else tostring(universeId),
				absolutePosition = t1.homepageCarouselAbsolutePosition
			})
		end

		v71.current = v91
	end, dependencyArray(t1.isOpen, v57, t1.userId, t1.presence, t1.homepageCarouselAbsolutePosition))
	React.useEffect(function() -- line: 161
		-- upvalues: t1 (copy), v57 (copy)
		if t1.isOpen and not v57 then
			t1.onClose()
		end
	end, dependencyArray(v57, t1))
	React.useEffect(function() -- line: 168
		-- upvalues: t1 (copy), v57 (copy), v70 (copy), useGameJoinCardAnalytics (copy), str (copy)
		if not t1.isOpen or not v57 or not v70 then
			return
		end

		useGameJoinCardAnalytics.logJoinCardAgeCheckUpsellImpression({
			universeId = if str == "" then nil else str
		})
	end, dependencyArray(t1.isOpen, v57, v70, str))

	local v72 = str == "" or (lastLocation == nil or (lastLocation == "" or v65 == Enum.AssetFetchStatus.Loading))
	local v73 = usePreferredInput() == Responsive.Input.Directional
	local v74 = nil

	if FFlagEnableConsoleGameJoinCard then
		local platformProfileId = t1.platformProfileId

		v74 = React.useCallback(function() -- line: 189
			-- upvalues: getPlatformFriendsService (copy), platformProfileId (copy)
			if getPlatformFriendsService == nil or (platformProfileId == nil or platformProfileId == "") then
				return
			end

			getPlatformFriendsService:ShowProfile(platformProfileId)
		end, { platformProfileId })
	end

	local v76 = if not FFlagEnableConsoleGameJoinCard then nil else useAppFocusRoot({
		isAutoFocusRoot = false,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isFocusable = t1.isFocused == true and v57
	})
	local v77 = React.useRef(nil)
	local v78 = React.useCallback(function(p1) -- line: 207
		-- upvalues: FFlagEnableConsoleGameJoinCard (copy), v77 (copy), v76 (copy), t1 (copy)
		if not FFlagEnableConsoleGameJoinCard then
			return
		end

		v77.current = p1

		if v76 then
			v76(p1)
		end

		if t1.onCardGuiObjectChanged then
			t1.onCardGuiObjectChanged(p1)
		end
	end, {
		v76,
		t1.onCardGuiObjectChanged
	})
	local v79 = useRoactService(AppEventIngestService)
	local v80 = useRoactService(AppSessionService)
	local v81 = useRoactService(AppGuiService)
	local v82 = useAppPolicy(function(p2) -- line: 224
		return p2.getCanUsePlatformChat()
	end)
	local v83 = React.useCallback(function() -- line: 228
		-- upvalues: t1 (copy), presence (copy), gamePlayIntent (copy), v79 (copy), PeopleListInHomePage (copy), HttpService (copy)
		local userId = t1.userId

		if userId == "" then
			return
		end

		local v96 = (presence.placeId == nil or tostring(presence.placeId) == "") and "" or tostring(presence.placeId)
		local num = tonumber(presence.rootPlaceId)

		if v96 == "" or num == nil then
			return
		end

		gamePlayIntent(v79, PeopleListInHomePage, {
			placeId = v96,
			rootPlaceId = num,
			friendId = userId,
			joinAttemptId = HttpService:GenerateGUID(false)
		})
	end, dependencyArray(t1.userId, presence))
	local v84 = React.useCallback(function() -- line: 249
		-- upvalues: str (copy), presence (copy), t1 (copy), v80 (copy), SetGamePlaySession (copy), SessionType (copy), gameDetailReferral (copy), v79 (copy), v55 (copy), OpenGameDetails (copy), v56 (copy)
		if str == "" then
			return
		end

		local rootPlaceId = presence.rootPlaceId
		local v99 = if rootPlaceId == nil or tostring(rootPlaceId) == "" then str else tostring(rootPlaceId)
		local v100 = t1.homepageCarouselAbsolutePosition or 0

		if v80 then
			SetGamePlaySession(v80, SessionType.StructuralIdentifier.GameDetailSource, false)
		end

		gameDetailReferral(v79, "home", {
			ad = "no",
			pg = "home",
			rowOnPage = 1,
			tis = 1,
			friendId = t1.userId,
			pid = v99,
			pos = v100,
			sortPos = t1.layoutOrder,
			universeId = str
		})
		v55(OpenGameDetails(str, v56))
	end, dependencyArray(v55, v56, str, presence, t1.homepageCarouselAbsolutePosition, t1.layoutOrder, t1.userId))
	local v85 = React.useCallback(function(p3) -- line: 285
		-- upvalues: str (copy), t1 (copy), viewEDPsourceValues (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), v84 (copy)
		if str == "" then
			return
		end

		if t1.userId ~= "" then
			local t2 = {
				friendId = t1.userId,
				universeId = if str == "" then nil else str,
				absolutePosition = t1.homepageCarouselAbsolutePosition
			}

			if p3 == viewEDPsourceValues.Thumbnail then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.ViewExperienceDetailsFromThumbnail, t2)
			elseif p3 == viewEDPsourceValues.Title then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.ViewExperienceDetailsFromTitle, t2)
			end
		end

		v84()
	end, dependencyArray(v84, str, t1.userId, t1.homepageCarouselAbsolutePosition))
	local v86 = React.useCallback(function() -- line: 311
		-- upvalues: t1 (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), str (copy), v83 (copy), v68 (copy)
		if t1.userId ~= "" then
			useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.JoinGame, {
				friendId = t1.userId,
				universeId = if str == "" then nil else str,
				absolutePosition = t1.homepageCarouselAbsolutePosition
			})
		end

		v83()
		v68.joinExperience()
		t1.onClose()
	end, dependencyArray(v83, v68.joinExperience, t1.userId, str, t1.homepageCarouselAbsolutePosition, t1.onClose))
	local v87 = React.useCallback(function(p4) -- line: 333
		-- upvalues: t1 (copy), str (copy), viewProfileSourceValues (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), v56 (copy), AppPage (copy)
		if t1.userId ~= "" then
			local t3 = {
				friendId = t1.userId,
				universeId = if str == "" then nil else str,
				absolutePosition = t1.homepageCarouselAbsolutePosition
			}

			if p4 == viewProfileSourceValues.UserTile then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.OpenProfileFromUserTile, t3)
			elseif p4 == viewProfileSourceValues.ViewProfileButton then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.OpenProfileFromViewProfile, t3)
			end
		end

		v56.navigate(AppPage.ProfilePlatform, {
			detail = t1.userId
		})
		t1.onClose()
	end, dependencyArray(v56, t1.userId, str, t1.homepageCarouselAbsolutePosition, t1.onClose))
	local v88 = React.useCallback(function() -- line: 358
		-- upvalues: t1 (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), str (copy), v81 (copy), NotificationType (copy)
		if t1.userId == "" then
			return
		end

		useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.Chat, {
			friendId = t1.userId,
			universeId = if str == "" then nil else str,
			absolutePosition = t1.homepageCarouselAbsolutePosition
		})
		v81:BroadcastNotification(t1.userId, NotificationType.LAUNCH_CONVERSATION)
		t1.onClose()
	end, dependencyArray(t1.userId, str, t1.homepageCarouselAbsolutePosition, v81, t1.onClose))
	local v89 = React.createElement(DesktopGameJoinCard, {
		layoutOrder = layoutOrder,
		playerName = playerName,
		experienceName = lastLocation,
		gameIconUrl = v64,
		isLoading = v72,
		onJoin = v86,
		onViewExperienceDetails = v85,
		anchorRef = t1.anchorRef,
		isOpen = t1.isOpen and v57,
		onClose = t1.onClose,
		isConsole = v73,
		consolePlatformLabel = platformName,
		focusRootRef = if not FFlagEnableConsoleGameJoinCard then nil else v78,
		ageCheckRequired = if not FFlagJoinCardAgeCheckUpsell then nil else v68.ageCheckRequired,
		onAgeCheckPressed = v69,
		onPlatformProfilePressed = if not FFlagEnableConsoleGameJoinCard or not v73 then nil else v74,
		onChat = if v73 or not v82 then nil else v88,
		onViewProfile = if v73 then nil else v87
	})

	if t1.showGamepadJoinFocus then
		return React.createElement(React.Fragment, nil, {
			GamepadJoinFocus = React.createElement(GamepadJoinFocusBehavior, {
				tileRef = t1.anchorRef,
				cardRef = if not FFlagEnableConsoleGameJoinCard then nil else v77,
				joinExperience = v86
			}),
			Card = v89
		})
	end

	return v89
end

return DesktopGameJoinCardContainer
