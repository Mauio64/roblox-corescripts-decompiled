local ParentParent = script.Parent.Parent.Parent.Parent
local HttpService = game:GetService("HttpService")
local React = require(ParentParent.React)
local AnalyticsConstants = require(script.Parent.Parent.Parent.Analytics.AnalyticsConstants)
local GameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local useGameJoinCardAnalytics = require(script.Parent.Parent.Parent.Analytics.useGameJoinCardAnalytics)
local useAgeCheckUpsellAnalytics = require(script.Parent.Parent.Parent.Analytics.useAgeCheckUpsellAnalytics)
local useAgeCheckCompletionLogger = useAgeCheckUpsellAnalytics.useAgeCheckCompletionLogger
local useAgeCheckPressLogger = useAgeCheckUpsellAnalytics.useAgeCheckPressLogger
local GameJoinCardTelemetry = require(script.Parent.Parent.Parent.Telemetry.GameJoinCardTelemetry)
local RobloxAppEnums = require(ParentParent.RobloxAppEnums)
local RoactUtils = require(ParentParent.RoactUtils)
local SocialExperienceJoin = require(ParentParent.SocialExperienceJoin)
local useNavigation = require(ParentParent.Navigation).useNavigation
local useQuery = require(ParentParent.ApolloClient).useQuery
local ApolloLocalState = require(ParentParent.ApolloLocalState)
local Players = game:GetService("Players")
local UserProfiles = require(ParentParent.UserProfiles)
local SharedFlags = require(ParentParent.SharedFlags)
local FFlagSocialCarouselUseProfileStore = SharedFlags.FFlagSocialCarouselUseProfileStore
local FFlagFriendSortedByPresenceSignalsImplementation = SharedFlags.FFlagFriendSortedByPresenceSignalsImplementation
local FFlagJoinCardAgeCheckUpsell = SharedFlags.FFlagJoinCardAgeCheckUpsell
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local DataHydration = require(ParentParent.DataHydration)
local v26 = if not FFlagSocialCarouselUseProfileStore and not FFlagFriendSortedByPresenceSignalsImplementation then nil else require(ParentParent.Signals)
local v27 = if not FFlagSocialCarouselUseProfileStore and not FFlagFriendSortedByPresenceSignalsImplementation then nil else require(ParentParent.SignalsReact)
local v28 = if not FFlagSocialCarouselUseProfileStore then nil else UserProfiles.Stores.UserProfileStore.get()
local useExperienceBannerImage = require(ParentParent.GameDetail).useExperienceBannerImage
local DiscoveryAnalytics = require(ParentParent.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local PeopleListInHomePage = DiscoveryAnalytics.Constants.Context.PeopleListInHomePage
local RoactServiceTags = require(ParentParent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local AppGuiService = RoactServiceTags.AppGuiService
local useRoactService = require(ParentParent.RobloxAppHooks).useRoactService
local useAppPolicy = require(ParentParent.UniversalAppPolicy).useAppPolicy
local AppPage = RobloxAppEnums.AppPage
local NotificationType = RobloxAppEnums.NotificationType
local dependencyArray = RoactUtils.Hooks.dependencyArray
local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience
local MobileGameJoinCard = require(script.Parent.MobileGameJoinCard)
local v43 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else DataHydration.Presence.PresenceStore.get()
local t1 = {
	universeId = "",
	lastLocation = "",
	userPresenceType = "",
	placeId = "",
	rootPlaceId = "",
	gameId = ""
}

local function MobileGameJoinCardContainer() -- line: 78
	-- upvalues: useNavigation (copy), useRoactService (copy), AppEventIngestService (copy), AppGuiService (copy), useAppPolicy (copy), Players (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), React (copy), v26 (copy), v43 (copy), v27 (copy), useQuery (copy), ApolloLocalState (copy), useGameJoinCardAnalytics (copy), FFlagSocialCarouselUseProfileStore (copy), v28 (copy), UserProfiles (copy), useExperienceBannerImage (copy), GameJoinCardTelemetry (copy), FFlagJoinCardAgeCheckUpsell (copy), useAgeCheckCompletionLogger (copy), useJoinUserInExperience (copy), t1 (copy), useAgeCheckPressLogger (copy), GameJoinCardButtonAction (copy), gamePlayIntent (copy), PeopleListInHomePage (copy), HttpService (copy), dependencyArray (copy), FFlagEnableSplitPane (copy), AppPage (copy), viewProfileSourceValues (copy), NotificationType (copy), MobileGameJoinCard (copy)
	local v46 = useNavigation()
	local v47 = v46.getParam("userId") or ""
	local v48 = v46.getParam("homepageCarouselAbsolutePosition")
	local v49 = useRoactService(AppEventIngestService)
	local v50 = useRoactService(AppGuiService)
	local v51 = useAppPolicy(function(p1) -- line: 85
		return p1.getCanUsePlatformChat()
	end)
	local str = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or "")
	local u54

	if FFlagFriendSortedByPresenceSignalsImplementation then
		local v53 = React.useMemo(function() -- line: 94
			-- upvalues: v26 (copy), v43 (copy), v47 (copy)
			return v26.createComputed(function(p2) -- line: 95
				-- upvalues: v43 (copy), v47 (copy)
				return v43.GetPresenceByUserId(v47).data(p2)
			end)
		end, { v47 })

		u54 = v27.useSignalState(v53)
	else
		local v55 = useQuery(ApolloLocalState.queries.onlineFriendsByUserId, {
			fetchPolicy = "cache-only",
			variables = {
				sort = 1,
				userId = str
			}
		})

		u54 = React.useMemo(function() -- line: 110
			-- upvalues: v55 (copy), v47 (copy)
			local v78 = v55.data and v55.data.onlineFriendsByUserId

			if not v78 then
				return nil
			end

			for _, v80 in v78 do
				if v80.id == v47 then
					return v80.presence
				end
			end

			return nil
		end, {
			v55.data,
			v47
		})
	end

	local v56, v57 = React.useState({
		universeId = "",
		experienceName = ""
	})

	React.useEffect(function() -- line: 129
		-- upvalues: u54 (ref), v57 (copy)
		if not u54 or tostring(u54.universeId) == "" then
			return
		end

		v57({
			universeId = tostring(u54.universeId),
			experienceName = u54.lastLocation
		})
	end, { u54 })

	local universeId = v56.universeId
	local experienceName = v56.experienceName

	React.useEffect(function() -- line: 142
		-- upvalues: v47 (copy), u54 (ref), useGameJoinCardAnalytics (copy), v48 (copy)
		if v47 == "" then
			return
		end

		local v81 = if not u54 or (u54.universeId == nil or tostring(u54.universeId) == "") then nil else tostring(u54.universeId)

		useGameJoinCardAnalytics.logGameJoinCardPageLoaded({
			friendId = v47,
			universeId = v81,
			absolutePosition = v48
		})
	end, {})

	local v62

	if FFlagSocialCarouselUseProfileStore then
		local v60 = React.useMemo(function() -- line: 160
			-- upvalues: v28 (copy), v47 (copy)
			return v28.fetchNamesByUserIds({ v47 })
		end, { v47 })
		local v61 = React.useMemo(function() -- line: 164
			-- upvalues: v26 (copy), v60 (copy)
			return v26.createComputed(function(p3) -- line: 165
				-- upvalues: v60 (copy)
				local v89 = v60(p3)
				local v90 = v89 and (v89.data and v89.data[1])

				if v90 and v90.names then
					return (v90.names.getCombinedName(p3))
				end

				return nil
			end)
		end, { v60 })

		v62 = v27.useSignalState(v61) or ""
	else
		local v63 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { v47 },
			query = UserProfiles.Queries.userProfilesCombinedAndPlatformByUserIds
		})

		v62 = React.useMemo(function() -- line: 179
			-- upvalues: v63 (copy), UserProfiles (copy), v47 (copy)
			if not v63.data then
				return ""
			end

			return UserProfiles.Selectors.getCombinedNameFromId(v63.data, v47) or ""
		end, {
			v63.data,
			v47
		})
	end

	local v64 = if not u54 or u54.rootPlaceId == nil then nil else tostring(u54.rootPlaceId)
	local v65 = useExperienceBannerImage(universeId, v64)

	React.useEffect(function() -- line: 192
		-- upvalues: universeId (copy), GameJoinCardTelemetry (copy), v65 (copy)
		if universeId == "" then
			return
		end

		GameJoinCardTelemetry.logBannerLoadResult(v65.status)
	end, {
		v65.status,
		universeId
	})

	local v66 = React.useCallback(function() -- line: 199
		-- upvalues: v46 (copy)
		v46.goBack()
	end, { v46 })
	local v67 = if not FFlagJoinCardAgeCheckUpsell then nil else useAgeCheckCompletionLogger(universeId)
	local v68 = useJoinUserInExperience(v47, {
		isHomePageCarousel = true,
		presence = u54 or t1,
		onBeforeJoin = v66,
		onAgeCheckCompletion = v67
	})
	local v69 = if not FFlagJoinCardAgeCheckUpsell then nil else useAgeCheckPressLogger({
		userId = v47,
		universeId = universeId,
		absolutePosition = v48,
		joinAgeCheckUpsellFlow = v68.joinAgeCheckUpsellFlow
	})
	local v70 = FFlagJoinCardAgeCheckUpsell and v68.ageCheckRequired == true

	React.useEffect(function() -- line: 224
		-- upvalues: v70 (copy), universeId (copy), useGameJoinCardAnalytics (copy)
		if not v70 or universeId == "" then
			return
		end

		useGameJoinCardAnalytics.logJoinCardAgeCheckUpsellImpression({
			universeId = universeId
		})
	end, {
		v70,
		universeId
	})

	local v71 = React.useCallback(function() -- line: 233
		-- upvalues: v46 (copy)
		v46.goBack()
	end, { v46 })
	local v72 = React.useCallback(function() -- line: 237
		-- upvalues: v47 (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), universeId (copy), v48 (copy), u54 (ref), gamePlayIntent (copy), v49 (copy), PeopleListInHomePage (copy), HttpService (copy)
		local v82 = v47

		if v82 ~= "" then
			useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.JoinGame, {
				friendId = v82,
				universeId = if universeId == "" then nil else universeId,
				absolutePosition = v48
			})
		end

		if v82 == "" or not u54 then
			return
		end

		local v83 = (u54.placeId == nil or tostring(u54.placeId) == "") and "" or tostring(u54.placeId)
		local num = tonumber(u54.rootPlaceId)

		if v83 == "" or num == nil then
			return
		end

		gamePlayIntent(v49, PeopleListInHomePage, {
			placeId = v83,
			rootPlaceId = num,
			friendId = v82,
			joinAttemptId = HttpService:GenerateGUID(false)
		})
	end, dependencyArray(v47, universeId, v48, u54))
	local v73 = React.useCallback(function() -- line: 264
		-- upvalues: FFlagEnableSplitPane (copy), v46 (copy), AppPage (copy), v47 (copy);
		((if not FFlagEnableSplitPane then v46.navigate else v46.push))(AppPage.ProfilePlatform, {
			detail = v47
		})
	end, {
		v46,
		v47
	})
	local v74 = React.useCallback(function(p4) -- line: 271
		-- upvalues: v47 (copy), universeId (copy), v48 (copy), viewProfileSourceValues (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), v73 (copy)
		if v47 ~= "" then
			local t2 = {
				friendId = v47,
				universeId = if universeId == "" then nil else universeId,
				absolutePosition = v48
			}

			if p4 == viewProfileSourceValues.UserTile then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.OpenProfileFromUserTile, t2)
			elseif p4 == viewProfileSourceValues.ViewProfileButton then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.OpenProfileFromViewProfile, t2)
			end
		end

		v73()
	end, dependencyArray(v73, v47, universeId, v48))
	local v75 = React.useCallback(function() -- line: 293
		-- upvalues: v72 (copy), v68 (copy)
		v72()
		v68.joinExperience()
	end, dependencyArray(v72, v68))
	local v76 = React.useCallback(function() -- line: 298
		-- upvalues: v47 (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), universeId (copy), v48 (copy), v50 (copy), NotificationType (copy)
		if v47 == "" then
			return
		end

		useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.Chat, {
			friendId = v47,
			universeId = if universeId == "" then nil else universeId,
			absolutePosition = v48
		})
		v50:BroadcastNotification(v47, NotificationType.LAUNCH_CONVERSATION)
	end, dependencyArray(v47, universeId, v48, v46, v50))

	return React.createElement(MobileGameJoinCard, {
		onClose = v71,
		onJoin = v75,
		onViewProfile = v74,
		onChat = v76,
		canUsePlatformChat = v51,
		userId = v47,
		universeId = universeId,
		homepageCarouselAbsolutePosition = v48,
		playerName = v62,
		experienceName = experienceName,
		bannerImageUrl = v65.url,
		isLoading = v68.isLoading,
		isInExperience = v68.isInExperience,
		ageCheckRequired = if not FFlagJoinCardAgeCheckUpsell then nil else v68.ageCheckRequired,
		onAgeCheckPressed = v69,
		wasPlayabilityCached = v68.playabilityFromCache
	})
end

return MobileGameJoinCardContainer
