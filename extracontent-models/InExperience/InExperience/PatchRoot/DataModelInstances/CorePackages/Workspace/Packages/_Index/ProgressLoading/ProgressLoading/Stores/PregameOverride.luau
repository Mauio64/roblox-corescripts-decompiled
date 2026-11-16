local parent = script:FindFirstAncestor("ProgressLoading").Parent

require(parent.React)
local Signals = require(parent.Signals)

local signal, v = Signals.createSignal(nil)
local PregameOverride = {}
PregameOverride.getPregameOverride = signal

function PregameOverride.setPregameOverride(p, p2: number?)
	if p == nil then
		v(nil)
		return
	end

	local clone = table.clone(p)
	clone.setAt = p2 or os.clock()
	v(clone)
end

function PregameOverride.claims(p, p2: number, p3: number): boolean
	return p.placeId == p2 and p3 - (p.setAt or 0) <= 15
end

return PregameOverride
