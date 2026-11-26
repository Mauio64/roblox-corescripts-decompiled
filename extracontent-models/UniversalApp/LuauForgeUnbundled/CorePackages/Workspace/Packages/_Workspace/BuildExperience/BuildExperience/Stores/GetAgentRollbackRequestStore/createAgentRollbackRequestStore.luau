local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

local function createAgentRollbackRequestStore()
	local count = 0
	local v5 = {}
	local v6 = nil
	local v7 = nil

	local function getRequestSignal(p2)
		local requestSignal = v5[p2]

		if requestSignal == nil then
			local signal, v8 = Signals.createSignal(false)
			requestSignal = { getIsPending = signal, setIsPending = v8 }

			v5[p2] = requestSignal
		end

		return requestSignal
	end

	local function turnStarterMatchesTarget(p2): boolean
		return v6 ~= nil
			and v6.target.placeId == p2.placeId
			and (p2.universeId == nil or v6.target.universeId == p2.universeId)
	end

	local function finishRequest(data, p2)
		if v7 ~= data then
			return
		end

		v7 = nil
		local placeId = data.target.placeId
		local v8 = v5[placeId]

		if v8 == nil then
			local signal, v9 = Signals.createSignal(false)
			v8 = { getIsPending = signal, setIsPending = v9 }

			v5[placeId] = v8
		end

		v8.setIsPending(false)

		if p2 == nil then
			data.resolve()
		else
			data.reject(p2)
		end
	end

	local function beginRequest(p2)
		if v7 ~= nil then
			return nil, Promise.reject("agent_rollback_busy")
		end

		local v8

		if v6 == nil or v6.target.placeId ~= p2.placeId then
			v8 = false
		else
			v8 = p2.universeId == nil or v6.target.universeId == p2.universeId
		end

		if not v8 then
			return nil, Promise.reject("agent_rollback_no_turn_starter")
		end

		count += 1
		local v9 = count
		local v10 = v6
		return v9, (Promise.new(function(resolve, reject)
			local v11 = { id = v9, target = 0, resolve = 0, reject = 0 }

			local v13 = if p2.universeId == nil then v10.target.universeId else p2.universeId
			v11.target = { universeId = v13, placeId = p2.placeId }

			v11.resolve = resolve
			v11.reject = reject
			v7 = v11

			local placeId = p2.placeId
			local v14 = v5[placeId]

			if v14 == nil then
				local signal, v15 = Signals.createSignal(false)
				v14 = { getIsPending = signal, setIsPending = v15 }

				v5[placeId] = v14
			end

			v14.setIsPending(true)
		end))
	end

	local function setRequestData(p2, data)
		local v8 = v7

		if v8 == nil or v8.id ~= p2 then
			return false
		end

		local target = v8.target
		local v9

		if v6 == nil or v6.target.placeId ~= target.placeId then
			v9 = false
		else
			v9 = target.universeId == nil or v6.target.universeId == target.universeId
		end

		if v9 then
			local v10 = v6

			if v10 ~= nil then
				local v11 = {
					id = p2,
					universeId = v8.target.universeId,
					placeId = v8.target.placeId,
					versionNumber = data.versionNumber,
					noteTitle = data.noteTitle,
					noteDescription = data.noteDescription
				}

				local success, result = pcall(v10.startTurn, v11, function()
					local v12 = v8

					if v7 ~= v12 then
						return
					end

					v7 = nil
					local placeId = v12.target.placeId
					local v13 = v5[placeId]

					if v13 == nil then
						local signal, v14 = Signals.createSignal(false)
						v13 = { getIsPending = signal, setIsPending = v14 }

						v5[placeId] = v13
					end

					v13.setIsPending(false)

					v12.resolve()
				end, function()
					local v12 = v8

					if v7 ~= v12 then
						return
					end

					v7 = nil
					local placeId = v12.target.placeId
					local v13 = v5[placeId]

					if v13 == nil then
						local signal, v14 = Signals.createSignal(false)
						v13 = { getIsPending = signal, setIsPending = v14 }

						v5[placeId] = v13
					end

					v13.setIsPending(false)

					v12.reject("agent_rollback_start_failed")
				end)

				if success and result or v7 ~= v8 then
					return success and result
				end

				v7 = nil
				local placeId = v8.target.placeId
				local v12 = v5[placeId]

				if v12 == nil then
					local signal, v13 = Signals.createSignal(false)
					v12 = { getIsPending = signal, setIsPending = v13 }

					v5[placeId] = v12
				end

				v12.setIsPending(false)

				v8.reject("agent_rollback_start_failed")

				return success and result
			end
		end

		if v7 ~= v8 then
			return false
		end

		v7 = nil
		local placeId = v8.target.placeId
		local v10 = v5[placeId]

		if v10 == nil then
			local signal, v11 = Signals.createSignal(false)
			v10 = { getIsPending = signal, setIsPending = v11 }

			v5[placeId] = v10
		end

		v10.setIsPending(false)

		v8.reject("agent_rollback_start_failed")

		return false
	end

	return {
		getIsPendingForPlaceId = function(p2)
			local v8 = v5[p2]

			if v8 == nil then
				local signal, v9 = Signals.createSignal(false)
				v8 = { getIsPending = signal, setIsPending = v9 }

				v5[p2] = v8
			end

			return v8.getIsPending
		end,
		registerTurnStarter = function(p2, p3, p4): boolean
			if v6 ~= nil and v6.registration ~= p3 then
				return false
			end

			local v8 = v7

			if
				v8 ~= nil
				and (v8.target.placeId ~= p2.placeId or v8.target.universeId ~= p2.universeId)
				and v7 == v8
			then
				v7 = nil
				local placeId = v8.target.placeId
				local v9 = v5[placeId]

				if v9 == nil then
					local signal, v10 = Signals.createSignal(false)
					v9 = { getIsPending = signal, setIsPending = v10 }

					v5[placeId] = v9
				end

				v9.setIsPending(false)

				v8.reject("agent_rollback_start_failed")
			end

			v6 = { target = p2, registration = p3, startTurn = p4 }

			return true
		end,
		unregisterTurnStarter = function(p2)
			if v6 == nil or v6.registration ~= p2 then
				return
			end

			v6 = nil
			local v8 = v7

			if v8 ~= nil then
				if v7 ~= v8 then
					return
				end

				v7 = nil
				local placeId = v8.target.placeId
				local v9 = v5[placeId]

				if v9 == nil then
					local signal, v10 = Signals.createSignal(false)
					v9 = { getIsPending = signal, setIsPending = v10 }

					v5[placeId] = v9
				end

				v9.setIsPending(false)

				v8.reject("agent_rollback_start_failed")
			end
		end,
		beginRequest = beginRequest,
		setRequestData = setRequestData,
		failRequest = function(p2): boolean
			local v8 = v7

			if v8 == nil or v8.id ~= p2 then
				return false
			end

			if v7 ~= v8 then
				return true
			end

			v7 = nil
			local placeId = v8.target.placeId
			local v9 = v5[placeId]

			if v9 == nil then
				local signal, v10 = Signals.createSignal(false)
				v9 = { getIsPending = signal, setIsPending = v10 }

				v5[placeId] = v9
			end

			v9.setIsPending(false)

			v8.reject("agent_rollback_start_failed")

			return true
		end,
		cancelRequestForPlaceId = function(p2): boolean
			local v8 = v7

			if v8 == nil or v8.target.placeId ~= p2 then
				return false
			end

			if v7 ~= v8 then
				return true
			end

			v7 = nil
			local placeId = v8.target.placeId
			local v9 = v5[placeId]

			if v9 == nil then
				local signal, v10 = Signals.createSignal(false)
				v9 = { getIsPending = signal, setIsPending = v10 }

				v5[placeId] = v9
			end

			v9.setIsPending(false)

			v8.reject("agent_rollback_cancelled")

			return true
		end,
		request = function(p2, p3)
			local v8, v9 = beginRequest(p2)

			if v8 ~= nil then
				setRequestData(v8, p3)
			end

			return v9
		end,
		reset = function()
			local v8 = v7

			if v8 ~= nil and v7 == v8 then
				v7 = nil
				local placeId = v8.target.placeId
				local v9 = v5[placeId]

				if v9 == nil then
					local signal, v10 = Signals.createSignal(false)
					v9 = { getIsPending = signal, setIsPending = v10 }

					v5[placeId] = v9
				end

				v9.setIsPending(false)

				v8.reject("agent_rollback_start_failed")
			end

			v6 = nil
		end
	}
end

return createAgentRollbackRequestStore
