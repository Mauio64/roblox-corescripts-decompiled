local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
local parent = script.Parent.Parent
local IsDetailsItemPartOfBundleAndOffsale = require(parent.Selectors.IsDetailsItemPartOfBundleAndOffsale)
local UtilityFunctions = require(parent.UtilityFunctions)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getFavoriteForAsset")
local inspectAndBuyKeyMapper2 = createInspectAndBuyKeyMapper("getFavoriteForBundle")

return function(data): boolean
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
		local v = inspectAndBuyKeyMapper(data.storeId, assetId)
		return data.FetchingStatus[v] == RetrievalStatus.Fetching or data.FetchingStatus[v] == RetrievalStatus.Done
	end

	local bundleId = UtilityFunctions.getBundleId(asset)

	local v = inspectAndBuyKeyMapper2(data.storeId, bundleId)
	return data.FetchingStatus[v] == RetrievalStatus.Fetching or data.FetchingStatus[v] == RetrievalStatus.Done
end
