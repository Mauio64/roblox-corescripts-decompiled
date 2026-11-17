local AppComposition = script:FindFirstAncestor("AppComposition")
local parent = AppComposition.Parent
local Display = require(parent.Display)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppCompositionContainerWidth = SharedFlags.FFlagAppCompositionContainerWidth

require(AppComposition.AppCompositionTypes)
local CompositionConfig = require(AppComposition.CompositionConfig)
local createBreakpointComputed = require(AppComposition.createBreakpointComputed)
local getGlobalViewportBreakpoint = require(AppComposition.getGlobalViewportBreakpoint)

local useTokens = Foundation.Hooks.useTokens

local function useCompositionLayout(callback)
	local v = useTokens()
	local v2

	if FFlagAppCompositionContainerWidth then
		v2 = React.useMemo(function()
			if callback then
				return (createBreakpointComputed(function(p)
					return callback(p) / Display.GetDisplayStore(p).getPlatformScale(p)
				end))
			end

			return getGlobalViewportBreakpoint
		end, { callback })
	end

	local useSignalState = SignalsReact.useSignalState

	if not FFlagAppCompositionContainerWidth then
		v2 = getGlobalViewportBreakpoint
	end

	local v3 = useSignalState(v2)

	return React.useMemo(function()
		return CompositionConfig.getBaseConfig(v3, v)
	end, { v3, v })
end

return useCompositionLayout
