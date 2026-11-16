local ContentProvider = game:GetService("ContentProvider")

local v = { 0.5, 1, 2 }

local function isRetryable(p): boolean
	return p == Enum.AssetFetchStatus.Failure or p == Enum.AssetFetchStatus.TimedOut
end

local function preloadImageWithRetry(p: string, data, data2)
	local v2

	if data2 and data2.contentProvider then
		v2 = data2.contentProvider
	else
		v2 = ContentProvider
	end

	local v3

	if data2 and data2.retryDelays then
		v3 = data2.retryDelays
	else
		v3 = v
	end

	local wait = if data2 and data2.wait then data2.wait else task.wait

	for i = 1, #v3 + 1 do
		local v4 = nil
		pcall(function()
			v2:PreloadAsync({ p }, function(p2, p3)
				if p2 == p then
					v4 = p3
				end
			end)
		end)

		if not data.isCurrent() then
			return
		end

		local assetFetchStatus = v2:GetAssetFetchStatus(p)

		if v4 == Enum.AssetFetchStatus.Success or assetFetchStatus == Enum.AssetFetchStatus.Success then
			data.onSuccess()
			return
		end

		local v5 = v4

		if
			v5 ~= Enum.AssetFetchStatus.Failure
			and v5 ~= Enum.AssetFetchStatus.TimedOut
			and assetFetchStatus ~= Enum.AssetFetchStatus.Failure
			and assetFetchStatus ~= Enum.AssetFetchStatus.TimedOut
		then
			return
		end

		local v6 = v3[i]

		if v6 == nil then
			break
		end

		wait(v6)

		if not data.isCurrent() then
			return
		end
	end

	data.onGiveUp()
end

return preloadImageWithRetry
