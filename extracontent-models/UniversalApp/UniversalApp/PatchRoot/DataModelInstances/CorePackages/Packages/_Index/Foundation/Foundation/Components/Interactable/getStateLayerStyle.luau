local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Providers.Style.Tokens)
require(Foundation.Components.Types)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)

local StateLayerMode = require(Foundation.Enums.StateLayerMode)

local ControlState = require(Foundation.Enums.ControlState)

function guiStateToStateLayer(p): string
	if not (p ~= ControlState.Pressed and p ~= ControlState.SelectedPressed) then
		return "Press"
	end

	return if p == ControlState.Hover then "Hover" else "Idle"
end

function stateLayerModeToTokenNamespace(p)
	if p == StateLayerMode.Default then
		return ColorNamespace.Color
	end

	if p == StateLayerMode.Inverse then
		return ColorNamespace.Inverse
	end

	if p == StateLayerMode.Light then
		return ColorNamespace.LightMode
	end

	if p == StateLayerMode.Dark then
		return ColorNamespace.DarkMode
	end

	return ColorNamespace.Color
end

local function getStateLayerStyle(p, p2, p3)
	local v = stateLayerModeToTokenNamespace(p2)
	local v2 = guiStateToStateLayer(p3)

	return p[v].State[v2]
end

return getStateLayerStyle
