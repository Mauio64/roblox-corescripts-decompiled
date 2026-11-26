local TelemetryService = game:GetService("TelemetryService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useRoactService
local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactServiceTags").RoactAnalyticsCommonGameEvents

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local contentType = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UnifiedLogging").ContentType
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")
local SquareCollectionGridView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/BaseComponents/CollectionGridViews/SquareCollectionGridView")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useRenderExperienceTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/Tiles/useRenderExperienceTile")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local formatExperienceDetailsForImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/formatExperienceDetailsForImpressions")
local useGenerateImpressionsTag = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useGenerateImpressionsTag")
local useSendItemImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useSendItemImpressions")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage

local useTextSizeOffset = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").Hooks.useTextSizeOffset

local defineFastInt = game:DefineFastInt(
	"CommunityProfileAffiliatedExperienceTelemetryThrottlePermyriad",
	0
)

local function getTextSizeAdjustedSquareExperienceTileHeight(p2)
	return function(p3)
		return p3 + 80 + 3 * p2
	end
end

local function Experiences(p2)
	local experienceDetails = p2.experienceDetails

	local v5 = useTextSizeOffset()
	local v6 = React.useMemo(function()
		local v7 = v5
		return function(p3)
			return p3 + 80 + 3 * v7
		end
	end, { v5 })
	local v7 = useProfileAnalyticsContext()
	local v8 = useProfileWrapperContext()
	local v9 = useRoactService(roactAnalyticsCommonGameEvents)

	local v10 = useGenerateImpressionsTag(Enums.Components.Experiences)
	local v12 = useSendItemImpressions(React.useMemo(function()
		return formatExperienceDetailsForImpressions(experienceDetails)
	end, { experienceDetails }), 3, contentType.Game, p2.layoutOrder, Enums.Components.Experiences)

	local v14 = useRenderExperienceTile(v10, "ProfileExperienceTile", React.useCallback(function(p3, p4, value)
		v7.fireAnalyticsEvent(EventNames.ExperienceOpened, {
			experienceId = p3.experienceId,
			positionInComponent = p4
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
				community_id = v8.profileId,
				affiliationType = "owner",
				place_id = p3.rootPlaceId,
				universe_id = p3.experienceId
			}
		})

		local v16 = experienceDetails and #experienceDetails or 0

		v9.reportOpenGameDetailFromProfile(
			p3.rootPlaceId,
			p4,
			v16,
			p3.experienceId,
			appPage.ProfilePlatform,
			p2.layoutOrder,
			value or 1,
			nil
		)
	end, { v7, experienceDetails, v9, p2.layoutOrder }), true)

	local v15 = useLocalization({ title = TextKeys.Experiences })

	return if experienceDetails and not Cryo.isEmpty(experienceDetails) then React.createElement(SquareCollectionGridView, {
		getItemHeight = v6,
		hideHeaderButton = true,
		maxNumRows = 1,
		items = experienceDetails,
		layoutOrder = p2.layoutOrder,
		renderItem = v14,
		title = v15.title,
		impressionsTag = v10,
		sendImpressions = v12,
		overrides = { numColumns = 3 }
	}) else nil
end

return Experiences
