local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Leaderboards/RobloxAppEnums").AppPage
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Leaderboards/SduiSharedUtilities")
local sduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local sduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local sduiCapabilities = SduiSharedUtilities.SduiCapabilities

local getExperienceLeaderboardSeeAllUrl = require("@game/CorePackages/Workspace/Packages/_Index/Leaderboards/Leaderboards/ExperienceLeaderboardSeeAllPage/getExperienceLeaderboardSeeAllUrl")

local getExperienceLeaderboardSeeAllPageKey = require("@game/CorePackages/Workspace/Packages/_Index/Leaderboards/Leaderboards/ExperienceLeaderboardSeeAllPage/getExperienceLeaderboardSeeAllPageKey")

local v5 = {}

local function fetchExperienceLeaderboardSeeAllPageIfNeeded(p2, p3, p4, p5)
	local experienceLeaderboardSeeAllPageIfNeeded = getExperienceLeaderboardSeeAllUrl()
	local v6 = getExperienceLeaderboardSeeAllPageKey(p2)
	local v7 = not (p3 == nil) and v5[v6] ~= p3
	v5[v6] = p3 or false

	local see_all = require("@game/CorePackages/Workspace/Packages/_Workspace/Leaderboards/ServiceContractsProto").apppageplatform.experienceleaderboard.see_all

	getSduiApiStore().fetchIfNeeded({
		responseType = sduiResponseType.Protobuf,
		url = experienceLeaderboardSeeAllPageIfNeeded,
		surfaceKey = appPage.ExperienceLeaderboardSeeAll,
		configKey = v6,
		loadTimer = p4,
		apiProto = see_all.ExperienceLeaderboardSeeAllResponse,
		postConfig = {
			contentType = sduiApiStorePostConfigContentType.Proto,
			protoMessage = see_all.ExperienceLeaderboardSeeAllRequest,
			body = see_all.ExperienceLeaderboardSeeAllRequest.new({
				universe_id = tonumber(p2),
				initial_tab = p3,
				client_capabilities = sduiCapabilities.buildClientCapabilities(),
				cached_roblox_component_to_template_id = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(appPage.ExperienceLeaderboardSeeAll)
			})
		},
		enableTemplateCache = true
	}, p5 or v7)

	return experienceLeaderboardSeeAllPageIfNeeded
end

return fetchExperienceLeaderboardSeeAllPageIfNeeded
