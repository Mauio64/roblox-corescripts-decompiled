local Parent = script:FindFirstAncestor("ProgressLoading").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local ProgressLoadingAssets = require(script.Parent.ProgressLoadingAssets)
local ProgressLoadingTelemetry = require(script.Parent.ProgressLoadingTelemetry)
local GetDeferredAssetStore = require(script.Parent.Stores.GetDeferredAssetStore)
local Constants = require(script.Parent.Constants)

local function getIsLoadingAssets(p1) -- line: 14
	-- upvalues: GetDeferredAssetStore (copy)
	local v11 = GetDeferredAssetStore(p1)

	if v11 then
		return v11.getDownloadStatus(p1) == Enum.PrefetchDownloadStatus.InProgress
	end

	return false
end
local function ProgressLoadingAssetsScreenGui(t1: {[any]: any}) -- line: 28
	-- upvalues: SignalsReact (copy), getIsLoadingAssets (copy), React (copy), ProgressLoadingTelemetry (copy), Constants (copy), ProgressLoadingAssets (copy)
	local v13 = SignalsReact.useSignalState(getIsLoadingAssets)
	local v14, v15 = React.useState(v13)

	React.useEffect(function() -- line: 32
		-- upvalues: v13 (copy), ProgressLoadingTelemetry (copy), v15 (copy)
		if v13 then
			ProgressLoadingTelemetry.logLoadingAssetsActivated()
			v15(true)
		end
	end, { v13 })

	local v16 = React.useCallback(function() -- line: 39
		-- upvalues: ProgressLoadingTelemetry (copy), v15 (copy)
		ProgressLoadingTelemetry.logLoadingAssetsDeactivated()
		v15(false)
	end, {})

	if not v14 then
		return nil
	end

	return React.createElement("ScreenGui", {
		Enabled = true,
		ClipToDeviceSafeArea = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = t1.displayOrder or Constants.DISPLAY_ORDER,
		ScreenInsets = Enum.ScreenInsets.None
	}, {
		ProgressLoadingAssets = React.createElement(ProgressLoadingAssets, {
			isVisible = v13,
			onHideComplete = v16
		})
	})
end

return React.memo(ProgressLoadingAssetsScreenGui)
