if not game:GetEngineFeature("CoreAttributes") then
	return false
end

return game:DefineFastFlag("LeaderstatsWithASideOfClient", false)
