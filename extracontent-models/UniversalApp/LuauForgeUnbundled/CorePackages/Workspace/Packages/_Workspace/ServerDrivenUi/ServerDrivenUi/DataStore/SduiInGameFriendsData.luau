local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Signals")

local v5 = nil

return {
	getInGameFriendsByGame = function(p2)
		if v5 == nil then
			v5 = Signals.createSignal({})
		end

		return v5(p2)
	end,
	setInGameFriendsByGameSignal = function(p2)
		v5 = p2
	end
}
