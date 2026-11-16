local BuildExperience = script:FindFirstAncestor("BuildExperience")
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)

local v = {
	creating = true,
	processing = true,
	created = true,
	active = true,
	retryable_error = true,
	outcome_unknown = true,
	payment_required = true,
	failed = true
}

local function isNonemptyString(value): boolean -- 15 equivalent calls inferred from this helper
	return type(value) == "string" and value ~= ""
end

local function isCount(value): boolean -- 26 equivalent calls inferred from this helper
	return type(value) == "number" and value >= 0 and value < 1e999 and value % 1 == 0
end

local function isRecord(data, value: string, value2: string)
	if type(data) ~= "table" then
		return false
	end

	local v2

	if data.sessionId == value and data.toolCallId == value2 then
		v2 = isNonemptyString(value) -- inferred equivalent call

		if v2 then
			v2 = isNonemptyString(value2) -- inferred equivalent call

			if v2 then
				v2 = isCount(data.universeId) -- inferred equivalent call

				if v2 then
					if data.universeId > 0 then
						v2 = isNonemptyString(data.idempotencyKey) -- inferred equivalent call

						if v2 then
							local campaignId, createdAtMs, updatedAtMs, v3, campaignStatus, durationDays, displayAmountRobux

							if data.campaignOption == nil then
								if data.fundingType == "free" or data.fundingType == "paid" then
									if data.durationDays == nil and data.displayAmountRobux == nil then
										if type(data.phase) == "string" and v[data.phase] == true then
											if data.phase == "active" or data.phase == "created" then
												campaignId = data.campaignId
												v2 = isNonemptyString(campaignId) -- inferred equivalent call
											else
												v2 = data.campaignId == nil
											end

											if v2 then
												if data.campaignStatus == nil then
													if
														(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
														and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
													then
														createdAtMs = data.createdAtMs
														v2 = isCount(createdAtMs) -- inferred equivalent call

														if v2 then
															updatedAtMs = data.updatedAtMs
															v3 = isCount(updatedAtMs) -- inferred equivalent call
															return v3 and data.updatedAtMs >= data.createdAtMs
														end
													else
														return false
													end
												else
													campaignStatus = data.campaignStatus
													v2 = isNonemptyString(campaignStatus) -- inferred equivalent call

													if v2 then
														if
															(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
															and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
														then
															createdAtMs = data.createdAtMs
															v2 = isCount(createdAtMs) -- inferred equivalent call

															if v2 then
																updatedAtMs = data.updatedAtMs
																v3 = isCount(updatedAtMs) -- inferred equivalent call
																return v3 and data.updatedAtMs >= data.createdAtMs
															end
														else
															return false
														end
													end
												end
											end
										else
											return false
										end
									else
										durationDays = data.durationDays
										v2 = isCount(durationDays) -- inferred equivalent call

										if v2 then
											if data.durationDays > 0 then
												displayAmountRobux = data.displayAmountRobux
												v2 = isCount(displayAmountRobux) -- inferred equivalent call

												if v2 then
													if type(data.phase) == "string" and v[data.phase] == true then
														if data.phase == "active" or data.phase == "created" then
															campaignId = data.campaignId
															v2 = isNonemptyString(campaignId) -- inferred equivalent call
														else
															v2 = data.campaignId == nil
														end

														if v2 then
															if data.campaignStatus == nil then
																if
																	(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
																	and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
																then
																	createdAtMs = data.createdAtMs
																	v2 = isCount(createdAtMs) -- inferred equivalent call

																	if v2 then
																		updatedAtMs = data.updatedAtMs
																		v3 = isCount(updatedAtMs) -- inferred equivalent call
																		return v3
																			and data.updatedAtMs >= data.createdAtMs
																	end
																else
																	return false
																end
															else
																campaignStatus = data.campaignStatus
																v2 = isNonemptyString(campaignStatus) -- inferred equivalent call

																if v2 then
																	if
																		(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
																		and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
																	then
																		createdAtMs = data.createdAtMs
																		v2 = isCount(createdAtMs) -- inferred equivalent call

																		if v2 then
																			updatedAtMs = data.updatedAtMs
																			v3 = isCount(updatedAtMs) -- inferred equivalent call
																			return v3
																				and data.updatedAtMs >= data.createdAtMs
																		end
																	else
																		return false
																	end
																end
															end
														end
													else
														return false
													end
												end
											else
												return false
											end
										end
									end
								else
									return false
								end
							else
								v2 = isNonemptyString(data.campaignOption) -- inferred equivalent call

								if v2 then
									if data.fundingType == "free" or data.fundingType == "paid" then
										if data.durationDays == nil and data.displayAmountRobux == nil then
											if type(data.phase) == "string" and v[data.phase] == true then
												if data.phase == "active" or data.phase == "created" then
													campaignId = data.campaignId
													v2 = isNonemptyString(campaignId) -- inferred equivalent call
												else
													v2 = data.campaignId == nil
												end

												if v2 then
													if data.campaignStatus == nil then
														if
															(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
															and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
														then
															createdAtMs = data.createdAtMs
															v2 = isCount(createdAtMs) -- inferred equivalent call

															if v2 then
																updatedAtMs = data.updatedAtMs
																v3 = isCount(updatedAtMs) -- inferred equivalent call
																return v3 and data.updatedAtMs >= data.createdAtMs
															end
														else
															return false
														end
													else
														campaignStatus = data.campaignStatus
														v2 = isNonemptyString(campaignStatus) -- inferred equivalent call

														if v2 then
															if
																(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
																and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
															then
																createdAtMs = data.createdAtMs
																v2 = isCount(createdAtMs) -- inferred equivalent call

																if v2 then
																	updatedAtMs = data.updatedAtMs
																	v3 = isCount(updatedAtMs) -- inferred equivalent call
																	return v3 and data.updatedAtMs >= data.createdAtMs
																end
															else
																return false
															end
														end
													end
												end
											else
												return false
											end
										else
											durationDays = data.durationDays
											v2 = isCount(durationDays) -- inferred equivalent call

											if v2 then
												if data.durationDays > 0 then
													displayAmountRobux = data.displayAmountRobux
													v2 = isCount(displayAmountRobux) -- inferred equivalent call

													if v2 then
														if type(data.phase) == "string" and v[data.phase] == true then
															if data.phase == "active" or data.phase == "created" then
																campaignId = data.campaignId
																v2 = isNonemptyString(campaignId) -- inferred equivalent call
															else
																v2 = data.campaignId == nil
															end

															if v2 then
																if data.campaignStatus == nil then
																	if
																		(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
																		and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
																	then
																		createdAtMs = data.createdAtMs
																		v2 = isCount(createdAtMs) -- inferred equivalent call

																		if v2 then
																			updatedAtMs = data.updatedAtMs
																			v3 = isCount(updatedAtMs) -- inferred equivalent call
																			return v3
																				and data.updatedAtMs >= data.createdAtMs
																		end
																	else
																		return false
																	end
																else
																	campaignStatus = data.campaignStatus
																	v2 = isNonemptyString(campaignStatus) -- inferred equivalent call

																	if v2 then
																		if
																			(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
																			and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
																		then
																			createdAtMs = data.createdAtMs
																			v2 = isCount(createdAtMs) -- inferred equivalent call

																			if v2 then
																				updatedAtMs = data.updatedAtMs
																				v3 = isCount(updatedAtMs) -- inferred equivalent call
																				return v3
																					and data.updatedAtMs >= data.createdAtMs
																			end
																		else
																			return false
																		end
																	end
																end
															end
														else
															return false
														end
													end
												else
													return false
												end
											end
										end
									else
										return false
									end
								end
							end
						end
					else
						return false
					end
				end
			end
		end
	else
		return false
	end

	return v2
end

local function readRecord(p) -- 3 equivalent calls inferred from this helper
	local clone = table.clone(p)

	if clone.phase == "active" then
		clone.phase = "created"
	end

	return clone
end

local function isDurableAttempt(data)
	local v2 = isCount(data.userId) -- inferred equivalent call

	if not v2 then
		return v2
	end

	if data.userId > 0 then
		v2 = isCount(data.attemptStartedAtMs) -- inferred equivalent call

		if v2 then
			if
				type(data.hasAmbiguousFailure) == "boolean"
				and (data.campaignOption == "feedback" or data.campaignOption == "plays")
				and data.durationDays ~= nil
			then
				return data.displayAmountRobux ~= nil
			end

			return false
		end
	else
		return false
	end

	return v2
end

local function sameAttempt(data, data2): boolean
	if
		data.userId == data2.userId
		and data.universeId == data2.universeId
		and data.idempotencyKey == data2.idempotencyKey
		and data.campaignOption == data2.campaignOption
		and data.fundingType == data2.fundingType
		and data.durationDays == data2.durationDays
		and data.displayAmountRobux == data2.displayAmountRobux
		and data.createdAtMs == data2.createdAtMs
	then
		return data.attemptStartedAtMs == data2.attemptStartedAtMs
	end

	return false
end

local function readNamespace(p)
	local adCampaignCards = p.adCampaignCards

	if adCampaignCards == nil then
		return { sessions = {} }, nil
	end

	if type(adCampaignCards) == "table" and type(adCampaignCards.sessions) == "table" then
		return adCampaignCards, nil
	end

	return nil, "malformed_storage"
end

local function createAdCampaignCardStorage(p)
	local function readData()
		local success, result, v2 = pcall(p.readData)
		return success and result == true, v2
	end

	local function writeData(clone) -- 3 equivalent calls inferred from this helper
		local success, result = pcall(p.writeData, clone)
		return success and result == true
	end

	local v2 = nil
	local v3 = {}

	local v4 = {}

	local v5 = {}

	local function beforeUnsentPreflight(p2: string, p3: string, data)
		local v6

		if v5[p2] ~= nil then
			v6 = v5[p2][p3]
		end

		if v6 ~= nil and data ~= nil then
			local staged = v6.staged

			if
				sameAttempt(staged, data)
				and data.phase == staged.phase
				and data.updatedAtMs == staged.updatedAtMs
				and data.hasAmbiguousFailure == staged.hasAmbiguousFailure
				and data.lastErrorCode == staged.lastErrorCode
			then
				return v6.previous, true
			end
		end

		return data, false
	end

	local function load()
		if v2 ~= nil then
			return v2, nil
		end

		local success, result, v6 = pcall(p.readData)

		if not success or result ~= true then
			return nil, "storage_unavailable"
		end

		local v7, v8 = readNamespace(v6)
		v2 = v7
		return v7, v8
	end

	local function get(sessionId: string, toolCallId: string)
		local v6

		if v3[sessionId] ~= nil then
			v6 = v3[sessionId][toolCallId]
		end

		if v6 == nil then
			local v7

			if v4[sessionId] ~= nil then
				v7 = v4[sessionId][toolCallId]
			end

			if v7 == nil then
				local v8, v9

				if v2 == nil then
					local success, result, v10 = pcall(p.readData)

					if success and result == true then
						v8, v9 = readNamespace(v10)
						v2 = v8
					else
						v9 = "storage_unavailable"
					end
				else
					v8 = v2
				end

				if v8 ~= nil and isNonemptyString(sessionId) and isNonemptyString(toolCallId) then -- inferred equivalent call
					local session = v8.sessions[sessionId]

					if session ~= nil and type(session) ~= "table" then
						return {
							isAvailable = false,
							isPersisted = false,
							errorCode = "malformed_session"
						}
					end

					local v10

					if session ~= nil then
						v10 = session[toolCallId]
					end

					if
						v10 ~= nil
						and (not isRecord(v10, sessionId, toolCallId) or FFlagBuildAgentAdCampaignCard and v10.userId ~= nil and not isDurableAttempt(v10))
					then
						return {
							isAvailable = false,
							isPersisted = false,
							errorCode = "malformed_record"
						}
					end

					local v11

					if FFlagBuildAgentAdCampaignCard then
						v10, v11 = beforeUnsentPreflight(sessionId, toolCallId, v10)
					else
						v11 = false
					end

					local v12 = {
						isAvailable = true,
						isPersisted = not v11,
						record = 0
					}
					local clone

					if v10 ~= nil then
						clone = table.clone(v10)

						if clone.phase == "active" then
							clone.phase = "created"
						end
					end

					v12.record = clone
					return v12
				end

				return {
					isAvailable = false,
					isPersisted = false,
					errorCode = v9 or "invalid_identity"
				}
			end

			return { isAvailable = true, isPersisted = false, record = readRecord(v7) } -- inferred equivalent call
		end

		return { isAvailable = true, isPersisted = false, record = readRecord(v6) } -- inferred equivalent call
	end

	local function retryWrites(): boolean
		if next(v3) == nil then
			return true
		end

		local success, result, v6 = pcall(p.readData)

		if not success or result ~= true then
			return false
		end

		local v7 = readNamespace(v6)

		if v7 == nil then
			return false
		end

		local clone = table.clone(v7)
		clone.sessions = table.clone(v7.sessions)
		local v8 = {}
		local v9 = false

		for k, v10 in v3 do
			local session = clone.sessions[k]

			if session == nil or type(session) == "table" then
				local clones = session == nil and {} or table.clone(session)

				for k2, v11 in v10 do
					local v12 = clones[k2]

					if
						(v12 == nil or isRecord(v12, k, k2))
						and (v12 == nil or v12.universeId == v11.universeId and not (v12.updatedAtMs > v11.updatedAtMs) and (v12.campaignId == nil or v12.campaignId == v11.campaignId) and (not FFlagBuildAgentAdCampaignCard or v11.userId == nil or sameAttempt(v12, v11)))
					then
						clones[k2] = table.clone(v11)
						v9 = true
						continue
					end

					v8[k] = v8[k] or {}
					v8[k][k2] = true
				end

				clone.sessions[k] = clones
			else
				v8[k] = {}

				for k2 in v10 do
					v8[k][k2] = true
				end
			end
		end

		for k, v10 in v8 do
			for k2 in v10 do
				local clones = v4[k] or {}
				clones[k2] = table.clone(v3[k][k2])
				v4[k] = clones
				v3[k][k2] = nil
			end

			if next(v3[k]) == nil then
				v3[k] = nil
			end
		end

		if not v9 then
			return next(v8) == nil
		end

		local clone2 = table.clone(v6)
		clone2.adCampaignCards = clone

		if not writeData(clone2) then -- inferred equivalent call
			return false
		end

		v2 = clone
		table.clear(v3)
		return next(v8) == nil
	end

	local function retain(data)
		if not isRecord(data, data.sessionId, data.toolCallId) then
			return false, false
		end

		local clonesByToolCallId = v3[data.sessionId] or {}
		clonesByToolCallId[data.toolCallId] = table.clone(data)
		v3[data.sessionId] = clonesByToolCallId
		return retryWrites(), true
	end

	return {
		get = get,
		list = function(value: string)
			if not isNonemptyString(value) then -- inferred equivalent call
				return { isAvailable = false, records = {}, errorCode = "invalid_identity" }
			end

			local v6, errorCode

			if v2 == nil then
				local success, result, v7 = pcall(p.readData)

				if success and result == true then
					v6, errorCode = readNamespace(v7)
					v2 = v6
				else
					errorCode = "storage_unavailable"
				end
			else
				v6 = v2
			end

			local v7

			if v6 ~= nil then
				v7 = v6.sessions[value]
			end

			if v7 ~= nil and type(v7) ~= "table" then
				v7 = nil
				errorCode = "malformed_session"
			end

			local v8 = v7 == nil and {} or table.clone(v7)

			for k, v9 in v4[value] or {} do
				v8[k] = v9
			end

			for k, v9 in v3[value] or {} do
				v8[k] = v9
			end

			local records = {}

			for k, v9 in v8 do
				if not (isRecord(v9, value, k) and (not FFlagBuildAgentAdCampaignCard or v9.userId == nil or isDurableAttempt(v9))) then
					continue
				end

				if FFlagBuildAgentAdCampaignCard then
					v9 = beforeUnsentPreflight(value, k, v9)
				end

				if v9 ~= nil then
					table.insert(records, readRecord(v9)) -- inferred equivalent call
				end
			end

			table.sort(records, function(a, b): boolean
				if a.createdAtMs == b.createdAtMs then
					return a.toolCallId < b.toolCallId
				end

				return a.createdAtMs < b.createdAtMs
			end)

			return {
				isAvailable = errorCode == nil,
				records = records,
				errorCode = errorCode
			}
		end,
		confirm = function(data)
			if not isRecord(data, data.sessionId, data.toolCallId) or data.phase ~= "created" then
				return false, false
			end

			local v6 = get(data.sessionId, data.toolCallId)
			local record = v6.record

			if FFlagBuildAgentAdCampaignCard and data.userId ~= nil then
				if not isDurableAttempt(data) then
					return false, false
				end

				if record == nil and not v6.isAvailable then
					return retain(data)
				end

				if record == nil or not sameAttempt(record, data) then
					return false, false
				end
			end

			if record == nil or record.campaignId == nil then
				return retain(data)
			end

			if record.campaignId == data.campaignId then
				return retryWrites() and get(data.sessionId, data.toolCallId).isPersisted, false
			end

			return false, false
		end,
		saveAttempt = function(data, p2: string?): boolean
			if
				not isRecord(data, data.sessionId, data.toolCallId)
				or not isDurableAttempt(data)
				or data.campaignId ~= nil
			then
				return false
			end

			local v6 = get(data.sessionId, data.toolCallId)

			if v6.record ~= nil and v6.record.campaignId ~= nil then
				return false
			end

			local success, result, v7 = pcall(p.readData)
			local v8

			if success and result == true then
				v8 = readNamespace(v7)
			end

			if v8 == nil then
				return false
			end

			local session = v8.sessions[data.sessionId]

			if session ~= nil and type(session) ~= "table" then
				return false
			end

			local v9

			if session ~= nil then
				v9 = session[data.toolCallId]
			end

			if
				v9 ~= nil
				and (not isRecord(v9, data.sessionId, data.toolCallId) or not isDurableAttempt(v9) or v9.campaignId ~= nil or v9.userId ~= data.userId or v9.universeId ~= data.universeId)
			then
				return false
			end

			local v10 = beforeUnsentPreflight(data.sessionId, data.toolCallId, v9)

			if v10 == nil then
				if p2 ~= nil and p2 ~= data.idempotencyKey then
					return false
				end
			elseif v10.idempotencyKey == data.idempotencyKey then
				local v11

				if data.idempotencyKey == data.toolCallId and p2 == v10.idempotencyKey then
					v11 = not v10.hasAmbiguousFailure

					if v11 then
						if v10.phase == "failed" or v10.phase == "payment_required" then
							v11 = data.phase == "creating"
						else
							v11 = false
						end
					end
				else
					v11 = false
				end

				if not (sameAttempt(v10, data) or v11) or v10.hasAmbiguousFailure and not data.hasAmbiguousFailure then
					return false
				end
			elseif
				v10.idempotencyKey ~= p2
				or v10.hasAmbiguousFailure
				or v10.phase ~= "failed" and v10.phase ~= "payment_required"
			then
				return false
			end

			local clone = table.clone(v8)
			clone.sessions = table.clone(v8.sessions)
			local clone2 = table.clone(session or {})
			clone2[data.toolCallId] = table.clone(data)
			clone.sessions[data.sessionId] = clone2
			local clone3 = table.clone(v7)
			clone3.adCampaignCards = clone
			v2 = nil

			if writeData(clone3) then -- inferred equivalent call
				if v5[data.sessionId] ~= nil then
					v5[data.sessionId][data.toolCallId] = nil
				end

				v2 = clone
				return true
			else
				if data.phase ~= "creating" then
					return false
				end

				local v11 = v5[data.sessionId] or {}
				local toolCallId = data.toolCallId
				local v12 = { staged = table.clone(data), previous = 0 }
				local previous

				if v10 ~= nil then
					previous = table.clone(v10)
				end

				v12.previous = previous
				v11[toolCallId] = v12

				v5[data.sessionId] = v11

				return false
			end
		end,
		hasPendingWrites = function(): boolean
			return next(v3) ~= nil
		end,
		retryWrites = retryWrites,
		prune = function(data): (boolean, boolean)
			if next(v3) ~= nil then
				return false, false
			end

			if not (isCount(data.nowMs) and isCount(data.retentionMs) and isCount(data.maxRecords)) then -- inferred equivalent call
				return false, false
			end

			local success, result, v6 = pcall(p.readData)

			if not success or result ~= true then
				return false, false
			end

			local v7 = readNamespace(v6)

			if v7 == nil then
				return false, false
			end

			local count = 0
			local v8 = {}

			for k, session in v7.sessions do
				if type(session) ~= "table" then
					continue
				end

				local loadedToolCallId = data.loadedToolCallIdsBySession[k]

				for k2, v9 in session do
					if not (isRecord(v9, k, k2) and v9.universeId == data.universeId) then
						continue
					end

					count += 1
					local v10

					if
						v9.campaignId == nil
						or data.settledCampaignIds[v9.campaignId] ~= true
						or loadedToolCallId == nil
					then
						v10 = false
					else
						v10 = not loadedToolCallId[k2]
					end

					if data.nowMs - v9.updatedAtMs > data.retentionMs and v10 then
						table.insert(v8, v9)
					end
				end
			end

			if count <= data.maxRecords or #v8 == 0 then
				return true, false
			end

			table.sort(v8, function(a, b): boolean
				if a.updatedAtMs ~= b.updatedAtMs then
					return a.updatedAtMs < b.updatedAtMs
				end

				if a.sessionId == b.sessionId then
					return a.toolCallId < b.toolCallId
				end

				return a.sessionId < b.sessionId
			end)

			local clone = table.clone(v7)
			clone.sessions = table.clone(v7.sessions)

			for i = 1, math.min(count - data.maxRecords, #v8) do
				local v9 = v8[i]
				local clone2 = table.clone(clone.sessions[v9.sessionId])
				clone2[v9.toolCallId] = nil
				clone.sessions[v9.sessionId] = clone2
			end

			local clone2 = table.clone(v6)
			clone2.adCampaignCards = clone

			if not writeData(clone2) then -- inferred equivalent call
				return false, false
			end

			v2 = clone
			return true, true
		end,
		reset = function()
			v2 = nil
			table.clear(v3)
			table.clear(v4)
			table.clear(v5)
		end
	}
end

return createAdCampaignCardStorage
