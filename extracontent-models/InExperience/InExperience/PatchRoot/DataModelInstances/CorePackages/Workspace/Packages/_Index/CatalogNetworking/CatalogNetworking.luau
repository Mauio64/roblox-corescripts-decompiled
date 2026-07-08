local ParentParent = script:FindFirstAncestor("CatalogNetworking").Parent.Parent
local networkRequests = script.networkRequests
local createGetItemAndBundleDetails = require(networkRequests.createGetItemAndBundleDetails)

require(script.Types)

local FFlagSocialEnableProfileInspectAndBuy = require(ParentParent.SharedFlags).FFlagSocialEnableProfileInspectAndBuy

local function createRequestThunks(p1) -- line: 21
	-- upvalues: createGetItemAndBundleDetails (copy)
	return {
		GetItemAndBundleDetails = createGetItemAndBundleDetails(p1)
	}
end

return {
	config = createRequestThunks,
	PurchaseDetailsStore = if not FFlagSocialEnableProfileInspectAndBuy then nil else require(script.stores.PurchaseDetailsStore),
	CollectibleProductIdStore = if not FFlagSocialEnableProfileInspectAndBuy then nil else require(script.stores.CollectibleProductIdStore),
	BundleOwnershipStore = if not FFlagSocialEnableProfileInspectAndBuy then nil else require(script.stores.BundleOwnershipStore),
	ItemDetailsStore = if not FFlagSocialEnableProfileInspectAndBuy then nil else require(script.stores.ItemDetailsStore),
	["jest.config"] = script["jest.config"]
}
