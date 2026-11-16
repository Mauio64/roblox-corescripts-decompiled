local DataHydration = script:FindFirstAncestor("DataHydration")

local PresenceStore = require(DataHydration.Presence.PresenceStore)
local normalizePresenceRawData = require(DataHydration.Presence.normalizePresenceRawData)

local function hydratePresenceFromProfileMetadata(p: string, p2)
	local presence = p2 and p2.presence

	if presence == nil then
		return
	end

	local presenceRawData = normalizePresenceRawData(presence, p)

	if presenceRawData == nil then
		return
	end

	PresenceStore.get().UpdateUserPresence(p, presenceRawData, {
		isUpdatedRealtime = nil,
		isRealtimeUnknown = true
	})
end

return hydratePresenceFromProfileMetadata
