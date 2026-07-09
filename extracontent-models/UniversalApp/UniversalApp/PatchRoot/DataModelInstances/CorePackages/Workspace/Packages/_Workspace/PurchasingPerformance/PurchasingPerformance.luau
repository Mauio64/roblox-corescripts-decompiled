local BuyRobuxPageTTIManager = require(script.BuyRobuxPageTTIManager)
local Bridge = require(script.Bridge)

return {
	BuyRobuxPageTTIManager = BuyRobuxPageTTIManager,
	Bridge = Bridge,
	Flags = {
		FFlagEnableBuyRobuxPageTTI = require(script.Flags.FFlagEnableBuyRobuxPageTTI),
		FFlagSimulateBuyRobuxPageWebTTIPayload = require(script.Flags.FFlagSimulateBuyRobuxPageWebTTIPayload)
	},
	["jest.config"] = script["jest.config"]
}
