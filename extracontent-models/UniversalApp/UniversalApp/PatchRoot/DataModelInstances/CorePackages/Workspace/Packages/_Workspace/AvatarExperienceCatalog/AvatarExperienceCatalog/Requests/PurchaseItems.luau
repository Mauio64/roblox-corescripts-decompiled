local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local Http = require(Parent.Http)
local FFlagAXMISEnableMultiShoppingUnifiedEvents = require(Parent.AvatarExperienceFlags).FFlagAXMISEnableMultiShoppingUnifiedEvents
local v5 = `{ Http.Url.APIS_URL }cloud/v2/avatar-marketplace-orders`

local function purchaseItems(t1: {[any]: any}) -- line: 31
	-- upvalues: FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), HttpService (copy), v5 (copy)
	local t2 = {}

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		if t1.lookId then
			table.insert(t2, t1.lookId)
		end

		if t1.makeupLookId then
			table.insert(t2, t1.makeupLookId)
		end
	end

	local json = HttpService:JSONEncode({
		purchasingUser = `users/{ t1.userId }`,
		context = {
			productSurface = "MARKETPLACE_UA",
			lookId = t1.lookId,
			lookContext = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else {
				lookIds = t2
			}
		},
		fulfillmentGroups = {{
			strategy = "BEST_EFFORT",
			lineItems = t1.lineItems
		}}
	})
	local v10 = `{ v5 }?idempotencyKey.key={ HttpService:GenerateGUID(false) }`

	return t1.networkImpl(v10, "POST", {
		postBody = json
	})
end

return purchaseItems
