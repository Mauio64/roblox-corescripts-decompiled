local function GetEngineFeatureSafe(p1) -- line: 8
	local ok, result = pcall(function() -- line: 9
		-- upvalues: p1 (copy)
		return game:GetEngineFeature(p1)
	end)

	return ok and result
end

return GetEngineFeatureSafe
