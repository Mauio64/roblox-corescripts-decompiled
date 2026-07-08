local ParentParent = script.Parent.Parent

require(ParentParent.util.BundlesMetadata)

local Constants = require(ParentParent.Constants)

local function getUGCBodyPartsAssetTypeMap(p1, p2, s1: string) -- line: 43
	-- upvalues: Constants (copy)
	assert(p1:IsA("Model"))

	local v8 = p2[s1]

	if v8 == nil then
		return {}
	end

	local t1 = {}

	for _, v11 in Constants.UGC_BODY_PARTS do
		local v12 = p1:FindFirstChild(v11)

		if v12 ~= nil then
			local v13 = Constants.UGC_BODY_PART_NAMES_TO_ASSET_TYPE[v11]

			assert(v13 ~= nil, "Body part doesn't map to an asset type")

			if v8.allowedAssetTypeSettings[v13.Name] ~= nil then
				if t1[v13] == nil then
					t1[v13] = { v12 }
				else
					table.insert(t1[v13], v12)
				end
			end
		end
	end

	return t1
end
local function createUGCBodyPartFolders(p3, p4, s2: string, b1: boolean?) -- line: 97
	-- upvalues: getUGCBodyPartsAssetTypeMap (copy), Constants (copy)
	assert(p3:IsA("Model"), "Invalid root instance, must be a model")

	local t2 = {}

	for v19, v20 in (getUGCBodyPartsAssetTypeMap(p3, p4, s2)) do
		if table.find(Constants.ASSET_TYPES_THAT_SKIP_FOLDER, v19) ~= nil then
			t2[v19] = v20
		else
			local Folder = Instance.new("Folder")

			Folder.Name = Constants.FOLDER_NAMES.R15ArtistIntent

			for _, v23 in v20 do
				v23.Parent = Folder
			end

			t2[v19] = { Folder }

			if b1 then
				local clone = Folder:Clone()

				clone.Name = Constants.FOLDER_NAMES.R15Fixed
				table.insert(t2[v19], clone)

				local Folder2 = Instance.new("Folder")

				Folder2.Name = Constants.FOLDER_NAMES.R6
				table.insert(t2[v19], Folder2)
			end
		end
	end

	return t2
end

return createUGCBodyPartFolders
