function LUAUFORGE_MODULE_GLOBALS_beP_isCreatorStoreAssetType(value): boolean
	if value == nil or type(value) ~= "string" then
		return false
	end

	for k, v5 in {
		"Model",
		"Plugin",
		"Audio",
		"Decal",
		"FontFamily",
		"MeshPart",
		"Video"
	} do
		if value == v5 then
			return true
		end
	end

	return false
end

return LUAUFORGE_MODULE_GLOBALS_beP_isCreatorStoreAssetType
