local MarketplaceCatalogSduiSelectionBridge = require(script.System.MarketplaceCatalogSduiSelectionBridge)

return {
	SduiAvatarExperienceRegister = require(script.System.SduiAvatarExperienceRegister),
	MarketplaceCatalogSduiSelectionBridge = MarketplaceCatalogSduiSelectionBridge,
	Context = {
		SduiWidgetTTITileLatencyContext = require(script.Context.SduiWidgetTTITileLatencyContext)
	},
	["jest.config"] = script["jest.config"]
}
