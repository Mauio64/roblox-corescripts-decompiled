local AppComposition = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppComposition")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Display")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SignalsReact")

local getShareSheetRowLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/getShareSheetRowLayout")

local useTokens = Foundation.Hooks.useTokens

local function useMeasuredRows()
	local v5 = useTokens()
	local v6 = SignalsReact.useSignalState(Display.GetDisplayStore().getDisplaySize)
	local v7 = React.useMemo(function()
		local signal, v8 = Signals.createSignal(0)
		return { get = signal, set = v8 }
	end, {})
	local v8 = SignalsReact.useSignalState(v7.get)
	local v9 = AppComposition.useCompositionLayout(v7.get)
	local v10 = React.useCallback(function(p2)
		v7.set(p2.AbsoluteSize.X)
	end, { v7 })

	return React.useMemo(function()
		return {
			isLayoutReady = v8 > 0,
			layout = getShareSheetRowLayout(v8, v9, v6, v5.Size.Size_1700),
			onAbsoluteSizeChanged = v10
		}
	end, { v9, v6, v8, v10, v5 })
end

return useMeasuredRows
