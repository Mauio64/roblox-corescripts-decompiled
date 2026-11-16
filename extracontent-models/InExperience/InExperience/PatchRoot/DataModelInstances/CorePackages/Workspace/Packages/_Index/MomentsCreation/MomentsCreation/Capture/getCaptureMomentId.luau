local function getCaptureMomentId(p)
	if typeof(p) ~= "table" then
		return nil
	end

	if p.assetId ~= nil then
		return `creation:{p.assetId}`
	end

	if p.LocalId == nil then
		return nil
	end

	return `creation:{p.LocalId}`
end

return getCaptureMomentId
