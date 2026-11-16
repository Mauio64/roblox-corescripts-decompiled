local parent = script.Parent.Parent
local IsDetailsItemPartOfBundleAndOffsale = require(parent.Selectors.IsDetailsItemPartOfBundleAndOffsale)
local UtilityFunctions = require(parent.UtilityFunctions)

return function(data)
	local assetId = data.detailsInformation.assetId

	if not assetId then
		return false
	end

	local detailsItemPartOfBundleAndOffsale = IsDetailsItemPartOfBundleAndOffsale(data)

	if detailsItemPartOfBundleAndOffsale == nil then
		return false
	end

	local asset = data.assets[assetId]

	if not asset then
		return false
	end

	if not detailsItemPartOfBundleAndOffsale then
		return data.favorites.assets[assetId]
	end

	local bundleId = UtilityFunctions.getBundleId(asset)
	return data.favorites.bundles[bundleId]
end
