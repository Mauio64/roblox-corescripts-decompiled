local parent = script:FindFirstAncestor("ShareSheet").Parent

local AppComposition = require(parent.AppComposition)
local Display = require(parent.Display)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local getShareSheetRowLayout = require(script.Parent.getShareSheetRowLayout)

local useTokens = Foundation.Hooks.useTokens

local function useMeasuredRows()
	local v = useTokens()
	local v2 = SignalsReact.useSignalState(Display.GetDisplayStore().getDisplaySize)
	local v3 = React.useMemo(function()
		local signal, set = Signals.createSignal(0)
		return { get = signal, set = set }
	end, {})
	local v4 = SignalsReact.useSignalState(v3.get)
	local v5 = AppComposition.useCompositionLayout(v3.get)
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v3.set(p.AbsoluteSize.X)
	end, { v3 })

	return React.useMemo(function()
		return {
			isLayoutReady = v4 > 0,
			layout = getShareSheetRowLayout(v4, v5, v2, v.Size.Size_1700),
			onAbsoluteSizeChanged = onAbsoluteSizeChanged
		}
	end, { v5, v2, v4, onAbsoluteSizeChanged, v })
end

return useMeasuredRows
