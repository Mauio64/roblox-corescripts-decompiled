local AffiliateLinks = script:FindFirstAncestor("AffiliateLinks")
local AffiliateLinksParent = AffiliateLinks.Parent
local GetFIntAttributeJoinLinkFailureCounterThrottle = require(AffiliateLinks.Flags).GetFIntAttributeJoinLinkFailureCounterThrottle
local LoggingProtocol = require(AffiliateLinksParent.LoggingProtocol)

return {
	eventName = "attributeJoinLinkFailure",
	description = "Counter to track failed Attribute ID generation on Lua Apps.",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = GetFIntAttributeJoinLinkFailureCounterThrottle(),
	lastUpdated = {
		24,
		10,
		21
	}
}
