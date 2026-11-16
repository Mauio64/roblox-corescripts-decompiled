local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local Http = require(parent.Http)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents

local formatted = `{Http.Url.APIS_URL}cloud/v2/avatar-marketplace-orders`

local function purchaseItems(data)
	local lookIds = {}

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		if data.lookId then
			table.insert(lookIds, data.lookId)
		end

		if data.makeupLookId then
			table.insert(lookIds, data.makeupLookId)
		end
	end

	local jsonEncode = HttpService:JSONEncode({
		purchasingUser = `users/{data.userId}`,
		context = {
			productSurface = "MARKETPLACE_UA",
			lookId = data.lookId,
			lookContext = FFlagAXMISEnableMultiShoppingUnifiedEvents and { lookIds = lookIds } or nil
		},
		fulfillmentGroups = {
			{ strategy = "BEST_EFFORT", lineItems = data.lineItems }
		}
	})

	local formatted2 = `{formatted}?idempotencyKey.key={HttpService:GenerateGUID(false)}`
	return data.networkImpl(formatted2, "POST", { postBody = jsonEncode })
end

return purchaseItems
