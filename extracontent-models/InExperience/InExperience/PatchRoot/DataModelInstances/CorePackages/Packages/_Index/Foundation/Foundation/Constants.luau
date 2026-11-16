local Foundation = script:FindFirstAncestor("Foundation")
local ColorNamespace = require(Foundation.Enums.ColorNamespace)
require(Foundation.Components.Types)

local StateLayerMode = require(Foundation.Enums.StateLayerMode)

local InputPlacement = require(Foundation.Enums.InputPlacement)

local v = {
	[InputPlacement.Start] = Enum.HorizontalAlignment.Right,
	[InputPlacement.End] = Enum.HorizontalAlignment.Left
}

local v2 = {
	[false] = {
		[ColorNamespace.Color] = StateLayerMode.Default,
		[ColorNamespace.Inverse] = StateLayerMode.Inverse,
		[ColorNamespace.LightMode] = StateLayerMode.Light,
		[ColorNamespace.DarkMode] = StateLayerMode.Dark
	},
	[true] = {
		[ColorNamespace.Color] = StateLayerMode.Inverse,
		[ColorNamespace.Inverse] = StateLayerMode.Default,
		[ColorNamespace.LightMode] = StateLayerMode.Dark,
		[ColorNamespace.DarkMode] = StateLayerMode.Light
	}
}

return {
	MAX_LAYOUT_ORDER = 2147483648,
	MIN_LAYOUT_ORDER = -2147483648,
	DISABLED_TRANSPARENCY = 0.5,
	DEFAULT_DELAY_TIME = 0.15,
	DEFAULT_INPUT_FIELD_WIDTH_PIXELS = 400,
	DEFAULT_NUMBER_INPUT_WIDTH = 300,
	TOOLTIP_MAX_WIDTH = 280,
	SHADOW_IMAGE = "component_assets/dropshadow_17_8",
	SHADOW_SIZE = 16,
	PLUGIN_SHADOW_SIZE = 4,
	MODAL = {
		DISABLE_SELECTION = { Selectable = false },
		TRAP_FOCUS = {
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		}
	},
	COLOR_NAMESPACE_TO_STATE_LAYER_MODE = v2,
	INPUT_PLACEMENT_TO_LABEL_ALIGNMENT = v,
	BUILDER_SANS_FONT_ASSET = "rbxasset://fonts/families/BuilderSans.json"
}
