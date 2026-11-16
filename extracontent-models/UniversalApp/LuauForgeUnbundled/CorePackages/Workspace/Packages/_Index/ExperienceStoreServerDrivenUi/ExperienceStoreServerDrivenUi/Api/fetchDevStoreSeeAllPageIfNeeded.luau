local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/RobloxAppEnums").AppPage
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SduiSharedUtilities")
local sduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getDevStoreSeeAllUrl = require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/Api/getDevStoreSeeAllUrl")
local getDevStoreSeeAllPageKey = require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/Utils/getDevStoreSeeAllPageKey")

local function fetchDevStoreSeeAllPageIfNeeded(p2, p3, p4)
	local devStoreSeeAllPageIfNeeded = getDevStoreSeeAllUrl(p2)
	local v5 = getDevStoreSeeAllPageKey(p2)

	local dev_store_see_all = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/ServiceContractsProto").apppageplatform.devstore.dev_store_see_all

	getSduiApiStore().fetchIfNeeded({
		responseType = sduiResponseType.Protobuf,
		url = devStoreSeeAllPageIfNeeded,
		surfaceKey = appPage.DevStoreSeeAll,
		configKey = v5,
		loadTimer = p3,
		apiProto = dev_store_see_all.DevStoreSeeAllResponse
	}, p4)

	return devStoreSeeAllPageIfNeeded
end

return fetchDevStoreSeeAllPageIfNeeded
