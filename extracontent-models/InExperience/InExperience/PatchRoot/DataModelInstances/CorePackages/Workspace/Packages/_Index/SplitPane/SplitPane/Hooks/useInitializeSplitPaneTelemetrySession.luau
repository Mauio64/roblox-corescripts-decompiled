local parent = script:FindFirstAncestor("SplitPane").Parent
local React = require(parent.React)
local Signals = require(parent.Signals)
local SplitPaneStore = require(script.Parent.Parent.Stores.SplitPaneStore)
local SplitPaneTelemetry = require(script.Parent.Parent.Telemetry.SplitPaneTelemetry)
local getTelemetrySnapshot = require(script.Parent.Parent.Telemetry.getTelemetrySnapshot)

local function useInitializeSplitPaneTelemetrySession(flag: boolean)
	React.useEffect(function()
		if not flag then
			return nil
		end

		local store = SplitPaneStore.getStore()
		return Signals.createEffect(function(p)
			if store.getIsTelemetrySessionInitialized(p) then
				return
			end

			local telemetrySnapshot = getTelemetrySnapshot(store, p)

			if SplitPaneTelemetry.logAppLaunchViewport(telemetrySnapshot) then
				store.setIsTelemetrySessionInitialized(true)
				SplitPaneTelemetry.logSplitPaneViewChange(telemetrySnapshot, SplitPaneTelemetry.Action.Launch)
				SplitPaneTelemetry.logStateChanged(
					SplitPaneTelemetry.getTelemetryStateFromMode(store.getSupportPaneModeIfActive(false)),
					SplitPaneTelemetry.Action.Launch
				)
			end
		end)
	end, { flag })
end

return useInitializeSplitPaneTelemetrySession
