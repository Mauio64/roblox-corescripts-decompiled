local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Signals = require(Parent.Signals)
local u3 = nil

return {
	getInGameFriendsByGame = function(p1) -- line: 7
		-- upvalues: u3 (ref), Signals (copy)
		if u3 == nil then
			u3 = Signals.createSignal({})
		end

		return u3(p1)
	end,
	setInGameFriendsByGameSignal = function(p2) -- line: 14
		-- upvalues: u3 (ref)
		u3 = p2
	end
}
