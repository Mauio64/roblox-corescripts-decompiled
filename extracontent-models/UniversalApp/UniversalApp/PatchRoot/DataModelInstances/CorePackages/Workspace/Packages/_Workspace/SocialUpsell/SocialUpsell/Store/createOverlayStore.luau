local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local Signals = require(SocialUpsellParent.Signals)

require(SocialUpsell.Types)

local t1 = {
	overlayType = nil,
	overlayProps = {}
}

return function() -- line: 19
	-- upvalues: Signals (copy), t1 (copy)
	local v5, v6 = Signals.createSignal(table.clone(t1))
	local v7 = Signals.createComputed(function(p1) -- line: 21
		-- upvalues: v5 (copy)
		return v5(p1).overlayType
	end)

	return {
		getCurrentOverlay = v5,
		setCurrentOverlay = function(p2, p3) -- line: 27
			-- upvalues: v6 (copy)
			v6({
				overlayType = p2,
				overlayProps = p3
			})
		end,
		getCurrentOverlayType = v7,
		dismissCurrentOverlay = function() -- line: 34
			-- upvalues: v6 (copy), t1 (copy)
			v6(table.clone(t1))
		end
	}
end
