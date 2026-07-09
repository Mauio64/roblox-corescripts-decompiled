local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

require(AvatarExperienceCatalog.Models.WidgetListInfo)

local function getFooterVisibilityFromItemFooters(t1: {[any]: any}?) -- line: 11
	local t2 = {
		isCreatorNameVisible = false,
		isTitleVisible = false,
		isPriceVisible = false
	}

	if not t1 then
		return t2
	end

	for _, v6 in t1 do
		if v6.contentType == "AgentName" then
			t2.isCreatorNameVisible = true
		elseif v6.contentType == "Price" then
			t2.isPriceVisible = true
		elseif v6.contentType == "ItemName" then
			t2.isTitleVisible = true
		end
	end

	return t2
end

return getFooterVisibilityFromItemFooters
