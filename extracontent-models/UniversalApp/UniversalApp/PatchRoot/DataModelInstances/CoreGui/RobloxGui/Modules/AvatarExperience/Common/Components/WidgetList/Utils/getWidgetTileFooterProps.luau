local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Utils = require(Modules.AvatarExperience.Common.Utils)

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

local function getWidgetTileFooterProps(p1, p2) -- line: 13
	-- upvalues: Utils (copy)
	local v7 = nil
	local v8 = nil

	for _, v10 in p1.template and p1.template.itemFooters or {} do
		if v10.contentType == "AgentName" then
			v7 = true
		end

		if v10.contentType == "Price" then
			v8 = true
		end
	end

	local v11 = Utils.getCreatorNameTileFooterEnabled(p2)

	return {
		creatorNameFooterEnabled = v7,
		priceFooterEnabled = v8,
		creatorNameTileFooterEnabled = v11
	}
end

return getWidgetTileFooterProps
