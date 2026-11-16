local SocialUpsell = script:FindFirstAncestor("SocialUpsell")

local parent = SocialUpsell.Parent

local Signals = require(parent.Signals)

require(SocialUpsell.Types)

local v = { overlayType = nil, overlayProps = {} }

return function()
	local signal, v2 = Signals.createSignal(table.clone(v))
	return {
		getCurrentOverlay = signal,
		setCurrentOverlay = function(overlayType, overlayProps)
			v2({ overlayType = overlayType, overlayProps = overlayProps })
		end,
		getCurrentOverlayType = Signals.createComputed(function(p)
			return signal(p).overlayType
		end),
		dismissCurrentOverlay = function()
			v2(table.clone(v))
		end
	}
end
