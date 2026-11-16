local parent = script:FindFirstAncestor("ProgressLoading").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local ProgressLoadingAssets = require(script.Parent.ProgressLoadingAssets)
local ProgressLoadingTelemetry = require(script.Parent.ProgressLoadingTelemetry)
local GetDeferredAssetStore = require(script.Parent.Stores.GetDeferredAssetStore)
local Constants = require(script.Parent.Constants)

local function getIsLoadingAssets(p): boolean
	local deferredAssetStore = GetDeferredAssetStore(p)

	if deferredAssetStore then
		return deferredAssetStore.getDownloadStatus(p) == Enum.PrefetchDownloadStatus.InProgress
	end

	return false
end

local function ProgressLoadingAssetsScreenGui(p)
	local isVisible = SignalsReact.useSignalState(getIsLoadingAssets)
	local state, setState = React.useState(isVisible)

	React.useEffect(function()
		if isVisible then
			ProgressLoadingTelemetry.logLoadingAssetsActivated()
			setState(true)
		end
	end, { isVisible })

	local onHideComplete = React.useCallback(function()
		ProgressLoadingTelemetry.logLoadingAssetsDeactivated()
		setState(false)
	end, {})

	if state then
		return React.createElement("ScreenGui", {
			Enabled = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = p.displayOrder or Constants.DISPLAY_ORDER,
			ScreenInsets = Enum.ScreenInsets.None,
			ClipToDeviceSafeArea = false
		}, {
			ProgressLoadingAssets = React.createElement(ProgressLoadingAssets, {
				isVisible = isVisible,
				onHideComplete = onHideComplete
			})
		})
	end

	return nil
end

return React.memo(ProgressLoadingAssetsScreenGui)
