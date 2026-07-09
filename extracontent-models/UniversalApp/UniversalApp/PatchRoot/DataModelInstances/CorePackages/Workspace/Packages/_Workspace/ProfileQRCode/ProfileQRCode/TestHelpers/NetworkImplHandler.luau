local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local beforeAll = require(ProfileQRCodeParent.Dev.JestGlobals).beforeAll
local configuredRoduxNetworking = require(ProfileQRCode.Networking.configuredRoduxNetworking)

beforeAll(function() -- line: 8
	-- upvalues: configuredRoduxNetworking (copy)
	configuredRoduxNetworking.setNetworkImpl(function(p1) -- line: 9
		error(string.format("🔥 Should have replaced network implementation for url: %s", (tostring(p1))))
	end)
end)
