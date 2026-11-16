local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local Http = require(parent.Http)
local Url = Http.Url

local NetworkingGames = require(ProfilePlatform.Networking.NetworkingGames)

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue

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
local UnifiedLogging = require(parent.UnifiedLogging)
local ContentType = UnifiedLogging.ContentType

local RoactServiceTags = require(parent.RoactServiceTags)
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local SharedFlags = require(parent.SharedFlags)

local defineFastFlag = game:DefineFastFlag("ProfilePlatformFavoritesNavigateToWeb_V2", false)

local defineFastFlag2 = game:DefineFastFlag("ProfilePlatformFavoritesEnableProfilePlatformClickAnalytics", false)

local FFlagProfilePlatformFavoritesEnableGameDetailAnalytics = SharedFlags.FFlagProfilePlatformFavoritesEnableGameDetailAnalytics
local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableImpressions = SharedFlags2.FFlagProfilePlatformEnableImpressions

local SharedFlags3 = require(parent.SharedFlags)
local FFlagProfilePlatformImproveGameDetailsAnalytics = SharedFlags3.FFlagProfilePlatformImproveGameDetailsAnalytics
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local v = {}

local function getSquareExperienceTileHeight(p: number)
	return p + 42
end

local function useFavoriteExperiences(_: string)
	local v2 = useDispatch()

	local experiences = useProfileJsonComponent(Enums.Components.FavoriteExperiences).experiences or v

	local v3 = React.useMemo(function()
		return Cryo.List.map(experiences, function(p, _)
			return (tostring(p.universeId))
		end)
	end, { experiences })

	React.useEffect(function()
		if v3 ~= nil and not Cryo.isEmpty(v3) then
			v2(NetworkingGames.GetExperiencesDetails.API(v3)):catch(function(_) end)
		end
	end, { v3 })

	local v4 = useSelector(function(p)
		return getDeepValue(p, "ProfilePlatform.Games.byGameId") or v
	end)

	local v5 = React.useMemo(function()
		local result = {}

		for _, v5 in v3 do
			if v4[v5] then
				table.insert(result, v4[v5])
			end
		end

		return result
	end, { v3, v4 })

	return if experiences and #v5 == #v3 then v5 else v
end

local function FavoriteExperiences(p)
	local v2 = useDispatch()
	local v3 = useProfileWrapperContext()
	local v4

	if defineFastFlag2 then
		v4 = useProfileAnalyticsContext()
	else
		v4 = nil
	end

	local impressionsTag

	if FFlagProfilePlatformEnableImpressions then
		impressionsTag = useGenerateImpressionsTag(Enums.Components.FavoriteExperiences)
	end

	local profileId = v3.profileId

	local v5 = useLocalization({ title = TextKeys.Favorites })

	local onActivateHeader = React.useCallback(function()
		if defineFastFlag2 and v4 then
			v4.fireAnalyticsEvent(EventNames.FavoriteExperienceSeeAll)
		end

		if defineFastFlag then
			local v6 = {
				name = AppPage.GenericWebPage,
				detail = string.format("%susers/%s/favorites#!/places", Url.BASE_URL, profileId),
				extraProps = { titleKey = TextKeys.Favorites }
			}

			if FFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				v2(NavigateDown(v6, nil))
			end
		end
	end, defineFastFlag2 and { profileId, v4 } or nil)

	local items = useFavoriteExperiences(profileId)
	local v6

	if FFlagProfilePlatformFavoritesEnableGameDetailAnalytics then
		v6 = useRoactService(RoactAnalyticsCommonGameEvents)
	else
		v6 = nil
	end

	local v7 = React.useCallback(function(p2, positionInComponent: number, value: number?)
		if defineFastFlag2 then
			v4.fireAnalyticsEvent(EventNames.FavoriteExperienceOpened, {
				experienceId = p2.experienceId,
				positionInComponent = positionInComponent
			})
		end

		if FFlagProfilePlatformFavoritesEnableGameDetailAnalytics then
			local v7 = items and #items or 0

			local reportOpenGameDetailFromProfile = v6.reportOpenGameDetailFromProfile
			local rootPlaceId = p2.rootPlaceId

			local experienceId = p2.experienceId
			local profilePlatform = AppPage.ProfilePlatform
			local layoutOrder = p.layoutOrder
			local v8

			if FFlagProfilePlatformImproveGameDetailsAnalytics then
				v8 = profileId
			end

			reportOpenGameDetailFromProfile(
				rootPlaceId,
				positionInComponent,
				v7,
				experienceId,
				profilePlatform,
				layoutOrder,
				value or 1,
				v8
			)
		end
	end, FFlagProfilePlatformFavoritesEnableGameDetailAnalytics and { v4, items, v6, p.layoutOrder } or { v4 })
	local renderItem

	if FFlagProfilePlatformEnableImpressions then
		renderItem = useRenderExperienceTile(impressionsTag, "ProfileFavoriteExperienceTile", v7)
	else
		renderItem = useRenderExperienceTile_DEPRECATED("ProfileFavoriteExperienceTile", v7)
	end

	local v8

	if FFlagProfilePlatformEnableImpressions then
		v8 = React.useMemo(function()
			return formatExperienceDetailsForImpressions(items)
		end, { items })
	end

	local sendImpressions

	if FFlagProfilePlatformEnableImpressions then
		sendImpressions = useSendItemImpressions(
			v8,
			3,
			ContentType.Game,
			p.layoutOrder,
			Enums.Components.FavoriteExperiences
		)
	end

	if Cryo.isEmpty(items) then
		return nil
	end

	local createElement = React.createElement
	local v9 = {
		getItemHeight = getSquareExperienceTileHeight,
		hideHeaderButton = not defineFastFlag,
		items = items,
		layoutOrder = p.layoutOrder,
		onActivateHeader = onActivateHeader,
		renderItem = renderItem,
		title = v5.title,
		impressionsTag = 0,
		sendImpressions = 0,
		overrides = 0
	}

	if not FFlagProfilePlatformEnableImpressions then
		impressionsTag = nil
	end

	v9.impressionsTag = impressionsTag

	if not FFlagProfilePlatformEnableImpressions then
		sendImpressions = nil
	end

	v9.sendImpressions = sendImpressions
	v9.overrides = { numColumns = 3 }
	return (createElement(SquareCollectionGridView, v9))
end

return FavoriteExperiences
