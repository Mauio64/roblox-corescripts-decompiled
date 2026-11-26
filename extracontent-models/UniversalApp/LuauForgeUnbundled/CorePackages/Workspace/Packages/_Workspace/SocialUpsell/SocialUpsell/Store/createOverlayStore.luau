local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Types")

local v5 = { overlayType = nil, overlayProps = {} }

return function()
	local signal, v6 = Signals.createSignal(table.clone(v5))
	return {
		getCurrentOverlay = signal,
		setCurrentOverlay = function(p2, p3)
			v6({ overlayType = p2, overlayProps = p3 })
		end,
		getCurrentOverlayType = Signals.createComputed(function(p2)
			return signal(p2).overlayType
		end),
		dismissCurrentOverlay = function()
			v6(table.clone(v5))
		end
	}
end
