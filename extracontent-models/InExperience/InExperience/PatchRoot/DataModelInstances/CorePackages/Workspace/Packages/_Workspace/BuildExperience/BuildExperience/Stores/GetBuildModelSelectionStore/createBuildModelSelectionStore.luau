local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore

local function createBuildModelSelectionStore(p: number?)
	local function createAccount()
		local userId

		if p == nil then
			userId = localUserIdStore.getCurrentUserId(false)
		else
			userId = tostring(p)
		end

		return { userId = userId, entries = {} }
	end

	local sessionScopedSignal, v = SignalsUtils.createSessionScopedSignal(createAccount)

	local count = 0

	local function isAuthenticated(p2): boolean -- 2 equivalent calls inferred from this helper
		return (tonumber(p2.userId) or 0) > 0
	end

	local function createEntry(p2, formatted: string)
		local signal, v2 = Signals.createSignal({ intendedTier = "default" })

		local computed = Signals.createComputed(function(p3)
			local v3 = signal(p3)
			return table.freeze({
				intendedTier = v3.intendedTier,
				isBusy = v3.lock ~= nil
			})
		end, function(p3, p4): boolean
			return p3.intendedTier == p4.intendedTier and p3.isBusy == p4.isBusy
		end)

		local v3 = false
		local signal2, v4 = Signals.createSignal(true)

		local function isCurrent(p3) -- 5 equivalent calls inferred from this helper
			return sessionScopedSignal(p3) == p2 and signal2(p3)
		end

		return {
			identity = formatted,
			retainers = 0,
			discardRequested = false,
			invalidate = function()
				v4(false)
			end,
			entry = {
				getSelection = function(p3)
					if isCurrent(p3) then -- inferred equivalent call
						return (computed(p3))
					end

					return nil
				end,
				selectTier = function(intendedTier: string): boolean
					if
						not isCurrent(nil) -- inferred equivalent call
						or signal(false).lock ~= nil
						or intendedTier ~= "default" and intendedTier ~= "advanced"
					then
						return false
					end

					v2({ intendedTier = intendedTier })
					v3 = true
					return true
				end,
				restoreTier = function(intendedTier: string): boolean
					if not isCurrent(nil) or v3 or intendedTier ~= "default" and intendedTier ~= "advanced" then -- inferred equivalent call
						return false
					end

					v3 = true
					local clone = table.clone(signal(false))
					clone.intendedTier = intendedTier
					v2(clone)
					return true
				end,
				acquireLock = function()
					if not isCurrent(nil) or signal(false).lock ~= nil then -- inferred equivalent call
						return nil
					end

					local frozen = table.freeze({})
					local clone = table.clone(signal(false))
					clone.lock = frozen
					v2(clone)
					return frozen
				end,
				releaseLock = function(p3): boolean
					if not isCurrent(nil) or signal(false).lock == nil or signal(false).lock ~= p3 then -- inferred equivalent call
						return false
					end

					local clone = table.clone(signal(false))
					clone.lock = nil
					v2(clone)
					return true
				end
			}
		}
	end

	local function discardDraft(p2: string): boolean
		local v2 = sessionScopedSignal(false)
		local entry = v2.entries[p2]

		if entry == nil then
			return false
		end

		if entry.retainers > 0 then
			entry.discardRequested = true
			return true
		end

		if entry.identity == p2 and entry.createdUniverseId ~= nil then
			local createdUniverseId = entry.createdUniverseId
			local v3 = sessionScopedSignal(false)
			local entry2 = v3.entries[p2]

			if entry2 ~= nil and not (createdUniverseId <= 0) then
				local formatted = `universe:{createdUniverseId}`

				if entry2.identity == p2 then
					if v3.entries[formatted] == nil then
						entry2.identity = formatted
						v3.entries[formatted] = entry2
					end
				else
					local _ = entry2.identity == formatted
				end
			end
		end

		v2.entries[p2] = nil

		if entry.identity == p2 then
			entry.invalidate()
		end

		return true
	end

	return {
		getUniverse = function(p2: number, p3)
			local v2 = sessionScopedSignal(p3)

			if not isAuthenticated(v2) or p2 <= 0 then -- inferred equivalent call
				return nil
			end

			local formatted = `universe:{p2}`

			if v2.entries[formatted] == nil then
				v2.entries[formatted] = createEntry(v2, formatted)
			end

			return v2.entries[formatted].entry
		end,
		getDraft = function(p2: string, p3)
			local entry = sessionScopedSignal(p3).entries[p2]
			return if entry ~= nil then entry.entry else nil
		end,
		createDraft = function()
			local v2 = sessionScopedSignal(false)

			if not isAuthenticated(v2) then -- inferred equivalent call
				return nil
			end

			count += 1
			local formatted = `draft:{count}`
			v2.entries[formatted] = createEntry(v2, formatted)
			return formatted
		end,
		retainDraftForCreation = function(p2: string)
			local v2 = sessionScopedSignal(false)
			local entry = v2.entries[p2]

			if entry == nil then
				return nil
			end

			entry.retainers += 1
			local flag = false
			return function(createdUniverseId: number?)
				if flag then
					return
				end

				flag = true
				entry.retainers -= 1

				if sessionScopedSignal(false) == v2 then
					if createdUniverseId ~= nil then
						entry.createdUniverseId = createdUniverseId
					end

					if entry.retainers == 0 and entry.discardRequested then
						discardDraft(p2)
					end
				end
			end
		end,
		promoteDraft = function(p2: string, p3: number): boolean
			local v2 = sessionScopedSignal(false)
			local entry = v2.entries[p2]

			if entry == nil or p3 <= 0 then
				return false
			end

			local formatted = `universe:{p3}`

			if entry.identity ~= p2 then
				return entry.identity == formatted
			end

			if v2.entries[formatted] ~= nil then
				return false
			end

			entry.identity = formatted
			v2.entries[formatted] = entry
			return true
		end,
		discardDraft = discardDraft,
		reset = function()
			v(createAccount())
		end
	}
end

return createBuildModelSelectionStore
