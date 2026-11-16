function LUAUFORGE_MODULE_GLOBALS_xN_FindFirstAncestorWithTag(instance, tag)
	if instance == nil then
		return nil
	end

	if instance:HasTag(tag) then
		return instance
	end

	return LUAUFORGE_MODULE_GLOBALS_xN_FindFirstAncestorWithTag(instance.Parent, tag)
end

return LUAUFORGE_MODULE_GLOBALS_xN_FindFirstAncestorWithTag
