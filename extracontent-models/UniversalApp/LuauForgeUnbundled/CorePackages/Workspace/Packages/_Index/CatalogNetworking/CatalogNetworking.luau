local createGetItemAndBundleDetails = require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/networkRequests/createGetItemAndBundleDetails")

require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/Types")
local fFlagSocialEnableProfileInspectAndBuy = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSocialEnableProfileInspectAndBuy

local function createRequestThunks(p2)
	return { GetItemAndBundleDetails = createGetItemAndBundleDetails(p2) }
end

local v6 = if fFlagSocialEnableProfileInspectAndBuy then require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/stores/PurchaseDetailsStore") else nil

local v7 = if fFlagSocialEnableProfileInspectAndBuy then require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/stores/CollectibleProductIdStore") else nil

local v8 = if fFlagSocialEnableProfileInspectAndBuy then require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/stores/BundleOwnershipStore") else nil

local v9 = if fFlagSocialEnableProfileInspectAndBuy then require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/stores/ItemDetailsStore") else nil
return {
	config = createRequestThunks,
	PurchaseDetailsStore = v6,
	CollectibleProductIdStore = v7,
	BundleOwnershipStore = v8,
	ItemDetailsStore = v9
}
