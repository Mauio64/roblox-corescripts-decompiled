local AppComposition = script:FindFirstAncestor("AppComposition")
local AppCompositionParent = AppComposition.Parent
local Foundation = require(AppCompositionParent.Foundation)
local React = require(AppCompositionParent.React)
local SignalsReact = require(AppCompositionParent.SignalsReact)

require(AppComposition.AppCompositionTypes)

local CompositionConfig = require(AppComposition.CompositionConfig)
local getGlobalViewportBreakpoint = require(AppComposition.getGlobalViewportBreakpoint)
local useTokens = Foundation.Hooks.useTokens

local function useCompositionLayout() -- line: 16
	-- upvalues: useTokens (copy), SignalsReact (copy), getGlobalViewportBreakpoint (copy), React (copy), CompositionConfig (copy)
	local v10 = useTokens()
	local v11 = SignalsReact.useSignalState(getGlobalViewportBreakpoint)

	return React.useMemo(function() -- line: 20
		-- upvalues: CompositionConfig (copy), v11 (copy), v10 (copy)
		return CompositionConfig.getBaseConfig(v11, v10)
	end, {
		v11,
		v10
	})
end

return useCompositionLayout
