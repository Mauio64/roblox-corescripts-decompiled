local module = require("@luauforge/bundled/fCe")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

local function getWidgetTileFooterProps(p2, p3)
	local v5 = nil
	local v6 = nil

	for k, v7 in p2.template and p2.template.itemFooters or {} do
		v5 = v7.contentType == "AgentName" or v5

		if v7.contentType == "Price" then
			v6 = true
		end
	end

	return {
		creatorNameFooterEnabled = v5,
		priceFooterEnabled = v6,
		creatorNameTileFooterEnabled = module.getCreatorNameTileFooterEnabled(p3)
	}
end

return getWidgetTileFooterProps
