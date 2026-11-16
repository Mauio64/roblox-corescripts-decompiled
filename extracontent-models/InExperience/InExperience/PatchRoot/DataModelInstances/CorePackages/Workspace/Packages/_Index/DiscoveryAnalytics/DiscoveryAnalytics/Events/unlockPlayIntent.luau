local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local Loggers = require(parent.Loggers)
local flaggedMutedError = Loggers.flaggedMutedError

local strictInterface = t.strictInterface({
	universeId = t.string,
	upsellName = t.string,
	playabilityStatus = t.optional(t.string),
	pageName = t.optional(t.string)
})

return function(object, p)
	local v, v2 = strictInterface(p)

	if not v then
		flaggedMutedError("UnlockPlayIntentEventInterface", v2)
	end

	object:sendEventDeferred("PlayButton", "unlockPlayIntent", p)
end
