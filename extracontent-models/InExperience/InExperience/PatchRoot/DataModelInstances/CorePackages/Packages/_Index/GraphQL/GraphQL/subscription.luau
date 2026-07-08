local subscribe = require(script.subscribe)
local subscribe2 = subscribe.subscribe
local createSourceEventStream = subscribe.createSourceEventStream

return {
	subscribe = subscribe2,
	createSourceEventStream = createSourceEventStream
}
