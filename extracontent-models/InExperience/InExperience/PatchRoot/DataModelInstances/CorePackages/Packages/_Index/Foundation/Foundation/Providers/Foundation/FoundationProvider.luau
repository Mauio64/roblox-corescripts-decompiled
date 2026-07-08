local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local React = require(ParentParentParentParent.React)
local ContextStack = require(ParentParentParentParent.ReactUtils).ContextStack
local Cursor = require(ParentParent.Cursor)
local Overlay = require(ParentParent.Overlay)
local PanelsProvider = require(ParentParent.StudioPanels.PanelsProvider)
local PluginProvider = require(ParentParent.Plugin.PluginProvider)
local PreferencesProvider = require(ParentParent.Preferences.PreferencesProvider)

require(ParentParent.Responsive.ResponsiveContext)

local ResponsiveProvider = require(ParentParent.Responsive.ResponsiveProvider)
local StyleProvider = require(ParentParent.Style.StyleProvider)

require(ParentParentParent.Components.Types)

local WidgetsProvider = require(ParentParent.StudioWidgets.WidgetsProvider)
local ElevationProvider = require(ParentParent.Elevation.ElevationProvider).ElevationProvider
local Flags = require(ParentParentParent.Utility.Flags)
local isPluginElevated = require(ParentParent.Plugin.isPluginElevated)

local function FoundationProvider(p1) -- line: 35
	-- upvalues: React (copy), PluginProvider (copy), ElevationProvider (copy), PreferencesProvider (copy), StyleProvider (copy), ResponsiveProvider (copy), Overlay (copy), Cursor (copy), isPluginElevated (copy), Flags (copy), WidgetsProvider (copy), PanelsProvider (copy), ContextStack (copy)
	local v19 = if not p1.preferences then {} else p1.preferences
	local v20 = if not p1.responsiveConfig then {} else p1.responsiveConfig
	local t1 = {
		React.createElement(PluginProvider, {
			plugin = p1.plugin
		}),
		React.createElement(ElevationProvider, nil),
		React.createElement(PreferencesProvider, v19),
		React.createElement(StyleProvider, {
			theme = p1.theme,
			device = p1.device,
			derives = p1.derives,
			scale = v19.scale,
			tokenOverrides = p1.tokenOverrides
		}),
		React.createElement(ResponsiveProvider, {
			config = v20
		}),
		React.createElement(Overlay, if typeof(p1.overlayGui) ~= "table" then {
			gui = p1.overlayGui
		} else {
			DisplayOrder = p1.overlayGui.DisplayOrder
		}),
		React.createElement(Cursor)
	}

	if p1.plugin and (isPluginElevated(p1.plugin) and Flags.FoundationPopoverPluginSupport) then
		table.insert(t1, React.createElement(WidgetsProvider, {}))
		table.insert(t1, React.createElement(PanelsProvider, {}))
	end

	return React.createElement(ContextStack, {
		providers = t1
	}, p1.children)
end

return FoundationProvider
