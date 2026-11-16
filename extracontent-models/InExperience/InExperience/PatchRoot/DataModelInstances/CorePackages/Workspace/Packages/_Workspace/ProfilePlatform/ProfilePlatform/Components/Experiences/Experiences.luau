local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local TelemetryService = game:GetService("TelemetryService")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local UnifiedLogging = require(parent.UnifiedLogging)
local ContentType = UnifiedLogging.ContentType
local Cryo = require(parent.Cryo)
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
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local Foundation = require(parent.Foundation)
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset

local defineFastInt = game:DefineFastInt("CommunityProfileAffiliatedExperienceTelemetryThrottlePermyriad", 0)

local function getTextSizeAdjustedSquareExperienceTileHeight(p: number) -- 1 equivalent call inferred from this helper
	return function(p2: number)
		return p2 + 80 + p * 3
	end
end

local function Experiences(p)
	local experienceDetails = p.experienceDetails

	local v = useTextSizeOffset()
	local getItemHeight = React.useMemo(function()
		return getTextSizeAdjustedSquareExperienceTileHeight(v) -- inferred equivalent call
	end, { v })
	local v2 = useProfileAnalyticsContext()
	local v3 = useProfileWrapperContext()
	local v4 = useRoactService(RoactAnalyticsCommonGameEvents)

	local impressionsTag = useGenerateImpressionsTag(Enums.Components.Experiences)
	local sendImpressions = useSendItemImpressions(React.useMemo(function()
		return formatExperienceDetailsForImpressions(experienceDetails)
	end, { experienceDetails }), 3, ContentType.Game, p.layoutOrder, Enums.Components.Experiences)

	local renderItem = useRenderExperienceTile(
		impressionsTag,
		"ProfileExperienceTile",
		React.useCallback(function(p2, positionInComponent: number, value: number?)
			v2.fireAnalyticsEvent(EventNames.ExperienceOpened, {
				experienceId = p2.experienceId,
				positionInComponent = positionInComponent
			})

			TelemetryService:LogEvent({
				eventName = "communityAffiliatedExperienceClick",
				backends = { "EventIngest" },
				throttlingPercentage = defineFastInt,
				lastUpdated = { 25, 6, 5 },
				description = "Event fired from the client every time an experience is clicked from a community profile",
				links = "https://github.rbx.com/Roblox/proto-schemas/pull/6250"
			}, {
				customFields = {
					community_id = v3.profileId,
					affiliationType = "owner",
					place_id = p2.rootPlaceId,
					universe_id = p2.experienceId
				}
			})

			local v5 = experienceDetails and #experienceDetails or 0

			v4.reportOpenGameDetailFromProfile(
				p2.rootPlaceId,
				positionInComponent,
				v5,
				p2.experienceId,
				AppPage.ProfilePlatform,
				p.layoutOrder,
				value or 1,
				nil
			)
		end, { v2, experienceDetails, v4, p.layoutOrder }),
		true
	)

	local v5 = useLocalization({ title = TextKeys.Experiences })
	local v6

	if experienceDetails and not Cryo.isEmpty(experienceDetails) then
		return (React.createElement(SquareCollectionGridView, {
			getItemHeight = getItemHeight,
			hideHeaderButton = true,
			maxNumRows = 1,
			items = experienceDetails,
			layoutOrder = p.layoutOrder,
			renderItem = renderItem,
			title = v5.title,
			impressionsTag = impressionsTag,
			sendImpressions = sendImpressions,
			overrides = { numColumns = 3 }
		}))
	end

	return v6
end

return Experiences
