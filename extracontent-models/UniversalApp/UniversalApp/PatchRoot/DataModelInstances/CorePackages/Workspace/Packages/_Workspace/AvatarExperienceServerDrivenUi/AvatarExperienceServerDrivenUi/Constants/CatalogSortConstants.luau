local AvatarExperienceServerDrivenUi = script:FindFirstAncestor("AvatarExperienceServerDrivenUi")

require(AvatarExperienceServerDrivenUi.Types.CatalogSortPropTypes)

local t1 = {
	{
		contentType = "ItemName"
	},
	{
		contentType = "Price"
	},
	{
		contentType = "AgentName"
	}
}

return {
	DEFAULT_PREVIEW_COLUMNS = 3,
	DEFAULT_ITEM_FOOTERS = t1
}
