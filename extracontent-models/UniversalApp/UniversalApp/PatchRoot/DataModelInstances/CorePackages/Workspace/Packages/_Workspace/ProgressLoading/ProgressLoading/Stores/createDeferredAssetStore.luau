local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local ProgressLoadingParent = ProgressLoading.Parent
local EngineFeatureEnableDeferredAssetManagerService = require(ProgressLoading.Flags.EngineFeatureEnableDeferredAssetManagerService)
local v4 = if not EngineFeatureEnableDeferredAssetManagerService then nil else game:GetService("DeferredAssetManagerService")
local Signals = require(ProgressLoadingParent.Signals)

local function createDeferredAssetStore(p1) -- line: 19
	-- upvalues: v4 (copy), EngineFeatureEnableDeferredAssetManagerService (copy), Signals (copy)
	local v8 = p1 or v4

	if not EngineFeatureEnableDeferredAssetManagerService and p1 == nil then
		return {
			getDownloadStatus = function() -- line: 23
			end,
			cleanUp = function() -- line: 24
			end
		}
	end

	local PrefetchDownloadStatus = v8:GetPrefetchDownloadStatus()
	local v10, v11 = Signals.createSignal(PrefetchDownloadStatus)
	local connection = v8.PrefetchDownloadStatusChanged:Connect(function(p2) -- line: 30
		-- upvalues: v11 (copy)
		v11(p2)
	end)

	return {
		getDownloadStatus = v10,
		cleanUp = function() -- line: 36
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	}
end

return createDeferredAssetStore
