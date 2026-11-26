local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")

local v5 = {
	creating = true,
	processing = true,
	created = true,
	active = true,
	retryable_error = true,
	outcome_unknown = true,
	payment_required = true,
	failed = true
}

local function isNonemptyString(value): boolean
	return type(value) == "string" and value ~= ""
end

local function isCount(value): boolean
	return type(value) == "number" and value >= 0 and value < 1e999 and value % 1 == 0
end

local function isRecord(data, value, value2)
	if type(data) ~= "table" then
		return false
	end

	local v6

	if data.sessionId == value and data.toolCallId == value2 then
		v6 = type(value) == "string" and value ~= ""

		if v6 then
			v6 = type(value2) == "string" and value2 ~= ""

			if v6 then
				local universeId = data.universeId

				if type(universeId) == "number" and universeId >= 0 and universeId < 1e999 then
					v6 = universeId % 1 == 0
				else
					v6 = false
				end

				if v6 then
					if data.universeId > 0 then
						local idempotencyKey = data.idempotencyKey
						v6 = type(idempotencyKey) == "string" and idempotencyKey ~= ""

						if v6 then
							local campaignId, createdAtMs, updatedAtMs, v7, campaignStatus, durationDays, displayAmountRobux

							if data.campaignOption == nil then
								if data.fundingType == "free" or data.fundingType == "paid" then
									if data.durationDays == nil and data.displayAmountRobux == nil then
										if type(data.phase) == "string" and v5[data.phase] == true then
											if data.phase == "active" or data.phase == "created" then
												campaignId = data.campaignId
												v6 = type(campaignId) == "string" and campaignId ~= ""
											else
												v6 = data.campaignId == nil
											end

											if v6 then
												if data.campaignStatus == nil then
													if
														(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
														and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
													then
														createdAtMs = data.createdAtMs

														if
															type(createdAtMs) == "number"
															and createdAtMs >= 0
															and createdAtMs < 1e999
														then
															v6 = createdAtMs % 1 == 0
														else
															v6 = false
														end

														if v6 then
															updatedAtMs = data.updatedAtMs

															if
																type(updatedAtMs) == "number"
																and updatedAtMs >= 0
																and updatedAtMs < 1e999
															then
																v7 = updatedAtMs % 1 == 0
															else
																v7 = false
															end

															v6 = v7 and data.updatedAtMs >= data.createdAtMs
														end
													else
														v6 = false
													end
												else
													campaignStatus = data.campaignStatus
													v6 = type(campaignStatus) == "string"
														and campaignStatus ~= ""

													if v6 then
														if
															(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
															and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
														then
															createdAtMs = data.createdAtMs

															if
																type(createdAtMs) == "number"
																and createdAtMs >= 0
																and createdAtMs < 1e999
															then
																v6 = createdAtMs % 1 == 0
															else
																v6 = false
															end

															if v6 then
																updatedAtMs = data.updatedAtMs

																if
																	type(updatedAtMs) == "number"
																	and updatedAtMs >= 0
																	and updatedAtMs < 1e999
																then
																	v7 = updatedAtMs % 1 == 0
																else
																	v7 = false
																end

																v6 = v7
																	and data.updatedAtMs >= data.createdAtMs
															end
														else
															v6 = false
														end
													end
												end
											end
										else
											v6 = false
										end
									else
										durationDays = data.durationDays

										if
											type(durationDays) == "number"
											and durationDays >= 0
											and durationDays < 1e999
										then
											v6 = durationDays % 1 == 0
										else
											v6 = false
										end

										if v6 then
											if data.durationDays > 0 then
												displayAmountRobux = data.displayAmountRobux

												if
													type(displayAmountRobux) == "number"
													and displayAmountRobux >= 0
													and displayAmountRobux < 1e999
												then
													v6 = displayAmountRobux % 1 == 0
												else
													v6 = false
												end

												if v6 then
													if
														type(data.phase) == "string"
														and v5[data.phase] == true
													then
														if
															data.phase == "active"
															or data.phase == "created"
														then
															campaignId = data.campaignId
															v6 = type(campaignId) == "string"
																and campaignId ~= ""
														else
															v6 = data.campaignId == nil
														end

														if v6 then
															if data.campaignStatus == nil then
																if
																	(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
																	and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
																then
																	createdAtMs = data.createdAtMs

																	if
																		type(createdAtMs) == "number"
																		and createdAtMs >= 0
																		and createdAtMs < 1e999
																	then
																		v6 = createdAtMs % 1 == 0
																	else
																		v6 = false
																	end

																	if v6 then
																		updatedAtMs = data.updatedAtMs

																		if
																			type(updatedAtMs) == "number"
																			and updatedAtMs >= 0
																			and updatedAtMs < 1e999
																		then
																			v7 = updatedAtMs % 1 == 0
																		else
																			v7 = false
																		end

																		v6 = v7
																			and data.updatedAtMs >= data.createdAtMs
																	end
																else
																	v6 = false
																end
															else
																campaignStatus = data.campaignStatus
																v6 = type(campaignStatus) == "string"
																	and campaignStatus ~= ""

																if v6 then
																	if
																		(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
																		and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
																	then
																		createdAtMs = data.createdAtMs

																		if
																			type(createdAtMs) == "number"
																			and createdAtMs >= 0
																			and createdAtMs < 1e999
																		then
																			v6 = createdAtMs % 1 == 0
																		else
																			v6 = false
																		end

																		if v6 then
																			updatedAtMs = data.updatedAtMs

																			if
																				type(updatedAtMs) == "number"
																				and updatedAtMs >= 0
																				and updatedAtMs < 1e999
																			then
																				v7 = updatedAtMs % 1 == 0
																			else
																				v7 = false
																			end

																			v6 = v7
																				and data.updatedAtMs >= data.createdAtMs
																		end
																	else
																		v6 = false
																	end
																end
															end
														end
													else
														v6 = false
													end
												end
											else
												v6 = false
											end
										end
									end
								else
									v6 = false
								end
							else
								local campaignOption = data.campaignOption
								v6 = type(campaignOption) == "string" and campaignOption ~= ""

								if v6 then
									if data.fundingType == "free" or data.fundingType == "paid" then
										if data.durationDays == nil and data.displayAmountRobux == nil then
											if type(data.phase) == "string" and v5[data.phase] == true then
												if data.phase == "active" or data.phase == "created" then
													campaignId = data.campaignId
													v6 = type(campaignId) == "string" and campaignId ~= ""
												else
													v6 = data.campaignId == nil
												end

												if v6 then
													if data.campaignStatus == nil then
														if
															(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
															and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
														then
															createdAtMs = data.createdAtMs

															if
																type(createdAtMs) == "number"
																and createdAtMs >= 0
																and createdAtMs < 1e999
															then
																v6 = createdAtMs % 1 == 0
															else
																v6 = false
															end

															if v6 then
																updatedAtMs = data.updatedAtMs

																if
																	type(updatedAtMs) == "number"
																	and updatedAtMs >= 0
																	and updatedAtMs < 1e999
																then
																	v7 = updatedAtMs % 1 == 0
																else
																	v7 = false
																end

																v6 = v7
																	and data.updatedAtMs >= data.createdAtMs
															end
														else
															v6 = false
														end
													else
														campaignStatus = data.campaignStatus
														v6 = type(campaignStatus) == "string"
															and campaignStatus ~= ""

														if v6 then
															if
																(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
																and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
															then
																createdAtMs = data.createdAtMs

																if
																	type(createdAtMs) == "number"
																	and createdAtMs >= 0
																	and createdAtMs < 1e999
																then
																	v6 = createdAtMs % 1 == 0
																else
																	v6 = false
																end

																if v6 then
																	updatedAtMs = data.updatedAtMs

																	if
																		type(updatedAtMs) == "number"
																		and updatedAtMs >= 0
																		and updatedAtMs < 1e999
																	then
																		v7 = updatedAtMs % 1 == 0
																	else
																		v7 = false
																	end

																	v6 = v7
																		and data.updatedAtMs >= data.createdAtMs
																end
															else
																v6 = false
															end
														end
													end
												end
											else
												v6 = false
											end
										else
											durationDays = data.durationDays

											if
												type(durationDays) == "number"
												and durationDays >= 0
												and durationDays < 1e999
											then
												v6 = durationDays % 1 == 0
											else
												v6 = false
											end

											if v6 then
												if data.durationDays > 0 then
													displayAmountRobux = data.displayAmountRobux

													if
														type(displayAmountRobux) == "number"
														and displayAmountRobux >= 0
														and displayAmountRobux < 1e999
													then
														v6 = displayAmountRobux % 1 == 0
													else
														v6 = false
													end

													if v6 then
														if
															type(data.phase) == "string"
															and v5[data.phase] == true
														then
															if
																data.phase == "active"
																or data.phase == "created"
															then
																campaignId = data.campaignId
																v6 = type(campaignId) == "string"
																	and campaignId ~= ""
															else
																v6 = data.campaignId == nil
															end

															if v6 then
																if data.campaignStatus == nil then
																	if
																		(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
																		and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
																	then
																		createdAtMs = data.createdAtMs

																		if
																			type(createdAtMs) == "number"
																			and createdAtMs >= 0
																			and createdAtMs < 1e999
																		then
																			v6 = createdAtMs % 1 == 0
																		else
																			v6 = false
																		end

																		if v6 then
																			updatedAtMs = data.updatedAtMs

																			if
																				type(updatedAtMs) == "number"
																				and updatedAtMs >= 0
																				and updatedAtMs < 1e999
																			then
																				v7 = updatedAtMs % 1 == 0
																			else
																				v7 = false
																			end

																			v6 = v7
																				and data.updatedAtMs >= data.createdAtMs
																		end
																	else
																		v6 = false
																	end
																else
																	campaignStatus = data.campaignStatus
																	v6 = type(campaignStatus) == "string"
																		and campaignStatus ~= ""

																	if v6 then
																		if
																			(data.lastErrorCode == nil or type(data.lastErrorCode) == "string" or type(data.lastErrorCode) == "number" and math.abs(data.lastErrorCode) < 1e999)
																			and (data.lastErrorMessage == nil or type(data.lastErrorMessage) == "string")
																		then
																			createdAtMs = data.createdAtMs

																			if
																				type(createdAtMs) == "number"
																				and createdAtMs >= 0
																				and createdAtMs < 1e999
																			then
																				v6 = createdAtMs % 1 == 0
																			else
																				v6 = false
																			end

																			if v6 then
																				updatedAtMs = data.updatedAtMs

																				if
																					type(updatedAtMs) == "number"
																					and updatedAtMs >= 0
																					and updatedAtMs < 1e999
																				then
																					v7 = updatedAtMs % 1 == 0
																				else
																					v7 = false
																				end

																				v6 = v7
																					and data.updatedAtMs >= data.createdAtMs
																			end
																		else
																			v6 = false
																		end
																	end
																end
															end
														else
															v6 = false
														end
													end
												else
													v6 = false
												end
											end
										end
									else
										v6 = false
									end
								end
							end
						end
					else
						v6 = false
					end
				end
			end
		end
	else
		v6 = false
	end

	return v6
end

local function readRecord(p2)
	local clone = table.clone(p2)

	if clone.phase == "active" then
		clone.phase = "created"
	end

	return clone
end

local function isDurableAttempt(data)
	local userId = data.userId
	local v6 = type(userId) == "number" and userId >= 0 and userId < 1e999 and userId % 1 == 0

	if not v6 then
		return v6
	end

	if data.userId > 0 then
		local attemptStartedAtMs = data.attemptStartedAtMs

		if
			type(attemptStartedAtMs) == "number"
			and attemptStartedAtMs >= 0
			and attemptStartedAtMs < 1e999
		then
			v6 = attemptStartedAtMs % 1 == 0
		else
			v6 = false
		end

		if v6 then
			if
				type(data.hasAmbiguousFailure) == "boolean"
				and (data.campaignOption == "feedback" or data.campaignOption == "plays")
				and data.durationDays ~= nil
			then
				v6 = data.displayAmountRobux ~= nil
			else
				v6 = false
			end
		end
	else
		v6 = false
	end

	return v6
end

local function sameAttempt(data, data2)
	local v6

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
		v6 = data.attemptStartedAtMs == data2.attemptStartedAtMs
	else
		v6 = false
	end

	return v6
end

local function readNamespace(p2)
	local adCampaignCards = p2.adCampaignCards

	if adCampaignCards == nil then
		return { sessions = {} }, nil
	end

	if type(adCampaignCards) == "table" and type(adCampaignCards.sessions) == "table" then
		return adCampaignCards, nil
	end

	return nil, "malformed_storage"
end

local function createAdCampaignCardStorage(p2)
	local function readData()
		local success, result, v6 = pcall(p2.readData)
		return success and result == true, v6
	end

	local function writeData(p3)
		local success, result = pcall(p2.writeData, p3)
		return success and result == true
	end

	local v6 = nil
	local v7 = {}

	local v8 = {}

	local v9 = {}

	local function beforeUnsentPreflight(p3, p4, data)
		local v10 = if v9[p3] ~= nil then v9[p3][p4] else nil

		if v10 ~= nil and data ~= nil then
			local staged = v10.staged

			if
				sameAttempt(staged, data)
				and data.phase == staged.phase
				and data.updatedAtMs == staged.updatedAtMs
				and data.hasAmbiguousFailure == staged.hasAmbiguousFailure
				and data.lastErrorCode == staged.lastErrorCode
			then
				return v10.previous, true
			end
		end

		return data, false
	end

	local function load()
		if v6 ~= nil then
			return v6, nil
		end

		local success, result, v10 = pcall(p2.readData)

		if not success or result ~= true then
			return nil, "storage_unavailable"
		end

		local v11, v12 = readNamespace(v10)
		v6 = v11
		return v11, v12
	end

	local function get(sessionId, toolCallId)
		local v10 = if v7[sessionId] ~= nil then v7[sessionId][toolCallId] else nil

		if v10 == nil then
			local v11 = if v8[sessionId] ~= nil then v8[sessionId][toolCallId] else nil

			if v11 == nil then
				local v12, v13

				if v6 == nil then
					local success, result, v14 = pcall(p2.readData)

					if success and result == true then
						v12, v13 = readNamespace(v14)
						v6 = v12
					else
						v13 = "storage_unavailable"
					end
				else
					v12 = v6
				end

				if v12 ~= nil then
					local v14 = type(sessionId) == "string" and sessionId ~= ""

					if v14 then
						local v15 = type(toolCallId) == "string" and toolCallId ~= ""

						if v15 then
							local session = v12.sessions[sessionId]

							if session ~= nil and type(session) ~= "table" then
								return {
									isAvailable = false,
									isPersisted = false,
									errorCode = "malformed_session"
								}
							end

							local v16 = if session ~= nil then session[toolCallId] else nil

							if
								v16 ~= nil
								and (not isRecord(v16, sessionId, toolCallId) or FFlagBuildAgentAdCampaignCard and v16.userId ~= nil and not isDurableAttempt(v16))
							then
								return {
									isAvailable = false,
									isPersisted = false,
									errorCode = "malformed_record"
								}
							end

							local v17

							if FFlagBuildAgentAdCampaignCard then
								v16, v17 = beforeUnsentPreflight(sessionId, toolCallId, v16)
							else
								v17 = false
							end

							local v18 = {
								isAvailable = true,
								isPersisted = not v17,
								record = 0
							}
							local clone

							if v16 ~= nil then
								clone = table.clone(v16)

								if clone.phase == "active" then
									clone.phase = "created"
								end
							end

							v18.record = clone
							return v18
						end
					end
				end

				return {
					isAvailable = false,
					isPersisted = false,
					errorCode = v13 or "invalid_identity"
				}
			else
				local clone = table.clone(v11)

				if clone.phase == "active" then
					clone.phase = "created"
				end

				return { isAvailable = true, isPersisted = false, record = clone }
			end
		else
			local clone = table.clone(v10)

			if clone.phase == "active" then
				clone.phase = "created"
			end

			return { isAvailable = true, isPersisted = false, record = clone }
		end
	end

	local function retryWrites(): boolean
		if next(v7) == nil then
			return true
		end

		local success, result, v10 = pcall(p2.readData)

		if not success or result ~= true then
			return false
		end

		local v11 = readNamespace(v10)

		if v11 == nil then
			return false
		end

		local clone = table.clone(v11)
		clone.sessions = table.clone(v11.sessions)
		local v12 = {}
		local v13 = false

		for k, v14 in v7 do
			local session = clone.sessions[k]

			if session == nil or type(session) == "table" then
				local clones = session == nil and {} or table.clone(session)

				for k2, v15 in v14 do
					local v16 = clones[k2]

					if
						(v16 == nil or isRecord(v16, k, k2))
						and (v16 == nil or v16.universeId == v15.universeId and not (v16.updatedAtMs > v15.updatedAtMs) and (v16.campaignId == nil or v16.campaignId == v15.campaignId) and (not FFlagBuildAgentAdCampaignCard or v15.userId == nil or sameAttempt(v16, v15)))
					then
						clones[k2] = table.clone(v15)
						v13 = true
						continue
					end

					v12[k] = v12[k] or {}
					v12[k][k2] = true
				end

				clone.sessions[k] = clones
			else
				v12[k] = {}

				for k2 in v14 do
					v12[k][k2] = true
				end
			end
		end

		for k, v14 in v12 do
			for k2 in v14 do
				local clones = v8[k] or {}
				clones[k2] = table.clone(v7[k][k2])
				v8[k] = clones
				v7[k][k2] = nil
			end

			if next(v7[k]) == nil then
				v7[k] = nil
			end
		end

		if not v13 then
			return next(v12) == nil
		end

		local clone2 = table.clone(v10)
		clone2.adCampaignCards = clone
		local success2, result2 = pcall(p2.writeData, clone2)

		if not success2 or result2 ~= true then
			return false
		end

		v6 = clone
		table.clear(v7)
		return next(v12) == nil
	end

	local function retain(data)
		if not isRecord(data, data.sessionId, data.toolCallId) then
			return false, false
		end

		local clonesByToolCallId = v7[data.sessionId] or {}
		clonesByToolCallId[data.toolCallId] = table.clone(data)
		v7[data.sessionId] = clonesByToolCallId
		return retryWrites(), true
	end

	return {
		get = get,
		list = function(value)
			local v10 = type(value) == "string" and value ~= ""

			if not v10 then
				return {
					isAvailable = false,
					records = {},
					errorCode = "invalid_identity"
				}
			end

			local v11, v12

			if v6 == nil then
				local success, result, v13 = pcall(p2.readData)

				if success and result == true then
					v11, v12 = readNamespace(v13)
					v6 = v11
				else
					v12 = "storage_unavailable"
				end
			else
				v11 = v6
			end

			local v13 = if v11 ~= nil then v11.sessions[value] else nil

			if v13 ~= nil and type(v13) ~= "table" then
				v13 = nil
				v12 = "malformed_session"
			end

			local v14 = v13 == nil and {} or table.clone(v13)

			for k, v15 in v8[value] or {} do
				v14[k] = v15
			end

			for k, v15 in v7[value] or {} do
				v14[k] = v15
			end

			local clones = {}

			for k, v15 in v14 do
				if not (isRecord(v15, value, k) and (not FFlagBuildAgentAdCampaignCard or v15.userId == nil or isDurableAttempt(v15))) then
					continue
				end

				if FFlagBuildAgentAdCampaignCard then
					v15 = beforeUnsentPreflight(value, k, v15)
				end

				if v15 == nil then
					continue
				end

				local clone = table.clone(v15)

				if clone.phase == "active" then
					clone.phase = "created"
				end

				table.insert(clones, clone)
			end

			table.sort(clones, function(a, b): boolean
				if a.createdAtMs == b.createdAtMs then
					return a.toolCallId < b.toolCallId
				end

				return a.createdAtMs < b.createdAtMs
			end)

			return {
				isAvailable = v12 == nil,
				records = clones,
				errorCode = v12
			}
		end,
		confirm = function(data)
			if not isRecord(data, data.sessionId, data.toolCallId) or data.phase ~= "created" then
				return false, false
			end

			local v10 = get(data.sessionId, data.toolCallId)
			local record = v10.record

			if FFlagBuildAgentAdCampaignCard and data.userId ~= nil then
				if not isDurableAttempt(data) then
					return false, false
				end

				if record == nil and not v10.isAvailable then
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
		saveAttempt = function(data, p3): boolean
			if
				not isRecord(data, data.sessionId, data.toolCallId)
				or not isDurableAttempt(data)
				or data.campaignId ~= nil
			then
				return false
			end

			local v10 = get(data.sessionId, data.toolCallId)

			if v10.record ~= nil and v10.record.campaignId ~= nil then
				return false
			end

			local success, result, v11 = pcall(p2.readData)

			local v12 = if success and result == true then readNamespace(v11) else nil

			if v12 == nil then
				return false
			end

			local session = v12.sessions[data.sessionId]

			if session ~= nil and type(session) ~= "table" then
				return false
			end

			local v13 = if session ~= nil then session[data.toolCallId] else nil

			if
				v13 ~= nil
				and (not isRecord(v13, data.sessionId, data.toolCallId) or not isDurableAttempt(v13) or v13.campaignId ~= nil or v13.userId ~= data.userId or v13.universeId ~= data.universeId)
			then
				return false
			end

			local v14 = beforeUnsentPreflight(data.sessionId, data.toolCallId, v13)

			if v14 == nil then
				if p3 ~= nil and p3 ~= data.idempotencyKey then
					return false
				end
			elseif v14.idempotencyKey == data.idempotencyKey then
				local v15

				if data.idempotencyKey == data.toolCallId and p3 == v14.idempotencyKey then
					v15 = not v14.hasAmbiguousFailure

					if v15 then
						v15 = (v14.phase == "failed" or v14.phase == "payment_required")
							and data.phase == "creating"
					end
				else
					v15 = false
				end

				if
					not (sameAttempt(v14, data) or v15)
					or v14.hasAmbiguousFailure and not data.hasAmbiguousFailure
				then
					return false
				end
			elseif
				v14.idempotencyKey ~= p3
				or v14.hasAmbiguousFailure
				or v14.phase ~= "failed" and v14.phase ~= "payment_required"
			then
				return false
			end

			local clone = table.clone(v12)
			clone.sessions = table.clone(v12.sessions)
			local clone2 = table.clone(session or {})
			clone2[data.toolCallId] = table.clone(data)
			clone.sessions[data.sessionId] = clone2
			local clone3 = table.clone(v11)
			clone3.adCampaignCards = clone
			v6 = nil
			local success2, result2 = pcall(p2.writeData, clone3)

			if success2 and result2 == true then
				if v9[data.sessionId] ~= nil then
					v9[data.sessionId][data.toolCallId] = nil
				end

				v6 = clone
				return true
			else
				if data.phase ~= "creating" then
					return false
				end

				local v15 = v9[data.sessionId] or {}
				local toolCallId = data.toolCallId
				local v16 = { staged = table.clone(data), previous = 0 }
				local v17 = if v14 ~= nil then table.clone(v14) else nil
				v16.previous = v17
				v15[toolCallId] = v16

				v9[data.sessionId] = v15

				return false
			end
		end,
		hasPendingWrites = function(): boolean
			return next(v7) ~= nil
		end,
		retryWrites = retryWrites,
		prune = function(data): (boolean, boolean)
			if next(v7) ~= nil then
				return false, false
			end

			local nowMs = data.nowMs
			local v10 = type(nowMs) == "number" and nowMs >= 0 and nowMs < 1e999 and nowMs % 1 == 0

			if not v10 then
				return false, false
			end

			local retentionMs = data.retentionMs
			local v11

			if type(retentionMs) == "number" and retentionMs >= 0 and retentionMs < 1e999 then
				v11 = retentionMs % 1 == 0
			else
				v11 = false
			end

			if v11 then
				local maxRecords = data.maxRecords
				local v12

				if type(maxRecords) == "number" and maxRecords >= 0 and maxRecords < 1e999 then
					v12 = maxRecords % 1 == 0
				else
					v12 = false
				end

				if v12 then
					local success, result, v13 = pcall(p2.readData)

					if not success or result ~= true then
						return false, false
					end

					local v14 = readNamespace(v13)

					if v14 == nil then
						return false, false
					end

					local count = 0
					local v15 = {}

					for k, session in v14.sessions do
						if type(session) ~= "table" then
							continue
						end

						local loadedToolCallId = data.loadedToolCallIdsBySession[k]

						for k2, v16 in session do
							if not (isRecord(v16, k, k2) and v16.universeId == data.universeId) then
								continue
							end

							count += 1
							local v17

							if
								v16.campaignId == nil
								or data.settledCampaignIds[v16.campaignId] ~= true
								or loadedToolCallId == nil
							then
								v17 = false
							else
								v17 = not loadedToolCallId[k2]
							end

							if data.nowMs - v16.updatedAtMs > data.retentionMs and v17 then
								table.insert(v15, v16)
							end
						end
					end

					if count <= data.maxRecords or #v15 == 0 then
						return true, false
					end

					table.sort(v15, function(a, b): boolean
						if a.updatedAtMs ~= b.updatedAtMs then
							return a.updatedAtMs < b.updatedAtMs
						end

						if a.sessionId == b.sessionId then
							return a.toolCallId < b.toolCallId
						end

						return a.sessionId < b.sessionId
					end)

					local clone = table.clone(v14)
					clone.sessions = table.clone(v14.sessions)

					for i = 1, math.min(count - data.maxRecords, #v15) do
						local v16 = v15[i]
						local clone2 = table.clone(clone.sessions[v16.sessionId])
						clone2[v16.toolCallId] = nil
						clone.sessions[v16.sessionId] = clone2
					end

					local clone2 = table.clone(v13)
					clone2.adCampaignCards = clone
					local success2, result2 = pcall(p2.writeData, clone2)

					if not success2 or result2 ~= true then
						return false, false
					end

					v6 = clone
					return true, true
				end
			end

			return false, false
		end,
		reset = function()
			v6 = nil
			table.clear(v7)
			table.clear(v8)
			table.clear(v9)
		end
	}
end

return createAdCampaignCardStorage
