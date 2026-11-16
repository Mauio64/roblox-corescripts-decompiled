local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local v5 = { overlayType = nil, overlayProps = {} }

local function createOverlayStore()
	local signal, v6 = Signals.createSignal(table.clone(v5))
	local signal2, v7 = Signals.createSignal({})

	return {
		getCurrentOverlay = signal,
		showOverlay = function(p2, p3)
			v6({ overlayType = p2, overlayProps = p3 })
		end,
		dismissOverlay = function()
			v6(table.clone(v5))
		end,
		getOverlayDefaultProps = signal2,
		setOverlayDefaultProps = v7
	}
end

return createOverlayStore
