local Drawer = script:FindFirstAncestor("Drawer")
local CoreGui = game:GetService("CoreGui")
local DrawerParent = Drawer.Parent
local React = require(DrawerParent.React)
local ReactRoblox = require(DrawerParent.ReactRoblox)
local Drawer2 = require(script.Parent.Drawer)

require(script.Parent.Parent.Types)

return React.memo(function(p1) -- line: 9
	-- upvalues: ReactRoblox (copy), React (copy), Drawer2 (copy), CoreGui (copy)
	return ReactRoblox.createPortal({
		Drawer = React.createElement("ScreenGui", {
			ClipToDeviceSafeArea = false,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = p1.displayOrder,
			ScreenInsets = Enum.ScreenInsets.None
		}, {
			DrawerContent = React.createElement(Drawer2, p1)
		})
	}, CoreGui)
end)
