local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals").createSignal

local AcpProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/AcpProtocol")
local turnState = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/turnState")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local decodeFundingError = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/decodeFundingError")
local fFlagBuildExperienceModelPickerData = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceModelPickerData

local fFlagBuildExperiencePromptFailureTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperiencePromptFailureTelemetry
local fFlagBuildExperienceLibrary = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceLibrary

local function createTurnHandle(p2, p3, p4, p5, items)
	local signal, v5 = createSignal(p5 or turnState.createEmptyTurnState(p2, p3))

	local turnId = nil
	local v6 = {}
	local v7 = {}
	local v8 = 1
	local set = {}
	local latestProcessedSequenceNumber = nil
	local v9 = nil
	local v10 = 0
	local v11 = nil

	local function noteProcessedSequenceNumber(p6): boolean
		if set[p6] == true then
			return false
		end

		set[p6] = true

		if latestProcessedSequenceNumber == nil then
			latestProcessedSequenceNumber = p6
			v9 = p6
		elseif latestProcessedSequenceNumber < p6 then
			v10 += p6 - latestProcessedSequenceNumber - 1
			latestProcessedSequenceNumber = p6
		elseif p6 < v9 then
			v10 += v9 - p6 - 1
			v9 = p6
		else
			v10 -= 1
		end

		return true
	end

	local function hasSequenceGap(): boolean
		return v10 > 0
	end

	if items ~= nil then
		for k, item in items do
			if not (typeof(item) == "number" and set[item] ~= true) then
				continue
			end

			set[item] = true

			if latestProcessedSequenceNumber == nil then
				latestProcessedSequenceNumber = item
				v9 = item
			elseif latestProcessedSequenceNumber < item then
				v10 += item - latestProcessedSequenceNumber - 1
				latestProcessedSequenceNumber = item
			elseif item < v9 then
				v10 += v9 - item - 1
				v9 = item
			else
				v10 -= 1
			end
		end
	end

	local function onNotification(p6)
		local v12 = v8
		v8 += 1
		v6[v12] = p6
		return function()
			v6[v12] = nil
		end
	end

	local function onUpdate(p6)
		local v12 = v8
		v8 += 1
		v7[v12] = p6
		return function()
			v7[v12] = nil
		end
	end

	local function fireUpdateHandlers(update, p6)
		for k, v12 in v7 do
			local success, result = pcall(function()
				v12(update, p6)
			end)

			if not success then
				warn(("CreatorAgentClient onUpdate handler errored: %s"):format((tostring(result))))
			end
		end
	end

	local function mutate(callback)
		v5(function(p6)
			if p6.isDone then
				return p6
			end

			local clone = table.clone(p6)
			callback(clone)
			return clone
		end)
	end

	local function fireHandlers(notification)
		for k, v12 in v6 do
			local success, result = pcall(function()
				v12(notification)
			end)

			if not success then
				warn(("CreatorAgentClient onNotification handler errored: %s"):format((tostring(result))))
			end
		end
	end

	local function completeFromResponse(p6)
		if p6.error then
			local err = p6.error
			local function fn(clone)
				clone.error = tostring(err.message or "JSON-RPC error")
				clone.errorCode = tonumber(err.code)

				if fFlagBuildExperienceModelPickerData then
					local v12, v13 = decodeFundingError(err)
					clone.fundingReason = v12
					clone.fundingDetails = v13
				end

				if fFlagBuildExperiencePromptFailureTelemetry then
					clone.requestFailure = { kind = "rpc_error" }
				end

				clone.status = "failed"
				clone.isDone = true
			end

			v5(function(p7)
				if p7.isDone then
					return p7
				end

				local clone = table.clone(p7)
				fn(clone)
				return clone
			end)
		end
	end

	local function getEventSequenceId(p6, p7)
		local sequenceId = p6.sequenceId

		if typeof(sequenceId) == "number" then
			return sequenceId
		end

		local sequenceNumber = if p7 ~= nil then p7.sequenceNumber else nil

		if typeof(sequenceNumber) == "number" then
			return sequenceNumber
		end

		return nil
	end

	local function applyTerminalUpdate(data)
		local v12 = data.sessionUpdate == "state_change" and data.state == "idle"

		if not v12 and signal(false).status ~= "queued" then
			return
		end

		local function fn(clone)
			if clone.status == "queued" then
				clone.status = "streaming"
			end

			if v12 then
				local v13 = typeof(data.stop_reason) ~= "string" and "end_turn" or data.stop_reason
				clone.stopReason = v13
				clone.status = v13 == "cancelled" and "cancelled" or "succeeded"
				clone.isDone = true
			end
		end

		v5(function(p6)
			if p6.isDone then
				return p6
			end

			local clone = table.clone(p6)
			fn(clone)
			return clone
		end)
	end

	local function dispatchFrame(data, p6, p7)
		if signal(false).isDone then
			return false
		end

		local v12 = false

		if data.kind == "notification" then
			if data.notification.method == AcpProtocol.Notifications.SessionUpdate then
				local update = data.notification.params and data.notification.params.update

				if update ~= nil then
					local v13 = update.sequenceId

					if typeof(v13) ~= "number" then
						v13 = if p6 ~= nil then p6.sequenceNumber else nil

						if typeof(v13) ~= "number" then
							v13 = nil
						end
					end

					if fFlagBuildExperienceModelPickerData and v13 ~= nil and v11 ~= nil and v13 <= v11 then
						return false
					end

					if v13 == nil then
						v12 = true
					elseif set[v13] == true then
						v12 = false
					else
						set[v13] = true

						if latestProcessedSequenceNumber == nil then
							latestProcessedSequenceNumber = v13
							v9 = v13
						elseif latestProcessedSequenceNumber < v13 then
							v10 += v13 - latestProcessedSequenceNumber - 1
							latestProcessedSequenceNumber = v13
						elseif v13 < v9 then
							v10 += v9 - v13 - 1
							v9 = v13
						else
							v10 -= 1
						end

						v12 = true
					end

					if fFlagBuildExperienceModelPickerData and not v12 then
						return false
					end

					if turnId == nil then
						turnId = turnState.extractTurnId(update)
					end

					local v14 = update.sessionUpdate == "state_change" and update.state == "idle"

					if v14 or signal(false).status == "queued" then
						local function fn(clone)
							if clone.status == "queued" then
								clone.status = "streaming"
							end

							if v14 then
								local v15 = typeof(update.stop_reason) ~= "string" and "end_turn"
									or update.stop_reason
								clone.stopReason = v15
								clone.status = v15 == "cancelled" and "cancelled" or "succeeded"
								clone.isDone = true
							end
						end

						v5(function(p8)
							if p8.isDone then
								return p8
							end

							local clone = table.clone(p8)
							fn(clone)
							return clone
						end)
					end

					if fFlagBuildExperiencePromptFailureTelemetry and v12 then
						fireUpdateHandlers(update, v13)
					end
				end
			end

			if p7 == false then
				return v12
			end

			fireHandlers(data.notification)
		elseif data.kind == "response" then
			local response = data.response

			if response.error then
				local err = response.error
				local function fn(clone)
					clone.error = tostring(err.message or "JSON-RPC error")
					clone.errorCode = tonumber(err.code)

					if fFlagBuildExperienceModelPickerData then
						local v13, v14 = decodeFundingError(err)
						clone.fundingReason = v13
						clone.fundingDetails = v14
					end

					if fFlagBuildExperiencePromptFailureTelemetry then
						clone.requestFailure = { kind = "rpc_error" }
					end

					clone.status = "failed"
					clone.isDone = true
				end

				v5(function(p8)
					if p8.isDone then
						return p8
					end

					local clone = table.clone(p8)
					fn(clone)
					return clone
				end)
			end

			v12 = data.response.error ~= nil
		end

		return v12
	end

	local v12, fn

	if fFlagBuildExperienceLibrary then
		local v13
		v12, v13 = createSignal(false)
		fn = function()
			v13(true)
		end
	end

	return {
		state = signal,
		getTurnId = function()
			return turnId
		end,
		onNotification = onNotification,
		onUpdate = onUpdate,
		getLatestProcessedSequenceNumber = function()
			return latestProcessedSequenceNumber
		end,
		hasSequenceGap = hasSequenceGap,
		noteProcessedSequenceNumber = function(p6)
			if set[p6] == true then
				return
			end

			set[p6] = true

			if latestProcessedSequenceNumber == nil then
				latestProcessedSequenceNumber = p6
				v9 = p6
			elseif latestProcessedSequenceNumber < p6 then
				v10 += p6 - latestProcessedSequenceNumber - 1
				latestProcessedSequenceNumber = p6
			elseif p6 < v9 then
				v10 += v9 - p6 - 1
				v9 = p6
			else
				v10 -= 1
			end
		end,
		setHistoryBoundary = fFlagBuildExperienceModelPickerData and function(p6)
			if v11 == nil then
				v11 = p6
			end
		end or nil,
		cancel = p4,
		isAccepted = v12
	}, {
		dispatchFrame = dispatchFrame,
		noteProcessedSequenceNumber = noteProcessedSequenceNumber,
		fail = function(err, errorCode, requestFailure, fundingReason, fundingDetails)
			local function fn(clone)
				clone.error = err
				clone.errorCode = errorCode

				if fFlagBuildExperienceModelPickerData then
					clone.fundingReason = fundingReason
					clone.fundingDetails = fundingDetails
				end

				if fFlagBuildExperiencePromptFailureTelemetry then
					clone.requestFailure = requestFailure
				end

				clone.status = "failed"
				clone.isDone = true
			end

			v5(function(p6)
				if p6.isDone then
					return p6
				end

				local clone = table.clone(p6)
				fn(clone)
				return clone
			end)
		end,
		markCancelled = function()
			local function fn(clone)
				clone.status = "cancelled"
				clone.stopReason = "cancelled"
				clone.isDone = true
			end

			v5(function(p6)
				if p6.isDone then
					return p6
				end

				local clone = table.clone(p6)
				fn(clone)
				return clone
			end)
		end,
		markAccepted = fn,
		isDone = function()
			return signal(false).isDone
		end,
		requestId = p3
	}
end

return createTurnHandle
