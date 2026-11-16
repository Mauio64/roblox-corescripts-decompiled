local parent = script.Parent.Parent.Parent
local Signals = require(parent.Signals)
local LeaderboardStore = require(parent.LeaderboardStore)
local leaderboardStore = LeaderboardStore.createLeaderboardStore()

local signal, v = Signals.createSignal(nil)
local LeaderboardStoreInstanceManager = {}

function LeaderboardStoreInstanceManager.createLeaderboardStoreInstance()
	v(leaderboardStore())
end

LeaderboardStoreInstanceManager.getLeaderboardStoreInstance = signal

function LeaderboardStoreInstanceManager.cleanUpInstance()
	local v2 = signal(false)

	if v2 ~= nil then
		v2.cleanUp()
		v(nil)
	end
end

return LeaderboardStoreInstanceManager
