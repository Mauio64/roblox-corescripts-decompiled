local parent = script:FindFirstAncestor("SplitPane").Parent

local Signals = require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local AppComposition = require(parent.AppComposition)
local AppSplitView = require(parent.AppSplitView)
local Display = require(parent.Display)
local SharedFlags = require(parent.SharedFlags)
local SplitPaneTelemetry = require(script.Parent.Parent.Telemetry.SplitPaneTelemetry)
local getTelemetrySnapshot = require(script.Parent.Parent.Telemetry.getTelemetrySnapshot)
local createSplitPanePreference = require(script.Parent.createSplitPanePreference)

local EnablePersistSplitPanePreferenceFeature = require(script.Parent.Parent.Flags.EnablePersistSplitPanePreferenceFeature)

local createCurrentScreenOrientationSignal = require(script.Parent.Parent.Utils.createCurrentScreenOrientationSignal)
local supportPaneWidthRules = require(script.Parent.Parent.Utils.supportPaneWidthRules)

local SplitPaneVariant = require(script.Parent.Parent.Utils.SplitPaneVariant)
local getRegionOverrides = AppComposition.getRegionOverrides
local RegionName = AppComposition.RegionName

local SupportPaneMode = AppSplitView.Enums.SupportPaneMode

local FFlagSplitPaneFixClassicThemeHeader = SharedFlags.FFlagSplitPaneFixClassicThemeHeader
local FFlagEnableSplitPaneTelemetry = SharedFlags.FFlagEnableSplitPaneTelemetry
local FFlagEnableSplitPaneStackFallbackFix = SharedFlags.FFlagEnableSplitPaneStackFallbackFix
local FFlagAXPauseSceneWhenSplitPaneCollapsed = SharedFlags.FFlagAXPauseSceneWhenSplitPaneCollapsed

local function getSupportRegionSizing()
	local v

	if getRegionOverrides and RegionName then
		v = getRegionOverrides(RegionName.SupportRegion)
	end

	local v2 = not (v and v.widthScale) and 0.33 or v.widthScale
	local v3 = not (v and v.minWidth) and 0 or v.minWidth

	if v and v.maxWidth then
		return v2, v3, v.maxWidth
	end

	return v2, v3, 1e999
end

local function evaluateShouldDefaultToCollapsed(p)
	if SplitPaneVariant.isPaneCollapsedByDefault() then
		return true
	end

	local designSpaceViewportWidth = Display.GetDisplayStore(p).getDesignSpaceViewportWidth(p)
	return supportPaneWidthRules.shouldDefaultToCollapsed(designSpaceViewportWidth)
end

local _ = nil
local v = nil
local v2 = nil

local function createSplitPaneStore()
	local v3

	if getRegionOverrides and RegionName then
		v3 = getRegionOverrides(RegionName.SupportRegion)
	end

	local v4 = not (v3 and v3.widthScale) and 0.33 or v3.widthScale
	local minSupportWidth = not (v3 and v3.minWidth) and 0 or v3.minWidth
	local maxSupportWidth = not (v3 and v3.maxWidth) and 1e999 or v3.maxWidth

	local currentScreenOrientationSignal, v5 = createCurrentScreenOrientationSignal()
	v = v5
	local function evaluateBreakpointEnabled(p)
		local designSpaceViewportWidth = Display.GetDisplayStore(p).getDesignSpaceViewportWidth(p)
		local v6 = currentScreenOrientationSignal(p)
		return (v6 == Enum.ScreenOrientation.LandscapeLeft or v6 == Enum.ScreenOrientation.LandscapeRight)
			and supportPaneWidthRules.isSplitEnabledForWidth(designSpaceViewportWidth)
	end

	local signal, v6 = Signals.createSignal(nil)

	local signal2, v7 = Signals.createSignal(nil)

	local signal3, v8 = Signals.createSignal(nil)
	local getShouldDefaultToCollapsed = Signals.createComputed(evaluateShouldDefaultToCollapsed)
	local v9, v10

	if EnablePersistSplitPanePreferenceFeature then
		v9, v10 = createSplitPanePreference()
	else
		v9 = nil
		v10 = nil
	end

	local function computeSupportPaneMode(p, flag: boolean?)
		local v11 = signal3(p)

		if v11 ~= nil then
			return v11
		end

		local v12 = signal2(p)

		if v12 ~= nil then
			return v12
		end

		if EnablePersistSplitPanePreferenceFeature then
			local v13 = v9(p)

			if v13 ~= nil then
				if v13 then
					return SupportPaneMode.Collapsed
				end

				return SupportPaneMode.Normal
			end
		end

		if flag == nil then
			flag = getShouldDefaultToCollapsed(p)
		end

		if flag then
			return SupportPaneMode.Collapsed
		end

		return SupportPaneMode.Normal
	end

	local computed = Signals.createComputed(function(p)
		if FFlagEnableSplitPaneTelemetry then
			return computeSupportPaneMode(p)
		end

		local v11 = signal3(p)

		if v11 ~= nil then
			return v11
		end

		local v12 = signal2(p)

		if v12 ~= nil then
			return v12
		end

		if EnablePersistSplitPanePreferenceFeature then
			local v13 = v9(p)

			if v13 ~= nil then
				if v13 then
					return SupportPaneMode.Collapsed
				end

				return SupportPaneMode.Normal
			end
		end

		if getShouldDefaultToCollapsed(p) then
			return SupportPaneMode.Collapsed
		end

		return SupportPaneMode.Normal
	end)

	local function getSupportPaneMode(p) -- 2 equivalent calls inferred from this helper
		return (computed(p))
	end

	local signal4, setSupportPaneEntryTarget = Signals.createSignal(nil)

	local signal5, v11 = Signals.createSignal(nil)

	local signal6, setSupportPaneTopRouteKey = Signals.createSignal(nil)

	if not FFlagEnableSplitPaneTelemetry then
		local v12 = getShouldDefaultToCollapsed(false)

		_ = Signals.createEffect(function(p)
			local v13 = getShouldDefaultToCollapsed(p)

			if v13 ~= v12 then
				v7(nil)
			end

			v12 = v13
		end)
	end

	local getSupportWidthFraction = Signals.createComputed(function(p)
		local designSpaceViewportWidth = Display.GetDisplayStore(p).getDesignSpaceViewportWidth(p)

		if designSpaceViewportWidth <= 0 then
			return v4
		end

		return (signal(p) or math.clamp(designSpaceViewportWidth * v4, minSupportWidth, maxSupportWidth)) / designSpaceViewportWidth
	end)
	local getContentRegionRect, setContentRegionRect

	if FFlagSplitPaneFixClassicThemeHeader then
		getContentRegionRect, setContentRegionRect = Signals.createSignal(nil)
	end

	local getHasSupportRoute, setHasSupportRoute

	if FFlagAXPauseSceneWhenSplitPaneCollapsed then
		getHasSupportRoute, setHasSupportRoute = Signals.createSignal(false)
	end

	local signal7, setIsSplitEligible = Signals.createSignal(false)
	local getIsTelemetrySessionInitialized, setIsTelemetrySessionInitialized

	if FFlagEnableSplitPaneTelemetry then
		getIsTelemetrySessionInitialized, setIsTelemetrySessionInitialized = SignalsUtils.createSessionScopedSignal(false)
	else
		getIsTelemetrySessionInitialized = nil
	end

	local function evaluateSplitActive(p)
		return evaluateBreakpointEnabled(p) and signal7(p)
	end

	local computed2 = Signals.createComputed(evaluateSplitActive)
	local getSupportPaneModeIfActive = Signals.createComputed(function(p)
		if computed2(p) then
			return getSupportPaneMode(p) -- inferred equivalent call
		end

		return nil
	end)

	local getIsSplitPaneCollapsedOrNotActive = Signals.createComputed(function(p): boolean
		local v12 = getSupportPaneModeIfActive(p)
		return v12 == nil or v12 == SupportPaneMode.Collapsed
	end)
	local getWasSplitPaneAvailable

	if FFlagEnableSplitPaneStackFallbackFix then
		local v12
		getWasSplitPaneAvailable, v12 = Signals.createSignal(false)

		if evaluateBreakpointEnabled(false) then
			v12(true)
		end

		v2 = Signals.createEffect(function(p)
			if evaluateBreakpointEnabled(p) then
				v12(true)
			end
		end)
	else
		getWasSplitPaneAvailable = function(): boolean
			return false
		end
	end

	local splitPaneStore = nil
	local v12 = {}
	v12.getCurrentScreenOrientation = currentScreenOrientationSignal
	v12.getIsTelemetrySessionInitialized = getIsTelemetrySessionInitialized
	v12.setIsTelemetrySessionInitialized = setIsTelemetrySessionInitialized
	v12.getSupportWidth = signal
	v12.getSupportWidthFraction = getSupportWidthFraction

	function v12.setSupportWidth(p: number)
		local platformScale = Display.GetDisplayStore(false).getPlatformScale(false)
		v6((math.clamp(
			p / (not (platformScale and platformScale > 0) and 1 or platformScale),
			minSupportWidth,
			maxSupportWidth
		)))
	end

	function v12.resetSupportWidth()
		v6(nil)
	end
	function v12.getMinSupportWidth()
		return minSupportWidth
	end

	function v12.getMaxSupportWidth()
		return maxSupportWidth
	end

	if not FFlagSplitPaneFixClassicThemeHeader then
		getContentRegionRect = nil
	end

	v12.getContentRegionRect = getContentRegionRect

	if not FFlagSplitPaneFixClassicThemeHeader then
		setContentRegionRect = nil
	end

	v12.setContentRegionRect = setContentRegionRect

	v12.getIsBreakpointEnabled = Signals.createComputed(evaluateBreakpointEnabled)
	v12.getWasSplitPaneAvailable = getWasSplitPaneAvailable
	v12.getIsSplitPaneActive = computed2
	v12.getIsSplitEnabled = computed2
	v12.getSupportPaneModeIfActive = getSupportPaneModeIfActive
	v12.getIsSplitPaneCollapsedOrNotActive = getIsSplitPaneCollapsedOrNotActive

	if not FFlagAXPauseSceneWhenSplitPaneCollapsed then
		getHasSupportRoute = nil
	end

	v12.getHasSupportRoute = getHasSupportRoute

	if not FFlagAXPauseSceneWhenSplitPaneCollapsed then
		setHasSupportRoute = nil
	end

	v12.setHasSupportRoute = setHasSupportRoute
	v12.getIsSplitEligible = signal7
	v12.setIsSplitEligible = setIsSplitEligible

	v12.getSupportPaneMode = getSupportPaneMode
	v12.getTemporarySupportPaneMode = signal3
	v12.getShouldDefaultToCollapsed = getShouldDefaultToCollapsed
	function v12.setSupportPaneMode(p)
		v7(p)
	end
	function v12.setTemporarySupportPaneMode(p)
		v8(p)
	end

	function v12.resetSupportPaneMode()
		v7(nil)
		v8(nil)
	end
	function v12.toggleSupportPaneMode(p)
		local v13

		if FFlagEnableSplitPaneTelemetry then
			v13 = getIsSplitPaneCollapsedOrNotActive(false)
		end

		local v14

		if FFlagEnableSplitPaneTelemetry then
			v14 = SplitPaneTelemetry.getTelemetryStateFromMode(getSupportPaneModeIfActive(false))
		end

		local v15

		if getSupportPaneMode(false) == p then -- inferred equivalent call
			v15 = SupportPaneMode.Normal
		else
			v15 = p
		end

		if signal3(false) == nil then
			v7(v15)
		else
			v8(v15)
		end

		if
			EnablePersistSplitPanePreferenceFeature
			and (p == SupportPaneMode.Collapsed or p == SupportPaneMode.Normal)
		then
			v7(v15)
			v10(v15 == SupportPaneMode.Collapsed)
		end

		if FFlagEnableSplitPaneTelemetry and getIsTelemetrySessionInitialized(false) then
			local telemetryStateFromMode = SplitPaneTelemetry.getTelemetryStateFromMode(getSupportPaneModeIfActive(false))

			if v14 ~= telemetryStateFromMode then
				SplitPaneTelemetry.logStateChanged(telemetryStateFromMode, SplitPaneTelemetry.Action.Toggle)
			end

			if v13 ~= getIsSplitPaneCollapsedOrNotActive(false) then
				SplitPaneTelemetry.logSplitPaneViewChange(
					getTelemetrySnapshot(splitPaneStore, false),
					SplitPaneTelemetry.Action.Toggle
				)
			end
		end
	end
	v12.getSupportPaneEntryTarget = signal4
	v12.setSupportPaneEntryTarget = setSupportPaneEntryTarget
	v12.getSupportPaneTopRouteMatcher = signal5

	function v12.setSupportPaneTopRouteMatcher(callback)
		v11(function()
			return callback
		end)
	end
	v12.getSupportPaneTopRouteKey = signal6
	v12.setSupportPaneTopRouteKey = setSupportPaneTopRouteKey
	splitPaneStore = v12

	if FFlagEnableSplitPaneTelemetry then
		local v13 = getShouldDefaultToCollapsed(false)
		local v14 = evaluateBreakpointEnabled(false)

		_ = Signals.createEffect(function(p)
			local v15 = getShouldDefaultToCollapsed(p)
			local v16 = v15 ~= v13
			local v17 = evaluateBreakpointEnabled(p)

			if v16 or v17 ~= v14 then
				local v18 = computeSupportPaneMode(false, v13)
				local getTelemetryStateFromMode = SplitPaneTelemetry.getTelemetryStateFromMode
				local v19

				if v14 and splitPaneStore.getIsSplitEligible(false) then
					v19 = v18
				end

				local telemetryStateFromMode = getTelemetryStateFromMode(v19)

				local v20 = not v14 or not splitPaneStore.getIsSplitEligible(false) or v18 == SupportPaneMode.Collapsed

				if v16 then
					v7(nil)
				end

				if splitPaneStore.getIsTelemetrySessionInitialized(false) then
					local telemetryStateFromMode2 = SplitPaneTelemetry.getTelemetryStateFromMode(getSupportPaneModeIfActive(false))

					if telemetryStateFromMode ~= telemetryStateFromMode2 then
						SplitPaneTelemetry.logStateChanged(
							telemetryStateFromMode2,
							SplitPaneTelemetry.Action.ViewportChanged
						)
					end

					if v20 ~= splitPaneStore.getIsSplitPaneCollapsedOrNotActive(false) then
						SplitPaneTelemetry.logSplitPaneViewChange(
							getTelemetrySnapshot(splitPaneStore, false),
							SplitPaneTelemetry.Action.ViewportChanged
						)
					end
				end
			end

			v13 = v15
			v14 = v17
		end)
	end

	return splitPaneStore
end

local store = nil
local function getStore() -- 1 equivalent call inferred from this helper
	if store == nil then
		store = createSplitPaneStore()
	end

	return store
end

return {
	getStore = getStore,
	isSplitEnabledNow = function()
		local store2 = getStore() -- inferred equivalent call
		return store2.getIsBreakpointEnabled(false) and store2.getIsSplitEligible(false)
	end
}
