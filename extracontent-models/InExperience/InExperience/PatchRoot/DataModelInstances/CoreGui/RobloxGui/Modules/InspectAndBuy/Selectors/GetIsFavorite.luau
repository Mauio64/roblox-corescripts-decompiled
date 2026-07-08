local ParentParent = script.Parent.Parent
local IsDetailsItemPartOfBundleAndOffsale = require(ParentParent.Selectors.IsDetailsItemPartOfBundleAndOffsale)
local UtilityFunctions = require(ParentParent.UtilityFunctions)

return function(p1) -- line: 8
	-- upvalues: IsDetailsItemPartOfBundleAndOffsale (copy), UtilityFunctions (copy)
	local assetId = p1.detailsInformation.assetId

	if not assetId then
		return false
	end

	local v6 = IsDetailsItemPartOfBundleAndOffsale(p1)

	if v6 == nil then
		return false
	end

	local v7 = p1.assets[assetId]

	if not v7 then
		return false
	end

	if v6 then
		local v8 = UtilityFunctions.getBundleId(v7)

		return p1.favorites.bundles[v8]
	end

	return p1.favorites.assets[assetId]
end
