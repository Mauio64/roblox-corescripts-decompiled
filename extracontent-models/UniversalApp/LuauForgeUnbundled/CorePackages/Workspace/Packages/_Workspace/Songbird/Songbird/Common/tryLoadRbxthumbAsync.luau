local ContentProvider = game:GetService("ContentProvider")

local function tryLoadRbxthumbAsync(p2, value)
	local v5 = value or 5

	if ContentProvider:GetAssetFetchStatus(p2) == Enum.AssetFetchStatus.Success then
		return p2
	end

	ContentProvider:PreloadAsync({ p2 })
	local total = 0

	while ContentProvider:GetAssetFetchStatus(p2) ~= Enum.AssetFetchStatus.Success do
		total += task.wait()

		if v5 < total then
			error(`timed out after {v5} seconds when loading {p2}`)
		end
	end

	return p2
end

return tryLoadRbxthumbAsync
