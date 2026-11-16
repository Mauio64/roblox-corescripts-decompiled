local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local parent = ProgressLoading.Parent

local EngineFeatureEnableDeferredAssetManagerService = require(ProgressLoading.Flags.EngineFeatureEnableDeferredAssetManagerService)
local DeferredAssetManagerService

if EngineFeatureEnableDeferredAssetManagerService then
	DeferredAssetManagerService = game:GetService("DeferredAssetManagerService")
else
	DeferredAssetManagerService = nil
end

local Signals = require(parent.Signals)

local function createDeferredAssetStore(p)
	local v = p or DeferredAssetManagerService

	if not EngineFeatureEnableDeferredAssetManagerService and p == nil then
		return {
			getDownloadStatus = function() end,
			getPregameLoadingScreenOnly = function(): boolean
				return false
			end,
			cleanUp = function() end
		}
	end

	local prefetchDownloadStatus = v:GetPrefetchDownloadStatus()
	local signal, v2 = Signals.createSignal(prefetchDownloadStatus)
	local prefetchDownloadStatusChangedConnection = v.PrefetchDownloadStatusChanged:Connect(function(p2)
		v2(p2)
	end)

	local signal2, v3 = Signals.createSignal(v.PregameLoadingScreenOnly)

	local pregameLoadingScreenOnlyChangedConnection = v:GetPropertyChangedSignal("PregameLoadingScreenOnly"):Connect(function()
		v3(v.PregameLoadingScreenOnly)
	end)

	return {
		getDownloadStatus = signal,
		getPregameLoadingScreenOnly = signal2,
		cleanUp = function()
			prefetchDownloadStatusChangedConnection:Disconnect()
			pregameLoadingScreenOnlyChangedConnection:Disconnect()
		end
	}
end

return createDeferredAssetStore
