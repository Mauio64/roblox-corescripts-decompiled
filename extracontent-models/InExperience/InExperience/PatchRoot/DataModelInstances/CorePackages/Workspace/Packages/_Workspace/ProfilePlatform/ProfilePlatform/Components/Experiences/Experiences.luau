local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local TelemetryService = game:GetService("TelemetryService")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useRoactService = require(ProfilePlatformParent.RobloxAppHooks).useRoactService
local RoactAnalyticsCommonGameEvents = require(ProfilePlatformParent.RoactServiceTags).RoactAnalyticsCommonGameEvents
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local ContentType = require(ProfilePlatformParent.UnifiedLogging).ContentType
local Cryo = require(ProfilePlatformParent.Cryo)
local SquareCollectionGridView = require(ProfilePlatform.BaseComponents.CollectionGridViews.SquareCollectionGridView)
local Enums = require(ProfilePlatform.Common.Enums)
local useRenderExperienceTile = require(ProfilePlatform.Hooks.Tiles.useRenderExperienceTile)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local formatExperienceDetailsForImpressions = require(ProfilePlatform.Hooks.formatExperienceDetailsForImpressions)
local useGenerateImpressionsTag = require(ProfilePlatform.Hooks.useGenerateImpressionsTag)
local useSendItemImpressions = require(ProfilePlatform.Hooks.useSendItemImpressions)
local EventNames = require(ProfilePlatform.Analytics.EventNames)

require(ProfilePlatform.Common.Types)

local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local useTextSizeOffset = require(ProfilePlatformParent.Foundation).Hooks.useTextSizeOffset
local v22 = game:DefineFastInt("CommunityProfileAffiliatedExperienceTelemetryThrottlePermyriad", 0)

local function getTextSizeAdjustedSquareExperienceTileHeight(n1: number) -- line: 40
	return function(n2: number) -- line: 41
		-- upvalues: n1 (copy)
		return n2 + 80 + n1 * 3
	end
end
local function Experiences(t1: {[any]: any}) -- line: 46
	-- upvalues: useTextSizeOffset (copy), React (copy), useProfileAnalyticsContext (copy), useProfileWrapperContext (copy), useRoactService (copy), RoactAnalyticsCommonGameEvents (copy), useGenerateImpressionsTag (copy), Enums (copy), formatExperienceDetailsForImpressions (copy), useSendItemImpressions (copy), ContentType (copy), EventNames (copy), v22 (copy), TelemetryService (copy), AppPage (copy), useRenderExperienceTile (copy), useLocalization (copy), TextKeys (copy), Cryo (copy), SquareCollectionGridView (copy)
	local experienceDetails = t1.experienceDetails
	local u28 = useTextSizeOffset()
	local v29 = React.useMemo(function() -- line: 50
		-- upvalues: u28 (ref)
		local v40 = u28

		return function(n3: number) -- line: 41
			-- upvalues: v40 (copy)
			return n3 + 80 + v40 * 3
		end
	end, { u28 })
	local v30 = useProfileAnalyticsContext()
	local v31 = useProfileWrapperContext()
	local v32 = useRoactService(RoactAnalyticsCommonGameEvents)
	local v33 = useGenerateImpressionsTag(Enums.Components.Experiences)
	local v34 = React.useMemo(function() -- line: 58
		-- upvalues: formatExperienceDetailsForImpressions (copy), experienceDetails (copy)
		return formatExperienceDetailsForImpressions(experienceDetails)
	end, { experienceDetails })
	local v35 = useSendItemImpressions(v34, 3, ContentType.Game, t1.layoutOrder, Enums.Components.Experiences)
	local v36 = React.useCallback(function(p1, n4: number, n5: number?) -- line: 70
		-- upvalues: v30 (copy), EventNames (copy), v22 (copy), v31 (copy), TelemetryService (copy), experienceDetails (copy), v32 (copy), AppPage (copy), t1 (copy)
		v30.fireAnalyticsEvent(EventNames.ExperienceOpened, {
			experienceId = p1.experienceId,
			positionInComponent = n4
		})

		local t2 = {
			eventName = "communityAffiliatedExperienceClick",
			description = "Event fired from the client every time an experience is clicked from a community profile",
			links = "https://github.rbx.com/Roblox/proto-schemas/pull/6250",
			backends = { "EventIngest" },
			throttlingPercentage = v22,
			lastUpdated = {
				25,
				6,
				5
			}
		}
		local t3 = {
			affiliationType = "owner",
			community_id = v31.profileId,
			place_id = p1.rootPlaceId,
			universe_id = p1.experienceId
		}

		TelemetryService:LogEvent(t2, {
			customFields = t3
		})

		local n6 = 0

		if experienceDetails then
			n6 = #experienceDetails
		end

		v32.reportOpenGameDetailFromProfile(p1.rootPlaceId, n4, n6, p1.experienceId, AppPage.ProfilePlatform, t1.layoutOrder, n5 or 1, nil)
	end, {
		v30,
		experienceDetails,
		v32,
		t1.layoutOrder
	})
	local v37 = useRenderExperienceTile(v33, "ProfileExperienceTile", v36, true)
	local v38 = useLocalization({
		title = TextKeys.Experiences
	})

	return if not experienceDetails or Cryo.isEmpty(experienceDetails) then nil else React.createElement(SquareCollectionGridView, {
		hideHeaderButton = true,
		maxNumRows = 1,
		getItemHeight = v29,
		items = experienceDetails,
		layoutOrder = t1.layoutOrder,
		renderItem = v37,
		title = v38.title,
		impressionsTag = v33,
		sendImpressions = v35,
		overrides = {
			numColumns = 3
		}
	})
end

return Experiences
