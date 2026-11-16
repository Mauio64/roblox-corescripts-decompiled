local parent = script:FindFirstAncestor("ProfileShareLinks").Parent
local ShareLinksNetworking = require(parent.ShareLinksNetworking)

local configuredRoduxNetworking = require(script.Parent.configuredRoduxNetworking)

return {
	ShareLinksNetworking = ShareLinksNetworking.config({
		roduxNetworking = configuredRoduxNetworking
	})
}
