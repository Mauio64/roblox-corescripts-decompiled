local parent = script:FindFirstAncestor("AppChat").Parent

local Signals = require(parent.Signals)

local v = { overlayType = nil, overlayProps = {} }

local function createOverlayStore()
	local signal, v2 = Signals.createSignal(table.clone(v))
	local signal2, setOverlayDefaultProps = Signals.createSignal({})

	return {
		getCurrentOverlay = signal,
		showOverlay = function(overlayType: string, overlayProps)
			v2({ overlayType = overlayType, overlayProps = overlayProps })
		end,
		dismissOverlay = function()
			v2(table.clone(v))
		end,
		getOverlayDefaultProps = signal2,
		setOverlayDefaultProps = setOverlayDefaultProps
	}
end

return createOverlayStore
