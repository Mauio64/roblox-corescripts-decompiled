local function NoopComponent(): nil
	return nil
end

local function fn() end
local function noopRegisterSection(p2)
	return fn
end

local function noopRegisterSections(p2)
	return fn
end

local function noopGetRootSignal()
	return {
		title = "root",
		children = {},
		leafId = nil,
		component = nil,
		order = 0,
		defaultCollapsed = nil
	}
end

return {
	DebugPanel = NoopComponent,
	registerSection = noopRegisterSection,
	registerSections = noopRegisterSections,
	getRootSignal = noopGetRootSignal,
	DebugPanelWindow = NoopComponent,
	DebugPanelSection = NoopComponent,
	AnalyticsFeed = require("@game/CorePackages/Workspace/Packages/_Index/DebugPanel/DebugPanel/AnalyticsFeedNoopShim")
}
