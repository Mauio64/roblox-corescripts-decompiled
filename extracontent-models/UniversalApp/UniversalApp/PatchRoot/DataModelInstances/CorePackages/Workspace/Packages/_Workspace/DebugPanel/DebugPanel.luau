local function NoopComponent() -- line: 21
	return nil
end
local function v2() -- line: 25
end
local function noopRegisterSection(_) -- line: 26
	-- upvalues: v2 (copy)
	return v2
end
local function noopRegisterSections(_) -- line: 29
	-- upvalues: v2 (copy)
	return v2
end
local function noopGetRootSignal() -- line: 34
	return {
		title = "root",
		leafId = nil,
		component = nil,
		order = 0,
		defaultCollapsed = nil,
		children = {}
	}
end

if script:FindFirstChild("DevOnly") == nil then
	return {
		["jest.config"] = script:FindFirstChild("jest.config"),
		DebugPanel = NoopComponent,
		registerSection = noopRegisterSection,
		registerSections = noopRegisterSections,
		getRootSignal = noopGetRootSignal,
		DebugPanelWindow = NoopComponent,
		DebugPanelSection = NoopComponent
	}
end

local DevOnly = script.DevOnly
local DebugPanelSectionRegistry = require(DevOnly.DebugPanelSectionRegistry)

return {
	["jest.config"] = script:FindFirstChild("jest.config"),
	DebugPanel = require(DevOnly.DebugPanel),
	registerSection = DebugPanelSectionRegistry.registerSection,
	registerSections = DebugPanelSectionRegistry.registerSections,
	getRootSignal = DebugPanelSectionRegistry.getRootSignal,
	DebugPanelWindow = require(DevOnly.DebugPanelWindow),
	DebugPanelSection = require(DevOnly.DebugPanelSection)
}
