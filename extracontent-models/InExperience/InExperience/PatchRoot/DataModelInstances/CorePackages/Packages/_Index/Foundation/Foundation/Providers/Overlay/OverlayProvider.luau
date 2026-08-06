local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)
local getMainGui = require(Foundation.Utility.getMainGui)
local withDefaults = require(Foundation.Utility.withDefaults)
local useStyleSheet = require(Foundation.Providers.Style.StyleSheetContext).useStyleSheet

require(Foundation.Components.Types)

local OverlayContext = require(script.Parent.OverlayContext)
local useKeyboardAwareSize = require(script.Parent.useKeyboardAwareSize)
local React = require(FoundationParent.React)
local ReactRoblox = require(FoundationParent.ReactRoblox)
local t1 = {
	DisplayOrder = Constants.MAX_LAYOUT_ORDER - 1
}
local v13 = if not Flags.FoundationOverlayResilientMainGui then getMainGui() else nil

local function OverlayProvider(p1) -- line: 30
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), Flags (copy), useKeyboardAwareSize (copy), useStyleSheet (copy), getMainGui (copy), v13 (copy), OverlayContext (copy), ReactRoblox (copy)
	local v16 = withDefaults(p1, t1)
	local v17, v18 = React.useState(v16.gui)
	local v19, v20 = React.useState(false)
	local v21 = if not Flags.FoundationOverlayKeyboardAwarenessHardened or v16.gui then nil else v17 and v17.Parent
	local v22 = if not Flags.FoundationOverlayKeyboardAwareness then nil else useKeyboardAwareSize(if not Flags.FoundationOverlayKeyboardAwarenessHardened then v17 else v21)
	local v23 = useStyleSheet()
	local v24 = React.useCallback(function() -- line: 42
		-- upvalues: v16 (copy), v20 (copy)
		if v16.gui == nil then
			v20(true)
		end
	end, { v16.gui })
	local v25 = if not Flags.FoundationOverlayResilientMainGui then v13 else if v16.gui ~= nil or not v19 then nil else getMainGui()
	local v26 = v16.gui == nil and (v25 ~= nil and v19)
	local v27 = if v16.gui == nil then v17 else v16.gui
	local v28 = nil

	if Flags.FoundationOverlayKeyboardAwarenessHardened then
		v28 = if v16.gui == nil then v21 else v16.gui
	end

	return React.createElement(OverlayContext.Provider, {
		value = {
			requestOverlay = v24,
			instance = v27,
			screen = v28
		}
	}, {
		FoundationOverlay = if not v26 then nil else ReactRoblox.createPortal(React.createElement("ScreenGui", {
			Enabled = true,
			ClipToDeviceSafeArea = false,
			DisplayOrder = v16.DisplayOrder,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
			SafeAreaCompatibility = Enum.SafeAreaCompatibility.None,
			ref = if Flags.FoundationOverlayKeyboardAwareness then nil else v18
		}, {
			SafeAreaFrame = if not Flags.FoundationOverlayKeyboardAwareness then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = v22,
				ref = v18
			}),
			FoundationStyleLink = React.createElement("StyleLink", {
				StyleSheet = v23
			})
		}), v25),
		Children = React.createElement(React.Fragment, nil, v16.children)
	})
end

return OverlayProvider
