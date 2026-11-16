local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/AppCompositionTypes")
local CompositionConfig = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/CompositionConfig")
local getGlobalViewportBreakpoint = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/getGlobalViewportBreakpoint")

local useTokens = Foundation.Hooks.useTokens

local function useCompositionLayout()
	local v5 = useTokens()
	local v6 = SignalsReact.useSignalState(getGlobalViewportBreakpoint)

	return React.useMemo(function()
		return CompositionConfig.getBaseConfig(v6, v5)
	end, { v6, v5 })
end

return useCompositionLayout
