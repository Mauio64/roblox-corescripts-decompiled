local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/ServerDrivenUi")
require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/EntryPoint")

return function()
	local entries = {}

	local function getOrCreateEntry(p2)
		local entry = entries[p2]

		if entry ~= nil then
			return entry
		end

		local signal, v5 = Signals.createSignal(nil)
		local signal2, v6 = Signals.createSignal(false)
		local signal3, v7 = Signals.createSignal(false)
		entry = {
			metadata = { get = signal, set = v5 },
			hasShown = { get = signal2, set = v6 },
			primaryHandlerClaimed = { get = signal3, set = v7 }
		}

		entries[p2] = entry

		return entry
	end

	return {
		getMetadataGetter = function(p2)
			return getOrCreateEntry(p2).metadata.get
		end,
		setMetadata = function(p2, p3)
			getOrCreateEntry(p2).metadata.set(p3)
		end,
		getHasShownGetter = function(p2)
			return getOrCreateEntry(p2).hasShown.get
		end,
		setHasShown = function(p2, p3)
			getOrCreateEntry(p2).hasShown.set(p3)
		end,
		getPrimaryHandlerClaimedGetter = function(p2)
			return getOrCreateEntry(p2).primaryHandlerClaimed.get
		end,
		tryClaimPrimaryHandler = function(p2): boolean
			local entry = getOrCreateEntry(p2)

			if entry.primaryHandlerClaimed.get() then
				return false
			end

			entry.primaryHandlerClaimed.set(true)
			return true
		end,
		releasePrimaryHandler = function(p2)
			getOrCreateEntry(p2).primaryHandlerClaimed.set(false)
		end
	}
end
