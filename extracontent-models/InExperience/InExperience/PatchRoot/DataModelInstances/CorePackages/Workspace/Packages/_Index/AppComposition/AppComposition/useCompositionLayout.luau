local AppComposition = script:FindFirstAncestor("AppComposition")
local parent = AppComposition.Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

require(AppComposition.AppCompositionTypes)
local CompositionConfig = require(AppComposition.CompositionConfig)
local getGlobalViewportBreakpoint = require(AppComposition.getGlobalViewportBreakpoint)

local useTokens = Foundation.Hooks.useTokens

local function useCompositionLayout()
	local v = useTokens()
	local v2 = SignalsReact.useSignalState(getGlobalViewportBreakpoint)

	return React.useMemo(function()
		return CompositionConfig.getBaseConfig(v2, v)
	end, { v2, v })
end

return useCompositionLayout
