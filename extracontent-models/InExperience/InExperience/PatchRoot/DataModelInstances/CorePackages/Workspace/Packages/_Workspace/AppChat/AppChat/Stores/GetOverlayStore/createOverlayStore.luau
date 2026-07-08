local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)
local t1 = {
	overlayType = nil,
	overlayProps = {}
}

local function createOverlayStore() -- line: 32
	-- upvalues: Signals (copy), t1 (copy)
	local v5, v6 = Signals.createSignal(table.clone(t1))
	local v7, v8 = Signals.createSignal({})

	return {
		getCurrentOverlay = v5,
		showOverlay = function(s1: string, p1) -- line: 38
			-- upvalues: v6 (copy)
			v6({
				overlayType = s1,
				overlayProps = p1
			})
		end,
		dismissOverlay = function() -- line: 44
			-- upvalues: v6 (copy), t1 (copy)
			v6(table.clone(t1))
		end,
		getOverlayDefaultProps = v7,
		setOverlayDefaultProps = v8
	}
end

return createOverlayStore
