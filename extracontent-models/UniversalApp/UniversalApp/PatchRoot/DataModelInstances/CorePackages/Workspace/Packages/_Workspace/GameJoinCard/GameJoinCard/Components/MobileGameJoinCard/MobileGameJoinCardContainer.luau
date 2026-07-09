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
local DataHydration = require(ParentParent.DataHydration)
local v25 = if not FFlagSocialCarouselUseProfileStore and not FFlagFriendSortedByPresenceSignalsImplementation then nil else require(ParentParent.Signals)
local v26 = if not FFlagSocialCarouselUseProfileStore and not FFlagFriendSortedByPresenceSignalsImplementation then nil else require(ParentParent.SignalsReact)
local v27 = if not FFlagSocialCarouselUseProfileStore then nil else UserProfiles.Stores.UserProfileStore.get()
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
local v42 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else DataHydration.Presence.PresenceStore.get()
local t1 = {
	universeId = "",
	lastLocation = "",
	userPresenceType = "",
	placeId = "",
	rootPlaceId = "",
	gameId = ""
}

local function MobileGameJoinCardContainer() -- line: 77
	-- upvalues: useNavigation (copy), useRoactService (copy), AppEventIngestService (copy), AppGuiService (copy), useAppPolicy (copy), Players (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), React (copy), v25 (copy), v42 (copy), v26 (copy), useQuery (copy), ApolloLocalState (copy), useGameJoinCardAnalytics (copy), FFlagSocialCarouselUseProfileStore (copy), v27 (copy), UserProfiles (copy), useExperienceBannerImage (copy), GameJoinCardTelemetry (copy), FFlagJoinCardAgeCheckUpsell (copy), useAgeCheckCompletionLogger (copy), useJoinUserInExperience (copy), t1 (copy), useAgeCheckPressLogger (copy), GameJoinCardButtonAction (copy), gamePlayIntent (copy), PeopleListInHomePage (copy), HttpService (copy), dependencyArray (copy), AppPage (copy), viewProfileSourceValues (copy), NotificationType (copy), MobileGameJoinCard (copy)
	local v45 = useNavigation()
	local v46 = v45.getParam("userId") or ""
	local v47 = v45.getParam("homepageCarouselAbsolutePosition")
	local v48 = useRoactService(AppEventIngestService)
	local v49 = useRoactService(AppGuiService)
	local v50 = useAppPolicy(function(p1) -- line: 84
		return p1.getCanUsePlatformChat()
	end)
	local str = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or "")
	local u53

	if FFlagFriendSortedByPresenceSignalsImplementation then
		local v52 = React.useMemo(function() -- line: 93
			-- upvalues: v25 (copy), v42 (copy), v46 (copy)
			return v25.createComputed(function(p2) -- line: 94
				-- upvalues: v42 (copy), v46 (copy)
				return v42.GetPresenceByUserId(v46).data(p2)
			end)
		end, { v46 })

		u53 = v26.useSignalState(v52)
	else
		local v54 = useQuery(ApolloLocalState.queries.onlineFriendsByUserId, {
			fetchPolicy = "cache-only",
			variables = {
				sort = 1,
				userId = str
			}
		})

		u53 = React.useMemo(function() -- line: 109
			-- upvalues: v54 (copy), v46 (copy)
			local v77 = v54.data and v54.data.onlineFriendsByUserId

			if not v77 then
				return nil
			end

			for _, v79 in v77 do
				if v79.id == v46 then
					return v79.presence
				end
			end

			return nil
		end, {
			v54.data,
			v46
		})
	end

	local v55, v56 = React.useState({
		universeId = "",
		experienceName = ""
	})

	React.useEffect(function() -- line: 128
		-- upvalues: u53 (ref), v56 (copy)
		if not u53 or tostring(u53.universeId) == "" then
			return
		end

		v56({
			universeId = tostring(u53.universeId),
			experienceName = u53.lastLocation
		})
	end, { u53 })

	local universeId = v55.universeId
	local experienceName = v55.experienceName

	React.useEffect(function() -- line: 141
		-- upvalues: v46 (copy), u53 (ref), useGameJoinCardAnalytics (copy), v47 (copy)
		if v46 == "" then
			return
		end

		local v80 = if not u53 or (u53.universeId == nil or tostring(u53.universeId) == "") then nil else tostring(u53.universeId)

		useGameJoinCardAnalytics.logGameJoinCardPageLoaded({
			friendId = v46,
			universeId = v80,
			absolutePosition = v47
		})
	end, {})

	local v61

	if FFlagSocialCarouselUseProfileStore then
		local v59 = React.useMemo(function() -- line: 159
			-- upvalues: v27 (copy), v46 (copy)
			return v27.fetchNamesByUserIds({ v46 })
		end, { v46 })
		local v60 = React.useMemo(function() -- line: 163
			-- upvalues: v25 (copy), v59 (copy)
			return v25.createComputed(function(p3) -- line: 164
				-- upvalues: v59 (copy)
				local v88 = v59(p3)
				local v89 = v88 and (v88.data and v88.data[1])

				if v89 and v89.names then
					return (v89.names.getCombinedName(p3))
				end

				return nil
			end)
		end, { v59 })

		v61 = v26.useSignalState(v60) or ""
	else
		local v62 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { v46 },
			query = UserProfiles.Queries.userProfilesCombinedAndPlatformByUserIds
		})

		v61 = React.useMemo(function() -- line: 178
			-- upvalues: v62 (copy), UserProfiles (copy), v46 (copy)
			if not v62.data then
				return ""
			end

			return UserProfiles.Selectors.getCombinedNameFromId(v62.data, v46) or ""
		end, {
			v62.data,
			v46
		})
	end

	local v63 = if not u53 or u53.rootPlaceId == nil then nil else tostring(u53.rootPlaceId)
	local v64 = useExperienceBannerImage(universeId, v63)

	React.useEffect(function() -- line: 191
		-- upvalues: universeId (copy), GameJoinCardTelemetry (copy), v64 (copy)
		if universeId == "" then
			return
		end

		GameJoinCardTelemetry.logBannerLoadResult(v64.status)
	end, {
		v64.status,
		universeId
	})

	local v65 = React.useCallback(function() -- line: 198
		-- upvalues: v45 (copy)
		v45.goBack()
	end, { v45 })
	local v66 = if not FFlagJoinCardAgeCheckUpsell then nil else useAgeCheckCompletionLogger(universeId)
	local v67 = useJoinUserInExperience(v46, {
		isHomePageCarousel = true,
		presence = u53 or t1,
		onBeforeJoin = v65,
		onAgeCheckCompletion = v66
	})
	local v68 = if not FFlagJoinCardAgeCheckUpsell then nil else useAgeCheckPressLogger({
		userId = v46,
		universeId = universeId,
		absolutePosition = v47,
		joinAgeCheckUpsellFlow = v67.joinAgeCheckUpsellFlow
	})
	local v69 = FFlagJoinCardAgeCheckUpsell and v67.ageCheckRequired == true

	React.useEffect(function() -- line: 223
		-- upvalues: v69 (copy), universeId (copy), useGameJoinCardAnalytics (copy)
		if not v69 or universeId == "" then
			return
		end

		useGameJoinCardAnalytics.logJoinCardAgeCheckUpsellImpression({
			universeId = universeId
		})
	end, {
		v69,
		universeId
	})

	local v70 = React.useCallback(function() -- line: 232
		-- upvalues: v45 (copy)
		v45.goBack()
	end, { v45 })
	local v71 = React.useCallback(function() -- line: 236
		-- upvalues: v46 (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), universeId (copy), v47 (copy), u53 (ref), gamePlayIntent (copy), v48 (copy), PeopleListInHomePage (copy), HttpService (copy)
		local v81 = v46

		if v81 ~= "" then
			useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.JoinGame, {
				friendId = v81,
				universeId = if universeId == "" then nil else universeId,
				absolutePosition = v47
			})
		end

		if v81 == "" or not u53 then
			return
		end

		local v82 = (u53.placeId == nil or tostring(u53.placeId) == "") and "" or tostring(u53.placeId)
		local num = tonumber(u53.rootPlaceId)

		if v82 == "" or num == nil then
			return
		end

		gamePlayIntent(v48, PeopleListInHomePage, {
			placeId = v82,
			rootPlaceId = num,
			friendId = v81,
			joinAttemptId = HttpService:GenerateGUID(false)
		})
	end, dependencyArray(v46, universeId, v47, u53))
	local v72 = React.useCallback(function() -- line: 263
		-- upvalues: v45 (copy), AppPage (copy), v46 (copy)
		v45.navigate(AppPage.ProfilePlatform, {
			detail = v46
		})
	end, {
		v45,
		v46
	})
	local v73 = React.useCallback(function(p4) -- line: 269
		-- upvalues: v46 (copy), universeId (copy), v47 (copy), viewProfileSourceValues (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), v72 (copy)
		if v46 ~= "" then
			local t2 = {
				friendId = v46,
				universeId = if universeId == "" then nil else universeId,
				absolutePosition = v47
			}

			if p4 == viewProfileSourceValues.UserTile then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.OpenProfileFromUserTile, t2)
			elseif p4 == viewProfileSourceValues.ViewProfileButton then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.OpenProfileFromViewProfile, t2)
			end
		end

		v72()
	end, dependencyArray(v72, v46, universeId, v47))
	local v74 = React.useCallback(function() -- line: 291
		-- upvalues: v71 (copy), v67 (copy)
		v71()
		v67.joinExperience()
	end, dependencyArray(v71, v67))
	local v75 = React.useCallback(function() -- line: 296
		-- upvalues: v46 (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), universeId (copy), v47 (copy), v49 (copy), NotificationType (copy)
		if v46 == "" then
			return
		end

		useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.Chat, {
			friendId = v46,
			universeId = if universeId == "" then nil else universeId,
			absolutePosition = v47
		})
		v49:BroadcastNotification(v46, NotificationType.LAUNCH_CONVERSATION)
	end, dependencyArray(v46, universeId, v47, v45, v49))

	return React.createElement(MobileGameJoinCard, {
		onClose = v70,
		onJoin = v74,
		onViewProfile = v73,
		onChat = v75,
		canUsePlatformChat = v50,
		userId = v46,
		universeId = universeId,
		homepageCarouselAbsolutePosition = v47,
		playerName = v61,
		experienceName = experienceName,
		bannerImageUrl = v64.url,
		isLoading = v67.isLoading,
		isInExperience = v67.isInExperience,
		ageCheckRequired = if not FFlagJoinCardAgeCheckUpsell then nil else v67.ageCheckRequired,
		onAgeCheckPressed = v68,
		wasPlayabilityCached = v67.playabilityFromCache
	})
end

return MobileGameJoinCardContainer
