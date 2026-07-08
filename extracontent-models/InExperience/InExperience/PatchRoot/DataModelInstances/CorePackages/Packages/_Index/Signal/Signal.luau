local createSignal = require(script.createSignal)
local createReadableSignal = require(script.createReadableSignal)

require(script.types)

return {
	createSignal = createSignal,
	createReadableSignal = createReadableSignal
}
