local ContentProvider = game:GetService("ContentProvider")

local function tryLoadRbxthumbAsync(s1: string, n1: number?) -- line: 3
	-- upvalues: ContentProvider (copy)
	local v5 = n1 or 5

	if ContentProvider:GetAssetFetchStatus(s1) == Enum.AssetFetchStatus.Success then
		return s1
	end

	ContentProvider:PreloadAsync({ s1 })

	local n2 = 0

	while ContentProvider:GetAssetFetchStatus(s1) ~= Enum.AssetFetchStatus.Success do
		n2 += task.wait()

		if v5 < n2 then
			error(`timed out after { v5 } seconds when loading { s1 }`)
		end
	end

	return s1
end

return tryLoadRbxthumbAsync
