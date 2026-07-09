local DevStore = script:FindFirstAncestor("DevStore")
local DevStoreParent = DevStore.Parent
local AppPage = require(DevStoreParent.RobloxAppEnums).AppPage
local SduiSharedUtilities = require(DevStoreParent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getDevStoreSeeAllUrl = require(DevStore.DevStoreSeeAllPage.getDevStoreSeeAllUrl)
local getDevStoreSeeAllPageKey = require(DevStore.DevStoreSeeAllPage.getDevStoreSeeAllPageKey)
local FFlagSduiProtobufJsonDecode = require(DevStoreParent.SharedFlags).FFlagSduiProtobufJsonDecode

local function fetchDevStoreSeeAllPageIfNeeded(s1: string, p1, b1: boolean?) -- line: 15
	-- upvalues: getDevStoreSeeAllUrl (copy), getDevStoreSeeAllPageKey (copy), DevStoreParent (copy), getSduiApiStore (copy), FFlagSduiProtobufJsonDecode (copy), SduiResponseType (copy), AppPage (copy)
	local v14 = getDevStoreSeeAllUrl(s1)
	local v15 = getDevStoreSeeAllPageKey(s1)
	local dev_store_see_all = require(DevStoreParent.ServiceContractsProto).apppageplatform.devstore.dev_store_see_all

	getSduiApiStore().fetchIfNeeded({
		responseType = if not FFlagSduiProtobufJsonDecode then nil else SduiResponseType.Protobuf,
		url = v14,
		surfaceKey = AppPage.DevStoreSeeAll,
		configKey = v15,
		loadTimer = p1,
		apiProto = dev_store_see_all.DevStoreSeeAllResponse
	}, b1)

	return v14
end

return fetchDevStoreSeeAllPageIfNeeded
