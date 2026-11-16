local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/ReactRoblox")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Components/Drawer")
require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Types")

local fFlagFixOverlayTopInsetForDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/SharedFlags").FFlagFixOverlayTopInsetForDeviceSafeInsets

return React.memo(function(p2)
	local createPortal = ReactRoblox.createPortal
	local createElement = React.createElement
	local v7 = {
		ClipToDeviceSafeArea = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = p2.displayOrder,
		IgnoreGuiInset = true,
		ScreenInsets = 0
	}

	local v8 = if fFlagFixOverlayTopInsetForDeviceSafeInsets and p2.deviceSafeInsets then Enum.ScreenInsets.DeviceSafeInsets else Enum.ScreenInsets.None
	v7.ScreenInsets = v8
	return createPortal({
		Drawer = createElement("ScreenGui", v7, {
			DrawerContent = React.createElement(module3, p2)
		})
	}, CoreGui)
end)
