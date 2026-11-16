local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

local AcpProtocol = require(script.Parent.Acp.AcpProtocol)
local turnState = require(script.Parent.turnState)
require(script.Parent.types)
local decodeFundingError = require(script.Parent.decodeFundingError)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData

local SharedFlags2 = require(parent.SharedFlags)
local FFlagBuildExperiencePromptFailureTelemetry = SharedFlags2.FFlagBuildExperiencePromptFailureTelemetry
local SharedFlags3 = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags3.FFlagBuildExperienceLibrary

local function createTurnHandle(p: string, requestId, cancel, p2, items)
	local signal, v = createSignal(p2 or turnState.createEmptyTurnState(p, requestId))

	local turnId = nil
	local v2 = {}
	local v3 = {}
	local v4 = 1
	local set = {}
	local latestProcessedSequenceNumber = nil
	local v5 = nil
	local v6 = 0
	local v7 = nil

	local function noteProcessedSequenceNumber(p3: number): boolean -- 2 equivalent calls inferred from this helper
		if set[p3] == true then
			return false
		end

		set[p3] = true

		if latestProcessedSequenceNumber == nil then
			latestProcessedSequenceNumber = p3
			v5 = p3
		elseif latestProcessedSequenceNumber < p3 then
			v6 += p3 - latestProcessedSequenceNumber - 1
			latestProcessedSequenceNumber = p3
		elseif p3 < v5 then
			v6 += v5 - p3 - 1
			v5 = p3
		else
			v6 -= 1
		end

		return true
	end

	local function hasSequenceGap(): boolean
		return v6 > 0
	end

	if items ~= nil then
		for _, item in items do
			if not (typeof(item) == "number" and set[item] ~= true) then
				continue
			end

			set[item] = true

			if latestProcessedSequenceNumber == nil then
				latestProcessedSequenceNumber = item
				v5 = item
			elseif latestProcessedSequenceNumber < item then
				v6 += item - latestProcessedSequenceNumber - 1
				latestProcessedSequenceNumber = item
			elseif item < v5 then
				v6 += v5 - item - 1
				v5 = item
			else
				v6 -= 1
			end
		end
	end

	local function onNotification(p3)
		local v8 = v4
		v4 += 1
		v2[v8] = p3
		return function()
			v2[v8] = nil
		end
	end

	local function onUpdate(p3)
		local v8 = v4
		v4 += 1
		v3[v8] = p3
		return function()
			v3[v8] = nil
		end
	end

	local function fireUpdateHandlers(update, p3: number?)
		for _, v8 in v3 do
			local success, result = pcall(function()
				v8(update, p3)
			end)

			if not success then
				warn(("CreatorAgentClient onUpdate handler errored: %s"):format((tostring(result))))
			end
		end
	end

	local function mutate(fn) -- 3 equivalent calls inferred from this helper
		v(function(p3)
			if p3.isDone then
				return p3
			end

			local clone = table.clone(p3)
			fn(clone)
			return clone
		end)
	end

	local function fireHandlers(notification)
		for _, v8 in v2 do
			local success, result = pcall(function()
				v8(notification)
			end)

			if not success then
				warn(("CreatorAgentClient onNotification handler errored: %s"):format((tostring(result))))
			end
		end
	end

	local function completeFromResponse(response) -- 1 equivalent call inferred from this helper
		if response.error then
			local err = response.error
			local function fn(p3)
				p3.error = tostring(err.message or "JSON-RPC error")
				p3.errorCode = tonumber(err.code)

				if FFlagBuildExperienceModelPickerData then
					local fundingReason, fundingDetails = decodeFundingError(err)
					p3.fundingReason = fundingReason
					p3.fundingDetails = fundingDetails
				end

				if FFlagBuildExperiencePromptFailureTelemetry then
					p3.requestFailure = { kind = "rpc_error" }
				end

				p3.status = "failed"
				p3.isDone = true
			end

			mutate(fn) -- inferred equivalent call
		end
	end

	local function getEventSequenceId(p3, p4)
		local sequenceId = p3.sequenceId

		if typeof(sequenceId) == "number" then
			return sequenceId
		end

		local sequenceNumber

		if p4 ~= nil then
			sequenceNumber = p4.sequenceNumber
		end

		if typeof(sequenceNumber) == "number" then
			return sequenceNumber
		end

		return nil
	end

	local function applyTerminalUpdate(update) -- 1 equivalent call inferred from this helper
		local v8

		if update.sessionUpdate == "state_change" then
			v8 = update.state == "idle"
		else
			v8 = false
		end

		if not v8 and signal(false).status ~= "queued" then
			return
		end

		local function fn(p3)
			if p3.status == "queued" then
				p3.status = "streaming"
			end

			if v8 then
				local stopReason = typeof(update.stop_reason) ~= "string" and "end_turn" or update.stop_reason
				p3.stopReason = stopReason
				p3.status = stopReason == "cancelled" and "cancelled" or "succeeded"
				p3.isDone = true
			end
		end

		mutate(fn) -- inferred equivalent call
	end

	local function dispatchFrame(data, p3, flag: boolean?)
		if signal(false).isDone then
			return false
		end

		local v8 = false

		if data.kind == "notification" then
			if data.notification.method == AcpProtocol.Notifications.SessionUpdate then
				local update = data.notification.params and data.notification.params.update

				if update ~= nil then
					local v9 = update.sequenceId

					if typeof(v9) ~= "number" then
						if p3 == nil then
							v9 = nil
						else
							v9 = p3.sequenceNumber
						end

						if typeof(v9) ~= "number" then
							v9 = nil
						end
					end

					if FFlagBuildExperienceModelPickerData and v9 ~= nil and v7 ~= nil and v9 <= v7 then
						return false
					end

					if v9 == nil then
						v8 = true
					else
						v8 = noteProcessedSequenceNumber(v9) -- inferred equivalent call
					end

					if FFlagBuildExperienceModelPickerData and not v8 then
						return false
					end

					if turnId == nil then
						turnId = turnState.extractTurnId(update)
					end

					applyTerminalUpdate(update) -- inferred equivalent call

					if FFlagBuildExperiencePromptFailureTelemetry and v8 then
						fireUpdateHandlers(update, v9)
					end
				end
			end

			if flag == false then
				return v8
			end

			fireHandlers(data.notification)
		elseif data.kind == "response" then
			completeFromResponse(data.response) -- inferred equivalent call
			return data.response.error ~= nil
		end

		return v8
	end

	local isAccepted, fn

	if FFlagBuildExperienceLibrary then
		local v8
		isAccepted, v8 = createSignal(false)
		fn = function()
			v8(true)
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
		noteProcessedSequenceNumber = function(p3: number)
			noteProcessedSequenceNumber(p3) -- inferred equivalent call
		end,
		setHistoryBoundary = FFlagBuildExperienceModelPickerData and function(p3: number)
			if v7 == nil then
				v7 = p3
			end
		end or nil,
		cancel = cancel,
		isAccepted = isAccepted
	}, {
		dispatchFrame = dispatchFrame,
		noteProcessedSequenceNumber = noteProcessedSequenceNumber,
		fail = function(err: string, errorCode: number?, requestFailure, fundingReason, fundingDetails)
			local function fn(p3)
				p3.error = err
				p3.errorCode = errorCode

				if FFlagBuildExperienceModelPickerData then
					p3.fundingReason = fundingReason
					p3.fundingDetails = fundingDetails
				end

				if FFlagBuildExperiencePromptFailureTelemetry then
					p3.requestFailure = requestFailure
				end

				p3.status = "failed"
				p3.isDone = true
			end

			mutate(fn) -- inferred equivalent call
		end,
		markCancelled = function()
			local function fn(clone)
				clone.status = "cancelled"
				clone.stopReason = "cancelled"
				clone.isDone = true
			end

			v(function(p3)
				if p3.isDone then
					return p3
				end

				local clone = table.clone(p3)
				fn(clone)
				return clone
			end)
		end,
		markAccepted = fn,
		isDone = function()
			return signal(false).isDone
		end,
		requestId = requestId
	}
end

return createTurnHandle
