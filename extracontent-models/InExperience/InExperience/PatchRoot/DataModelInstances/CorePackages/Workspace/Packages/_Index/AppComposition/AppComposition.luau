local parent = script.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane

local CompositionTags = require(script.CompositionTags)
local useCompositionLayout = require(script.useCompositionLayout)
local CompositionConfig

if FFlagEnableSplitPane then
	CompositionConfig = require(script.CompositionConfig)
end

local resolveBreakpoint

if FFlagEnableSplitPane then
	resolveBreakpoint = require(script.resolveBreakpoint)
end

local setupCompositionStyleRules = require(script.setupCompositionStyleRules)
local CompositionStyleSheet = require(script.CompositionStyleSheet)

require(script.AppCompositionTypes)
local AppCompositionEnums = require(script.AppCompositionEnums)
local getRegionOverrides

if FFlagEnableSplitPane then
	getRegionOverrides = CompositionConfig.getRegionOverrides
end

local regionName

if FFlagEnableSplitPane then
	regionName = AppCompositionEnums.RegionName
end

return {
	CompositionTags = CompositionTags,
	useCompositionLayout = useCompositionLayout,
	resolveBreakpoint = resolveBreakpoint,
	getRegionOverrides = getRegionOverrides,
	RegionName = regionName,
	CompositionStyleSheet = CompositionStyleSheet,
	setupCompositionStyleRules = setupCompositionStyleRules,
	["jest.config"] = script["jest.config"]
}
