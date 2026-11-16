local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)
local ReactUtils = require(parent3.ReactUtils)
local ContextStack = ReactUtils.ContextStack
local Flags = require(parent2.Utility.Flags)

local Cursor = require(parent.Cursor)
local Overlay = require(parent.Overlay)
local PanelsProvider = require(parent.StudioPanels.PanelsProvider)
local PluginProvider = require(parent.Plugin.PluginProvider)
local PreferencesProvider = require(parent.Preferences.PreferencesProvider)
require(parent.Responsive.ResponsiveContext)
local ResponsiveProvider = require(parent.Responsive.ResponsiveProvider)
local StyleProvider = require(parent.Style.StyleProvider)
require(parent2.Components.Types)
local WidgetsProvider = require(parent.StudioWidgets.WidgetsProvider)
local ElevationProvider = require(parent.Elevation.ElevationProvider)
local elevationProvider = ElevationProvider.ElevationProvider
local isPluginElevated = require(parent.Plugin.isPluginElevated)

local frozen = table.freeze({})

local function FoundationProvider(props)
	local v

	if props.preferences then
		v = props.preferences
	else
		v = not Flags.FoundationProviderStableEmptyTable and {} or frozen
	end

	local config

	if props.responsiveConfig then
		config = props.responsiveConfig
	else
		config = not Flags.FoundationProviderStableEmptyTable and {} or frozen
	end

	local element = React.createElement(PluginProvider, { plugin = props.plugin })

	local element2 = React.createElement(elevationProvider, nil)
	local element3 = React.createElement(PreferencesProvider, v)
	local element4 = React.createElement(StyleProvider, {
		themeName = props.themeName,
		colorMode = props.colorMode,
		theme = props.theme,
		device = props.device,
		derives = props.derives,
		scale = v.scale,
		tokenOverrides = props.tokenOverrides
	})

	local element5 = React.createElement(ResponsiveProvider, { config = config })
	local createElement = React.createElement
	local v2

	if typeof(props.overlayGui) == "table" then
		v2 = { DisplayOrder = props.overlayGui.DisplayOrder }
	else
		v2 = { gui = props.overlayGui }
	end

	local providers = {
		element,
		element2,
		element3,
		element4,
		element5,
		createElement(Overlay, v2),
		React.createElement(Cursor)
	}

	if props.plugin and isPluginElevated(props.plugin) then
		table.insert(providers, React.createElement(WidgetsProvider, {}))
		table.insert(providers, React.createElement(PanelsProvider, {}))
	end

	return React.createElement(ContextStack, { providers = providers }, props.children)
end

return FoundationProvider
