local ParentParent = script.Parent.Parent
local ReactRoblox = require(ParentParent.ReactRoblox)
local ReactGlobals = require(ParentParent.ReactGlobals)
local warnOnce = require(script.Parent.warnOnce)

local function PortalComponent(p1) -- line: 23
	-- upvalues: ReactGlobals (copy), warnOnce (copy), ReactRoblox (copy)
	if ReactGlobals.__DEV__ and ReactGlobals.__COMPAT_WARNINGS__ then
		warnOnce("Roact.Portal", "Please use the createPortal API on ReactRoblox instead")
	end

	return ReactRoblox.createPortal(p1.children, p1.target)
end

return PortalComponent
