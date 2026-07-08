local ParentParent = script.Parent.Parent.Parent
local Signals = require(ParentParent.Signals)
local v3 = require(ParentParent.LeaderboardStore).createLeaderboardStore()
local v4, v5 = Signals.createSignal(nil)
local u6 = v4
local u7 = v5

return {
	createLeaderboardStoreInstance = function() -- line: 13
		-- upvalues: u7 (ref), v3 (copy)
		u7(v3())
	end,
	getLeaderboardStoreInstance = u6,
	cleanUpInstance = function() -- line: 17
		-- upvalues: u6 (ref), u7 (ref)
		local v8 = u6(false)

		if v8 ~= nil then
			v8.cleanUp()
			u7(nil)
		end
	end
}
