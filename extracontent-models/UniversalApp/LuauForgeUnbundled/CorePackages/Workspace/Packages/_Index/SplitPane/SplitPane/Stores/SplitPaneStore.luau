local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Signals")
local SignalsUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SignalsUtils")
local AppComposition = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppComposition")
local AppSplitView = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Display")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags")
local SplitPaneTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Telemetry/SplitPaneTelemetry")
local getTelemetrySnapshot = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Telemetry/getTelemetrySnapshot")
local createSplitPanePreference = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/createSplitPanePreference")

local EnablePersistSplitPanePreferenceFeature = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Flags/EnablePersistSplitPanePreferenceFeature")

local createCurrentScreenOrientationSignal = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/createCurrentScreenOrientationSignal")
local supportPaneWidthRules = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/supportPaneWidthRules")

local SplitPaneVariant = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/SplitPaneVariant")
local getRegionOverrides = AppComposition.getRegionOverrides
local regionName = AppComposition.RegionName

local supportPaneMode = AppSplitView.Enums.SupportPaneMode

local fFlagSplitPaneFixClassicThemeHeader = SharedFlags.FFlagSplitPaneFixClassicThemeHeader
local fFlagEnableSplitPaneTelemetry = SharedFlags.FFlagEnableSplitPaneTelemetry
local fFlagEnableSplitPaneStackFallbackFix = SharedFlags.FFlagEnableSplitPaneStackFallbackFix
local fFlagAXPauseSceneWhenSplitPaneCollapsed = SharedFlags.FFlagAXPauseSceneWhenSplitPaneCollapsed

local function getSupportRegionSizing()
	local v5

	if getRegionOverrides and regionName then
		v5 = getRegionOverrides(regionName.SupportRegion)
	end

	local v6 = not (v5 and v5.widthScale) and 0.33 or v5.widthScale
	local v7 = not (v5 and v5.minWidth) and 0 or v5.minWidth

	if v5 and v5.maxWidth then
		return v6, v7, v5.maxWidth
	end

	return v6, v7, 1e999
end

local function evaluateShouldDefaultToCollapsed(p2)
	if SplitPaneVariant.isPaneCollapsedByDefault() then
		return true
	end

	local designSpaceViewportWidth = Display.GetDisplayStore(p2).getDesignSpaceViewportWidth(p2)
	return supportPaneWidthRules.shouldDefaultToCollapsed(designSpaceViewportWidth)
end

local v5 = nil
local v6 = nil
local v7 = nil

local function createSplitPaneStore()
	local v8

	if getRegionOverrides and regionName then
		v8 = getRegionOverrides(regionName.SupportRegion)
	end

	local v9 = not (v8 and v8.widthScale) and 0.33 or v8.widthScale
	local minSupportWidth = not (v8 and v8.minWidth) and 0 or v8.minWidth
	local maxSupportWidth = not (v8 and v8.maxWidth) and 1e999 or v8.maxWidth

	local v10, v11 = createCurrentScreenOrientationSignal()
	v6 = v11
	local function evaluateBreakpointEnabled(p2)
		local designSpaceViewportWidth = Display.GetDisplayStore(p2).getDesignSpaceViewportWidth(p2)
		local v13 = v10(p2)
		return (v13 == Enum.ScreenOrientation.LandscapeLeft or v13 == Enum.ScreenOrientation.LandscapeRight)
			and supportPaneWidthRules.isSplitEnabledForWidth(designSpaceViewportWidth)
	end

	local signal, v13 = Signals.createSignal(nil)

	local signal2, v14 = Signals.createSignal(nil)

	local signal3, v15 = Signals.createSignal(nil)
	local computed = Signals.createComputed(evaluateShouldDefaultToCollapsed)
	local v16, v17

	if EnablePersistSplitPanePreferenceFeature then
		v16, v17 = createSplitPanePreference()
	else
		v16 = nil
		v17 = nil
	end

	local function computeSupportPaneMode(p2, p3)
		local v18 = signal3(p2)

		if v18 ~= nil then
			return v18
		end

		local v19 = signal2(p2)

		if v19 ~= nil then
			return v19
		end

		if EnablePersistSplitPanePreferenceFeature then
			local v20 = v16(p2)

			if v20 ~= nil then
				if v20 then
					return supportPaneMode.Collapsed
				end

				return supportPaneMode.Normal
			end
		end

		if p3 == nil then
			p3 = computed(p2)
		end

		if p3 then
			return supportPaneMode.Collapsed
		end

		return supportPaneMode.Normal
	end

	local computed2 = Signals.createComputed(function(p2)
		if fFlagEnableSplitPaneTelemetry then
			return computeSupportPaneMode(p2)
		end

		local v18 = signal3(p2)

		if v18 ~= nil then
			return v18
		end

		local v19 = signal2(p2)

		if v19 ~= nil then
			return v19
		end

		if EnablePersistSplitPanePreferenceFeature then
			local v20 = v16(p2)

			if v20 ~= nil then
				if v20 then
					return supportPaneMode.Collapsed
				end

				return supportPaneMode.Normal
			end
		end

		if computed(p2) then
			return supportPaneMode.Collapsed
		end

		return supportPaneMode.Normal
	end)

	local function getSupportPaneMode(p2)
		return computed2(p2)
	end

	local signal4, v18 = Signals.createSignal(nil)

	local signal5, v19 = Signals.createSignal(nil)

	local signal6, v20 = Signals.createSignal(nil)

	if not fFlagEnableSplitPaneTelemetry then
		local v21 = computed(false)

		v5 = Signals.createEffect(function(p2)
			local v22 = computed(p2)

			if v22 ~= v21 then
				v14(nil)
			end

			v21 = v22
		end)
	end

	local computed3 = Signals.createComputed(function(p2)
		local designSpaceViewportWidth = Display.GetDisplayStore(p2).getDesignSpaceViewportWidth(p2)

		if designSpaceViewportWidth <= 0 then
			return v9
		end

		return (signal(p2) or math.clamp(designSpaceViewportWidth * v9, minSupportWidth, maxSupportWidth)) / designSpaceViewportWidth
	end)
	local v21, v22

	if fFlagSplitPaneFixClassicThemeHeader then
		v21, v22 = Signals.createSignal(nil)
	end

	local v23, v24

	if fFlagAXPauseSceneWhenSplitPaneCollapsed then
		v23, v24 = Signals.createSignal(false)
	end

	local signal7, v25 = Signals.createSignal(false)
	local v26, v27

	if fFlagEnableSplitPaneTelemetry then
		v26, v27 = SignalsUtils.createSessionScopedSignal(false)
	else
		v26 = nil
	end

	local function evaluateSplitActive(p2)
		return evaluateBreakpointEnabled(p2) and signal7(p2)
	end

	local computed4 = Signals.createComputed(evaluateSplitActive)
	local computed5 = Signals.createComputed(function(p2)
		if computed4(p2) then
			return getSupportPaneMode(p2)
		end

		return nil
	end)

	local computed6 = Signals.createComputed(function(p2): boolean
		local v28 = computed5(p2)
		return v28 == nil or v28 == supportPaneMode.Collapsed
	end)
	local v28

	if fFlagEnableSplitPaneStackFallbackFix then
		local v29
		v28, v29 = Signals.createSignal(false)

		if evaluateBreakpointEnabled(false) then
			v29(true)
		end

		v7 = Signals.createEffect(function(p2)
			if evaluateBreakpointEnabled(p2) then
				v29(true)
			end
		end)
	else
		v28 = function(): boolean
			return false
		end
	end

	local splitPaneStore = nil
	local v29 = {}
	v29.getCurrentScreenOrientation = v10
	v29.getIsTelemetrySessionInitialized = v26
	v29.setIsTelemetrySessionInitialized = v27
	v29.getSupportWidth = signal
	v29.getSupportWidthFraction = computed3

	function v29.setSupportWidth(p2)
		local platformScale = Display.GetDisplayStore(false).getPlatformScale(false)
		local v28 = p2 / (not (platformScale and platformScale > 0) and 1 or platformScale)
		v13((math.clamp(v28, minSupportWidth, maxSupportWidth)))
	end

	function v29.resetSupportWidth()
		v13(nil)
	end
	function v29.getMinSupportWidth()
		return minSupportWidth
	end

	function v29.getMaxSupportWidth()
		return maxSupportWidth
	end

	if not fFlagSplitPaneFixClassicThemeHeader then
		v21 = nil
	end

	v29.getContentRegionRect = v21

	if not fFlagSplitPaneFixClassicThemeHeader then
		v22 = nil
	end

	v29.setContentRegionRect = v22

	v29.getIsBreakpointEnabled = Signals.createComputed(evaluateBreakpointEnabled)
	v29.getWasSplitPaneAvailable = v28
	v29.getIsSplitPaneActive = computed4
	v29.getIsSplitEnabled = computed4
	v29.getSupportPaneModeIfActive = computed5
	v29.getIsSplitPaneCollapsedOrNotActive = computed6

	if not fFlagAXPauseSceneWhenSplitPaneCollapsed then
		v23 = nil
	end

	v29.getHasSupportRoute = v23

	if not fFlagAXPauseSceneWhenSplitPaneCollapsed then
		v24 = nil
	end

	v29.setHasSupportRoute = v24
	v29.getIsSplitEligible = signal7
	v29.setIsSplitEligible = v25

	v29.getSupportPaneMode = getSupportPaneMode
	v29.getTemporarySupportPaneMode = signal3
	v29.getShouldDefaultToCollapsed = computed
	function v29.setSupportPaneMode(p2)
		v14(p2)
	end
	function v29.setTemporarySupportPaneMode(p2)
		v15(p2)
	end

	function v29.resetSupportPaneMode()
		v14(nil)
		v15(nil)
	end
	function v29.toggleSupportPaneMode(p2)
		local v30 = if fFlagEnableSplitPaneTelemetry then computed6(false) else nil
		local v31

		if fFlagEnableSplitPaneTelemetry then
			v31 = SplitPaneTelemetry.getTelemetryStateFromMode(computed5(false))
		end

		local v32 = if computed2(false) == p2 then supportPaneMode.Normal else p2

		if signal3(false) == nil then
			v14(v32)
		else
			v15(v32)
		end

		if EnablePersistSplitPanePreferenceFeature and (p2 == supportPaneMode.Collapsed or p2 == supportPaneMode.Normal) then
			v14(v32)
			v17(v32 == supportPaneMode.Collapsed)
		end

		if fFlagEnableSplitPaneTelemetry and v26(false) then
			local telemetryStateFromMode = SplitPaneTelemetry.getTelemetryStateFromMode(computed5(false))

			if v31 ~= telemetryStateFromMode then
				SplitPaneTelemetry.logStateChanged(telemetryStateFromMode, SplitPaneTelemetry.Action.Toggle)
			end

			if v30 ~= computed6(false) then
				SplitPaneTelemetry.logSplitPaneViewChange(getTelemetrySnapshot(splitPaneStore, false), SplitPaneTelemetry.Action.Toggle)
			end
		end
	end
	v29.getSupportPaneEntryTarget = signal4
	v29.setSupportPaneEntryTarget = v18
	v29.getSupportPaneTopRouteMatcher = signal5

	function v29.setSupportPaneTopRouteMatcher(p2)
		v19(function()
			return p2
		end)
	end
	v29.getSupportPaneTopRouteKey = signal6
	v29.setSupportPaneTopRouteKey = v20
	splitPaneStore = v29

	if fFlagEnableSplitPaneTelemetry then
		local v30 = computed(false)
		local v31 = evaluateBreakpointEnabled(false)

		v5 = Signals.createEffect(function(p2)
			local v32 = computed(p2)
			local v33 = v32 ~= v30
			local v34 = evaluateBreakpointEnabled(p2)

			if v33 or v34 ~= v31 then
				local v35 = computeSupportPaneMode(false, v30)
				local getTelemetryStateFromMode = SplitPaneTelemetry.getTelemetryStateFromMode
				local v36 = if v31 and splitPaneStore.getIsSplitEligible(false) then v35 else nil
				local telemetryStateFromMode = getTelemetryStateFromMode(v36)

				local v37 = not v31
					or not splitPaneStore.getIsSplitEligible(false)
					or v35 == supportPaneMode.Collapsed

				if v33 then
					v14(nil)
				end

				if splitPaneStore.getIsTelemetrySessionInitialized(false) then
					local telemetryStateFromMode2 = SplitPaneTelemetry.getTelemetryStateFromMode(computed5(false))

					if telemetryStateFromMode ~= telemetryStateFromMode2 then
						SplitPaneTelemetry.logStateChanged(telemetryStateFromMode2, SplitPaneTelemetry.Action.ViewportChanged)
					end

					if v37 ~= splitPaneStore.getIsSplitPaneCollapsedOrNotActive(false) then
						SplitPaneTelemetry.logSplitPaneViewChange(
							getTelemetrySnapshot(splitPaneStore, false),
							SplitPaneTelemetry.Action.ViewportChanged
						)
					end
				end
			end

			v30 = v32
			v31 = v34
		end)
	end

	return splitPaneStore
end

local store = nil
return {
	getStore = function()
		if store == nil then
			store = createSplitPaneStore()
		end

		return store
	end,
	isSplitEnabledNow = function()
		if store == nil then
			store = createSplitPaneStore()
		end

		local v8 = store

		return v8.getIsBreakpointEnabled(false) and v8.getIsSplitEligible(false)
	end
}
