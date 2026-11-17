local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)

local getMainGui = require(Foundation.Utility.getMainGui)
local withDefaults = require(Foundation.Utility.withDefaults)
local StyleSheetContext = require(Foundation.Providers.Style.StyleSheetContext)
local useStyleSheet = StyleSheetContext.useStyleSheet
require(Foundation.Components.Types)

local OverlayContext = require(script.Parent.OverlayContext)
local ViewportBreakpointContext = require(script.Parent.ViewportBreakpointContext)
local useKeyboardAwareSize = require(script.Parent.useKeyboardAwareSize)
local useSharedViewportBreakpoint = require(script.Parent.useSharedViewportBreakpoint)

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local v = {
	DisplayOrder = Constants.MAX_LAYOUT_ORDER - 1
}

local function OverlayProvider(p)
	local v2 = withDefaults(p, v)
	local state, setState = React.useState(v2.gui)
	local state2, setState2 = React.useState(false)
	local screen

	if v2.gui then
		screen = nil
	else
		screen = state and state.Parent
	end

	local size = useKeyboardAwareSize(screen)
	local styleSheet = useStyleSheet()

	local requestOverlay = React.useCallback(function()
		if v2.gui == nil then
			setState2(true)
		end
	end, { v2.gui })
	local v3

	if v2.gui == nil and state2 then
		v3 = getMainGui()
	end

	if v2.gui == nil then
		if v3 == nil then
			state2 = false
		end
	else
		state2 = false
	end

	if v2.gui ~= nil then
		state = v2.gui
	end

	if v2.gui ~= nil then
		screen = v2.gui
	end

	local v4

	if Flags.FoundationSharedViewportBreakpoint then
		v4 = useSharedViewportBreakpoint(screen)
	end

	local v5 = React.useMemo(function()
		return { requestOverlay = requestOverlay, instance = state, screen = screen }
	end, { requestOverlay, state, screen })

	local createElement = React.createElement
	local provider = OverlayContext.Provider
	local foundationOverlay

	if state2 then
		foundationOverlay = ReactRoblox.createPortal(React.createElement("ScreenGui", {
			Enabled = true,
			DisplayOrder = v2.DisplayOrder,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
			SafeAreaCompatibility = Enum.SafeAreaCompatibility.None,
			ClipToDeviceSafeArea = false
		}, {
			SafeAreaFrame = React.createElement("Frame", {
				Size = size,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ref = setState
			}),
			FoundationStyleLink = React.createElement("StyleLink", { StyleSheet = styleSheet })
		}), v3)
	end

	local children

	if Flags.FoundationSharedViewportBreakpoint then
		children = React.createElement(ViewportBreakpointContext.Provider, { value = v4 }, v2.children)
	else
		children = React.createElement(React.Fragment, nil, v2.children)
	end

	return createElement(provider, { value = v5 }, {
		FoundationOverlay = foundationOverlay,
		Children = children
	})
end

return OverlayProvider
