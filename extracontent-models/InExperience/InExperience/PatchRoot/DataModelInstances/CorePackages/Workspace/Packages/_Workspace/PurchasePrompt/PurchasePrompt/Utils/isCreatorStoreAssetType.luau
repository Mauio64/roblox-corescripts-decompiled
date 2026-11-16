local parent = script.Parent.Parent

function isCreatorStoreAssetType(value: string): boolean
	if value == nil or type(value) ~= "string" then
		return false
	end

	for _, v in { "Model", "Plugin", "Audio", "Decal", "FontFamily", "MeshPart", "Video" } do
		if value == v then
			return true
		end
	end

	return false
end

return isCreatorStoreAssetType
