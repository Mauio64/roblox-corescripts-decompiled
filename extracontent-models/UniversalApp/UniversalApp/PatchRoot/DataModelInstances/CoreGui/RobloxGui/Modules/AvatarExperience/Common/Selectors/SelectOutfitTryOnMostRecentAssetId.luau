local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)

local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local v6 = memoize(function(p1, p2) -- line: 31
	-- upvalues: Constants (copy)
	local v9 = nil
	local itemId = nil
	local v11 = nil

	for _, v13 in p1 do
		if v13.selectedInTryOnManager then
			local itemRecency = v13.itemRecency

			if v13.itemType == Constants.ItemType.Asset then
				if p2 == v13.itemSubType and (v9 == nil or v9 < itemRecency) then
					v9 = itemRecency
					itemId = v13.itemId
					v11 = nil
				end
			elseif v13.bundleInfo then
				for v15, v16 in v13.bundleInfo do
					if p2 == v16.assetType and (v9 == nil or v9 < itemRecency) then
						v9 = itemRecency
						itemId = v15
						v11 = v13.bundleInfo
					end
				end
			end
		end
	end

	return itemId, v11, v9
end)

return function(p3, p4) -- line: 75
	-- upvalues: v6 (copy)
	local TryOnItems = p3.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	return v6(TryOnItems, p4)
end
