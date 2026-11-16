local Drawer = script:FindFirstAncestor("Drawer")
local CoreGui = game:GetService("CoreGui")
local parent = Drawer.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Drawer2 = require(script.Parent.Drawer)
require(script.Parent.Parent.Types)

local SharedFlags = require(parent.SharedFlags)
local FFlagFixOverlayTopInsetForDeviceSafeInsets = SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets

return React.memo(function(p)
	local createPortal = ReactRoblox.createPortal
	local createElement = React.createElement
	local v = {
		ClipToDeviceSafeArea = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = p.displayOrder,
		IgnoreGuiInset = true,
		ScreenInsets = 0
	}
	local screenInsets

	if FFlagFixOverlayTopInsetForDeviceSafeInsets and p.deviceSafeInsets then
		screenInsets = Enum.ScreenInsets.DeviceSafeInsets
	else
		screenInsets = Enum.ScreenInsets.None
	end

	v.ScreenInsets = screenInsets
	return createPortal({
		Drawer = createElement("ScreenGui", v, {
			DrawerContent = React.createElement(Drawer2, p)
		})
	}, CoreGui)
end)
