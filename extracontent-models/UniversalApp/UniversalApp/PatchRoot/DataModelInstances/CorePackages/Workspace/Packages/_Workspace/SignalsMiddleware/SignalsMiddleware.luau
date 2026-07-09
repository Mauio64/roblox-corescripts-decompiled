local ActionHandlers = require(script.ActionHandlers)

return {
	createSignalsMiddleware = require(script.SignalsMiddleware),
	ActionHandlers = ActionHandlers,
	["jest.config"] = script["jest.config"]
}
