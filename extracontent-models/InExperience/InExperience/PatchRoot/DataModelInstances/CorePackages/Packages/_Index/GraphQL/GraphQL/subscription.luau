local subscribe = require(script.subscribe)
return {
	subscribe = subscribe.subscribe,
	createSourceEventStream = subscribe.createSourceEventStream
}
