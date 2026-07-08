local HttpService = game:GetService("HttpService")
local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Http = require(ProfilePlatformParent.Http)
local myRoduxNetworkingImpl = require(ProfilePlatform.Networking.myRoduxNetworkingImpl)
local v6 = `{ Http.Url.APIS_URL }cloud/v2/avatar-marketplace-orders`

local function PurchaseBulkItems(t1: {[any]: any}) -- line: 21
	-- upvalues: HttpService (copy), v6 (copy), myRoduxNetworkingImpl (copy)
	local json = HttpService:JSONEncode({
		purchasingUser = `users/{ t1.userId }`,
		context = {
			productSurface = "MARKETPLACE_UA"
		},
		fulfillmentGroups = {{
			strategy = "BEST_EFFORT",
			lineItems = t1.lineItems
		}}
	})
	local v10 = `{ v6 }?idempotencyKey.key={ HttpService:GenerateGUID(false) }`

	return myRoduxNetworkingImpl(v10, "POST", {
		postBody = json
	})
end

return PurchaseBulkItems
