local WhatsNew = script:FindFirstAncestor("WhatsNew")

require(WhatsNew.Types)

local UnixTimestamp = DateTime.fromIsoDate("2026-06-01T00:00:00Z").UnixTimestamp

return {
	DEFAULT_USER_ID = 1,
	createPreStorageDeps = function(t1: {[any]: any}?) -- line: 18
		-- upvalues: UnixTimestamp (copy)
		local v4 = t1 or {}

		return {
			userId = v4.userId or 1,
			storage = v4.storage or {},
			meta = v4.meta or {},
			currentTime = v4.currentTime or UnixTimestamp
		}
	end,
	DEFAULT_CURRENT_TIME = UnixTimestamp
}
