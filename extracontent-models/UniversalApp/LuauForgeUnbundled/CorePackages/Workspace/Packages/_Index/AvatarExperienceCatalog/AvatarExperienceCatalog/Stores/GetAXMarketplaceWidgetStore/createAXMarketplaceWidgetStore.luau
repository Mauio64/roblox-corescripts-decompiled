local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppCommonLib")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local constants = AvatarExperienceCommon.Constants
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Constants")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics").sendAXCounterV2

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Signals")
local debounce = AvatarExperienceCommon.Utils.debounce

local getBreakpointFromRowWidth = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getBreakpointFromRowWidth")
local getCameraViewportSize = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getCameraViewportSize")
local WidgetListBreakPointEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListBreakPointEnum")

local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags").FFlagEnableSplitPane
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXMarketplaceBreakpointEstimateFix = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointEstimateFix
local fFlagAXMarketplaceBreakpointMismatchCounter = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointMismatchCounter

local LANDSCAPE_UI_WIDTH_PERCENTAGE = constants.LANDSCAPE_UI_WIDTH_PERCENTAGE
local CATALOG_RESULTS_HORIZONTAL_MARGIN = Constants.CATALOG_RESULTS_HORIZONTAL_MARGIN

local function getInitialScreenSizeEstimate()
	if AppCommonLib.isSpatial() then
		return WidgetListBreakPointEnum.XSmall
	end

	local currentCamera = workspace.CurrentCamera

	if not (currentCamera and currentCamera.ViewportSize) then
		return WidgetListBreakPointEnum.Medium
	end

	local viewportSize = currentCamera.ViewportSize
	local v5 = if viewportSize.X > viewportSize.Y then viewportSize.X * LANDSCAPE_UI_WIDTH_PERCENTAGE - CATALOG_RESULTS_HORIZONTAL_MARGIN * 2 - 10 else viewportSize.X

	return getBreakpointFromRowWidth(v5)
end

local function getSplitPaneCatalogWidthFraction()
	if not fFlagEnableSplitPane then
		return nil
	end

	local store = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SplitPane").SplitPaneStore.getStore()

	if store.getIsBreakpointEnabled(false) then
		return 1 - store.getSupportWidthFraction(false)
	end

	return nil
end

local function getScreenSizeEstimate()
	if AppCommonLib.isSpatial() then
		return WidgetListBreakPointEnum.XSmall
	end

	local v5 = getCameraViewportSize()

	if v5 == nil then
		return WidgetListBreakPointEnum.Medium
	end

	local displayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Display").GetDisplayStore(false)
	local guiInset = displayStore.getGuiInset(false)
	local v6 = v5.X - guiInset.left - guiInset.right
	local v7

	if fFlagEnableSplitPane then
		local store = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SplitPane").SplitPaneStore.getStore()

		if store.getIsBreakpointEnabled(false) then
			v7 = 1 - store.getSupportWidthFraction(false)
		end
	end

	if v7 == nil then
		if v5.X > v5.Y then
			v6 *= LANDSCAPE_UI_WIDTH_PERCENTAGE
		end
	else
		v6 *= v7
	end

	return getBreakpointFromRowWidth(
		math.max(v6 - CATALOG_RESULTS_HORIZONTAL_MARGIN * 2, 0),
		displayStore.getPlatformScale(false)
	)
end

local function getOrientationDimension(): string
	local v5 = getCameraViewportSize()

	if v5 == nil then
		return "Unknown"
	end

	if v5.X > v5.Y then
		return "Landscape"
	end

	return "Portrait"
end

local function createAXMarketplaceWidgetStore()
	local v5 = if fFlagAXMarketplaceBreakpointMismatchCounter then getCameraViewportSize() ~= nil else nil
	local v6

	if fFlagAXMarketplaceBreakpointEstimateFix then
		v6 = getScreenSizeEstimate()
	else
		v6 = getInitialScreenSizeEstimate()
	end

	local signal, v7 = Signals.createSignal(v6)
	local signal2, v8 = Signals.createSignal(v6)
	local flag = false

	local count = 0
	local estimateWriteBreakpoint = nil

	local v9 = debounce(function(p2)
		v8(p2)
	end, 0.8)

	return {
		getScreenSize = signal,
		setScreenSize = function(p2)
			if fFlagAXMarketplaceBreakpointEstimateFix then
				flag = true
			end

			v7(p2)
			v9(p2)
		end,
		getDebouncedScreenSize = signal2,
		reportMeasuredBreakpoint = function(p2, p3)
			local v10 = signal2(false)

			local marketplaceBreakpointMeasured = Constants.COUNTERS.MarketplaceBreakpointMeasured
			local v12 = {
				match = tostring(p2 == v10),
				fetched = v10,
				measured = p2,
				source = p3,
				orientation = 0,
				hadCameraAtCreation = 0,
				estimateFix = 0
			}
			local v13 = getCameraViewportSize()
			v12.orientation = v13 == nil and "Unknown" or v13.X > v13.Y and "Landscape" or "Portrait"
			v12.hadCameraAtCreation = tostring(v5)
			v12.estimateFix = tostring(fFlagAXMarketplaceBreakpointEstimateFix)
			sendAXCounterV2(marketplaceBreakpointMeasured, v12)
		end,
		refreshEstimate = function()
			if flag then
				return
			end

			local screenSizeEstimate = getScreenSizeEstimate()

			if fFlagAXMarketplaceBreakpointEstimateFix and signal2(false) ~= screenSizeEstimate then
				count += 1
				estimateWriteBreakpoint = screenSizeEstimate
			end

			v7(screenSizeEstimate)
			v8(screenSizeEstimate)
		end,
		getEstimateWriteId = function()
			return count
		end,
		getEstimateWriteBreakpoint = function()
			return estimateWriteBreakpoint
		end,
		wasScreenSizePublishedByEstimateWrite = function(p2, p3): boolean
			return count ~= p2 and estimateWriteBreakpoint == p3
		end
	}
end

return createAXMarketplaceWidgetStore
