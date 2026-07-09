local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local ProfileShareLinksParent = ProfileShareLinks.Parent
local beforeAll = require(ProfileShareLinksParent.Dev.JestGlobals).beforeAll
local configuredRoduxNetworking = require(ProfileShareLinks.Networking.configuredRoduxNetworking)

beforeAll(function() -- line: 8
	-- upvalues: configuredRoduxNetworking (copy)
	configuredRoduxNetworking.setNetworkImpl(function(p1) -- line: 9
		error(string.format("🔥 Should have replaced network implementation for url: %s", (tostring(p1))))
	end)
end)
