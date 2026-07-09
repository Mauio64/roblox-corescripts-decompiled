local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local AppCommonLib = require(AvatarExperienceCatalogParent.AppCommonLib)
local AvatarExperienceCommon = require(AvatarExperienceCatalogParent.AvatarExperienceCommon)
local Constants = AvatarExperienceCommon.Constants
local Constants2 = require(AvatarExperienceCatalog.Constants)
local Signals = require(AvatarExperienceCatalogParent.Signals)
local debounce = AvatarExperienceCommon.Utils.debounce
local getBreakpointFromRowWidth = require(AvatarExperienceCatalog.Utils.getBreakpointFromRowWidth)
local WidgetListBreakPointEnum = require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum)
local LANDSCAPE_UI_WIDTH_PERCENTAGE = Constants.LANDSCAPE_UI_WIDTH_PERCENTAGE
local CATALOG_RESULTS_HORIZONTAL_MARGIN = Constants2.CATALOG_RESULTS_HORIZONTAL_MARGIN

local function getInitialScreenSizeEstimate() -- line: 54
	-- upvalues: AppCommonLib (copy), WidgetListBreakPointEnum (copy), LANDSCAPE_UI_WIDTH_PERCENTAGE (copy), CATALOG_RESULTS_HORIZONTAL_MARGIN (copy), getBreakpointFromRowWidth (copy)
	if AppCommonLib.isSpatial() then
		return WidgetListBreakPointEnum.XSmall
	end

	local CurrentCamera = workspace.CurrentCamera

	if CurrentCamera and CurrentCamera.ViewportSize then
		local ViewportSize = CurrentCamera.ViewportSize
		local v17 = if not (ViewportSize.X > ViewportSize.Y) then ViewportSize.X else ViewportSize.X * LANDSCAPE_UI_WIDTH_PERCENTAGE - CATALOG_RESULTS_HORIZONTAL_MARGIN * 2 - 10

		return getBreakpointFromRowWidth(v17)
	end

	return WidgetListBreakPointEnum.Medium
end
local function createAXMarketplaceWidgetStore() -- line: 79
	-- upvalues: getInitialScreenSizeEstimate (copy), Signals (copy), debounce (copy)
	local v18 = getInitialScreenSizeEstimate()
	local v19, v20 = Signals.createSignal(v18)
	local v21, v22 = Signals.createSignal(v18)
	local v23 = debounce(function(p1) -- line: 86
		-- upvalues: v22 (copy)
		v22(p1)
	end, 0.8)

	return {
		getScreenSize = v19,
		setScreenSize = function(p2) -- line: 92
			-- upvalues: v20 (copy), v23 (copy)
			v20(p2)
			v23(p2)
		end,
		getDebouncedScreenSize = v21
	}
end

return createAXMarketplaceWidgetStore
