local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SignalsReact")

local module3 = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/ProgressLoadingAssets")
local ProgressLoadingTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/ProgressLoadingTelemetry")
local GetDeferredAssetStore = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Stores/GetDeferredAssetStore")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Constants")

local function getIsLoadingAssets(p2): boolean
	local v5 = GetDeferredAssetStore(p2)

	if v5 then
		return v5.getDownloadStatus(p2) == Enum.PrefetchDownloadStatus.InProgress
	end

	return false
end

local function ProgressLoadingAssetsScreenGui(p2)
	local v5 = SignalsReact.useSignalState(getIsLoadingAssets)
	local state, setState = React.useState(v5)

	React.useEffect(function()
		if v5 then
			ProgressLoadingTelemetry.logLoadingAssetsActivated()
			setState(true)
		end
	end, { v5 })

	local v6 = React.useCallback(function()
		ProgressLoadingTelemetry.logLoadingAssetsDeactivated()
		setState(false)
	end, {})

	if state then
		return React.createElement("ScreenGui", {
			Enabled = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = p2.displayOrder or Constants.DISPLAY_ORDER,
			ScreenInsets = Enum.ScreenInsets.None,
			ClipToDeviceSafeArea = false
		}, {
			ProgressLoadingAssets = React.createElement(module3, {
				isVisible = v5,
				onHideComplete = v6
			})
		})
	end

	return nil
end

return React.memo(ProgressLoadingAssetsScreenGui)
