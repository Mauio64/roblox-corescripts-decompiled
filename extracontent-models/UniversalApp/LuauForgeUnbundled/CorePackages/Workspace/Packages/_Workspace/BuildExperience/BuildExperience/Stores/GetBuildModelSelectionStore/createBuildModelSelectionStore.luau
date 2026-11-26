local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsUtils")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/LocalUserIdStore").LocalUserIdStore

local function createBuildModelSelectionStore(p2)
	local function createAccount()
		local v5 = if p2 == nil then localUserIdStore.getCurrentUserId(false) else tostring(p2)
		return { userId = v5, entries = {} }
	end

	local sessionScopedSignal, v5 = SignalsUtils.createSessionScopedSignal(createAccount)

	local count = 0

	local function isAuthenticated(p3): boolean
		return (tonumber(p3.userId) or 0) > 0
	end

	local function createEntry(p3, formatted)
		local signal, v6 = Signals.createSignal({ intendedTier = "default" })

		local computed = Signals.createComputed(function(p4)
			local v7 = signal(p4)
			return table.freeze({
				intendedTier = v7.intendedTier,
				isBusy = v7.lock ~= nil
			})
		end, function(p4, p5): boolean
			return p4.intendedTier == p5.intendedTier and p4.isBusy == p5.isBusy
		end)

		local v7 = false
		local signal2, v8 = Signals.createSignal(true)

		local function isCurrent(p4)
			return sessionScopedSignal(p4) == p3 and signal2(p4)
		end

		return {
			identity = formatted,
			retainers = 0,
			discardRequested = false,
			invalidate = function()
				v8(false)
			end,
			entry = {
				getSelection = function(p4)
					local v9 = sessionScopedSignal(p4) == p3 and signal2(p4)

					if v9 then
						return (computed(p4))
					end

					return nil
				end,
				selectTier = function(p4): boolean
					local v9 = sessionScopedSignal(nil) == p3 and signal2(nil)

					if not v9 or signal(false).lock ~= nil or p4 ~= "default" and p4 ~= "advanced" then
						return false
					end

					v6({ intendedTier = p4 })
					v7 = true
					return true
				end,
				restoreTier = function(intendedTier): boolean
					local v9 = sessionScopedSignal(nil) == p3 and signal2(nil)

					if not v9 or v7 or intendedTier ~= "default" and intendedTier ~= "advanced" then
						return false
					end

					v7 = true
					local clone = table.clone(signal(false))
					clone.intendedTier = intendedTier
					v6(clone)
					return true
				end,
				acquireLock = function()
					local v9 = sessionScopedSignal(nil) == p3 and signal2(nil)

					if not v9 or signal(false).lock ~= nil then
						return nil
					end

					local frozen = table.freeze({})
					local clone = table.clone(signal(false))
					clone.lock = frozen
					v6(clone)
					return frozen
				end,
				releaseLock = function(p4): boolean
					local v9 = sessionScopedSignal(nil) == p3 and signal2(nil)

					if not v9 or signal(false).lock == nil or signal(false).lock ~= p4 then
						return false
					end

					local clone = table.clone(signal(false))
					clone.lock = nil
					v6(clone)
					return true
				end
			}
		}
	end

	local function discardDraft(p3): boolean
		local v6 = sessionScopedSignal(false)
		local entry = v6.entries[p3]

		if entry == nil then
			return false
		end

		if entry.retainers > 0 then
			entry.discardRequested = true
			return true
		end

		if entry.identity == p3 and entry.createdUniverseId ~= nil then
			local createdUniverseId = entry.createdUniverseId
			local v7 = sessionScopedSignal(false)
			local entry2 = v7.entries[p3]

			if entry2 ~= nil and not (createdUniverseId <= 0) then
				local formatted = `universe:{createdUniverseId}`

				if entry2.identity == p3 then
					if v7.entries[formatted] == nil then
						entry2.identity = formatted
						v7.entries[formatted] = entry2
					end
				else
					local v8 = entry2.identity == formatted
				end
			end
		end

		v6.entries[p3] = nil

		if entry.identity == p3 then
			entry.invalidate()
		end

		return true
	end

	return {
		getUniverse = function(p3, p4)
			local v6 = sessionScopedSignal(p4)

			if not ((tonumber(v6.userId) or 0) > 0) or p3 <= 0 then
				return nil
			end

			local formatted = `universe:{p3}`

			if v6.entries[formatted] == nil then
				v6.entries[formatted] = createEntry(v6, formatted)
			end

			return v6.entries[formatted].entry
		end,
		getDraft = function(p3, p4)
			local entry = sessionScopedSignal(p4).entries[p3]

			if entry == nil then
				return nil
			end

			return entry.entry
		end,
		createDraft = function()
			local v6 = sessionScopedSignal(false)

			if not ((tonumber(v6.userId) or 0) > 0) then
				return nil
			end

			count += 1
			local formatted = `draft:{count}`
			v6.entries[formatted] = createEntry(v6, formatted)
			return formatted
		end,
		retainDraftForCreation = function(p3)
			local v6 = sessionScopedSignal(false)
			local entry = v6.entries[p3]

			if entry == nil then
				return nil
			end

			entry.retainers += 1
			local flag = false
			return function(createdUniverseId)
				if flag then
					return
				end

				flag = true
				entry.retainers -= 1

				if sessionScopedSignal(false) == v6 then
					if createdUniverseId ~= nil then
						entry.createdUniverseId = createdUniverseId
					end

					if entry.retainers == 0 and entry.discardRequested then
						discardDraft(p3)
					end
				end
			end
		end,
		promoteDraft = function(p3, p4): boolean
			local v6 = sessionScopedSignal(false)
			local entry = v6.entries[p3]

			if entry == nil or p4 <= 0 then
				return false
			end

			local formatted = `universe:{p4}`

			if entry.identity ~= p3 then
				return entry.identity == formatted
			end

			if v6.entries[formatted] ~= nil then
				return false
			end

			entry.identity = formatted
			v6.entries[formatted] = entry
			return true
		end,
		discardDraft = discardDraft,
		reset = function()
			v5(createAccount())
		end
	}
end

return createBuildModelSelectionStore
