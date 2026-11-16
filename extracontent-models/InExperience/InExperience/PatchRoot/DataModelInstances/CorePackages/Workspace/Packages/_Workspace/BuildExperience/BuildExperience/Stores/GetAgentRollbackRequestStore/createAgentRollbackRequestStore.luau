local parent = script:FindFirstAncestor("BuildExperience").Parent

local Promise = require(parent.Promise)
local Signals = require(parent.Signals)

local function createAgentRollbackRequestStore()
	local count = 0
	local requestSignals = {}
	local v = nil
	local v2 = nil

	local function getRequestSignal(p: number) -- 12 equivalent calls inferred from this helper
		local requestSignal = requestSignals[p]

		if requestSignal == nil then
			local signal, setIsPending = Signals.createSignal(false)
			requestSignal = { getIsPending = signal, setIsPending = setIsPending }

			requestSignals[p] = requestSignal
		end

		return requestSignal
	end

	local function turnStarterMatchesTarget(p): boolean -- 2 equivalent calls inferred from this helper
		return v ~= nil
			and v.target.placeId == p.placeId
			and (p.universeId == nil or v.target.universeId == p.universeId)
	end

	local function finishRequest(data, p: string?)
		if v2 ~= data then
			return
		end

		v2 = nil
		getRequestSignal(data.target.placeId).setIsPending(false) -- inferred equivalent call

		if p == nil then
			data.resolve()
		else
			data.reject(p)
		end
	end

	local function beginRequest(p)
		if v2 ~= nil then
			return nil, Promise.reject("agent_rollback_busy")
		end

		if not turnStarterMatchesTarget(p) then -- inferred equivalent call
			return nil, Promise.reject("agent_rollback_no_turn_starter")
		end

		count += 1
		local id = count
		local v3 = v
		return id, (Promise.new(function(resolve, reject)
			local v4 = { id = id, target = 0, resolve = 0, reject = 0 }
			local universeId

			if p.universeId == nil then
				universeId = v3.target.universeId
			else
				universeId = p.universeId
			end

			v4.target = { universeId = universeId, placeId = p.placeId }

			v4.resolve = resolve
			v4.reject = reject
			v2 = v4

			getRequestSignal(p.placeId).setIsPending(true) -- inferred equivalent call
		end))
	end

	local function setRequestData(id: number, data)
		local v3 = v2

		if v3 == nil or v3.id ~= id then
			return false
		end

		if turnStarterMatchesTarget(v3.target) then -- inferred equivalent call
			local v4 = v

			if v4 ~= nil then
				local v5 = {
					id = id,
					universeId = v3.target.universeId,
					placeId = v3.target.placeId,
					versionNumber = data.versionNumber,
					noteTitle = data.noteTitle,
					noteDescription = data.noteDescription
				}

				local success, result = pcall(v4.startTurn, v5, function()
					local v6 = v3

					if v2 ~= v6 then
						return
					end

					v2 = nil
					getRequestSignal(v6.target.placeId).setIsPending(false) -- inferred equivalent call

					v6.resolve()
				end, function()
					local v6 = v3

					if v2 ~= v6 then
						return
					end

					v2 = nil
					getRequestSignal(v6.target.placeId).setIsPending(false) -- inferred equivalent call

					v6.reject("agent_rollback_start_failed")
				end)

				if not (success and result) and v2 == v3 then
					v2 = nil
					getRequestSignal(v3.target.placeId).setIsPending(false) -- inferred equivalent call

					v3.reject("agent_rollback_start_failed")
				end

				return success and result
			end
		end

		if v2 == v3 then
			v2 = nil
			getRequestSignal(v3.target.placeId).setIsPending(false) -- inferred equivalent call

			v3.reject("agent_rollback_start_failed")
		end

		return false
	end

	return {
		getIsPendingForPlaceId = function(p: number)
			return getRequestSignal(p).getIsPending -- inferred equivalent call
		end,
		registerTurnStarter = function(target, registration, startTurn): boolean
			if v ~= nil and v.registration ~= registration then
				return false
			end

			local v3 = v2

			if
				v3 ~= nil
				and (v3.target.placeId ~= target.placeId or v3.target.universeId ~= target.universeId)
				and v2 == v3
			then
				v2 = nil
				getRequestSignal(v3.target.placeId).setIsPending(false) -- inferred equivalent call

				v3.reject("agent_rollback_start_failed")
			end

			v = { target = target, registration = registration, startTurn = startTurn }

			return true
		end,
		unregisterTurnStarter = function(p)
			if v == nil or v.registration ~= p then
				return
			end

			v = nil
			local v3 = v2

			if v3 ~= nil then
				if v2 ~= v3 then
					return
				end

				v2 = nil
				getRequestSignal(v3.target.placeId).setIsPending(false) -- inferred equivalent call

				v3.reject("agent_rollback_start_failed")
			end
		end,
		beginRequest = beginRequest,
		setRequestData = setRequestData,
		failRequest = function(p: number): boolean
			local v3 = v2

			if v3 == nil or v3.id ~= p then
				return false
			end

			if v2 == v3 then
				v2 = nil
				getRequestSignal(v3.target.placeId).setIsPending(false) -- inferred equivalent call

				v3.reject("agent_rollback_start_failed")
			end

			return true
		end,
		cancelRequestForPlaceId = function(p: number): boolean
			local v3 = v2

			if v3 == nil or v3.target.placeId ~= p then
				return false
			end

			if v2 == v3 then
				v2 = nil
				getRequestSignal(v3.target.placeId).setIsPending(false) -- inferred equivalent call

				v3.reject("agent_rollback_cancelled")
			end

			return true
		end,
		request = function(p, p2)
			local id, v3 = beginRequest(p)

			if id ~= nil then
				setRequestData(id, p2)
			end

			return v3
		end,
		reset = function()
			local v3 = v2

			if v3 ~= nil and v2 == v3 then
				v2 = nil
				getRequestSignal(v3.target.placeId).setIsPending(false) -- inferred equivalent call

				v3.reject("agent_rollback_start_failed")
			end

			v = nil
		end
	}
end

return createAgentRollbackRequestStore
