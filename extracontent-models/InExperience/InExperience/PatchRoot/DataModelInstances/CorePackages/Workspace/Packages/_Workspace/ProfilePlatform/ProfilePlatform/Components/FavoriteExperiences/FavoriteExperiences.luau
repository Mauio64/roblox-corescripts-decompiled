local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Cryo = require(ProfilePlatformParent.Cryo)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local NavigateDown = require(ProfilePlatformParent.NavigationRodux).Thunks.NavigateDown
local Url = require(ProfilePlatformParent.Http).Url
local NetworkingGames = require(ProfilePlatform.Networking.NetworkingGames)
local getDeepValue = require(ProfilePlatformParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local SquareCollectionGridView = require(ProfilePlatform.BaseComponents.CollectionGridViews.SquareCollectionGridView)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useRenderExperienceTile = require(ProfilePlatform.Hooks.Tiles.useRenderExperienceTile)
local useRenderExperienceTile_DEPRECATED = require(ProfilePlatform.Hooks.Tiles.useRenderExperienceTile_DEPRECATED)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useSendItemImpressions = require(ProfilePlatform.Hooks.useSendItemImpressions)
local useGenerateImpressionsTag = require(ProfilePlatform.Hooks.useGenerateImpressionsTag)
local formatExperienceDetailsForImpressions = require(ProfilePlatform.Hooks.formatExperienceDetailsForImpressions)
local Enums = require(ProfilePlatform.Common.Enums)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local TextKeys = require(ProfilePlatform.Common.TextKeys)

require(ProfilePlatform.Common.Types)

local ContentType = require(ProfilePlatformParent.UnifiedLogging).ContentType
local RoactAnalyticsCommonGameEvents = require(ProfilePlatformParent.RoactServiceTags).RoactAnalyticsCommonGameEvents
local useRoactService = require(ProfilePlatformParent.RobloxAppHooks).useRoactService
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local v30 = game:DefineFastFlag("ProfilePlatformFavoritesNavigateToWeb_V2", false)
local v31 = game:DefineFastFlag("ProfilePlatformFavoritesEnableProfilePlatformClickAnalytics", false)
local FFlagProfilePlatformFavoritesEnableGameDetailAnalytics = SharedFlags.FFlagProfilePlatformFavoritesEnableGameDetailAnalytics
local FFlagProfilePlatformEnableImpressions = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableImpressions
local FFlagProfilePlatformImproveGameDetailsAnalytics = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformImproveGameDetailsAnalytics
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v36 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands
local t1 = {}

local function getSquareExperienceTileHeight(n1: number) -- line: 65
	return n1 + 42
end
local function useFavoriteExperiences(_: string) -- line: 69
	-- upvalues: useDispatch (copy), useProfileJsonComponent (copy), Enums (copy), t1 (copy), React (copy), Cryo (copy), NetworkingGames (copy), useSelector (copy), getDeepValue (copy)
	local v43 = useDispatch()
	local v44 = useProfileJsonComponent(Enums.Components.FavoriteExperiences).experiences or t1
	local v45 = React.useMemo(function() -- line: 75
		-- upvalues: Cryo (copy), v44 (copy)
		return Cryo.List.map(v44, function(p1, _) -- line: 76
			return (tostring(p1.universeId))
		end)
	end, { v44 })

	React.useEffect(function() -- line: 81
		-- upvalues: v45 (copy), Cryo (copy), v43 (copy), NetworkingGames (copy)
		if v45 ~= nil and not Cryo.isEmpty(v45) then
			v43(NetworkingGames.GetExperiencesDetails.API(v45)):catch(function(_) -- line: 83
			end)
		end
	end, { v45 })

	local v46 = useSelector(function(p4) -- line: 89
		-- upvalues: getDeepValue (copy), t1 (copy)
		return getDeepValue(p4, "ProfilePlatform.Games.byGameId") or t1
	end)
	local v47 = React.useMemo(function() -- line: 93
		-- upvalues: v45 (copy), v46 (copy)
		local t2 = {}

		for _, v67 in v45 do
			if v46[v67] then
				table.insert(t2, v46[v67])
			end
		end

		return t2
	end, {
		v45,
		v46
	})

	if not v44 or #v47 ~= #v45 then
		return t1
	end

	return v47
end
local function FavoriteExperiences(t3: {[any]: any}) -- line: 114
	-- upvalues: useDispatch (copy), useProfileWrapperContext (copy), v31 (copy), useProfileAnalyticsContext (copy), FFlagProfilePlatformEnableImpressions (copy), useGenerateImpressionsTag (copy), Enums (copy), useLocalization (copy), TextKeys (copy), React (copy), EventNames (copy), v30 (copy), AppPage (copy), Url (copy), FFlagSignalsNavP3Dispatch (copy), v36 (copy), NavigateDown (copy), getSquareExperienceTileHeight (copy), useFavoriteExperiences (copy), FFlagProfilePlatformFavoritesEnableGameDetailAnalytics (copy), useRoactService (copy), RoactAnalyticsCommonGameEvents (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), useRenderExperienceTile (copy), useRenderExperienceTile_DEPRECATED (copy), formatExperienceDetailsForImpressions (copy), useSendItemImpressions (copy), ContentType (copy), Cryo (copy), SquareCollectionGridView (copy)
	local v49 = useDispatch()
	local v50 = useProfileWrapperContext()
	local v51 = if not v31 then nil else useProfileAnalyticsContext()
	local v52 = if not FFlagProfilePlatformEnableImpressions then nil else useGenerateImpressionsTag(Enums.Components.FavoriteExperiences)
	local profileId = v50.profileId
	local v54 = useLocalization({
		title = TextKeys.Favorites
	})
	local v55 = React.useCallback(function() -- line: 131
		-- upvalues: v31 (copy), v51 (copy), EventNames (copy), v30 (copy), AppPage (copy), Url (copy), profileId (copy), TextKeys (copy), FFlagSignalsNavP3Dispatch (copy), v36 (copy), v49 (copy), NavigateDown (copy)
		if v31 and v51 then
			v51.fireAnalyticsEvent(EventNames.FavoriteExperienceSeeAll)
		end

		if v30 then
			local t4 = {
				name = AppPage.GenericWebPage,
				detail = string.format("%susers/%s/favorites#!/places", Url.BASE_URL, profileId),
				extraProps = {
					titleKey = TextKeys.Favorites
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v36.down(v36.fromLegacyPage(t4))

				return
			end

			v49(NavigateDown(t4, nil))
		end
	end, if not v31 then nil else {
		profileId,
		v51
	})
	local v56 = v30
	local v57 = getSquareExperienceTileHeight
	local v58 = useFavoriteExperiences(profileId)
	local v59 = if not FFlagProfilePlatformFavoritesEnableGameDetailAnalytics then nil else useRoactService(RoactAnalyticsCommonGameEvents)
	local v60 = React.useCallback(function(p5, n2: number, n3: number?) -- line: 165
		-- upvalues: v31 (copy), v51 (copy), EventNames (copy), FFlagProfilePlatformFavoritesEnableGameDetailAnalytics (copy), v58 (copy), v59 (copy), AppPage (copy), t3 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), profileId (copy)
		if v31 then
			v51.fireAnalyticsEvent(EventNames.FavoriteExperienceOpened, {
				experienceId = p5.experienceId,
				positionInComponent = n2
			})
		end

		if FFlagProfilePlatformFavoritesEnableGameDetailAnalytics then
			local n4 = 0

			if v58 then
				n4 = #v58
			end

			v59.reportOpenGameDetailFromProfile(p5.rootPlaceId, n2, n4, p5.experienceId, AppPage.ProfilePlatform, t3.layoutOrder, n3 or 1, if not FFlagProfilePlatformImproveGameDetailsAnalytics then nil else profileId)
		end
	end, if not FFlagProfilePlatformFavoritesEnableGameDetailAnalytics then { v51 } else {
		v51,
		v58,
		v59,
		t3.layoutOrder
	})
	local v61 = if not FFlagProfilePlatformEnableImpressions then useRenderExperienceTile_DEPRECATED("ProfileFavoriteExperienceTile", v60) else useRenderExperienceTile(v52, "ProfileFavoriteExperienceTile", v60)
	local v62 = if not FFlagProfilePlatformEnableImpressions then nil else React.useMemo(function() -- line: 198
		-- upvalues: formatExperienceDetailsForImpressions (copy), v58 (copy)
		return formatExperienceDetailsForImpressions(v58)
	end, { v58 })
	local v63 = if not FFlagProfilePlatformEnableImpressions then nil else useSendItemImpressions(v62, 3, ContentType.Game, t3.layoutOrder, Enums.Components.FavoriteExperiences)

	if not Cryo.isEmpty(v58) then
		return (React.createElement(SquareCollectionGridView, {
			getItemHeight = v57,
			hideHeaderButton = not v56,
			items = v58,
			layoutOrder = t3.layoutOrder,
			onActivateHeader = v55,
			renderItem = v61,
			title = v54.title,
			impressionsTag = if not FFlagProfilePlatformEnableImpressions then nil else v52,
			sendImpressions = if not FFlagProfilePlatformEnableImpressions then nil else v63,
			overrides = {
				numColumns = 3
			}
		}))
	end

	return nil
end

return FavoriteExperiences
