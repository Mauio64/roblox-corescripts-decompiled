local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local OverlayFocusHandler = require(Modules.AvatarExperience.Common.Components.OverlayFocusHandler)

return function(p1) -- line: 15
	-- upvalues: Roact (copy), OverlayFocusHandler (copy)
	return function(p2) -- line: 16
		-- upvalues: Roact (copy), OverlayFocusHandler (copy), p1 (copy)
		return Roact.createElement(OverlayFocusHandler, {
			overlayComponent = p1,
			arguments = p2
		})
	end
end
