local function getCaptureMomentId(p1) -- line: 12
	if typeof(p1) ~= "table" then
		return nil
	end

	if p1.assetId ~= nil then
		return `creation:{ p1.assetId }`
	end

	if p1.LocalId ~= nil then
		return `creation:{ p1.LocalId }`
	end

	return nil
end

return getCaptureMomentId
