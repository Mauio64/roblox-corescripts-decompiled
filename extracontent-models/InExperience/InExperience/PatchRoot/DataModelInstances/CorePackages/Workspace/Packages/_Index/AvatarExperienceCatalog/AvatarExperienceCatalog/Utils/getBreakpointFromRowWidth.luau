local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local WidgetListBreakPointEnum = require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum)
local WidgetListBreakPointThresholds = require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointThresholds)

local function getBreakpointFromRowWidth(p: number?, value: number?)
	local v = value or 1

	if not p then
		return WidgetListBreakPointEnum.Default
	end

	if p <= WidgetListBreakPointThresholds.XSmall * v then
		return WidgetListBreakPointEnum.XSmall
	end

	if p <= WidgetListBreakPointThresholds.Small * v then
		return WidgetListBreakPointEnum.Small
	end

	if p <= WidgetListBreakPointThresholds.Medium * v then
		return WidgetListBreakPointEnum.Medium
	end

	if p <= WidgetListBreakPointThresholds.Large * v then
		return WidgetListBreakPointEnum.Large
	end

	if p <= WidgetListBreakPointThresholds.XLarge * v then
		return WidgetListBreakPointEnum.XLarge
	end

	return WidgetListBreakPointEnum.X2Large
end

return getBreakpointFromRowWidth
