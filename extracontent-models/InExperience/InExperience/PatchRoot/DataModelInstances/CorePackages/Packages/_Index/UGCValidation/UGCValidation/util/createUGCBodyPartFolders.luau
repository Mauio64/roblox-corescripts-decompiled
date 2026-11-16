local parent = script.Parent.Parent

require(parent.util.BundlesMetadata)
local Constants = require(parent.Constants)

local function getUGCBodyPartsAssetTypeMap(model, p, p2: string)
	assert(model:IsA("Model"))

	local v = p[p2]

	if v == nil then
		return {}
	end

	local result = {}

	for _, childName in Constants.UGC_BODY_PARTS do
		local child = model:FindFirstChild(childName)

		if child == nil then
			continue
		end

		local v2 = Constants.UGC_BODY_PART_NAMES_TO_ASSET_TYPE[childName]
		assert(v2 ~= nil, "Body part doesn't map to an asset type")

		if v.allowedAssetTypeSettings[v2.Name] == nil then
			continue
		end

		if result[v2] == nil then
			result[v2] = { child }
		else
			table.insert(result[v2], child)
		end
	end

	return result
end

local function createUGCBodyPartFolders(model, p, p2: string, flag: boolean?)
	assert(model:IsA("Model"), "Invalid root instance, must be a model")

	local ugcBodyPartsAssetTypeMap = getUGCBodyPartsAssetTypeMap(model, p, p2)

	local ugcBodyPartFolders = {}

	for k, ugcBodyPartsAssetType in ugcBodyPartsAssetTypeMap do
		if table.find(Constants.ASSET_TYPES_THAT_SKIP_FOLDER, k) == nil then
			local folder = Instance.new("Folder")
			folder.Name = Constants.FOLDER_NAMES.R15ArtistIntent

			for _, v in ugcBodyPartsAssetType do
				v.Parent = folder
			end

			ugcBodyPartFolders[k] = { folder }

			if flag then
				local clone = folder:Clone()
				clone.Name = Constants.FOLDER_NAMES.R15Fixed
				table.insert(ugcBodyPartFolders[k], clone)

				local folder2 = Instance.new("Folder")
				folder2.Name = Constants.FOLDER_NAMES.R6
				table.insert(ugcBodyPartFolders[k], folder2)
			end
		else
			ugcBodyPartFolders[k] = ugcBodyPartsAssetType
		end
	end

	return ugcBodyPartFolders
end

return createUGCBodyPartFolders
