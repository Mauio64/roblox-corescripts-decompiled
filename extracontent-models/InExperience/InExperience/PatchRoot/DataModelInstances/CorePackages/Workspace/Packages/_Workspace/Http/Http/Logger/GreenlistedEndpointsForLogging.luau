local t1 = {
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
local t3 = {
	isSuccessStatusCode = function(_: {[any]: any}, n1: number) -- line: 25
		return n1 >= 200 and n1 < 300
	end
}

function t3.getMatchingName(s1: string, n2: number) -- line: 32
	-- upvalues: t3 (copy), t1 (copy)
	local str = tostring(n2)
	local v8 = not t3:isSuccessStatusCode(n2) and "api_error_" or "api_success_"

	for v9, v10 in t1 do
		if string.find(s1, v9, 1, true) then
			return v8 .. v10 .. "_" .. str
		end
	end

	return nil
end
function t3.sendStatusCodeCounter(s2: string, n3: number, p1) -- line: 49
	-- upvalues: t3 (copy)
	if not p1 then
		p1 = game:GetService("RbxAnalyticsService")
	end

	local v14 = t3.getMatchingName(s2, n3)

	if v14 and p1 then
		p1:ReportCounter(v14, 1)
	end
end

return t3
