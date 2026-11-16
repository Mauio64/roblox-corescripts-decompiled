local parent = script.Parent.Parent
local ReactRoblox = require(parent.ReactRoblox)
local ReactGlobals = require(parent.ReactGlobals)

local warnOnce = require(script.Parent.warnOnce)

local function PortalComponent(p)
	if ReactGlobals.__DEV__ and ReactGlobals.__COMPAT_WARNINGS__ then
		warnOnce("Roact.Portal", "Please use the createPortal API on ReactRoblox instead")
	end

	return ReactRoblox.createPortal(p.children, p.target)
end

return PortalComponent
