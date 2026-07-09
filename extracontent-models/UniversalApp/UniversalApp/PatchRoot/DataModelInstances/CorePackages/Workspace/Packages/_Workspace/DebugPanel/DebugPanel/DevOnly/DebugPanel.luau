local Parent = script:FindFirstAncestor("DebugPanel").Parent
local React = require(Parent.React)
local useSignalState = require(Parent.SignalsReact).useSignalState
local scriptParent = script.Parent
local DebugPanelWindow = require(scriptParent.DebugPanelWindow)
local DebugPanelTree = require(scriptParent.DebugPanelTree)
local DebugPanelSectionRegistry = require(scriptParent.DebugPanelSectionRegistry)

local function DebugPanel() -- line: 27
	-- upvalues: useSignalState (copy), DebugPanelSectionRegistry (copy), React (copy), DebugPanelWindow (copy), DebugPanelTree (copy)
	local v9 = useSignalState(DebugPanelSectionRegistry.getRootSignal)

	if next(v9.children) == nil then
		return nil
	end

	return React.createElement(DebugPanelWindow, {
		title = "Dev Debug Panel",
		screenGuiName = "DevDebugPanel"
	}, {
		Tree = React.createElement(DebugPanelTree, {
			depth = 0,
			node = v9
		})
	})
end

return DebugPanel
