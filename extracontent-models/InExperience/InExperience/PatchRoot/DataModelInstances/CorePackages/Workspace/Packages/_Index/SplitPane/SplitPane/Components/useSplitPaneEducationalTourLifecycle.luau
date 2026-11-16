local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)
local AppSplitView = require(parent.AppSplitView)

require(script.Parent.Parent.Stores.getSplitPaneEducationalTourStore)
require(script.Parent.Parent.Stores.SplitPaneStore)

local FFlagSplitPaneEducationalTourTelemetry = require(script.Parent.Parent.Flags.FFlagSplitPaneEducationalTourTelemetry)
local SplitPaneEducationalTourTelemetry

if FFlagSplitPaneEducationalTourTelemetry then
	SplitPaneEducationalTourTelemetry = require(script.Parent.Parent.Telemetry.SplitPaneEducationalTourTelemetry)
else
	SplitPaneEducationalTourTelemetry = nil
end

local SupportPaneMode = AppSplitView.Enums.SupportPaneMode

local function useSplitPaneEducationalTourLifecycle(data)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)
	local v = React.useCallback(function(current)
		ref.current = current
		data.splitPaneStore.setTemporarySupportPaneMode(current)
	end, { data.splitPaneStore })
	local v2 = React.useCallback(function()
		local current = ref.current

		if current ~= nil and data.splitPaneStore.getTemporarySupportPaneMode(false) == current then
			data.splitPaneStore.setTemporarySupportPaneMode(nil)
		end

		ref.current = nil
	end, { data.splitPaneStore })

	local v3 = React.useCallback(function()
		local v3

		if data.splitPaneStore.getSupportPaneMode(false) == SupportPaneMode.Expanded then
			v3 = SupportPaneMode.Expanded
		else
			v3 = SupportPaneMode.Normal
		end

		v(v3)
	end, { data.splitPaneStore, v })

	React.useEffect(function()
		if data.stepIndex == data.totalSteps then
			v3()
		end
	end, { data.stepIndex, data.totalSteps, v3 })

	local ref3 = React.useRef(data.supportPaneMode)

	React.useEffect(function()
		v(ref3.current)
		return function()
			v2()
		end
	end, { v, v2 })

	React.useEffect(function()
		if data.isSupportSurfaceEligible then
			return
		end

		if FFlagSplitPaneEducationalTourTelemetry then
			SplitPaneEducationalTourTelemetry.logInterrupted(data.tourStore.getStepIndex(false), data.totalSteps)
		end

		v2()
		data.tourStore.reset()
	end, { data.isSupportSurfaceEligible, v2, data.tourStore, data.totalSteps })

	local ref4 = React.useRef(data.shouldDefaultToCollapsed)
	React.useEffect(function()
		local current = ref4.current
		ref4.current = data.shouldDefaultToCollapsed

		if current and not data.shouldDefaultToCollapsed then
			v3()
		end
	end, { data.shouldDefaultToCollapsed, v3 })

	return {
		endTour = React.useCallback(function()
			local supportPaneMode = data.splitPaneStore.getSupportPaneMode(false)

			if ref2.current and supportPaneMode ~= SupportPaneMode.Collapsed then
				local setSupportPaneMode = data.splitPaneStore.setSupportPaneMode
				local v4

				if supportPaneMode == SupportPaneMode.Expanded then
					v4 = SupportPaneMode.Expanded
				else
					v4 = SupportPaneMode.Normal
				end

				setSupportPaneMode(v4)
			end

			v2()
			data.tourStore.discardPendingTour()
		end, { data.splitPaneStore, data.tourStore, v2 }),
		handleNext = React.useCallback(function()
			local stepIndex = data.tourStore.getStepIndex(false)

			if stepIndex == 1 and data.isSupportPaneCollapsed then
				ref2.current = true
				v(SupportPaneMode.Normal)
			end

			data.tourStore.setStepIndex(stepIndex + 1)
		end, { data.tourStore, data.isSupportPaneCollapsed, v })
	}
end

return useSplitPaneEducationalTourLifecycle
