local breakpoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Foundation").Enums.Breakpoint

require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/AppCompositionTypes")
local AppCompositionEnums = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/AppCompositionEnums")

local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/SharedFlags").FFlagEnableSplitPane

local regionName = AppCompositionEnums.RegionName

local function getRegionOverrides(p2)
	if p2 == regionName.SupportRegion then
		return { widthScale = 0.33, minWidth = 355 }
	end

	return nil
end

local function getBaseConfig(p2, data)
	if p2 == breakpoint.XSmall then
		local size_300 = data.Size.Size_300
		return {
			margin = size_300,
			gutter = data.Gutter.Small,
			columns = 3,
			carouselPeek = 2 * size_300
		}
	end

	if p2 == breakpoint.Small then
		local small = data.Margin.Small
		return {
			margin = small,
			gutter = data.Gutter.Medium,
			columns = 6,
			carouselPeek = 2 * small
		}
	end

	if not (p2 ~= breakpoint.Medium and p2 ~= breakpoint.Large) then
		return {
			margin = data.Size.Size_800,
			gutter = data.Gutter.Large,
			columns = 12,
			carouselPeek = 0
		}
	end

	if p2 == breakpoint.XLarge then
	end

	return {
		margin = data.Size.Size_1600,
		gutter = data.Gutter.XLarge,
		columns = 12,
		carouselPeek = 0
	}
end

local function resolveLayout(p2, p3)
	return getBaseConfig(p2, p3)
end

local function getRegionLayout(p2, p3, p4)
	local baseConfig = getBaseConfig(p3, p4)
	local v5 = p2 == regionName.SupportRegion and { widthScale = 0.33, minWidth = 355 } or nil

	if not v5 then
		return baseConfig
	end

	baseConfig.width = v5.width
	baseConfig.widthScale = v5.widthScale
	baseConfig.minWidth = v5.minWidth
	baseConfig.maxWidth = v5.maxWidth

	return baseConfig
end

local v5 = {
	getBaseConfig = getBaseConfig,
	resolveLayout = nil,
	getRegionOverrides = nil,
	getRegionLayout = nil
}

if not fFlagEnableSplitPane then
	resolveLayout = nil
end

v5.resolveLayout = resolveLayout

if not fFlagEnableSplitPane then
	getRegionOverrides = nil
end

v5.getRegionOverrides = getRegionOverrides

if not fFlagEnableSplitPane then
	getRegionLayout = nil
end

v5.getRegionLayout = getRegionLayout
return v5
