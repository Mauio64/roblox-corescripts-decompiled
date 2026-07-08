local Parent = script:FindFirstAncestor("ProfileShareLinks").Parent
local ShareLinksNetworking = require(Parent.ShareLinksNetworking)
local configuredRoduxNetworking = require(script.Parent.configuredRoduxNetworking)

return {
	ShareLinksNetworking = ShareLinksNetworking.config({
		roduxNetworking = configuredRoduxNetworking
	})
}
