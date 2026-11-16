local HttpService = game:GetService("HttpService")

local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Http = require(parent.Http)
local myRoduxNetworkingImpl = require(ProfilePlatform.Networking.myRoduxNetworkingImpl)

local formatted = `{Http.Url.APIS_URL}cloud/v2/avatar-marketplace-orders`

local function PurchaseBulkItems(p)
	local jsonEncode = HttpService:JSONEncode({
		purchasingUser = `users/{p.userId}`,
		context = { productSurface = "MARKETPLACE_UA" },
		fulfillmentGroups = {
			{ strategy = "BEST_EFFORT", lineItems = p.lineItems }
		}
	})

	return myRoduxNetworkingImpl(`{formatted}?idempotencyKey.key={HttpService:GenerateGUID(false)}`, "POST", {
		postBody = jsonEncode
	})
end

return PurchaseBulkItems
