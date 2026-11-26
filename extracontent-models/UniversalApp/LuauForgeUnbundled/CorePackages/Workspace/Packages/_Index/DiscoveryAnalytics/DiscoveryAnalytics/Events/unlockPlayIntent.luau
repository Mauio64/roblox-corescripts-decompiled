local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local flaggedMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/Loggers").flaggedMutedError

local strictInterface = t.strictInterface({
	universeId = t.string,
	upsellName = t.string,
	playabilityStatus = t.optional(t.string),
	pageName = t.optional(t.string)
})

return function(object, p2)
	local v5, v6 = strictInterface(p2)

	if not v5 then
		flaggedMutedError("UnlockPlayIntentEventInterface", v6)
	end

	object:sendEventDeferred("PlayButton", "unlockPlayIntent", p2)
end
