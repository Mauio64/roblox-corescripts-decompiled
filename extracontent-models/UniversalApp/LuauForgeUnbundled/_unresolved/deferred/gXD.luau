local module = require("@luauforge/bundled/dMx")
require("@luauforge/bundled/dHM")
require("@luauforge/bundled/dMc")
local module2 = require("@luauforge/deferred/gXE")

return function(p2, p3, p4)
	local common = p2.Common
	local avatarEditor = p2.AvatarEditor

	if p4 == module.ItemType.Asset then
		local v5 = common and common.AssetInfos[p3]

		if v5 then
			return module2.fromAssetInfo(v5)
		end
	elseif p4 == module.ItemType.Bundle then
		local v5 = common and common.BundleInfos[p3]

		if v5 then
			return module2.fromBundleInfo(v5)
		end
	else
		local v5 = p4 == module.ItemType.Outfit and avatarEditor and avatarEditor.OutfitInfos[p3]

		if v5 then
			return module2.fromOutfitInfo(v5)
		end
	end

	return nil
end
