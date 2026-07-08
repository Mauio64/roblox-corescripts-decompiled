local CorePackages = game:GetService("CorePackages")
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local ParentParent = script.Parent.Parent
local IsDetailsItemPartOfBundleAndOffsale = require(ParentParent.Selectors.IsDetailsItemPartOfBundleAndOffsale)
local UtilityFunctions = require(ParentParent.UtilityFunctions)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local v7 = createInspectAndBuyKeyMapper("getFavoriteForAsset")
local v8 = createInspectAndBuyKeyMapper("getFavoriteForBundle")

return function(p1) -- line: 14
	-- upvalues: IsDetailsItemPartOfBundleAndOffsale (copy), UtilityFunctions (copy), v8 (copy), RetrievalStatus (copy), v7 (copy)
	local assetId = p1.detailsInformation.assetId

	if not assetId then
		return false
	end

	local v11 = IsDetailsItemPartOfBundleAndOffsale(p1)

	if v11 == nil then
		return false
	end

	local v12 = p1.assets[assetId]

	if not v12 then
		return false
	end

	if v11 then
		local v13 = UtilityFunctions.getBundleId(v12)
		local v14 = v8(p1.storeId, v13)

		return p1.FetchingStatus[v14] == RetrievalStatus.Fetching or p1.FetchingStatus[v14] == RetrievalStatus.Done
	end

	local v15 = v7(p1.storeId, assetId)

	return p1.FetchingStatus[v15] == RetrievalStatus.Fetching or p1.FetchingStatus[v15] == RetrievalStatus.Done
end
