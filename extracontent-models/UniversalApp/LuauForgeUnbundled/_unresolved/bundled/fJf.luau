local getFIntAttributeJoinLinkFailureCounterThrottle = require("@luauforge/bundled/fJg").GetFIntAttributeJoinLinkFailureCounterThrottle
return {
	eventName = "attributeJoinLinkFailure",
	backends = { require("@luauforge/bundled/fJd").TelemetryBackends.Counter },
	throttlingPercentage = getFIntAttributeJoinLinkFailureCounterThrottle(),
	lastUpdated = { 24, 10, 21 },
	description = "Counter to track failed Attribute ID generation on Lua Apps."
}
