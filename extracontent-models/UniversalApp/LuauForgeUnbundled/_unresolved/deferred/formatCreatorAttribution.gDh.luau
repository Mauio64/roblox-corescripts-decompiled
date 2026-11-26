local function formatCreatorAttribution(object, p2, p3)
	local v5 = p2 and "Feature.ExperienceDetails.Label.MadeByCreatorWithBuild"
		or "Feature.ExperienceDetails.Label.MadeByCreator"
	local success, result = pcall(function()
		return object:Format(v5, { creatorName = p3 })
	end)

	if success and type(result) == "string" then
		return result
	end

	return nil
end

return formatCreatorAttribution
