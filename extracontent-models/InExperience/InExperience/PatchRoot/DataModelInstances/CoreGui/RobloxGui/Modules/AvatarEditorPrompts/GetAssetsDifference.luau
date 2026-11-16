local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
require(CorePackages.Packages.Promise)

local GetCurrentHumanoidDescription = require(script.Parent.GetCurrentHumanoidDescription)
local GetAssetIdsFromDescription = require(script.Parent.GetAssetIdsFromDescription)
local GetAssetNamesForIds = require(script.Parent.GetAssetNamesForIds)

return function(p)
	local function getAddedAndRemovedIds(p2, p3)
		local set = Cryo.List.toSet(p2)
		local set2 = Cryo.List.toSet(p3)

		return Cryo.List.filter(p3, function(p4): boolean
			return set[p4] == nil
		end), (Cryo.List.filter(p2, function(p4): boolean
			return set2[p4] == nil
		end))
	end

	return GetCurrentHumanoidDescription():andThen(function(p2)
		local addedAndRemovedIds, removedAssetIds = getAddedAndRemovedIds(
			GetAssetIdsFromDescription(p2),
			GetAssetIdsFromDescription(p)
		)
		return GetAssetNamesForIds((Cryo.List.join(addedAndRemovedIds, removedAssetIds))):andThen(function(p3)
			local addedNames = {}

			for _, addedAndRemovedId in ipairs(addedAndRemovedIds) do
				table.insert(addedNames, p3[addedAndRemovedId])
			end

			local removedNames = {}

			for _, v in ipairs(removedAssetIds) do
				table.insert(removedNames, p3[v])
			end

			return {
				addedNames = addedNames,
				removedNames = removedNames,
				addedAssetIds = addedAndRemovedIds,
				removedAssetIds = removedAssetIds
			}
		end)
	end)
end
