local WidgetListBreakPointEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListBreakPointEnum")
local WidgetListBreakPointThresholds = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListBreakPointThresholds")

local function getBreakpointFromRowWidth(p2, value)
	local v5 = value or 1

	if not p2 then
		return WidgetListBreakPointEnum.Default
	end

	if p2 <= WidgetListBreakPointThresholds.XSmall * v5 then
		return WidgetListBreakPointEnum.XSmall
	end

	if p2 <= WidgetListBreakPointThresholds.Small * v5 then
		return WidgetListBreakPointEnum.Small
	end

	if p2 <= WidgetListBreakPointThresholds.Medium * v5 then
		return WidgetListBreakPointEnum.Medium
	end

	if p2 <= WidgetListBreakPointThresholds.Large * v5 then
		return WidgetListBreakPointEnum.Large
	end

	if p2 <= WidgetListBreakPointThresholds.XLarge * v5 then
		return WidgetListBreakPointEnum.XLarge
	end

	return WidgetListBreakPointEnum.X2Large
end

return getBreakpointFromRowWidth
