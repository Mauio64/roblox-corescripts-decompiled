local ContentProvider = game:GetService("ContentProvider")

local function tryLoadRbxthumbAsync(p: string, value: number?)
	local v = value or 5

	if ContentProvider:GetAssetFetchStatus(p) == Enum.AssetFetchStatus.Success then
		return p
	end

	ContentProvider:PreloadAsync({ p })
	local total = 0

	while ContentProvider:GetAssetFetchStatus(p) ~= Enum.AssetFetchStatus.Success do
		total += task.wait()

		if v < total then
			error(`timed out after {v} seconds when loading {p}`)
		end
	end

	return p
end

return tryLoadRbxthumbAsync
