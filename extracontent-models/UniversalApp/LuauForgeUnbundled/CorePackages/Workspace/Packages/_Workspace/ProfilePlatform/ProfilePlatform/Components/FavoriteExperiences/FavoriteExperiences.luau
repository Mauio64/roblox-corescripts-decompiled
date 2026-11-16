local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux").Thunks.NavigateDown
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Http").Url

local module4 = require("@luauforge/bundled/fdJ")

local getDeepValue = require("@luauforge/bundled/eUd").SocialLibraries.config({}).Dictionary.getDeepValue

local SquareCollectionGridView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/BaseComponents/CollectionGridViews/SquareCollectionGridView")

local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useRenderExperienceTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/Tiles/useRenderExperienceTile")
local useRenderExperienceTile_DEPRECATED = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/Tiles/useRenderExperienceTile_DEPRECATED")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local useSendItemImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useSendItemImpressions")
local useGenerateImpressionsTag = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useGenerateImpressionsTag")
local formatExperienceDetailsForImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/formatExperienceDetailsForImpressions")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local contentType = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UnifiedLogging").ContentType

local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactServiceTags").RoactAnalyticsCommonGameEvents
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useRoactService

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")

local defineFastFlag = game:DefineFastFlag("ProfilePlatformFavoritesNavigateToWeb_V2", false)

local defineFastFlag2 = game:DefineFastFlag(
	"ProfilePlatformFavoritesEnableProfilePlatformClickAnalytics",
	false
)

local fFlagProfilePlatformFavoritesEnableGameDetailAnalytics = SharedFlags.FFlagProfilePlatformFavoritesEnableGameDetailAnalytics
local fFlagProfilePlatformEnableImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableImpressions

local fFlagProfilePlatformImproveGameDetailsAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformImproveGameDetailsAnalytics
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local v5 = {}

local function getSquareExperienceTileHeight(p2)
	return p2 + 42
end

local function useFavoriteExperiences(profileId)
	local v6 = useDispatch()

	local experiences = useProfileJsonComponent(Enums.Components.FavoriteExperiences).experiences or v5

	local v7 = React.useMemo(function()
		return Cryo.List.map(experiences, function(p2, p3)
			return (tostring(p2.universeId))
		end)
	end, { experiences })

	React.useEffect(function()
		if v7 ~= nil and not Cryo.isEmpty(v7) then
			v6(module4.GetExperiencesDetails.API(v7)):catch(function(p2) end)
		end
	end, { v7 })

	local v8 = useSelector(function(p2)
		return getDeepValue(p2, "ProfilePlatform.Games.byGameId") or v5
	end)

	local v9 = React.useMemo(function()
		local result = {}

		for k, v10 in v7 do
			if v8[v10] then
				table.insert(result, v8[v10])
			end
		end

		return result
	end, { v7, v8 })

	if experiences and #v9 == #v7 then
		return v9
	end

	return v5
end

local function FavoriteExperiences(p2)
	local v6 = useDispatch()
	local v7 = useProfileWrapperContext()

	local v8 = if defineFastFlag2 then useProfileAnalyticsContext() else nil
	local v9

	if fFlagProfilePlatformEnableImpressions then
		v9 = useGenerateImpressionsTag(Enums.Components.FavoriteExperiences)
	end

	local profileId = v7.profileId

	local v10 = useLocalization({ title = TextKeys.Favorites })

	local v11 = React.useCallback(function()
		if defineFastFlag2 and v8 then
			v8.fireAnalyticsEvent(EventNames.FavoriteExperienceSeeAll)
		end

		if defineFastFlag then
			local v12 = {
				name = appPage.GenericWebPage,
				detail = string.format("%susers/%s/favorites#!/places", url.BASE_URL, profileId),
				extraProps = { titleKey = TextKeys.Favorites }
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v12))
			else
				v6(navigateDown(v12, nil))
			end
		end
	end, defineFastFlag2 and { profileId, v8 } or nil)

	local v14 = useFavoriteExperiences(profileId)
	local v15

	if fFlagProfilePlatformFavoritesEnableGameDetailAnalytics then
		v15 = useRoactService(roactAnalyticsCommonGameEvents)
	else
		v15 = nil
	end

	local v16 = React.useCallback(function(p3, p4, value)
		if defineFastFlag2 then
			v8.fireAnalyticsEvent(EventNames.FavoriteExperienceOpened, {
				experienceId = p3.experienceId,
				positionInComponent = p4
			})
		end

		if fFlagProfilePlatformFavoritesEnableGameDetailAnalytics then
			local v17 = v14 and #v14 or 0

			v15.reportOpenGameDetailFromProfile(
				p3.rootPlaceId,
				p4,
				v17,
				p3.experienceId,
				appPage.ProfilePlatform,
				p2.layoutOrder,
				value or 1,
				if fFlagProfilePlatformImproveGameDetailsAnalytics then profileId else nil
			)
		end
	end, fFlagProfilePlatformFavoritesEnableGameDetailAnalytics and {
		v8,
		v14,
		v15,
		p2.layoutOrder
	} or { v8 })
	local v17

	if fFlagProfilePlatformEnableImpressions then
		v17 = useRenderExperienceTile(v9, "ProfileFavoriteExperienceTile", v16)
	else
		v17 = useRenderExperienceTile_DEPRECATED("ProfileFavoriteExperienceTile", v16)
	end

	local v18

	if fFlagProfilePlatformEnableImpressions then
		v18 = React.useMemo(function()
			return formatExperienceDetailsForImpressions(v14)
		end, { v14 })
	end

	local v19

	if fFlagProfilePlatformEnableImpressions then
		v19 = useSendItemImpressions(v18, 3, contentType.Game, p2.layoutOrder, Enums.Components.FavoriteExperiences)
	end

	if Cryo.isEmpty(v14) then
		return nil
	end

	local createElement = React.createElement
	local v21 = {
		getItemHeight = getSquareExperienceTileHeight,
		hideHeaderButton = not defineFastFlag,
		items = v14,
		layoutOrder = p2.layoutOrder,
		onActivateHeader = v11,
		renderItem = v17,
		title = v10.title,
		impressionsTag = 0,
		sendImpressions = 0,
		overrides = 0
	}

	if not fFlagProfilePlatformEnableImpressions then
		v9 = nil
	end

	v21.impressionsTag = v9

	if not fFlagProfilePlatformEnableImpressions then
		v19 = nil
	end

	v21.sendImpressions = v19
	v21.overrides = { numColumns = 3 }
	return (createElement(SquareCollectionGridView, v21))
end

return FavoriteExperiences
