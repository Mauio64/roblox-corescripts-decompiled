require(script.App.App)

local Constants = require(script.Constants)

require(script.Types)

return {
	["jest.config"] = script["jest.config"],
	Actions = require(script.Actions),
	Analytics = require(script.Analytics),
	App = require(script.App),
	CapturesPolicy = require(script.App.CapturesPolicy),
	Constants = Constants,
	Context = require(script.Context),
	Flags = require(script.Flags),
	installReducer = require(script.installReducer),
	RoduxKey = Constants.RoduxKey
}
