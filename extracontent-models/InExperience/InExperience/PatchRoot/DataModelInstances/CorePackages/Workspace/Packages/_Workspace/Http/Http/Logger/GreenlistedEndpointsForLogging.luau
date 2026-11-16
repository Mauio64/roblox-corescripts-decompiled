local v = {
	["catalog/sponsored-items"] = "avatar_experience_sponsored_items",
	["marketplace-widgets/v1/widgets?requestId"] = "avatar_experience_marketplace_widgets",
	["v3/outfits"] = "avatar_experience_outfits",
	["catalog/items/details"] = "avatar_experience_item_details",
	["recommendations/user-inventory"] = "avatar_experience_recommended_user_inventory",
	["v1/purchases/products"] = "avatar_experience_purchase_product",
	["autocomplete-avatar/v2/suggest"] = "avatar_experience_auto_complete",
	["topic/get-topics"] = "avatar_experience_get_topics",
	["widgets/search"] = "avatar_experience_widget_search",
	["widgets/hydrate"] = "avatar_experience_widget_hydrate",
	["marketplace-widgets/v1/pills"] = "avatar_experience_catalog_categories"
}

local GreenlistedEndpointsForLogging = {}

function GreenlistedEndpointsForLogging:isSuccessStatusCode(p: number): boolean
	return p >= 200 and p < 300
end

function GreenlistedEndpointsForLogging.getMatchingName(value: string, p: number)
	local v2 = tostring(p)
	local v3 = GreenlistedEndpointsForLogging:isSuccessStatusCode(p) and "api_success_" or "api_error_"

	for k, v4 in v do
		if string.find(value, k, 1, true) then
			return v3 .. v4 .. "_" .. v2
		end
	end

	return nil
end

function GreenlistedEndpointsForLogging.sendStatusCodeCounter(p: string, p2: number, object)
	object = object or game:GetService("RbxAnalyticsService")

	local matchingName = GreenlistedEndpointsForLogging.getMatchingName(p, p2)

	if matchingName and object then
		object:ReportCounter(matchingName, 1)
	end
end

return GreenlistedEndpointsForLogging
