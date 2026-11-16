local getFIntAttributeJoinLinkFailureCounterThrottle = require("@luauforge/bundled/hZt").GetFIntAttributeJoinLinkFailureCounterThrottle
return {
	eventName = "attributeJoinLinkFailure",
	backends = { require("@luauforge/bundled/hZq").TelemetryBackends.Counter },
	throttlingPercentage = getFIntAttributeJoinLinkFailureCounterThrottle(),
	lastUpdated = { 24, 10, 21 },
	description = "Counter to track failed Attribute ID generation on Lua Apps."
}
