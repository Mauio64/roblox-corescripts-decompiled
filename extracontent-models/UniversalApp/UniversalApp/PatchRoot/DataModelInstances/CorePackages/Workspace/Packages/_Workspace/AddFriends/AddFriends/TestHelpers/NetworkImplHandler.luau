local Parent = script:FindFirstAncestor("AddFriends").Parent
local myRoduxNetworking = require(Parent.AddFriendsState).Networking.myRoduxNetworking

require(Parent.Dev.JestGlobals).beforeAll(function() -- line: 9
	-- upvalues: myRoduxNetworking (copy)
	myRoduxNetworking.setNetworkImpl(function(p1) -- line: 10
		error(string.format("\n🔥 Should have replaced network implementation for url: %s\n", (tostring(p1))))
	end)
end)
