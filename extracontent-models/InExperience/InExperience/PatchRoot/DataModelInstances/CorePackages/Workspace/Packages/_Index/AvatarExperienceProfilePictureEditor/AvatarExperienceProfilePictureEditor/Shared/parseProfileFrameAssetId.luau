local function parseProfileFrameAssetId(p)
	if typeof(p) ~= "table" then
		return nil
	end

	local frameAssetId = p.FrameAssetId

	if typeof(frameAssetId) == "number" and frameAssetId ~= 0 then
		return (tostring(frameAssetId))
	end

	return nil
end

return parseProfileFrameAssetId
