local ContentProvider = game:GetService("ContentProvider")

local v5 = { 0.5, 1, 2 }

local function isRetryable(p2): boolean
	return p2 == Enum.AssetFetchStatus.Failure or p2 == Enum.AssetFetchStatus.TimedOut
end

local function preloadImageWithRetry(p2, data, data2)
	local v6 = if data2 and data2.contentProvider then data2.contentProvider else ContentProvider

	local v7 = if data2 and data2.retryDelays then data2.retryDelays else v5
	local wait2 = if data2 and data2.wait then data2.wait else task.wait

	for i = 1, #v7 + 1 do
		local v8 = nil
		pcall(function()
			v6:PreloadAsync({ p2 }, function(p3, p4)
				if p3 == p2 then
					v8 = p4
				end
			end)
		end)

		if not data.isCurrent() then
			return
		end

		local assetFetchStatus = v6:GetAssetFetchStatus(p2)

		if v8 == Enum.AssetFetchStatus.Success or assetFetchStatus == Enum.AssetFetchStatus.Success then
			data.onSuccess()
			return
		end

		local v9 = v8

		if
			v9 ~= Enum.AssetFetchStatus.Failure
			and v9 ~= Enum.AssetFetchStatus.TimedOut
			and assetFetchStatus ~= Enum.AssetFetchStatus.Failure
			and assetFetchStatus ~= Enum.AssetFetchStatus.TimedOut
		then
			return
		end

		local v10 = v7[i]

		if v10 == nil then
			break
		end

		wait2(v10)

		if not data.isCurrent() then
			return
		end
	end

	data.onGiveUp()
end

return preloadImageWithRetry
