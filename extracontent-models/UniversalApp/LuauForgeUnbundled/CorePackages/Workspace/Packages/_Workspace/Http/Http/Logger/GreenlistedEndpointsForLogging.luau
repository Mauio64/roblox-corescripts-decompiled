local v5 = {
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

local v6 = {}

function v6:isSuccessStatusCode(p3): boolean
	return p3 >= 200 and p3 < 300
end

function v6.getMatchingName(value, p2)
	local v7 = tostring(p2)
	local v8 = v6:isSuccessStatusCode(p2) and "api_success_" or "api_error_"

	for k, v10 in v5 do
		if string.find(value, k, 1, true) then
			return v8 .. v10 .. "_" .. v7
		end
	end

	return nil
end

function v6.sendStatusCodeCounter(p2, p3, p4)
	local v7 = p4 or game:GetService("RbxAnalyticsService")

	local matchingName = v6.getMatchingName(p2, p3)

	if matchingName and v7 then
		v7:ReportCounter(matchingName, 1)
	end
end

return v6
