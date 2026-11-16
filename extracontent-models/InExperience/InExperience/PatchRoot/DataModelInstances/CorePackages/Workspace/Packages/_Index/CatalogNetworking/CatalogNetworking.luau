local parent = script:FindFirstAncestor("CatalogNetworking").Parent.Parent

local networkRequests = script.networkRequests
local createGetItemAndBundleDetails = require(networkRequests.createGetItemAndBundleDetails)

require(script.Types)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuy = SharedFlags.FFlagSocialEnableProfileInspectAndBuy

local function createRequestThunks(p)
	return {
		GetItemAndBundleDetails = createGetItemAndBundleDetails(p)
	}
end

local purchaseDetailsStore

if FFlagSocialEnableProfileInspectAndBuy then
	purchaseDetailsStore = require(script.stores.PurchaseDetailsStore)
end

local collectibleProductIdStore

if FFlagSocialEnableProfileInspectAndBuy then
	collectibleProductIdStore = require(script.stores.CollectibleProductIdStore)
end

local bundleOwnershipStore

if FFlagSocialEnableProfileInspectAndBuy then
	bundleOwnershipStore = require(script.stores.BundleOwnershipStore)
end

local itemDetailsStore

if FFlagSocialEnableProfileInspectAndBuy then
	itemDetailsStore = require(script.stores.ItemDetailsStore)
end

return {
	config = createRequestThunks,
	PurchaseDetailsStore = purchaseDetailsStore,
	CollectibleProductIdStore = collectibleProductIdStore,
	BundleOwnershipStore = bundleOwnershipStore,
	ItemDetailsStore = itemDetailsStore,
	["jest.config"] = script["jest.config"]
}
