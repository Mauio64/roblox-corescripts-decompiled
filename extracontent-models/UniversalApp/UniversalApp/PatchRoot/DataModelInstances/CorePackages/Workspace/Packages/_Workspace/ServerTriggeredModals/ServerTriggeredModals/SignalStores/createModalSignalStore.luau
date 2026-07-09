local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local ServerTriggeredModalsParent = ServerTriggeredModals.Parent
local Signals = require(ServerTriggeredModalsParent.Signals)

require(ServerTriggeredModalsParent.ServerDrivenUi)
require(ServerTriggeredModals.EntryPoint)

return function() -- line: 42
	-- upvalues: Signals (copy)
	local t1 = {}

	local function getOrCreateEntry(p1) -- line: 45
		-- upvalues: t1 (copy), Signals (copy)
		local v7 = t1[p1]

		if v7 == nil then
			local v8, v9 = Signals.createSignal(nil)
			local v10, v11 = Signals.createSignal(false)
			local v12, v13 = Signals.createSignal(false)

			v7 = {
				metadata = {
					get = v8,
					set = v9
				},
				hasShown = {
					get = v10,
					set = v11
				},
				primaryHandlerClaimed = {
					get = v12,
					set = v13
				}
			}
			t1[p1] = v7
		end

		return v7
	end

	return {
		getMetadataGetter = function(p2) -- line: 70
			-- upvalues: getOrCreateEntry (copy)
			return getOrCreateEntry(p2).metadata.get
		end,
		setMetadata = function(p3, t2: {[any]: any}?) -- line: 74
			-- upvalues: getOrCreateEntry (copy)
			getOrCreateEntry(p3).metadata.set(t2)
		end,
		getHasShownGetter = function(p4) -- line: 78
			-- upvalues: getOrCreateEntry (copy)
			return getOrCreateEntry(p4).hasShown.get
		end,
		setHasShown = function(p5, b1: boolean) -- line: 82
			-- upvalues: getOrCreateEntry (copy)
			getOrCreateEntry(p5).hasShown.set(b1)
		end,
		getPrimaryHandlerClaimedGetter = function(p6) -- line: 86
			-- upvalues: getOrCreateEntry (copy)
			return getOrCreateEntry(p6).primaryHandlerClaimed.get
		end,
		tryClaimPrimaryHandler = function(p7) -- line: 90
			-- upvalues: getOrCreateEntry (copy)
			local v22 = getOrCreateEntry(p7)

			if v22.primaryHandlerClaimed.get() then
				return false
			end

			v22.primaryHandlerClaimed.set(true)

			return true
		end,
		releasePrimaryHandler = function(p8) -- line: 99
			-- upvalues: getOrCreateEntry (copy)
			getOrCreateEntry(p8).primaryHandlerClaimed.set(false)
		end
	}
end
