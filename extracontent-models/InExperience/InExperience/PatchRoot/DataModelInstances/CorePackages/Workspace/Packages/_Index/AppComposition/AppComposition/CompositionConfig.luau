local AppComposition = script:FindFirstAncestor("AppComposition")
local AppCompositionParent = AppComposition.Parent
local Breakpoint = require(AppCompositionParent.Foundation).Enums.Breakpoint
local HardwareSafeAreaInsets = require(AppCompositionParent.Responsive).HardwareSafeAreaInsets

require(AppComposition.AppCompositionTypes)

local AppCompositionEnums = require(AppComposition.AppCompositionEnums)
local SharedFlags = require(AppCompositionParent.SharedFlags)
local FFlagEnableLeftNavOnConsole = SharedFlags.FFlagEnableLeftNavOnConsole
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local RegionName = AppCompositionEnums.RegionName

local function getRegionOverrides(p1) -- line: 27
	-- upvalues: RegionName (copy)
	if p1 == RegionName.SupportRegion then
		return {
			widthScale = 0.33
		}
	end

	return nil
end
local function getBaseConfig(p2, p3) -- line: 36
	-- upvalues: Breakpoint (copy), FFlagEnableLeftNavOnConsole (copy), HardwareSafeAreaInsets (copy)
	local t1

	if p2 == Breakpoint.XSmall then
		local Size_300 = p3.Size.Size_300
		local Small = p3.Gutter.Small
		local v19 = 2 * Size_300

		t1 = {
			columns = 3,
			margin = Size_300,
			gutter = Small,
			carouselPeek = v19
		}
	elseif p2 == Breakpoint.Small then
		local Small = p3.Margin.Small
		local Medium = p3.Gutter.Medium
		local v23 = 2 * Small

		t1 = {
			columns = 6,
			margin = Small,
			gutter = Medium,
			carouselPeek = v23
		}
	else
		t1 = if p2 ~= Breakpoint.Medium then if p2 ~= Breakpoint.Large then if p2 ~= Breakpoint.XLarge then {
			columns = 12,
			carouselPeek = 0,
			margin = p3.Size.Size_1600,
			gutter = p3.Gutter.XLarge
		} else {
			columns = 12,
			carouselPeek = 0,
			margin = p3.Size.Size_1600,
			gutter = p3.Gutter.XLarge
		} else {
			columns = 12,
			carouselPeek = 0,
			margin = p3.Size.Size_800,
			gutter = p3.Gutter.Large
		} else {
			columns = 12,
			carouselPeek = 0,
			margin = p3.Size.Size_800,
			gutter = p3.Gutter.Large
		}
	end

	if not FFlagEnableLeftNavOnConsole and HardwareSafeAreaInsets.hasExtraPlatformInset() then
		t1.margin = HardwareSafeAreaInsets.deviceInsets().left
	end

	return t1
end
local function resolveLayout(p4, p5) -- line: 95
	-- upvalues: getBaseConfig (copy)
	return (getBaseConfig(p4, p5))
end
local function getRegionLayout(p6, p7, p8) -- line: 99
	-- upvalues: getBaseConfig (copy), RegionName (copy)
	local v29 = getBaseConfig(p7, p8)
	local v30 = if p6 ~= RegionName.SupportRegion then nil else {
		widthScale = 0.33
	}

	if v30 then
		v29.width = v30.width
		v29.widthScale = v30.widthScale
		v29.minWidth = v30.minWidth
		v29.maxWidth = v30.maxWidth
	end

	return v29
end

return {
	getBaseConfig = getBaseConfig,
	resolveLayout = if not FFlagEnableSplitPane then nil else resolveLayout,
	getRegionOverrides = if not FFlagEnableSplitPane then nil else getRegionOverrides,
	getRegionLayout = if not FFlagEnableSplitPane then nil else getRegionLayout
}
