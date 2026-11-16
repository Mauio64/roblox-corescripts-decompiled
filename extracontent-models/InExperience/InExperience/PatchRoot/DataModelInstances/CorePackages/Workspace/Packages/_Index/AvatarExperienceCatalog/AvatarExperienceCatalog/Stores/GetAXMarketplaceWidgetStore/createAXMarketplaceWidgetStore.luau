local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local parent = AvatarExperienceCatalog.Parent

local AppCommonLib = require(parent.AppCommonLib)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local Constants = AvatarExperienceCommon.Constants
local Constants2 = require(AvatarExperienceCatalog.Constants)
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2

local Signals = require(parent.Signals)
local debounce = AvatarExperienceCommon.Utils.debounce

local getBreakpointFromRowWidth = require(AvatarExperienceCatalog.Utils.getBreakpointFromRowWidth)
local getCameraViewportSize = require(AvatarExperienceCatalog.Utils.getCameraViewportSize)
local WidgetListBreakPointEnum = require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMarketplaceBreakpointEstimateFix = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointEstimateFix
local FFlagAXMarketplaceBreakpointMismatchCounter = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointMismatchCounter

local LANDSCAPE_UI_WIDTH_PERCENTAGE = Constants.LANDSCAPE_UI_WIDTH_PERCENTAGE
local CATALOG_RESULTS_HORIZONTAL_MARGIN = Constants2.CATALOG_RESULTS_HORIZONTAL_MARGIN

local function getInitialScreenSizeEstimate()
	if AppCommonLib.isSpatial() then
		return WidgetListBreakPointEnum.XSmall
	end

	local currentCamera = workspace.CurrentCamera

	if not (currentCamera and currentCamera.ViewportSize) then
		return WidgetListBreakPointEnum.Medium
	end

	local viewportSize = currentCamera.ViewportSize
	local v

	if viewportSize.X > viewportSize.Y then
		v = viewportSize.X * LANDSCAPE_UI_WIDTH_PERCENTAGE - CATALOG_RESULTS_HORIZONTAL_MARGIN * 2 - 10
	else
		v = viewportSize.X
	end

	return getBreakpointFromRowWidth(v)
end

local function getSplitPaneCatalogWidthFraction() -- 1 equivalent call inferred from this helper
	if not FFlagEnableSplitPane then
		return nil
	end

	local SplitPane = require(parent.SplitPane)
	local store = SplitPane.SplitPaneStore.getStore()

	if store.getIsBreakpointEnabled(false) then
		return 1 - store.getSupportWidthFraction(false)
	end

	return nil
end

local function getScreenSizeEstimate()
	if AppCommonLib.isSpatial() then
		return WidgetListBreakPointEnum.XSmall
	end

	local cameraViewportSize = getCameraViewportSize()

	if cameraViewportSize == nil then
		return WidgetListBreakPointEnum.Medium
	end

	local Display = require(parent.Display)
	local displayStore = Display.GetDisplayStore(false)
	local guiInset = displayStore.getGuiInset(false)
	local v = cameraViewportSize.X - guiInset.left - guiInset.right
	local splitPaneCatalogWidthFraction = getSplitPaneCatalogWidthFraction() -- inferred equivalent call

	if splitPaneCatalogWidthFraction == nil then
		if cameraViewportSize.X > cameraViewportSize.Y then
			v *= LANDSCAPE_UI_WIDTH_PERCENTAGE
		end
	else
		v *= splitPaneCatalogWidthFraction
	end

	return getBreakpointFromRowWidth(
		math.max(v - CATALOG_RESULTS_HORIZONTAL_MARGIN * 2, 0),
		displayStore.getPlatformScale(false)
	)
end

local function getOrientationDimension(): string -- 1 equivalent call inferred from this helper
	local cameraViewportSize = getCameraViewportSize()

	if cameraViewportSize == nil then
		return "Unknown"
	end

	if cameraViewportSize.X > cameraViewportSize.Y then
		return "Landscape"
	end

	return "Portrait"
end

local function createAXMarketplaceWidgetStore()
	local v

	if FFlagAXMarketplaceBreakpointMismatchCounter then
		v = getCameraViewportSize() ~= nil
	else
		v = nil
	end

	local v2

	if FFlagAXMarketplaceBreakpointEstimateFix then
		v2 = getScreenSizeEstimate()
	else
		v2 = getInitialScreenSizeEstimate()
	end

	local signal, v3 = Signals.createSignal(v2)
	local signal2, v4 = Signals.createSignal(v2)
	local flag = false

	local count = 0
	local estimateWriteBreakpoint = nil

	local v5 = debounce(function(p)
		v4(p)
	end, 0.8)

	return {
		getScreenSize = signal,
		setScreenSize = function(p)
			if FFlagAXMarketplaceBreakpointEstimateFix then
				flag = true
			end

			v3(p)
			v5(p)
		end,
		getDebouncedScreenSize = signal2,
		reportMeasuredBreakpoint = function(measured, source: string)
			local fetched = signal2(false)

			sendAXCounterV2(Constants2.COUNTERS.MarketplaceBreakpointMeasured, {
				match = tostring(measured == fetched),
				fetched = fetched,
				measured = measured,
				source = source,
				orientation = getOrientationDimension(), -- inferred equivalent call
				hadCameraAtCreation = tostring(v),
				estimateFix = tostring(FFlagAXMarketplaceBreakpointEstimateFix)
			})
		end,
		refreshEstimate = function()
			if flag then
				return
			end

			local screenSizeEstimate = getScreenSizeEstimate()

			if FFlagAXMarketplaceBreakpointEstimateFix and signal2(false) ~= screenSizeEstimate then
				count += 1
				estimateWriteBreakpoint = screenSizeEstimate
			end

			v3(screenSizeEstimate)
			v4(screenSizeEstimate)
		end,
		getEstimateWriteId = function()
			return count
		end,
		getEstimateWriteBreakpoint = function()
			return estimateWriteBreakpoint
		end,
		wasScreenSizePublishedByEstimateWrite = function(p: number, p2): boolean
			return count ~= p and estimateWriteBreakpoint == p2
		end
	}
end

return createAXMarketplaceWidgetStore
