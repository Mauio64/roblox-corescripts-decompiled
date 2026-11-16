local HttpService = game:GetService("HttpService")

local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Http")
local myRoduxNetworkingImpl = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworkingImpl")

local formatted = `{module.Url.APIS_URL}cloud/v2/avatar-marketplace-orders`

local function PurchaseBulkItems(p2)
	local jsonEncode = HttpService:JSONEncode({
		purchasingUser = `users/{p2.userId}`,
		context = { productSurface = "MARKETPLACE_UA" },
		fulfillmentGroups = {
			{ strategy = "BEST_EFFORT", lineItems = p2.lineItems }
		}
	})

	return myRoduxNetworkingImpl(`{formatted}?idempotencyKey.key={HttpService:GenerateGUID(false)}`, "POST", {
		postBody = jsonEncode
	})
end

return PurchaseBulkItems
