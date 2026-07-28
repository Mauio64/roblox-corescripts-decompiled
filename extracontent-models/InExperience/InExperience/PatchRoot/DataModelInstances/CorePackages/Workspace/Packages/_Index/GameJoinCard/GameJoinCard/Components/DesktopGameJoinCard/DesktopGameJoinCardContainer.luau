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
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local getPlatformFriendsService = require(GameJoinCard.Utils.getPlatformFriendsService)
local AnalyticsConstants = require(script.Parent.Parent.Parent.Analytics.AnalyticsConstants)
local GameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction
local viewEDPsourceValues = AnalyticsConstants.viewEDPsourceValues
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local useGameJoinCardAnalytics = require(script.Parent.Parent.Parent.Analytics.useGameJoinCardAnalytics)
local useAgeCheckUpsellAnalytics = require(script.Parent.Parent.Parent.Analytics.useAgeCheckUpsellAnalytics)
local useAgeCheckCompletionLogger = useAgeCheckUpsellAnalytics.useAgeCheckCompletionLogger
local useAgeCheckPressLogger = useAgeCheckUpsellAnalytics.useAgeCheckPressLogger

local function DesktopGameJoinCardContainer(t1: {[any]: any}) -- line: 91
	-- upvalues: useDispatch (copy), useNavigation (copy), useNavigationFocus (copy), React (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy), ContentProvider (copy), FFlagJoinCardAgeCheckUpsell (copy), useAgeCheckCompletionLogger (copy), useJoinUserInExperience (copy), useAgeCheckPressLogger (copy), useGameJoinCardAnalytics (copy), dependencyArray (copy), usePreferredInput (copy), Responsive (copy), FFlagEnableConsoleGameJoinCard (copy), getPlatformFriendsService (copy), useAppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), useRoactService (copy), AppEventIngestService (copy), AppSessionService (copy), AppGuiService (copy), useAppPolicy (copy), gamePlayIntent (copy), PeopleListInHomePage (copy), HttpService (copy), SetGamePlaySession (copy), SessionType (copy), gameDetailReferral (copy), OpenGameDetails (copy), viewEDPsourceValues (copy), GameJoinCardButtonAction (copy), viewProfileSourceValues (copy), FFlagEnableSplitPane (copy), AppPage (copy), NotificationType (copy), DesktopGameJoinCard (copy), GamepadJoinFocusBehavior (copy)
	local v56 = useDispatch()
	local v57 = useNavigation()
	local v58 = useNavigationFocus() ~= false
	local layoutOrder = t1.layoutOrder
	local playerName = t1.playerName
	local platformName = t1.platformName
	local presence = t1.presence
	local str = tostring(presence.universeId)
	local lastLocation = presence.lastLocation
	local v65 = React.useMemo(function() -- line: 101
		-- upvalues: getRbxThumb (copy), ThumbnailType (copy), str (copy), ThumbnailSize (copy)
		return getRbxThumb(ThumbnailType.GameIcon, str, ThumbnailSize.Small)
	end, { str })
	local v66, v67 = React.useState(Enum.AssetFetchStatus.None)

	React.useEffect(function() -- line: 105
		-- upvalues: v67 (copy), ContentProvider (copy), v65 (copy)
		v67(ContentProvider:GetAssetFetchStatus(v65))
	end, { v65 })
	React.useEffect(function() -- line: 108
		-- upvalues: ContentProvider (copy), v65 (copy), v67 (copy)
		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(v65):Connect(v67)

		return function() -- line: 111
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v65 })

	local v68 = if not FFlagJoinCardAgeCheckUpsell then nil else useAgeCheckCompletionLogger(str)
	local v69 = useJoinUserInExperience(t1.userId, {
		isHomePageCarousel = true,
		homepageCarouselAbsolutePosition = t1.homepageCarouselAbsolutePosition,
		presence = t1.presence,
		onAgeCheckCompletion = v68
	})
	local v70 = if not FFlagJoinCardAgeCheckUpsell then nil else useAgeCheckPressLogger({
		userId = t1.userId,
		universeId = str,
		absolutePosition = t1.homepageCarouselAbsolutePosition,
		joinAgeCheckUpsellFlow = v69.joinAgeCheckUpsellFlow
	})
	local v71 = FFlagJoinCardAgeCheckUpsell and v69.ageCheckRequired == true
	local v72 = React.useRef(false)

	React.useEffect(function() -- line: 138
		-- upvalues: t1 (copy), v58 (copy), v72 (copy), useGameJoinCardAnalytics (copy)
		local v92 = t1.isOpen == true and v58

		if v92 and not v72.current then
			local universeId = t1.presence.universeId

			useGameJoinCardAnalytics.logGameJoinCardPageLoaded({
				friendId = t1.userId,
				universeId = if universeId == nil or tostring(universeId) == "" then nil else tostring(universeId),
				absolutePosition = t1.homepageCarouselAbsolutePosition
			})
		end

		v72.current = v92
	end, dependencyArray(t1.isOpen, v58, t1.userId, t1.presence, t1.homepageCarouselAbsolutePosition))
	React.useEffect(function() -- line: 162
		-- upvalues: t1 (copy), v58 (copy)
		if t1.isOpen and not v58 then
			t1.onClose()
		end
	end, dependencyArray(v58, t1))
	React.useEffect(function() -- line: 169
		-- upvalues: t1 (copy), v58 (copy), v71 (copy), useGameJoinCardAnalytics (copy), str (copy)
		if not t1.isOpen or not v58 or not v71 then
			return
		end

		useGameJoinCardAnalytics.logJoinCardAgeCheckUpsellImpression({
			universeId = if str == "" then nil else str
		})
	end, dependencyArray(t1.isOpen, v58, v71, str))

	local v73 = str == "" or (lastLocation == nil or (lastLocation == "" or v66 == Enum.AssetFetchStatus.Loading))
	local v74 = usePreferredInput() == Responsive.Input.Directional
	local v75 = nil

	if FFlagEnableConsoleGameJoinCard then
		local platformProfileId = t1.platformProfileId

		v75 = React.useCallback(function() -- line: 190
			-- upvalues: getPlatformFriendsService (copy), platformProfileId (copy)
			if getPlatformFriendsService == nil or (platformProfileId == nil or platformProfileId == "") then
				return
			end

			getPlatformFriendsService:ShowProfile(platformProfileId)
		end, { platformProfileId })
	end

	local v77 = if not FFlagEnableConsoleGameJoinCard then nil else useAppFocusRoot({
		isAutoFocusRoot = false,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isFocusable = t1.isFocused == true and v58
	})
	local v78 = React.useRef(nil)
	local v79 = React.useCallback(function(p1) -- line: 208
		-- upvalues: FFlagEnableConsoleGameJoinCard (copy), v78 (copy), v77 (copy), t1 (copy)
		if not FFlagEnableConsoleGameJoinCard then
			return
		end

		v78.current = p1

		if v77 then
			v77(p1)
		end

		if t1.onCardGuiObjectChanged then
			t1.onCardGuiObjectChanged(p1)
		end
	end, {
		v77,
		t1.onCardGuiObjectChanged
	})
	local v80 = useRoactService(AppEventIngestService)
	local v81 = useRoactService(AppSessionService)
	local v82 = useRoactService(AppGuiService)
	local v83 = useAppPolicy(function(p2) -- line: 225
		return p2.getCanUsePlatformChat()
	end)
	local v84 = React.useCallback(function() -- line: 229
		-- upvalues: t1 (copy), presence (copy), gamePlayIntent (copy), v80 (copy), PeopleListInHomePage (copy), HttpService (copy)
		local userId = t1.userId

		if userId == "" then
			return
		end

		local v97 = (presence.placeId == nil or tostring(presence.placeId) == "") and "" or tostring(presence.placeId)
		local num = tonumber(presence.rootPlaceId)

		if v97 == "" or num == nil then
			return
		end

		gamePlayIntent(v80, PeopleListInHomePage, {
			placeId = v97,
			rootPlaceId = num,
			friendId = userId,
			joinAttemptId = HttpService:GenerateGUID(false)
		})
	end, dependencyArray(t1.userId, presence))
	local v85 = React.useCallback(function() -- line: 250
		-- upvalues: str (copy), presence (copy), t1 (copy), v81 (copy), SetGamePlaySession (copy), SessionType (copy), gameDetailReferral (copy), v80 (copy), v56 (copy), OpenGameDetails (copy), v57 (copy)
		if str == "" then
			return
		end

		local rootPlaceId = presence.rootPlaceId
		local v100 = if rootPlaceId == nil or tostring(rootPlaceId) == "" then str else tostring(rootPlaceId)
		local v101 = t1.homepageCarouselAbsolutePosition or 0

		if v81 then
			SetGamePlaySession(v81, SessionType.StructuralIdentifier.GameDetailSource, false)
		end

		gameDetailReferral(v80, "home", {
			ad = "no",
			pg = "home",
			rowOnPage = 1,
			tis = 1,
			friendId = t1.userId,
			pid = v100,
			pos = v101,
			sortPos = t1.layoutOrder,
			universeId = str
		})
		v56(OpenGameDetails(str, v57))
	end, dependencyArray(v56, v57, str, presence, t1.homepageCarouselAbsolutePosition, t1.layoutOrder, t1.userId))
	local v86 = React.useCallback(function(p3) -- line: 286
		-- upvalues: str (copy), t1 (copy), viewEDPsourceValues (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), v85 (copy)
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

		v85()
	end, dependencyArray(v85, str, t1.userId, t1.homepageCarouselAbsolutePosition))
	local v87 = React.useCallback(function() -- line: 312
		-- upvalues: t1 (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), str (copy), v84 (copy), v69 (copy)
		if t1.userId ~= "" then
			useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.JoinGame, {
				friendId = t1.userId,
				universeId = if str == "" then nil else str,
				absolutePosition = t1.homepageCarouselAbsolutePosition
			})
		end

		v84()
		v69.joinExperience()
		t1.onClose()
	end, dependencyArray(v84, v69.joinExperience, t1.userId, str, t1.homepageCarouselAbsolutePosition, t1.onClose))
	local v88 = React.useCallback(function(p4) -- line: 334
		-- upvalues: t1 (copy), str (copy), viewProfileSourceValues (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), FFlagEnableSplitPane (copy), v57 (copy), AppPage (copy)
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
		end;

		((if not FFlagEnableSplitPane then v57.navigate else v57.push))(AppPage.ProfilePlatform, {
			detail = t1.userId
		})
		t1.onClose()
	end, dependencyArray(v57, t1.userId, str, t1.homepageCarouselAbsolutePosition, t1.onClose))
	local v89 = React.useCallback(function() -- line: 360
		-- upvalues: t1 (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), str (copy), v82 (copy), NotificationType (copy)
		if t1.userId == "" then
			return
		end

		useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.Chat, {
			friendId = t1.userId,
			universeId = if str == "" then nil else str,
			absolutePosition = t1.homepageCarouselAbsolutePosition
		})
		v82:BroadcastNotification(t1.userId, NotificationType.LAUNCH_CONVERSATION)
		t1.onClose()
	end, dependencyArray(t1.userId, str, t1.homepageCarouselAbsolutePosition, v82, t1.onClose))
	local v90 = React.createElement(DesktopGameJoinCard, {
		layoutOrder = layoutOrder,
		playerName = playerName,
		experienceName = lastLocation,
		gameIconUrl = v65,
		isLoading = v73,
		onJoin = v87,
		onViewExperienceDetails = v86,
		anchorRef = t1.anchorRef,
		isOpen = t1.isOpen and v58,
		onClose = t1.onClose,
		isConsole = v74,
		consolePlatformLabel = platformName,
		focusRootRef = if not FFlagEnableConsoleGameJoinCard then nil else v79,
		ageCheckRequired = if not FFlagJoinCardAgeCheckUpsell then nil else v69.ageCheckRequired,
		onAgeCheckPressed = v70,
		onPlatformProfilePressed = if not FFlagEnableConsoleGameJoinCard or not v74 then nil else v75,
		onChat = if v74 or not v83 then nil else v89,
		onViewProfile = if v74 then nil else v88
	})

	if t1.showGamepadJoinFocus then
		return React.createElement(React.Fragment, nil, {
			GamepadJoinFocus = React.createElement(GamepadJoinFocusBehavior, {
				tileRef = t1.anchorRef,
				cardRef = if not FFlagEnableConsoleGameJoinCard then nil else v78,
				joinExperience = v87
			}),
			Card = v90
		})
	end

	return v90
end

return DesktopGameJoinCardContainer
