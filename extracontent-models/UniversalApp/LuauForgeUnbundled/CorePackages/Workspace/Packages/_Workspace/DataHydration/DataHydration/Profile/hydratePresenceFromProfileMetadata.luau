local PresenceStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/PresenceStore")
local normalizePresenceRawData = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/normalizePresenceRawData")

local function hydratePresenceFromProfileMetadata(p2, p3)
	local presence = p3 and p3.presence

	if presence == nil then
		return
	end

	local v5 = normalizePresenceRawData(presence, p2)

	if v5 == nil then
		return
	end

	PresenceStore.get().UpdateUserPresence(p2, v5, {
		isUpdatedRealtime = nil,
		isRealtimeUnknown = true
	})
end

return hydratePresenceFromProfileMetadata
