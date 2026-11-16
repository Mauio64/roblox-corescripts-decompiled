local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
require(AvatarExperienceCatalog.Models.WidgetListInfo)

local function getFooterVisibilityFromItemFooters(items)
	local footerVisibility = {
		isCreatorNameVisible = false,
		isTitleVisible = false,
		isPriceVisible = false
	}

	if not items then
		return footerVisibility
	end

	for _, item in items do
		if item.contentType == "AgentName" then
			footerVisibility.isCreatorNameVisible = true
		elseif item.contentType == "Price" then
			footerVisibility.isPriceVisible = true
		elseif item.contentType == "ItemName" then
			footerVisibility.isTitleVisible = true
		end
	end

	return footerVisibility
end

return getFooterVisibilityFromItemFooters
