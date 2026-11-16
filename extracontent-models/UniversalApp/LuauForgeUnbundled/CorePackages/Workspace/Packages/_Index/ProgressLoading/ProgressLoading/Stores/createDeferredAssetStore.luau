local EngineFeatureEnableDeferredAssetManagerService = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Flags/EngineFeatureEnableDeferredAssetManagerService")

local DeferredAssetManagerService = if EngineFeatureEnableDeferredAssetManagerService then game:GetService("DeferredAssetManagerService") else nil

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Signals")

local function createDeferredAssetStore(p2)
	local v5 = p2 or DeferredAssetManagerService

	if not EngineFeatureEnableDeferredAssetManagerService and p2 == nil then
		return {
			getDownloadStatus = function() end,
			getPregameLoadingScreenOnly = function(): boolean
				return false
			end,
			cleanUp = function() end
		}
	end

	local prefetchDownloadStatus = v5:GetPrefetchDownloadStatus()
	local signal, v6 = Signals.createSignal(prefetchDownloadStatus)
	local prefetchDownloadStatusChangedConnection = v5.PrefetchDownloadStatusChanged:Connect(function(p3)
		v6(p3)
	end)

	local signal2, v7 = Signals.createSignal(v5.PregameLoadingScreenOnly)

	local pregameLoadingScreenOnlyChangedConnection = v5:GetPropertyChangedSignal("PregameLoadingScreenOnly"):Connect(function()
		v7(v5.PregameLoadingScreenOnly)
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
