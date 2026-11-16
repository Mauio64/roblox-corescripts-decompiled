local Leaderboards = script:FindFirstAncestor("Leaderboards")
local parent = Leaderboards.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local SduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities

local getExperienceLeaderboardSeeAllUrl = require(Leaderboards.ExperienceLeaderboardSeeAllPage.getExperienceLeaderboardSeeAllUrl)

local getExperienceLeaderboardSeeAllPageKey = require(Leaderboards.ExperienceLeaderboardSeeAllPage.getExperienceLeaderboardSeeAllPageKey)

local v = {}

local function fetchExperienceLeaderboardSeeAllPageIfNeeded(p: string, initial_tab: string?, loadTimer, flag: boolean?)
	local experienceLeaderboardSeeAllUrl = getExperienceLeaderboardSeeAllUrl()
	local experienceLeaderboardSeeAllPageKey = getExperienceLeaderboardSeeAllPageKey(p)
	local v2

	if initial_tab == nil then
		v2 = false
	else
		v2 = v[experienceLeaderboardSeeAllPageKey] ~= initial_tab
	end

	v[experienceLeaderboardSeeAllPageKey] = initial_tab or false

	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local see_all = ServiceContractsProto.apppageplatform.experienceleaderboard.see_all

	getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.Protobuf,
		url = experienceLeaderboardSeeAllUrl,
		surfaceKey = AppPage.ExperienceLeaderboardSeeAll,
		configKey = experienceLeaderboardSeeAllPageKey,
		loadTimer = loadTimer,
		apiProto = see_all.ExperienceLeaderboardSeeAllResponse,
		postConfig = {
			contentType = SduiApiStorePostConfigContentType.Proto,
			protoMessage = see_all.ExperienceLeaderboardSeeAllRequest,
			body = see_all.ExperienceLeaderboardSeeAllRequest.new({
				universe_id = tonumber(p),
				initial_tab = initial_tab,
				client_capabilities = SduiCapabilities.buildClientCapabilities(),
				cached_roblox_component_to_template_id = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(AppPage.ExperienceLeaderboardSeeAll)
			})
		},
		enableTemplateCache = true
	}, flag or v2)

	return experienceLeaderboardSeeAllUrl
end

return fetchExperienceLeaderboardSeeAllPageIfNeeded
