require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local signal, v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Signals").createSignal(nil)

return {
	getPregameOverride = signal,
	setPregameOverride = function(p2, p3)
		if p2 == nil then
			v5(nil)
			return
		end

		local clone = table.clone(p2)
		clone.setAt = p3 or os.clock()
		v5(clone)
	end,
	claims = function(p2, p3, p4): boolean
		return p2.placeId == p3 and p4 - (p2.setAt or 0) <= 15
	end
}
