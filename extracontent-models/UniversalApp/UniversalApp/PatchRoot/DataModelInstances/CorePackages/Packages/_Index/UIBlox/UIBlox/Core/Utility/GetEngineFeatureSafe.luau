local function GetEngineFeatureSafe(p)
	local success, result = pcall(function()
		return game:GetEngineFeature(p)
	end)

	return success and result
end

return GetEngineFeatureSafe
