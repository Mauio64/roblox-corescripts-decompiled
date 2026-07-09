local _ = script.Parent.Parent

function isCreatorStoreAssetType(s1: string) -- line: 3
	if s1 == nil or type(s1) ~= "string" then
		return false
	end

	for _, v4 in {
		"Model",
		"Plugin",
		"Audio",
		"Decal",
		"FontFamily",
		"MeshPart",
		"Video"
	} do
		if s1 == v4 then
			return true
		end
	end

	return false
end

return isCreatorStoreAssetType
