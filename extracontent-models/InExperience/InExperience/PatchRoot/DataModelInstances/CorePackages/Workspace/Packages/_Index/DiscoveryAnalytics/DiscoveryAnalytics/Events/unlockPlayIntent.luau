local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local flaggedMutedError = require(Parent.Loggers).flaggedMutedError
local FFlagLuaAppLogPageContextUnlockPlayIntent = require(Parent.SharedFlags).FFlagLuaAppLogPageContextUnlockPlayIntent
local v5 = t.strictInterface({
	universeId = t.string,
	upsellName = t.string,
	playabilityStatus = t.optional(t.string),
	pageName = if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else t.optional(t.string)
})

return function(p1, p2) -- line: 17
	-- upvalues: v5 (copy), flaggedMutedError (copy)
	local v8, v9 = v5(p2)

	if not v8 then
		flaggedMutedError("UnlockPlayIntentEventInterface", v9)
	end

	p1:sendEventDeferred("PlayButton", "unlockPlayIntent", p2)
end
