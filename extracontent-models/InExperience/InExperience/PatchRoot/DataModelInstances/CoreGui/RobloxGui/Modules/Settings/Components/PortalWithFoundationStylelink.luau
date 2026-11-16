local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)

local View = Foundation.View
local useStyleSheet = Foundation.Hooks.useStyleSheet

local function PortalWithFoundationStylelink(p)
	local styleSheet = useStyleSheet()
	local joined = Cryo.Dictionary.join({
		StyleLink = React.createElement("StyleLink", { StyleSheet = styleSheet })
	}, p.children)

	return ReactRoblox.createPortal(React.createElement(View, { tag = "auto-xy" }, joined), p.parent)
end

return PortalWithFoundationStylelink
