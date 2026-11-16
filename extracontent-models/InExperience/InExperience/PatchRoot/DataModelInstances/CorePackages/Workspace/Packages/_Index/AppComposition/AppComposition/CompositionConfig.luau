local AppComposition = script:FindFirstAncestor("AppComposition")
local parent = AppComposition.Parent

local Foundation = require(parent.Foundation)
local Breakpoint = Foundation.Enums.Breakpoint

require(AppComposition.AppCompositionTypes)
local AppCompositionEnums = require(AppComposition.AppCompositionEnums)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane

local RegionName = AppCompositionEnums.RegionName

local function getRegionOverrides(p)
	if p == RegionName.SupportRegion then
		return { widthScale = 0.33, minWidth = 355 }
	end

	return nil
end

local function getBaseConfig(p, data)
	if p == Breakpoint.XSmall then
		local size_300 = data.Size.Size_300
		return {
			margin = size_300,
			gutter = data.Gutter.Small,
			columns = 3,
			carouselPeek = 2 * size_300
		}
	end

	if p == Breakpoint.Small then
		local small = data.Margin.Small
		return {
			margin = small,
			gutter = data.Gutter.Medium,
			columns = 6,
			carouselPeek = 2 * small
		}
	end

	if not (p ~= Breakpoint.Medium and p ~= Breakpoint.Large) then
		return {
			margin = data.Size.Size_800,
			gutter = data.Gutter.Large,
			columns = 12,
			carouselPeek = 0
		}
	end

	if p == Breakpoint.XLarge then
	end

	return {
		margin = data.Size.Size_1600,
		gutter = data.Gutter.XLarge,
		columns = 12,
		carouselPeek = 0
	}
end

local function resolveLayout(p, p2)
	return getBaseConfig(p, p2)
end

local function getRegionLayout(p, p2, p3)
	local baseConfig = getBaseConfig(p2, p3)
	local v = p == RegionName.SupportRegion and { widthScale = 0.33, minWidth = 355 } or nil

	if not v then
		return baseConfig
	end

	baseConfig.width = v.width
	baseConfig.widthScale = v.widthScale
	baseConfig.minWidth = v.minWidth
	baseConfig.maxWidth = v.maxWidth

	return baseConfig
end

local CompositionConfig = {
	getBaseConfig = getBaseConfig,
	resolveLayout = nil,
	getRegionOverrides = nil,
	getRegionLayout = nil
}

if not FFlagEnableSplitPane then
	resolveLayout = nil
end

CompositionConfig.resolveLayout = resolveLayout

if not FFlagEnableSplitPane then
	getRegionOverrides = nil
end

CompositionConfig.getRegionOverrides = getRegionOverrides

if not FFlagEnableSplitPane then
	getRegionLayout = nil
end

CompositionConfig.getRegionLayout = getRegionLayout
return CompositionConfig
