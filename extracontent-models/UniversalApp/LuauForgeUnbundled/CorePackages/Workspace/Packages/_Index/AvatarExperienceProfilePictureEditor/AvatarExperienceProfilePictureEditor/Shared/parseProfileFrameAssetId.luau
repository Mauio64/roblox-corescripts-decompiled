local function parseProfileFrameAssetId(p2)
	if typeof(p2) ~= "table" then
		return nil
	end

	local frameAssetId = p2.FrameAssetId

	if typeof(frameAssetId) == "number" and frameAssetId ~= 0 then
		return (tostring(frameAssetId))
	end

	return nil
end

return parseProfileFrameAssetId
