local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/SharedFlags").FFlagEnableSplitPane

local module = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/CompositionTags")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/useCompositionLayout")

local v5 = if fFlagEnableSplitPane then require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/CompositionConfig") else nil
local v6 = if fFlagEnableSplitPane then require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/resolveBreakpoint") else nil

local module3 = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/setupCompositionStyleRules")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/CompositionStyleSheet")

require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/AppCompositionTypes")
local AppCompositionEnums = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/AppCompositionEnums")

local v8 = if fFlagEnableSplitPane then v5.getRegionOverrides else nil
local v9 = if fFlagEnableSplitPane then AppCompositionEnums.RegionName else nil
return {
	CompositionTags = module,
	useCompositionLayout = module2,
	resolveBreakpoint = v6,
	getRegionOverrides = v8,
	RegionName = v9,
	CompositionStyleSheet = module4,
	setupCompositionStyleRules = module3
}
