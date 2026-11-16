local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Signals = require(parent.Signals)

local v = nil
local SduiInGameFriendsData = {}

function SduiInGameFriendsData.getInGameFriendsByGame(p)
	if v == nil then
		v = Signals.createSignal({})
	end

	return v(p)
end

function SduiInGameFriendsData.setInGameFriendsByGameSignal(p)
	v = p
end

return SduiInGameFriendsData
