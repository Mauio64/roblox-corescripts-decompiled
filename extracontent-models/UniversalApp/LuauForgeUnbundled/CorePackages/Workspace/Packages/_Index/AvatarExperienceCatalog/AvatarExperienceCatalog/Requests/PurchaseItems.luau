local HttpService = game:GetService("HttpService")

local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http")
local fFlagAXMISEnableMultiShoppingUnifiedEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXMISEnableMultiShoppingUnifiedEvents

local formatted = `{module.Url.APIS_URL}cloud/v2/avatar-marketplace-orders`

local function purchaseItems(data)
	local v5 = {}

	if fFlagAXMISEnableMultiShoppingUnifiedEvents then
		if data.lookId then
			table.insert(v5, data.lookId)
		end

		if data.makeupLookId then
			table.insert(v5, data.makeupLookId)
		end
	end

	local jsonEncode = HttpService:JSONEncode({
		purchasingUser = `users/{data.userId}`,
		context = {
			productSurface = "MARKETPLACE_UA",
			lookId = data.lookId,
			lookContext = fFlagAXMISEnableMultiShoppingUnifiedEvents and {
				lookIds = v5
			} or nil
		},
		fulfillmentGroups = {
			{ strategy = "BEST_EFFORT", lineItems = data.lineItems }
		}
	})

	local formatted2 = `{formatted}?idempotencyKey.key={HttpService:GenerateGUID(false)}`
	return data.networkImpl(formatted2, "POST", { postBody = jsonEncode })
end

return purchaseItems
