local WhatsNew = script:FindFirstAncestor("WhatsNew")
local EntryStorage = require(script.Parent.EntryStorage)

require(WhatsNew.Types)

local function createResolveDeps(t1: {[any]: any}?) -- line: 24
	-- upvalues: EntryStorage (copy)
	local v5 = t1 or {}

	return {
		storage = EntryStorage.getEntries(),
		meta = EntryStorage.getMeta(),
		currentTime = v5.currentTime or DateTime.now().UnixTimestamp
	}
end

return {
	createResolveDeps = createResolveDeps,
	bootstrapPersistedResolveDeps = function(t2: {[any]: any}?) -- line: 33
		-- upvalues: EntryStorage (copy), createResolveDeps (copy)
		EntryStorage.runMigration(if not t2 then nil else t2.runMigrationOptions)

		return (createResolveDeps({
			currentTime = if not t2 then nil else t2.currentTime
		}))
	end
}
