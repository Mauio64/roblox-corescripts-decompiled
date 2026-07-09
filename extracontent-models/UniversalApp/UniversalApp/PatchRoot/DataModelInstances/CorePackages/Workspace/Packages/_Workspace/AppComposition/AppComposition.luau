local scriptParent = script.Parent
local FFlagEnableSplitPane = require(scriptParent.SharedFlags).FFlagEnableSplitPane
local CompositionTags = require(script.CompositionTags)
local useCompositionLayout = require(script.useCompositionLayout)
local v5 = if not FFlagEnableSplitPane then nil else require(script.CompositionConfig)
local v6 = if not FFlagEnableSplitPane then nil else require(script.resolveBreakpoint)
local setupCompositionStyleRules = require(script.setupCompositionStyleRules)
local CompositionStyleSheet = require(script.CompositionStyleSheet)

require(script.AppCompositionTypes)

local AppCompositionEnums = require(script.AppCompositionEnums)

return {
	CompositionTags = CompositionTags,
	useCompositionLayout = useCompositionLayout,
	resolveBreakpoint = v6,
	getRegionOverrides = if not FFlagEnableSplitPane then nil else v5.getRegionOverrides,
	RegionName = if not FFlagEnableSplitPane then nil else AppCompositionEnums.RegionName,
	CompositionStyleSheet = CompositionStyleSheet,
	setupCompositionStyleRules = setupCompositionStyleRules,
	["jest.config"] = script["jest.config"]
}
