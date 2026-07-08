local SignalsScheduler = require(script.Parent.SignalsScheduler)
local createProxy = require(script.createProxy)

return {
	batch = SignalsScheduler.batch,
	createProxy = createProxy,
	createReducer = require(script.createReducer),
	onDisposed = require(script.onDisposed)
}
