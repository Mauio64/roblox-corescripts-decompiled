local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

require(CorePackages.Packages.Promise)

local GetCurrentHumanoidDescription = require(script.Parent.GetCurrentHumanoidDescription)
local GetAssetIdsFromDescription = require(script.Parent.GetAssetIdsFromDescription)
local GetAssetNamesForIds = require(script.Parent.GetAssetNamesForIds)

return function(p1) -- line: 10
	-- upvalues: Cryo (copy), GetCurrentHumanoidDescription (copy), GetAssetIdsFromDescription (copy), GetAssetNamesForIds (copy)
	local function getAddedAndRemovedIds(p2, p3) -- line: 11
		-- upvalues: Cryo (copy)
		local v10 = Cryo.List.toSet(p2)
		local v11 = Cryo.List.toSet(p3)

		return Cryo.List.filter(p3, function(p4) -- line: 15
			-- upvalues: v10 (copy)
			return v10[p4] == nil
		end), (Cryo.List.filter(p2, function(p5) -- line: 19
			-- upvalues: v11 (copy)
			return v11[p5] == nil
		end))
	end

	return GetCurrentHumanoidDescription():andThen(function(p6) -- line: 26
		-- upvalues: GetAssetIdsFromDescription (copy), p1 (copy), getAddedAndRemovedIds (copy), Cryo (copy), GetAssetNamesForIds (copy)
		local v13 = GetAssetIdsFromDescription(p6)
		local v14 = GetAssetIdsFromDescription(p1)
		local v15, v16 = getAddedAndRemovedIds(v13, v14)
		local v17 = Cryo.List.join(v15, v16)

		return GetAssetNamesForIds(v17):andThen(function(p7) -- line: 33
			-- upvalues: v15 (copy), v16 (copy)
			local t1 = {}

			for _, v in ipairs(v15) do
				table.insert(t1, p7[v])
			end

			local t2 = {}

			for _, v in ipairs(v16) do
				table.insert(t2, p7[v])
			end

			return {
				addedNames = t1,
				removedNames = t2,
				addedAssetIds = v15,
				removedAssetIds = v16
			}
		end)
	end)
end
