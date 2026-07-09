local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.Reducers.AvatarExperience)
require(Modules.AvatarExperience.Common.Types)

local ItemInfo = require(Modules.AvatarExperience.Common.Models.ItemInfo)

return function(p1, p2, p3) -- line: 12
	-- upvalues: Constants (copy), ItemInfo (copy)
	local Common = p1.Common
	local AvatarEditor = p1.AvatarEditor

	if p3 == Constants.ItemType.Asset then
		if Common then
			local v9 = Common.AssetInfos[p2]

			if v9 then
				return ItemInfo.fromAssetInfo(v9)
			end
		end
	elseif p3 == Constants.ItemType.Bundle then
		if Common then
			local v10 = Common.BundleInfos[p2]

			if v10 then
				return ItemInfo.fromBundleInfo(v10)
			end
		end
	elseif p3 == Constants.ItemType.Outfit and AvatarEditor then
		local v11 = AvatarEditor.OutfitInfos[p2]

		if v11 then
			return ItemInfo.fromOutfitInfo(v11)
		end
	end

	return nil
end
