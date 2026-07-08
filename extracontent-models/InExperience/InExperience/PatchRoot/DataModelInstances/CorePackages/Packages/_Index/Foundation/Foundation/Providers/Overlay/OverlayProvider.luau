local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Constants = require(Foundation.Constants)
local Wrappers = require(Foundation.Utility.Wrappers)
local CoreGui = Wrappers.Services.CoreGui
local RunService = Wrappers.Services.RunService
local Players = Wrappers.Services.Players
local Flags = require(Foundation.Utility.Flags)
local v9 = nil

if not Flags.FoundationUseMainGuiUtility then
	v9 = if not Players.LocalPlayer or not RunService:IsRunning() then nil else Players.LocalPlayer:WaitForChild("PlayerGui", 3)
end

local getMainGui = require(Foundation.Utility.getMainGui)
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)
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
local v19 = if not Flags.FoundationUseMainGuiUtility then if not isPluginSecurity() then v9 else CoreGui else getMainGui()

local function OverlayProvider(p1) -- line: 45
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), Flags (copy), useKeyboardAwareSize (copy), useStyleSheet (copy), v19 (copy), OverlayContext (copy), ReactRoblox (copy)
	local v22 = withDefaults(p1, t1)
	local v23, v24 = React.useState(v22.gui)
	local v25, v26 = React.useState(false)
	local v27 = if not Flags.FoundationOverlayKeyboardAwarenessHardened or v22.gui then nil else v23 and v23.Parent
	local v28 = if not Flags.FoundationOverlayKeyboardAwareness then nil else useKeyboardAwareSize(if not Flags.FoundationOverlayKeyboardAwarenessHardened then v23 else v27)
	local v29 = useStyleSheet()
	local v30 = React.useCallback(function() -- line: 57
		-- upvalues: v22 (copy), v26 (copy)
		if v22.gui == nil then
			v26(true)
		end
	end, { v22.gui })
	local v31 = v22.gui == nil and (v19 ~= nil and v25)
	local v32 = if v22.gui == nil then v23 else v22.gui
	local v33 = nil

	if Flags.FoundationOverlayKeyboardAwarenessHardened then
		v33 = if v22.gui == nil then v27 else v22.gui
	end

	return React.createElement(OverlayContext.Provider, {
		value = {
			requestOverlay = v30,
			instance = v32,
			screen = v33
		}
	}, {
		FoundationOverlay = if not v31 then nil else ReactRoblox.createPortal(React.createElement("ScreenGui", {
			Enabled = true,
			ClipToDeviceSafeArea = false,
			DisplayOrder = v22.DisplayOrder,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
			SafeAreaCompatibility = Enum.SafeAreaCompatibility.None,
			ref = if Flags.FoundationOverlayKeyboardAwareness then nil else v24
		}, {
			SafeAreaFrame = if not Flags.FoundationOverlayKeyboardAwareness then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = v28,
				ref = v24
			}),
			FoundationStyleLink = React.createElement("StyleLink", {
				StyleSheet = v29
			})
		}), v19),
		Children = React.createElement(React.Fragment, nil, v22.children)
	})
end

return OverlayProvider
