local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Providers.Style.Tokens)
require(Foundation.Components.Types)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local StateLayerMode = require(Foundation.Enums.StateLayerMode)
local ControlState = require(Foundation.Enums.ControlState)

function guiStateToStateLayer(p1) -- line: 15
	-- upvalues: ControlState (copy)
	if p1 == ControlState.Pressed then
		return "Press"
	end

	if p1 == ControlState.SelectedPressed then
		return "Press"
	end

	if p1 == ControlState.Hover then
		return "Hover"
	end

	return "Idle"
end
function stateLayerModeToTokenNamespace(p2) -- line: 27
	-- upvalues: StateLayerMode (copy), ColorNamespace (copy)
	if p2 == StateLayerMode.Default then
		return ColorNamespace.Color
	end

	if p2 == StateLayerMode.Inverse then
		return ColorNamespace.Inverse
	end

	if p2 == StateLayerMode.Light then
		return ColorNamespace.LightMode
	end

	if p2 == StateLayerMode.Dark then
		return ColorNamespace.DarkMode
	end

	return ColorNamespace.Color
end

local function getStateLayerStyle(p3, p4, p5) -- line: 41
	local v11 = stateLayerModeToTokenNamespace(p4)
	local v12 = guiStateToStateLayer(p5)

	return p3[v11].State[v12]
end

return getStateLayerStyle
