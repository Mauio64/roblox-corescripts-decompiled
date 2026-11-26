local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local AppSplitView = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView")

require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/getSplitPaneEducationalTourStore")
require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitPaneStore")

local FFlagSplitPaneEducationalTourTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Flags/FFlagSplitPaneEducationalTourTelemetry")

local v5 = if FFlagSplitPaneEducationalTourTelemetry then require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Telemetry/SplitPaneEducationalTourTelemetry") else nil

local supportPaneMode = AppSplitView.Enums.SupportPaneMode

local function useSplitPaneEducationalTourLifecycle(data)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)
	local v6 = React.useCallback(function(current)
		ref.current = current
		data.splitPaneStore.setTemporarySupportPaneMode(current)
	end, { data.splitPaneStore })
	local v7 = React.useCallback(function()
		local current = ref.current

		if current ~= nil and data.splitPaneStore.getTemporarySupportPaneMode(false) == current then
			data.splitPaneStore.setTemporarySupportPaneMode(nil)
		end

		ref.current = nil
	end, { data.splitPaneStore })

	local v8 = React.useCallback(function()
		local v9 = if data.splitPaneStore.getSupportPaneMode(false) == supportPaneMode.Expanded then supportPaneMode.Expanded else supportPaneMode.Normal
		v6(v9)
	end, { data.splitPaneStore, v6 })

	React.useEffect(function()
		if data.stepIndex == data.totalSteps then
			v8()
		end
	end, { data.stepIndex, data.totalSteps, v8 })

	local ref3 = React.useRef(data.supportPaneMode)

	React.useEffect(function()
		v6(ref3.current)
		return function()
			v7()
		end
	end, { v6, v7 })

	React.useEffect(function()
		if data.isSupportSurfaceEligible then
			return
		end

		if FFlagSplitPaneEducationalTourTelemetry then
			v5.logInterrupted(data.tourStore.getStepIndex(false), data.totalSteps)
		end

		v7()
		data.tourStore.reset()
	end, { data.isSupportSurfaceEligible, v7, data.tourStore, data.totalSteps })

	local ref4 = React.useRef(data.shouldDefaultToCollapsed)
	React.useEffect(function()
		local current = ref4.current
		ref4.current = data.shouldDefaultToCollapsed

		if current and not data.shouldDefaultToCollapsed then
			v8()
		end
	end, { data.shouldDefaultToCollapsed, v8 })

	return {
		endTour = React.useCallback(function()
			local supportPaneMode2 = data.splitPaneStore.getSupportPaneMode(false)

			if ref2.current and supportPaneMode2 ~= supportPaneMode.Collapsed then
				local setSupportPaneMode = data.splitPaneStore.setSupportPaneMode
				local v9 = if supportPaneMode2 == supportPaneMode.Expanded then supportPaneMode.Expanded else supportPaneMode.Normal
				setSupportPaneMode(v9)
			end

			v7()
			data.tourStore.discardPendingTour()
		end, { data.splitPaneStore, data.tourStore, v7 }),
		handleNext = React.useCallback(function()
			local stepIndex = data.tourStore.getStepIndex(false)

			if stepIndex == 1 and data.isSupportPaneCollapsed then
				ref2.current = true
				v6(supportPaneMode.Normal)
			end

			data.tourStore.setStepIndex(stepIndex + 1)
		end, { data.tourStore, data.isSupportPaneCollapsed, v6 })
	}
end

return useSplitPaneEducationalTourLifecycle
