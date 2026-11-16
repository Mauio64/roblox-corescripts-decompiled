local ExperienceStoreServerDrivenUi = script:FindFirstAncestor("ExperienceStoreServerDrivenUi")
local parent = ExperienceStoreServerDrivenUi.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getDevStoreSeeAllUrl = require(ExperienceStoreServerDrivenUi.Api.getDevStoreSeeAllUrl)
local getDevStoreSeeAllPageKey = require(ExperienceStoreServerDrivenUi.Utils.getDevStoreSeeAllPageKey)

local function fetchDevStoreSeeAllPageIfNeeded(p: string, loadTimer, flag: boolean?)
	local devStoreSeeAllUrl = getDevStoreSeeAllUrl(p)
	local devStoreSeeAllPageKey = getDevStoreSeeAllPageKey(p)

	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local dev_store_see_all = ServiceContractsProto.apppageplatform.devstore.dev_store_see_all

	getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.Protobuf,
		url = devStoreSeeAllUrl,
		surfaceKey = AppPage.DevStoreSeeAll,
		configKey = devStoreSeeAllPageKey,
		loadTimer = loadTimer,
		apiProto = dev_store_see_all.DevStoreSeeAllResponse
	}, flag)

	return devStoreSeeAllUrl
end

return fetchDevStoreSeeAllPageIfNeeded
