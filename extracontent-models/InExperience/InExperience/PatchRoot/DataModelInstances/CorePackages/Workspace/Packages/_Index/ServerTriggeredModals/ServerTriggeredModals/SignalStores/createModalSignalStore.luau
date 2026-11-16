local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local Signals = require(parent.Signals)
require(parent.ServerDrivenUi)
require(ServerTriggeredModals.EntryPoint)

return function()
	local entries = {}

	local function getOrCreateEntry(p)
		local entry = entries[p]

		if entry ~= nil then
			return entry
		end

		local signal, set = Signals.createSignal(nil)
		local signal2, set2 = Signals.createSignal(false)
		local signal3, set3 = Signals.createSignal(false)
		entry = {
			metadata = { get = signal, set = set },
			hasShown = { get = signal2, set = set2 },
			primaryHandlerClaimed = { get = signal3, set = set3 }
		}

		entries[p] = entry

		return entry
	end

	return {
		getMetadataGetter = function(p)
			return getOrCreateEntry(p).metadata.get
		end,
		setMetadata = function(p, p2)
			getOrCreateEntry(p).metadata.set(p2)
		end,
		getHasShownGetter = function(p)
			return getOrCreateEntry(p).hasShown.get
		end,
		setHasShown = function(p, flag: boolean)
			getOrCreateEntry(p).hasShown.set(flag)
		end,
		getPrimaryHandlerClaimedGetter = function(p)
			return getOrCreateEntry(p).primaryHandlerClaimed.get
		end,
		tryClaimPrimaryHandler = function(p): boolean
			local entry = getOrCreateEntry(p)

			if entry.primaryHandlerClaimed.get() then
				return false
			end

			entry.primaryHandlerClaimed.set(true)
			return true
		end,
		releasePrimaryHandler = function(p)
			getOrCreateEntry(p).primaryHandlerClaimed.set(false)
		end
	}
end
