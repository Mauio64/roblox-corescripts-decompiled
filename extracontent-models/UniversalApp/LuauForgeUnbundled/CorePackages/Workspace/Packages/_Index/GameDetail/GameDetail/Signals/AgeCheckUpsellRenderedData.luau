local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Signals")

local AgeCheckUpsellDismissedData = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/Signals/AgeCheckUpsellDismissedData")

local v5 = {}

local function getOrCreate(p2)
	local v6 = v5[p2]

	if not v6 then
		local signal, v7 = Signals.createSignal(false)
		v6 = { get = signal, set = v7 }
		v5[p2] = v6
	end

	return v6
end

return {
	getIsAgeCheckUpsellRendered = function(p2, p3)
		if p3 == nil or p3 == "" or AgeCheckUpsellDismissedData.getIsAgeCheckUpsellDismissed(p2) then
			return false
		end

		local v6 = v5[p3]

		if not v6 then
			local signal, v7 = Signals.createSignal(false)
			v6 = { get = signal, set = v7 }
			v5[p3] = v6
		end

		return v6.get(p2)
	end,
	setAgeCheckUpsellRendered = function(p2, p3)
		if p2 == nil or p2 == "" then
			return
		end

		local v6 = v5[p2]

		if not v6 then
			local signal, v7 = Signals.createSignal(false)
			v6 = { get = signal, set = v7 }
			v5[p2] = v6
		end

		v6.set(p3)
	end
}
