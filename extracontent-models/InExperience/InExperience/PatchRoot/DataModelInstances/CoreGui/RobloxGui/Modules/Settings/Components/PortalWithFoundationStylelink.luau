local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local View = Foundation.View
local useStyleSheet = Foundation.Hooks.useStyleSheet

local function PortalWithFoundationStylelink(t1: {[any]: any}) -- line: 16
	-- upvalues: useStyleSheet (copy), Cryo (copy), React (copy), ReactRoblox (copy), View (copy)
	local v10 = useStyleSheet()
	local v11 = Cryo.Dictionary.join({
		StyleLink = React.createElement("StyleLink", {
			StyleSheet = v10
		})
	}, t1.children)

	return ReactRoblox.createPortal(React.createElement(View, {
		tag = "auto-xy"
	}, v11), t1.parent)
end

return PortalWithFoundationStylelink
