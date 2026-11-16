local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Signals")
local SplitPaneStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitPaneStore")
local SplitPaneTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Telemetry/SplitPaneTelemetry")
local getTelemetrySnapshot = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Telemetry/getTelemetrySnapshot")

local function useInitializeSplitPaneTelemetrySession(p2)
	React.useEffect(function()
		if not p2 then
			return nil
		end

		local store = SplitPaneStore.getStore()
		return Signals.createEffect(function(p3)
			if store.getIsTelemetrySessionInitialized(p3) then
				return
			end

			local v5 = getTelemetrySnapshot(store, p3)

			if SplitPaneTelemetry.logAppLaunchViewport(v5) then
				store.setIsTelemetrySessionInitialized(true)
				SplitPaneTelemetry.logSplitPaneViewChange(v5, SplitPaneTelemetry.Action.Launch)
				SplitPaneTelemetry.logStateChanged(
					SplitPaneTelemetry.getTelemetryStateFromMode(store.getSupportPaneModeIfActive(false)),
					SplitPaneTelemetry.Action.Launch
				)
			end
		end)
	end, { p2 })
end

return useInitializeSplitPaneTelemetrySession
