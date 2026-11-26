local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Display")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/SignalsReact")
local fFlagAppCompositionContainerWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/SharedFlags").FFlagAppCompositionContainerWidth

require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/AppCompositionTypes")
local CompositionConfig = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/CompositionConfig")
local createBreakpointComputed = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/createBreakpointComputed")
local getGlobalViewportBreakpoint = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/getGlobalViewportBreakpoint")

local useTokens = Foundation.Hooks.useTokens

local function useCompositionLayout(callback)
	local v5 = useTokens()
	local v6

	if fFlagAppCompositionContainerWidth then
		v6 = React.useMemo(function()
			if callback then
				return (createBreakpointComputed(function(p2)
					return callback(p2) / Display.GetDisplayStore(p2).getPlatformScale(p2)
				end))
			end

			return getGlobalViewportBreakpoint
		end, { callback })
	end

	local useSignalState = SignalsReact.useSignalState

	if not fFlagAppCompositionContainerWidth then
		v6 = getGlobalViewportBreakpoint
	end

	local v7 = useSignalState(v6)

	return React.useMemo(function()
		return CompositionConfig.getBaseConfig(v7, v5)
	end, { v7, v5 })
end

return useCompositionLayout
