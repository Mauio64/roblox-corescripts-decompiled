local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local WidgetListBreakPointEnum = require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum)
local WidgetListBreakPointThresholds = require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointThresholds)

local function getBreakpointFromRowWidth(n1: number?, n2: number?) -- line: 14
	-- upvalues: WidgetListBreakPointEnum (copy), WidgetListBreakPointThresholds (copy)
	local v7 = n2 or 1

	if not n1 then
		return WidgetListBreakPointEnum.Default
	end

	if n1 <= WidgetListBreakPointThresholds.XSmall * v7 then
		return WidgetListBreakPointEnum.XSmall
	end

	if n1 <= WidgetListBreakPointThresholds.Small * v7 then
		return WidgetListBreakPointEnum.Small
	end

	if n1 <= WidgetListBreakPointThresholds.Medium * v7 then
		return WidgetListBreakPointEnum.Medium
	end

	if n1 <= WidgetListBreakPointThresholds.Large * v7 then
		return WidgetListBreakPointEnum.Large
	end

	if n1 <= WidgetListBreakPointThresholds.XLarge * v7 then
		return WidgetListBreakPointEnum.XLarge
	end

	return WidgetListBreakPointEnum.X2Large
end

return getBreakpointFromRowWidth
