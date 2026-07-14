local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Signals = require(ExpChatParent.Signals)
local SignalsExperimental = require(ExpChatParent.SignalsExperimental)
local SharedFlags = require(ExpChatParent.SharedFlags)
local isWhiteSpaceOnly = require(ExpChat.isWhiteSpaceOnly)
local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)
local computeNameColor = require(ExpChatParent.ChatUIPrimitives).Utils.computeNameColor

require(ExpChat.TextChatMessageChatActionType)

local ExpChatShared = require(ExpChat.Parent.ExpChatShared)
local getTextAndTranslation = require(ExpChat.getTextAndTranslation)
local Config = require(ExpChat.Config)
local sanitizeForRichText = require(ExpChat.sanitizeForRichText)
local generateRichSystemMessageTextFormat = require(ExpChat.generateRichSystemMessageTextFormat)
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local llama = require(ExpChatParent.llama)
local List = llama.List
local Dictionary = llama.Dictionary
local Set = llama.Set
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagEnableInExpChatRewrite = require(ExpChat.Flags.FFlagEnableInExpChatRewrite)
local FFlagEnableInExpChatSummaryOnLua = require(ExpChat.Flags.FFlagEnableInExpChatSummaryOnLua)
local FIntExpChatRandomCharChangeLowerBound = require(ExpChat.Flags.FIntExpChatRandomCharChangeLowerBound)
local FIntExpChatRandomCharChangeUpperBound = require(ExpChat.Flags.FIntExpChatRandomCharChangeUpperBound)
local getFFlagExpChatTelemetryEventTrigger = require(ExpChat.Flags.getFFlagExpChatTelemetryEventTrigger)
local FFlagExpChatClearHiddenMessagesPostAgeCheck = require(ExpChat.Flags.FFlagExpChatClearHiddenMessagesPostAgeCheck)
local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatDisableUniverseBubbleChat = ExpChatShared.Flags.FFlagExpChatDisableUniverseBubbleChat
local GetFFlagExpChatSyntheticSystemMessageRichText = ExpChatShared.Flags.GetFFlagExpChatSyntheticSystemMessageRichText
local FFlagChatLineReportingGlobalMuteEnabled = SharedFlags.FFlagChatLineReportingGlobalMuteEnabled
local FFlagExpChatEnablePostProcessRichSystemMessageTextFormat = require(ExpChat.Flags.FFlagExpChatEnablePostProcessRichSystemMessageTextFormat)
local FFlagExpChatMessagesStoreKeepInByMessageId = require(ExpChat.Flags.FFlagExpChatMessagesStoreKeepInByMessageId)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation
local FFlagExpChatMessagesStoreBatch = require(ExpChat.Flags.FFlagExpChatMessagesStoreBatch)
local FFlagExpChatMessagesStoreMemoryCleanup = require(ExpChat.Flags.FFlagExpChatMessagesStoreMemoryCleanup)
local FFlagExpChatEvictFloodcheckedFromWindowOrder = require(ExpChat.Flags.FFlagExpChatEvictFloodcheckedFromWindowOrder)

function getChatTranslationEnabled() -- line: 54
	-- upvalues: TextChatService (copy)
	return TextChatService.ChatTranslationEnabled
end

local function createMessagesStore(p1) -- line: 174
	-- upvalues: createSignal (copy), createComputed (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), List (copy), Dictionary (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), HttpService (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), FFlagExpChatEnableV2ChatWindow (copy), Set (copy), sanitizeForRichText (copy), GetFFlagExpChatSyntheticSystemMessageRichText (copy), generateRichSystemMessageTextFormat (copy), FFlagExpChatDictation (copy), FFlagExpChatEnablePostProcessRichSystemMessageTextFormat (copy), computeNameColor (copy), Players (copy), FFlagEnableInExpChatRewrite (copy), getTextAndTranslation (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), isWhiteSpaceOnly (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), ExpChatShared (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatDisableUniverseBubbleChat (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), FIntExpChatRandomCharChangeLowerBound (copy), FIntExpChatRandomCharChangeUpperBound (copy), Config (copy), FFlagExpChatClearHiddenMessagesPostAgeCheck (copy)
	local t1 = {
		canLocalUserChat = false,
		isBubbleChatEnabled = false,
		messageLimit = 50,
		nextMessageComponentPointer = 1,
		mutedUserIds = {},
		windowMessagesInOrder = {},
		windowMessagesInOrderByTabId = {},
		byMessageId = {},
		mockUserIdToPartOrModel = {},
		partOrModelToMockUserId = {},
		messagesBySenderId = {},
		messageComponentRingBuffer = {}
	}
	local v46, v47 = createSignal(t1.byMessageId)
	local v48, v49 = createSignal(t1.messagesBySenderId)
	local v50, v51 = createSignal(t1.windowMessagesInOrder)
	local v52, v53 = createSignal(t1.windowMessagesInOrderByTabId)
	local v54, v55 = createSignal(t1.mutedUserIds)
	local v56 = if p1 == nil then v54 else createComputed(function(p2) -- line: 200
		-- upvalues: v54 (copy), p1 (copy)
		local v88 = v54(p2)
		local v89 = p1(p2)
		local v90 = table.clone(v88)

		for v91 in v89 do
			v90[v91] = true
		end

		return v90
	end)
	local v57, v58 = createSignal(t1.canLocalUserChat)
	local v59, _ = createSignal(t1.isBubbleChatEnabled)
	local v61, v62 = createSignal(t1.mockUserIdToPartOrModel)
	local v63, v64 = createSignal(t1.partOrModelToMockUserId)
	local v65, v66 = createSignal(false)
	local v67, v68 = createSignal(t1.messageComponentRingBuffer)
	local v69, v70 = createSignal(t1.nextMessageComponentPointer)
	local t2 = {}
	local n1 = 0
	local t3 = {}
	local v74, v75 = createSignal(nil)
	local updateNextMessageComponent = nil
	local t4 = {}

	local function resolveChannelNameForMapOrder(t5: {[any]: any}, s1: string?) -- line: 241
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), v65 (copy)
		if GetFFlagTextChatEnableUniverseChatTabs() then
			if s1 then
				return s1
			end

			if t5.textChannel then
				if t5.textChannel.Name == "RBXSystem" or not v65(false) then
					return "RBXGeneral"
				end

				return t5.textChannel.Name
			end

			return nil
		end

		if t5.textChannel then
			if t5.textChannel.Name == "RBXSystem" then
				return "RBXGeneral"
			end

			return t5.textChannel.Name
		end

		return nil
	end
	local function maybeBatch(p3: ((...any) -> ...any)) -- line: 261
		-- upvalues: FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
		if FFlagExpChatMessagesStoreBatch then
			SignalsExperimental.batch(p3)

			return
		end

		p3()
	end
	local function addMessage(t6: {[any]: any}) -- line: 269
		-- upvalues: v46 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v51 (copy), List (copy), resolveChannelNameForMapOrder (copy), v53 (copy), Dictionary (copy), v47 (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v63 (copy), HttpService (copy), v62 (copy), v64 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v65 (copy), v50 (copy), v52 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v61 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
		local function v96() -- line: 270
			-- upvalues: v46 (copy), t6 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v51 (copy), List (copy), resolveChannelNameForMapOrder (copy), v53 (copy), Dictionary (copy), v47 (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v63 (copy), HttpService (copy), v62 (copy), v64 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v65 (copy), v50 (copy), v52 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v61 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), updateNextMessageComponent (ref)
			local v192 = v46(false)

			if v192 and v192[t6.messageId] then
				if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t6.status == Enum.TextChatMessageStatus.Floodchecked or t6.status == Enum.TextChatMessageStatus.MessageTooLong) then
					v51(function(p4) -- line: 281
						-- upvalues: List (copy), t6 (copy)
						return List.filter(p4, function(p5) -- line: 282
							-- upvalues: t6 (copy)
							return p5 ~= t6.messageId
						end)
					end)

					local v193 = resolveChannelNameForMapOrder(t6, t6.channelNameOverride)

					if v193 then
						v53(function(p6) -- line: 289
							-- upvalues: v193 (copy), List (copy), t6 (copy), Dictionary (copy)
							local v321 = p6[v193]

							if not v321 then
								return p6
							end

							local v322 = List.filter(v321, function(p7) -- line: 294
								-- upvalues: t6 (copy)
								return p7 ~= t6.messageId
							end)

							return Dictionary.join(p6, {
								[v193] = v322
							})
						end)
					end

					v47(function(p8) -- line: 303
						-- upvalues: Dictionary (copy), t6 (copy)
						return Dictionary.removeKey(p8, t6.messageId)
					end)

					if t6.userId then
						v49(function(p9) -- line: 308
							-- upvalues: t6 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
							local v325 = p9[t6.userId]

							if not v325 then
								return p9
							end

							local v326 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v325, function(p10) -- line: 319
								-- upvalues: t6 (copy)
								return p10.messageId ~= t6.messageId
							end) else List.filter(v325, function(p11) -- line: 315
								-- upvalues: t6 (copy)
								return p11 ~= t6.messageId
							end)

							if #v326 == 0 then
								return Dictionary.removeKey(p9, t6.userId)
							end

							return Dictionary.join(p9, {
								[t6.userId] = v326
							})
						end)
					end

					return
				end

				v47(function(p12) -- line: 336
					-- upvalues: Dictionary (copy), t6 (copy)
					return Dictionary.join(p12, {
						[t6.messageId] = t6
					})
				end)

				if not FFlagExpChatMessagesStoreMemoryCleanup and t6.userId then
					v49(function(p13) -- line: 342
						-- upvalues: t6 (copy), List (copy), Dictionary (copy)
						local v329 = p13[t6.userId] or {}
						local v330 = nil

						for i, v in ipairs(v329) do
							if v.messageId == t6.messageId then
								v330 = i

								break
							end
						end

						if v330 then
							local v333 = List.set(v329, v330, t6)

							return Dictionary.join(p13, {
								[t6.userId] = v333
							})
						end

						return p13
					end)
				end

				return
			end

			local userId = t6.userId
			local partOrModel = t6.partOrModel

			if not userId and partOrModel then
				userId = v63(false)[partOrModel]

				if not userId then
					userId = HttpService:GenerateGUID(false)
					v62(function(p14) -- line: 378
						-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
						return Dictionary.join(p14, {
							[userId] = partOrModel
						})
					end)
					v64(function(p15) -- line: 385
						-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
						return Dictionary.join(p15, {
							[partOrModel] = userId
						})
					end)
				end
			end

			local v196 = if userId == t6.userId then t6 else Dictionary.join(t6, {
				userId = userId
			})
			local channelNameOverride = nil

			if GetFFlagTextChatEnableUniverseChatTabs() and v196.channelNameOverride then
				channelNameOverride = v196.channelNameOverride
			elseif v196.textChannel then
				channelNameOverride = if v196.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v65(false)) then v196.textChannel.Name else "RBXGeneral"
			end

			if v196.isVisibleInChatWindow then
				local v198 = v50(false)
				local v199 = if not channelNameOverride then {} else v52(false)[channelNameOverride] or {}

				if #v198 >= t1.messageLimit then
					local v200 = v198[1]
					local v201 = v192 and v192[v200]

					if v201 then
						if not FFlagExpChatMessagesStoreKeepInByMessageId then
							v47(function(p16) -- line: 427
								-- upvalues: Dictionary (copy), v200 (copy)
								return Dictionary.removeKey(p16, v200)
							end)
						end

						if v201.userId then
							v49(function(p17) -- line: 434
								-- upvalues: v201 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v200 (copy), v61 (copy), v64 (copy), Dictionary (copy), v62 (copy)
								local v338 = p17[v201.userId]

								if v338 then
									local v339 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v338, function(p18) -- line: 443
										-- upvalues: v200 (copy)
										return p18.messageId ~= v200
									end) else List.filter(v338, function(p19) -- line: 439
										-- upvalues: v200 (copy)
										return p19 ~= v200
									end)

									if #v339 == 0 then
										local v340 = v61(false)

										if v340[v201.userId] then
											local v341 = v340[v201.userId]

											v64(function(p20) -- line: 455
												-- upvalues: Dictionary (copy), v341 (copy)
												return Dictionary.removeKey(p20, v341)
											end)
											v62(function(p21) -- line: 459
												-- upvalues: Dictionary (copy), v201 (copy)
												return Dictionary.removeKey(p21, v201.userId)
											end)
										end

										return Dictionary.removeKey(p17, v201.userId)
									end

									return Dictionary.join(p17, {
										[v201.userId] = v339
									})
								end

								return p17
							end)
						end

						v51(function(p22) -- line: 476
							-- upvalues: List (copy)
							return List.removeIndex(p22, 1)
						end)

						if FFlagExpChatMessagesStoreMemoryCleanup then
							t4[v200] = nil
						end
					end
				end

				if channelNameOverride and #v199 >= t1.messageLimit then
					local v202 = v199[1]

					if v202 then
						v53(function(p23) -- line: 490
							-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
							local v344 = p23[channelNameOverride] or {}
							local v345 = List.removeIndex(v344, 1)

							return Dictionary.join(p23, {
								[channelNameOverride] = v345
							})
						end)

						if v192 and v192[v202] then
							v47(function(p24) -- line: 499
								-- upvalues: Dictionary (copy), v202 (copy)
								return Dictionary.removeKey(p24, v202)
							end)
						end

						if FFlagExpChatMessagesStoreMemoryCleanup then
							t4[v202] = nil
						end
					end
				end
			end

			v47(function(p25) -- line: 511
				-- upvalues: Dictionary (copy), v196 (copy)
				return Dictionary.join(p25, {
					[v196.messageId] = v196
				})
			end)

			if v196.userId then
				v49(function(p26) -- line: 516
					-- upvalues: v196 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
					local v349 = p26[v196.userId] or {}
					local v350 = false

					if FFlagExpChatMessagesStoreMemoryCleanup then
						for _, v in ipairs(v349) do
							if v == v196.messageId then
								v350 = true

								break
							end
						end
					else
						for _, v in ipairs(v349) do
							if v.messageId == v196.messageId then
								v350 = true

								break
							end
						end
					end

					if not v350 then
						local v355 = if not FFlagExpChatMessagesStoreMemoryCleanup then v196 else v196.messageId
						local v356 = List.append(v349, v355)

						return Dictionary.join(p26, {
							[v196.userId] = v356
						})
					end

					return p26
				end)
			end

			if v196.isVisibleInChatWindow then
				v51(function(p27) -- line: 553
					-- upvalues: List (copy), v196 (copy)
					return List.append(p27, v196.messageId)
				end)

				if channelNameOverride then
					v53(function(p28) -- line: 559
						-- upvalues: channelNameOverride (ref), List (copy), v196 (copy), Dictionary (copy)
						local v359 = p28[channelNameOverride] or {}
						local v360 = List.append(v359, v196.messageId)

						return Dictionary.join(p28, {
							[channelNameOverride] = v360
						})
					end)
				end

				if FFlagExpChatEnableV2ChatWindow then
					local v203 = v74(false)

					if v203 == nil or v203 == channelNameOverride then
						updateNextMessageComponent(v196.messageId)
					end
				end
			end
		end

		if FFlagExpChatMessagesStoreBatch then
			SignalsExperimental.batch(v96)

			return
		end

		v96()
	end

	local t7 = {}

	local function getUserMessageCache(s2: string) -- line: 604
		-- upvalues: t7 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), createComputed (copy), v48 (copy), v46 (copy), v56 (copy), Set (copy)
		local str = tostring(s2)

		if not t7[str] then
			t7[str] = {}

			if not FFlagExpChatMessagesStoreMemoryCleanup then
				t7[str].messages = createComputed(function(p29) -- line: 610
					-- upvalues: v48 (copy), str (copy)
					return v48(p29)[str] or {}
				end)
			end

			if FFlagExpChatMessagesStoreMemoryCleanup then
				t7[str].bubbleMessages = createComputed(function(p30) -- line: 618
					-- upvalues: v48 (copy), str (copy), v46 (copy), v56 (copy), Set (copy)
					local v208 = v48(p30)[str] or {}
					local v209 = v46(p30)
					local v210 = v56(p30)
					local t8 = {}

					for _, v in ipairs(v208) do
						local v214 = v209[v]

						if v214 then
							local v215 = not not v214.userId and (Set.has(v210, v214.userId) or false)

							if v214.isVisibleInBubbleChat and not v215 then
								table.insert(t8, v214)
							end
						end
					end

					return t8
				end)
			else
				t7[str].bubbleMessages = createComputed(function(p31) -- line: 636
					-- upvalues: t7 (copy), str (copy), v56 (copy), Set (copy)
					local v217 = t7[str].messages(p31)
					local v218 = v56(p31)
					local t9 = {}

					for _, v in ipairs(v217) do
						local v222 = not not v.userId and (Set.has(v218, v.userId) or false)

						if v.isVisibleInBubbleChat and not v222 then
							table.insert(t9, v)
						end
					end

					return t9
				end)
			end

			if not FFlagExpChatMessagesStoreMemoryCleanup then
				t7[str].lastMessage = createComputed(function(p32) -- line: 651
					-- upvalues: t7 (copy), str (copy)
					local v224 = t7[str].messages(p32)

					if #v224 > 0 then
						return v224[#v224]
					end

					return nil
				end)
			end
		end

		return t7[str]
	end
	local function getUserMessages(s3: string) -- line: 663
		-- upvalues: getUserMessageCache (copy)
		return getUserMessageCache(s3).messages
	end
	local function getUserLastMessage(s4: string) -- line: 673
		-- upvalues: getUserMessageCache (copy)
		return getUserMessageCache(s4).lastMessage
	end
	local function createMessagesArraySignal() -- line: 678
		-- upvalues: createComputed (copy), v46 (copy)
		return createComputed(function(p33) -- line: 679
			-- upvalues: v46 (copy)
			local v226 = v46(p33)
			local t10 = {}

			for _, v in pairs(v226 or {}) do
				table.insert(t10, v)
			end

			return t10
		end)
	end
	local function formatPrefixForUniverseChatTabs(s5: string, s6: string?, p34) -- line: 728
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), computeNameColor (copy), Players (copy)
		if not GetFFlagTextChatEnableUniverseChatTabs() or (not s6 or #s5 == 0) then
			return s5
		end

		return `<font color="#{ ((if not p34.TextSource then computeNameColor(not Players.LocalPlayer and "" or Players.LocalPlayer.Name) else computeNameColor(p34.TextSource.Username))):ToHex() }">{ s5 }</font>`
	end

	function updateNextMessageComponent(s7: string) -- line: 1350
		-- upvalues: v67 (copy), v69 (copy), v70 (copy), t2 (copy), FFlagEnableInExpChatRewrite (copy), n1 (ref), t3 (copy)
		local v179 = v67(false)

		if #v179 == 0 then
			return
		end

		local v180 = v69(false)
		local v181 = v179[v180]

		if not v181 then
			v70(1)

			return
		end

		local v182 = t2[v181]

		if v182 then
			v182.setter(s7)
		end

		local v183 = not FFlagEnableInExpChatRewrite and 1 or 10

		n1 += v183

		local v184 = t3[v181]

		if v184 then
			v184.setter(n1)
		end

		local v185 = v180 % #v179 + 1

		v70(v185)
	end

	return {
		getByMessageId = v46,
		getMessages = if not FFlagExpChatMessagesStoreMemoryCleanup then createComputed(function(p35) -- line: 679
			-- upvalues: v46 (copy)
			local v188 = v46(p35)
			local t11 = {}

			for _, v in pairs(v188 or {}) do
				table.insert(t11, v)
			end

			return t11
		end) else nil,
		getMessagesBySenderId = v48,
		getWindowMessagesInOrder = v50,
		getWindowMessagesInOrderByTabId = v52,
		getMutedUserIds = v56,
		getCanLocalUserChat = v57,
		getIsBubbleChatEnabled = v59,
		getMockUserIdToPartOrModel = v61,
		getPartOrModelToMockUserId = v63,
		getMessage = function(s8: string) -- line: 591
			-- upvalues: t4 (copy), createComputed (copy), v46 (copy)
			if not t4[s8] then
				t4[s8] = createComputed(function(p36) -- line: 593
					-- upvalues: v46 (copy), s8 (copy)
					local v205 = v46(p36)

					if not v205 or not v205[s8] then
						return nil
					end

					return v205[s8]
				end)
			end

			return t4[s8]
		end,
		getUserMessages = if not FFlagExpChatMessagesStoreMemoryCleanup then getUserMessages else nil,
		getUserBubbleMessages = function(s9: string) -- line: 668
			-- upvalues: getUserMessageCache (copy)
			return getUserMessageCache(s9).bubbleMessages
		end,
		getUserLastMessage = if not FFlagExpChatMessagesStoreMemoryCleanup then getUserLastMessage else nil,
		registerMessageComponent = function(s10: string) -- line: 1263
			-- upvalues: t2 (copy), createSignal (copy), t3 (copy), v68 (copy), List (copy)
			if not t2[s10] then
				local v164, v165 = createSignal(nil)

				t2[s10] = {
					getter = v164,
					setter = v165
				}

				local v166, v167 = createSignal(0)

				t3[s10] = {
					getter = v166,
					setter = v167
				}
				v68(function(p37) -- line: 1278
					-- upvalues: List (copy), s10 (copy)
					return List.append(p37, s10)
				end)
			end

			return t2[s10].getter
		end,
		unregisterMessageComponent = function(s11: string) -- line: 1287
			-- upvalues: v67 (copy), t2 (copy), t3 (copy), v68 (copy), List (copy), v69 (copy), v70 (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local v169 = v67(false)
			local u170 = nil

			for i, v in ipairs(v169) do
				if v == s11 then
					u170 = i

					break
				end
			end

			if t2[s11] then
				t2[s11] = nil
			end

			if t3[s11] then
				t3[s11] = nil
			end

			if u170 then
				local function doUnregister() -- line: 1310
					-- upvalues: v68 (copy), List (copy), s11 (copy), v67 (copy), v69 (copy), v70 (copy), u170 (ref)
					v68(function(p38) -- line: 1311
						-- upvalues: List (copy), s11 (copy)
						return List.filter(p38, function(p39) -- line: 1312
							-- upvalues: s11 (copy)
							return p39 ~= s11
						end)
					end)

					local v310 = v67(false)
					local v311 = v69(false)

					if #v310 == 0 then
						v70(1)

						return
					end

					if v311 > u170 then
						v70(v311 - 1)

						return
					end

					if v311 > #v310 then
						v70(1)
					end
				end

				if FFlagExpChatMessagesStoreBatch then
					SignalsExperimental.batch(doUnregister)
				else
					doUnregister()
				end
			end
		end,
		repopulateMessageComponents = function() -- line: 1387
			-- upvalues: v74 (copy), v52 (copy), v50 (copy), v70 (copy), n1 (ref), updateNextMessageComponent (ref), v67 (copy), v69 (copy), t2 (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local function doRepopulate() -- line: 1388
				-- upvalues: v74 (copy), v52 (copy), v50 (copy), v70 (copy), n1 (ref), updateNextMessageComponent (ref), v67 (copy), v69 (copy), t2 (copy)
				local v312 = v74(false)
				local v313 = if not v312 then v50(false) else v52(false)[v312] or {}

				v70(1)
				n1 = 0

				for _, v in ipairs(v313) do
					updateNextMessageComponent(v)
				end

				local v316 = v67(false)

				if #v313 < #v316 then
					for i = v69(false), #v316 do
						local v318 = t2[v316[i]]

						if v318 then
							v318.setter(nil)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(doRepopulate)

				return
			end

			doRepopulate()
		end,
		getMessageComponentSignal = function(s12: string) -- line: 1338
			-- upvalues: t2 (copy)
			local v175 = t2[s12]

			if v175 then
				return v175.getter
			end

			return nil
		end,
		getLayoutOrderSignal = function(s13: string) -- line: 1344
			-- upvalues: t3 (copy)
			local v177 = t3[s13]

			if v177 then
				return v177.getter
			end

			return nil
		end,
		updateNextMessageComponent = updateNextMessageComponent,
		getMessageComponentRingBuffer = v67,
		getNextMessageComponentPointer = v69,
		setActiveChannelFilter = v75,
		getActiveChannelFilter = v74,
		setCanLocalUserChat = v58,
		muteUser = function(s14: string) -- line: 998
			-- upvalues: v55 (copy), Set (copy)
			v55(function(p40) -- line: 999
				-- upvalues: Set (copy), s14 (copy)
				if not p40 then
					return {}
				end

				return (Set.add(p40, s14))
			end)
		end,
		unmuteUser = function(s15: string) -- line: 1008
			-- upvalues: v55 (copy), Set (copy)
			v55(function(p41) -- line: 1009
				-- upvalues: Set (copy), s15 (copy)
				if not p41 then
					return {}
				end

				return (Set.subtract(p41, s15))
			end)
		end,
		handlePlayerRemoved = function(s16: string) -- line: 954
			-- upvalues: v49 (copy), Dictionary (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), t7 (copy), v55 (copy), Set (copy), v48 (copy), v61 (copy), v64 (copy), v62 (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local str = tostring(s16)

			local function doHandlePlayerRemoved() -- line: 957
				-- upvalues: v49 (copy), Dictionary (copy), str (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), t7 (copy), v55 (copy), Set (copy), v48 (copy), v61 (copy), v64 (copy), v62 (copy)
				v49(function(p42) -- line: 959
					-- upvalues: Dictionary (copy), str (copy)
					return Dictionary.removeKey(p42, str)
				end)

				if FFlagExpChatMessagesStoreMemoryCleanup then
					t7[str] = nil
				end

				v55(function(p43) -- line: 967
					-- upvalues: Set (copy), str (copy), v48 (copy), v61 (copy), v64 (copy), Dictionary (copy), v62 (copy)
					if not p43 then
						return {}
					end

					local v531 = Set.has(p43, str)

					if #(v48(false)[str] or {}) == 0 and not v531 then
						return p43
					end

					local v532 = v61(false)

					if v532[str] then
						local v533 = v532[str]

						v64(function(p44) -- line: 982
							-- upvalues: Dictionary (copy), v533 (copy)
							return Dictionary.removeKey(p44, v533)
						end)
						v62(function(p45) -- line: 986
							-- upvalues: Dictionary (copy), str (copy)
							return Dictionary.removeKey(p45, str)
						end)
					end

					return Set.subtract(p43, str)
				end)
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(doHandlePlayerRemoved)

				return
			end

			doHandlePlayerRemoved()
		end,
		clearWindowMessages = function() -- line: 1018
			-- upvalues: v47 (copy), Dictionary (copy), v51 (copy), v53 (copy), FFlagExpChatEnableV2ChatWindow (copy), v70 (copy), n1 (ref), v67 (copy), t2 (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local function doClearWindowMessages() -- line: 1019
				-- upvalues: v47 (copy), Dictionary (copy), v51 (copy), v53 (copy), FFlagExpChatEnableV2ChatWindow (copy), v70 (copy), n1 (ref), v67 (copy), t2 (copy)
				v47(function(p46) -- line: 1020
					-- upvalues: Dictionary (copy)
					if not p46 then
						return {}
					end

					return (Dictionary.map(p46, function(p47) -- line: 1025
						-- upvalues: Dictionary (copy)
						return Dictionary.join(p47, {
							isVisibleInChatWindow = false
						})
					end))
				end)
				v51(function(_) -- line: 1035
					return {}
				end)
				v53(function(_) -- line: 1040
					return {}
				end)

				if FFlagExpChatEnableV2ChatWindow then
					v70(1)
					n1 = 0

					local v280 = v67(false)

					for _, v in ipairs(v280) do
						local v283 = t2[v]

						if v283 then
							v283.setter(nil)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(doClearWindowMessages)

				return
			end

			doClearWindowMessages()
		end,
		toggleGlobalTranslation = function(b1: boolean) -- line: 1101
			-- upvalues: v47 (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local function doToggleGlobalTranslation() -- line: 1102
				-- upvalues: v47 (copy), b1 (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
				v47(function(p50) -- line: 1103
					-- upvalues: b1 (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
					if not p50 then
						return {}
					end

					local t12 = {}

					for k, _ in pairs(p50) do
						local v545 = p50[k]

						if v545 ~= nil then
							t12[k] = {
								prefixText = v545.prefixText,
								text = v545.text,
								translation = v545.translation,
								useTranslation = b1,
								messageId = v545.messageId,
								status = v545.status,
								timestamp = v545.timestamp,
								isVisibleInBubbleChat = v545.isVisibleInBubbleChat,
								isVisibleInChatWindow = v545.isVisibleInChatWindow,
								partOrModel = v545.partOrModel,
								shouldOverrideBubbleChatSettings = v545.shouldOverrideBubbleChatSettings,
								bubbleChatMessageProperties = v545.bubbleChatMessageProperties,
								chatWindowMessageProperties = v545.chatWindowMessageProperties,
								textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else v545.textChatMessageInstance,
								userId = v545.userId,
								textChannel = v545.textChannel,
								wasRewritten = if not FFlagEnableInExpChatRewrite then nil else v545.wasRewritten,
								originalText = if not FFlagEnableInExpChatRewrite then nil else v545.originalText,
								chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else v545.chatActionType,
								presetId = if not FFlagExpChatPresetChatEnabled then nil else v545.presetId,
								presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else v545.presetChatVersion
							}
						end
					end

					return t12
				end)
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(doToggleGlobalTranslation)

				return
			end

			v47(function(p51) -- line: 1103
				-- upvalues: b1 (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
				if not p51 then
					return {}
				end

				local t13 = {}

				for k, _ in pairs(p51) do
					local v291 = p51[k]

					if v291 ~= nil then
						t13[k] = {
							prefixText = v291.prefixText,
							text = v291.text,
							translation = v291.translation,
							useTranslation = b1,
							messageId = v291.messageId,
							status = v291.status,
							timestamp = v291.timestamp,
							isVisibleInBubbleChat = v291.isVisibleInBubbleChat,
							isVisibleInChatWindow = v291.isVisibleInChatWindow,
							partOrModel = v291.partOrModel,
							shouldOverrideBubbleChatSettings = v291.shouldOverrideBubbleChatSettings,
							bubbleChatMessageProperties = v291.bubbleChatMessageProperties,
							chatWindowMessageProperties = v291.chatWindowMessageProperties,
							textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else v291.textChatMessageInstance,
							userId = v291.userId,
							textChannel = v291.textChannel,
							wasRewritten = if not FFlagEnableInExpChatRewrite then nil else v291.wasRewritten,
							originalText = if not FFlagEnableInExpChatRewrite then nil else v291.originalText,
							chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else v291.chatActionType,
							presetId = if not FFlagExpChatPresetChatEnabled then nil else v291.presetId,
							presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else v291.presetChatVersion
						}
					end
				end

				return t13
			end)
		end,
		toggleMessageTranslation = function(b2: boolean, s17: string) -- line: 1154
			-- upvalues: v47 (copy), Dictionary (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
			v47(function(p52) -- line: 1155
				-- upvalues: s17 (copy), Dictionary (copy), b2 (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
				if not p52 then
					return {}
				end

				local v293 = p52[s17]

				if v293 ~= nil then
					return Dictionary.join(p52, {
						[s17] = {
							prefixText = v293.prefixText,
							text = v293.text,
							translation = v293.translation,
							useTranslation = b2,
							messageId = v293.messageId,
							status = v293.status,
							timestamp = v293.timestamp,
							isVisibleInBubbleChat = v293.isVisibleInBubbleChat,
							isVisibleInChatWindow = v293.isVisibleInChatWindow,
							partOrModel = v293.partOrModel,
							shouldOverrideBubbleChatSettings = v293.shouldOverrideBubbleChatSettings,
							bubbleChatMessageProperties = v293.bubbleChatMessageProperties,
							chatWindowMessageProperties = v293.chatWindowMessageProperties,
							textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else v293.textChatMessageInstance,
							userId = v293.userId,
							textChannel = v293.textChannel,
							wasRewritten = if not FFlagEnableInExpChatRewrite then nil else v293.wasRewritten,
							originalText = if not FFlagEnableInExpChatRewrite then nil else v293.originalText,
							chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else v293.chatActionType,
							presetId = if not FFlagExpChatPresetChatEnabled then nil else v293.presetId,
							presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else v293.presetChatVersion
						}
					})
				end

				return p52
			end)
		end,
		handleIncomingOrOutgoingMessage = function(p53, _: boolean, s18: string?, b4: boolean?) -- line: 751
			-- upvalues: FFlagEnableInExpChatRewrite (copy), getTextAndTranslation (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), isWhiteSpaceOnly (copy), v46 (copy), v57 (copy), FFlagExpChatPresetChatEnabled (copy), v56 (copy), Set (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), ExpChatShared (copy), v59 (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatDisableUniverseBubbleChat (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), formatPrefixForUniverseChatTabs (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v51 (copy), List (copy), resolveChannelNameForMapOrder (copy), v53 (copy), Dictionary (copy), v47 (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v63 (copy), HttpService (copy), v62 (copy), v64 (copy), v65 (copy), v50 (copy), v52 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v61 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local v120, v121

			if FFlagEnableInExpChatRewrite then
				v120, v121 = getTextAndTranslation(p53)
			else
				v120 = if not getFFlagExpChatProtectedChatInternalAPIs() then p53.Text else p53.TextInternal
				v121 = if not getFFlagExpChatProtectedChatInternalAPIs() then p53.Translation else p53.TranslationInternal
			end

			if isWhiteSpaceOnly(v120) and p53.Status ~= Enum.TextChatMessageStatus.Floodchecked and p53.Status ~= Enum.TextChatMessageStatus.MessageTooLong then
				return
			end

			local v122 = if not p53.TextSource then nil else tostring(p53.TextSource.UserId)

			if not v46(false) then
				return
			end

			local v123 = v57(false)
			local v124 = v122 == nil or (v123 or not not FFlagExpChatPresetChatEnabled and (p53.PresetId or "") ~= "") and (p53.Status == Enum.TextChatMessageStatus.Success or p53.Status == Enum.TextChatMessageStatus.Sending)
			local v125 = not not v122 and (not not v56(false) and Set.has(v56(false), v122))
			local v126 = v124 and not v125
			local v127 = false
			local v128

			if FFlagExpChatUseChatConfigStore then
				v128 = GetChatConfigurationStore(false).getIsBubbleChatEnabled(false)
			else
				local v129 = ExpChatShared.context and ExpChatShared.context.store

				v128 = if not v129 then v59(false) else v129:getState().Messages.isBubbleChatEnabled
			end

			if v128 and v126 and (not FFlagEnableInExpChatSummaryOnLua or v122 ~= nil) and (p53.Status == Enum.TextChatMessageStatus.Success or p53.Status == Enum.TextChatMessageStatus.Sending) then
				v127 = true
			end

			if FFlagExpChatDisableUniverseBubbleChat and GetFFlagTextChatEnableUniverseChatTabs() and b4 == true then
				v127 = false
			end

			if p53.Status ~= Enum.TextChatMessageStatus.Success and p53.Status ~= Enum.TextChatMessageStatus.Sending then
				v126 = false
				v127 = false
			end

			local v130 = formatPrefixForUniverseChatTabs(if not getFFlagExpChatProtectedChatInternalAPIs() then p53.PrefixText else p53.PrefixTextInternal, s18, p53)
			local t14 = {
				shouldOverrideBubbleChatSettings = false,
				userId = v122,
				prefixText = v130,
				text = v120,
				translation = v121,
				useTranslation = getChatTranslationEnabled() and v121 ~= nil,
				messageId = p53.MessageId,
				status = p53.Status,
				timestamp = p53.Timestamp,
				isVisibleInBubbleChat = v127,
				isVisibleInChatWindow = v126,
				textChannel = p53.TextChannel,
				bubbleChatMessageProperties = p53.BubbleChatMessageProperties,
				chatWindowMessageProperties = p53.ChatWindowMessageProperties,
				textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else p53,
				partOrModel = p53.TextSource and p53.TextSource.Parent or nil,
				wasRewritten = if not FFlagEnableInExpChatRewrite then nil else p53.WasRewritten,
				originalText = if not FFlagEnableInExpChatRewrite then nil else p53.OriginalText,
				channelNameOverride = GetFFlagTextChatEnableUniverseChatTabs() and s18 or nil,
				chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else p53.ChatActionType,
				isUniverseChat = if not FFlagChatLineReportingGlobalMuteEnabled then nil else b4,
				presetId = if not FFlagExpChatPresetChatEnabled then nil else p53.PresetId,
				presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else p53.PresetChatVersion
			}
			local v132 = v46(false)
			local v133 = v132 and v132[t14.messageId] ~= nil

			if t14.isVisibleInChatWindow or t14.isVisibleInBubbleChat or v133 then
				local function v134() -- line: 270
					-- upvalues: v46 (copy), t14 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v51 (copy), List (copy), resolveChannelNameForMapOrder (copy), v53 (copy), Dictionary (copy), v47 (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v63 (copy), HttpService (copy), v62 (copy), v64 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v65 (copy), v50 (copy), v52 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v61 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), updateNextMessageComponent (ref)
					local v242 = v46(false)

					if v242 and v242[t14.messageId] then
						if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t14.status == Enum.TextChatMessageStatus.Floodchecked or t14.status == Enum.TextChatMessageStatus.MessageTooLong) then
							v51(function(p54) -- line: 281
								-- upvalues: List (copy), t14 (copy)
								return List.filter(p54, function(p55) -- line: 282
									-- upvalues: t14 (copy)
									return p55 ~= t14.messageId
								end)
							end)

							local v243 = resolveChannelNameForMapOrder(t14, t14.channelNameOverride)

							if v243 then
								v53(function(p56) -- line: 289
									-- upvalues: v243 (copy), List (copy), t14 (copy), Dictionary (copy)
									local v405 = p56[v243]

									if not v405 then
										return p56
									end

									local v406 = List.filter(v405, function(p57) -- line: 294
										-- upvalues: t14 (copy)
										return p57 ~= t14.messageId
									end)

									return Dictionary.join(p56, {
										[v243] = v406
									})
								end)
							end

							v47(function(p58) -- line: 303
								-- upvalues: Dictionary (copy), t14 (copy)
								return Dictionary.removeKey(p58, t14.messageId)
							end)

							if t14.userId then
								v49(function(p59) -- line: 308
									-- upvalues: t14 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
									local v409 = p59[t14.userId]

									if not v409 then
										return p59
									end

									local v410 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v409, function(p60) -- line: 319
										-- upvalues: t14 (copy)
										return p60.messageId ~= t14.messageId
									end) else List.filter(v409, function(p61) -- line: 315
										-- upvalues: t14 (copy)
										return p61 ~= t14.messageId
									end)

									if #v410 == 0 then
										return Dictionary.removeKey(p59, t14.userId)
									end

									return Dictionary.join(p59, {
										[t14.userId] = v410
									})
								end)
							end

							return
						end

						v47(function(p62) -- line: 336
							-- upvalues: Dictionary (copy), t14 (copy)
							return Dictionary.join(p62, {
								[t14.messageId] = t14
							})
						end)

						if not FFlagExpChatMessagesStoreMemoryCleanup and t14.userId then
							v49(function(p63) -- line: 342
								-- upvalues: t14 (copy), List (copy), Dictionary (copy)
								local v413 = p63[t14.userId] or {}
								local v414 = nil

								for i, v in ipairs(v413) do
									if v.messageId == t14.messageId then
										v414 = i

										break
									end
								end

								if v414 then
									local v417 = List.set(v413, v414, t14)

									return Dictionary.join(p63, {
										[t14.userId] = v417
									})
								end

								return p63
							end)
						end

						return
					end

					local userId = t14.userId
					local partOrModel = t14.partOrModel

					if not userId and partOrModel then
						userId = v63(false)[partOrModel]

						if not userId then
							userId = HttpService:GenerateGUID(false)
							v62(function(p64) -- line: 378
								-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
								return Dictionary.join(p64, {
									[userId] = partOrModel
								})
							end)
							v64(function(p65) -- line: 385
								-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
								return Dictionary.join(p65, {
									[partOrModel] = userId
								})
							end)
						end
					end

					local v246 = if userId == t14.userId then t14 else Dictionary.join(t14, {
						userId = userId
					})
					local channelNameOverride = nil

					if GetFFlagTextChatEnableUniverseChatTabs() and v246.channelNameOverride then
						channelNameOverride = v246.channelNameOverride
					elseif v246.textChannel then
						channelNameOverride = if v246.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v65(false)) then v246.textChannel.Name else "RBXGeneral"
					end

					if v246.isVisibleInChatWindow then
						local v248 = v50(false)
						local v249 = if not channelNameOverride then {} else v52(false)[channelNameOverride] or {}

						if #v248 >= t1.messageLimit then
							local v250 = v248[1]
							local v251 = v242 and v242[v250]

							if v251 then
								if not FFlagExpChatMessagesStoreKeepInByMessageId then
									v47(function(p66) -- line: 427
										-- upvalues: Dictionary (copy), v250 (copy)
										return Dictionary.removeKey(p66, v250)
									end)
								end

								if v251.userId then
									v49(function(p67) -- line: 434
										-- upvalues: v251 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v250 (copy), v61 (copy), v64 (copy), Dictionary (copy), v62 (copy)
										local v422 = p67[v251.userId]

										if v422 then
											local v423 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v422, function(p68) -- line: 443
												-- upvalues: v250 (copy)
												return p68.messageId ~= v250
											end) else List.filter(v422, function(p69) -- line: 439
												-- upvalues: v250 (copy)
												return p69 ~= v250
											end)

											if #v423 == 0 then
												local v424 = v61(false)

												if v424[v251.userId] then
													local v425 = v424[v251.userId]

													v64(function(p70) -- line: 455
														-- upvalues: Dictionary (copy), v425 (copy)
														return Dictionary.removeKey(p70, v425)
													end)
													v62(function(p71) -- line: 459
														-- upvalues: Dictionary (copy), v251 (copy)
														return Dictionary.removeKey(p71, v251.userId)
													end)
												end

												return Dictionary.removeKey(p67, v251.userId)
											end

											return Dictionary.join(p67, {
												[v251.userId] = v423
											})
										end

										return p67
									end)
								end

								v51(function(p72) -- line: 476
									-- upvalues: List (copy)
									return List.removeIndex(p72, 1)
								end)

								if FFlagExpChatMessagesStoreMemoryCleanup then
									t4[v250] = nil
								end
							end
						end

						if channelNameOverride and #v249 >= t1.messageLimit then
							local v252 = v249[1]

							if v252 then
								v53(function(p73) -- line: 490
									-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
									local v428 = p73[channelNameOverride] or {}
									local v429 = List.removeIndex(v428, 1)

									return Dictionary.join(p73, {
										[channelNameOverride] = v429
									})
								end)

								if v242 and v242[v252] then
									v47(function(p74) -- line: 499
										-- upvalues: Dictionary (copy), v252 (copy)
										return Dictionary.removeKey(p74, v252)
									end)
								end

								if FFlagExpChatMessagesStoreMemoryCleanup then
									t4[v252] = nil
								end
							end
						end
					end

					v47(function(p75) -- line: 511
						-- upvalues: Dictionary (copy), v246 (copy)
						return Dictionary.join(p75, {
							[v246.messageId] = v246
						})
					end)

					if v246.userId then
						v49(function(p76) -- line: 516
							-- upvalues: v246 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
							local v433 = p76[v246.userId] or {}
							local v434 = false

							if FFlagExpChatMessagesStoreMemoryCleanup then
								for _, v in ipairs(v433) do
									if v == v246.messageId then
										v434 = true

										break
									end
								end
							else
								for _, v in ipairs(v433) do
									if v.messageId == v246.messageId then
										v434 = true

										break
									end
								end
							end

							if not v434 then
								local v439 = if not FFlagExpChatMessagesStoreMemoryCleanup then v246 else v246.messageId
								local v440 = List.append(v433, v439)

								return Dictionary.join(p76, {
									[v246.userId] = v440
								})
							end

							return p76
						end)
					end

					if v246.isVisibleInChatWindow then
						v51(function(p77) -- line: 553
							-- upvalues: List (copy), v246 (copy)
							return List.append(p77, v246.messageId)
						end)

						if channelNameOverride then
							v53(function(p78) -- line: 559
								-- upvalues: channelNameOverride (ref), List (copy), v246 (copy), Dictionary (copy)
								local v443 = p78[channelNameOverride] or {}
								local v444 = List.append(v443, v246.messageId)

								return Dictionary.join(p78, {
									[channelNameOverride] = v444
								})
							end)
						end

						if FFlagExpChatEnableV2ChatWindow then
							local v253 = v74(false)

							if v253 == nil or v253 == channelNameOverride then
								updateNextMessageComponent(v246.messageId)
							end
						end
					end
				end

				if FFlagExpChatMessagesStoreBatch then
					SignalsExperimental.batch(v134)

					return
				end

				v134()
			end
		end,
		handleIncomingBubbleChatMessage = function(t15: {[any]: any}) -- line: 898
			-- upvalues: v46 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v51 (copy), List (copy), resolveChannelNameForMapOrder (copy), v53 (copy), Dictionary (copy), v47 (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v63 (copy), HttpService (copy), v62 (copy), v64 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v65 (copy), v50 (copy), v52 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v61 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local t16 = {
				prefixText = "",
				textChannel = nil,
				shouldOverrideBubbleChatSettings = true,
				isVisibleInBubbleChat = true,
				isVisibleInChatWindow = false,
				chatWindowMessageProperties = nil,
				userId = t15.bubbleChatMessageUserId,
				text = t15.message,
				translation = t15.translation,
				useTranslation = getChatTranslationEnabled(),
				messageId = t15.bubbleChatMessageId,
				status = Enum.TextChatMessageStatus.Success,
				timestamp = t15.timestamp,
				partOrModel = t15.partOrModel,
				bubbleChatMessageProperties = t15.bubbleChatMessageProperties
			}

			local function v137() -- line: 270
				-- upvalues: v46 (copy), t16 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v51 (copy), List (copy), resolveChannelNameForMapOrder (copy), v53 (copy), Dictionary (copy), v47 (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v63 (copy), HttpService (copy), v62 (copy), v64 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v65 (copy), v50 (copy), v52 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v61 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), updateNextMessageComponent (ref)
				local v254 = v46(false)

				if v254 and v254[t16.messageId] then
					if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t16.status == Enum.TextChatMessageStatus.Floodchecked or t16.status == Enum.TextChatMessageStatus.MessageTooLong) then
						v51(function(p79) -- line: 281
							-- upvalues: List (copy), t16 (copy)
							return List.filter(p79, function(p80) -- line: 282
								-- upvalues: t16 (copy)
								return p80 ~= t16.messageId
							end)
						end)

						local v255 = resolveChannelNameForMapOrder(t16, t16.channelNameOverride)

						if v255 then
							v53(function(p81) -- line: 289
								-- upvalues: v255 (copy), List (copy), t16 (copy), Dictionary (copy)
								local v447 = p81[v255]

								if not v447 then
									return p81
								end

								local v448 = List.filter(v447, function(p82) -- line: 294
									-- upvalues: t16 (copy)
									return p82 ~= t16.messageId
								end)

								return Dictionary.join(p81, {
									[v255] = v448
								})
							end)
						end

						v47(function(p83) -- line: 303
							-- upvalues: Dictionary (copy), t16 (copy)
							return Dictionary.removeKey(p83, t16.messageId)
						end)

						if t16.userId then
							v49(function(p84) -- line: 308
								-- upvalues: t16 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
								local v451 = p84[t16.userId]

								if not v451 then
									return p84
								end

								local v452 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v451, function(p85) -- line: 319
									-- upvalues: t16 (copy)
									return p85.messageId ~= t16.messageId
								end) else List.filter(v451, function(p86) -- line: 315
									-- upvalues: t16 (copy)
									return p86 ~= t16.messageId
								end)

								if #v452 == 0 then
									return Dictionary.removeKey(p84, t16.userId)
								end

								return Dictionary.join(p84, {
									[t16.userId] = v452
								})
							end)
						end

						return
					end

					v47(function(p87) -- line: 336
						-- upvalues: Dictionary (copy), t16 (copy)
						return Dictionary.join(p87, {
							[t16.messageId] = t16
						})
					end)

					if not FFlagExpChatMessagesStoreMemoryCleanup and t16.userId then
						v49(function(p88) -- line: 342
							-- upvalues: t16 (copy), List (copy), Dictionary (copy)
							local v455 = p88[t16.userId] or {}
							local v456 = nil

							for i, v in ipairs(v455) do
								if v.messageId == t16.messageId then
									v456 = i

									break
								end
							end

							if v456 then
								local v459 = List.set(v455, v456, t16)

								return Dictionary.join(p88, {
									[t16.userId] = v459
								})
							end

							return p88
						end)
					end

					return
				end

				local userId = t16.userId
				local partOrModel = t16.partOrModel

				if not userId and partOrModel then
					userId = v63(false)[partOrModel]

					if not userId then
						userId = HttpService:GenerateGUID(false)
						v62(function(p89) -- line: 378
							-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
							return Dictionary.join(p89, {
								[userId] = partOrModel
							})
						end)
						v64(function(p90) -- line: 385
							-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
							return Dictionary.join(p90, {
								[partOrModel] = userId
							})
						end)
					end
				end

				local v258 = if userId == t16.userId then t16 else Dictionary.join(t16, {
					userId = userId
				})
				local channelNameOverride = nil

				if GetFFlagTextChatEnableUniverseChatTabs() and v258.channelNameOverride then
					channelNameOverride = v258.channelNameOverride
				elseif v258.textChannel then
					channelNameOverride = if v258.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v65(false)) then v258.textChannel.Name else "RBXGeneral"
				end

				if v258.isVisibleInChatWindow then
					local v260 = v50(false)
					local v261 = if not channelNameOverride then {} else v52(false)[channelNameOverride] or {}

					if #v260 >= t1.messageLimit then
						local v262 = v260[1]
						local v263 = v254 and v254[v262]

						if v263 then
							if not FFlagExpChatMessagesStoreKeepInByMessageId then
								v47(function(p91) -- line: 427
									-- upvalues: Dictionary (copy), v262 (copy)
									return Dictionary.removeKey(p91, v262)
								end)
							end

							if v263.userId then
								v49(function(p92) -- line: 434
									-- upvalues: v263 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v262 (copy), v61 (copy), v64 (copy), Dictionary (copy), v62 (copy)
									local v464 = p92[v263.userId]

									if v464 then
										local v465 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v464, function(p93) -- line: 443
											-- upvalues: v262 (copy)
											return p93.messageId ~= v262
										end) else List.filter(v464, function(p94) -- line: 439
											-- upvalues: v262 (copy)
											return p94 ~= v262
										end)

										if #v465 == 0 then
											local v466 = v61(false)

											if v466[v263.userId] then
												local v467 = v466[v263.userId]

												v64(function(p95) -- line: 455
													-- upvalues: Dictionary (copy), v467 (copy)
													return Dictionary.removeKey(p95, v467)
												end)
												v62(function(p96) -- line: 459
													-- upvalues: Dictionary (copy), v263 (copy)
													return Dictionary.removeKey(p96, v263.userId)
												end)
											end

											return Dictionary.removeKey(p92, v263.userId)
										end

										return Dictionary.join(p92, {
											[v263.userId] = v465
										})
									end

									return p92
								end)
							end

							v51(function(p97) -- line: 476
								-- upvalues: List (copy)
								return List.removeIndex(p97, 1)
							end)

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v262] = nil
							end
						end
					end

					if channelNameOverride and #v261 >= t1.messageLimit then
						local v264 = v261[1]

						if v264 then
							v53(function(p98) -- line: 490
								-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
								local v470 = p98[channelNameOverride] or {}
								local v471 = List.removeIndex(v470, 1)

								return Dictionary.join(p98, {
									[channelNameOverride] = v471
								})
							end)

							if v254 and v254[v264] then
								v47(function(p99) -- line: 499
									-- upvalues: Dictionary (copy), v264 (copy)
									return Dictionary.removeKey(p99, v264)
								end)
							end

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v264] = nil
							end
						end
					end
				end

				v47(function(p100) -- line: 511
					-- upvalues: Dictionary (copy), v258 (copy)
					return Dictionary.join(p100, {
						[v258.messageId] = v258
					})
				end)

				if v258.userId then
					v49(function(p101) -- line: 516
						-- upvalues: v258 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
						local v475 = p101[v258.userId] or {}
						local v476 = false

						if FFlagExpChatMessagesStoreMemoryCleanup then
							for _, v in ipairs(v475) do
								if v == v258.messageId then
									v476 = true

									break
								end
							end
						else
							for _, v in ipairs(v475) do
								if v.messageId == v258.messageId then
									v476 = true

									break
								end
							end
						end

						if not v476 then
							local v481 = if not FFlagExpChatMessagesStoreMemoryCleanup then v258 else v258.messageId
							local v482 = List.append(v475, v481)

							return Dictionary.join(p101, {
								[v258.userId] = v482
							})
						end

						return p101
					end)
				end

				if v258.isVisibleInChatWindow then
					v51(function(p102) -- line: 553
						-- upvalues: List (copy), v258 (copy)
						return List.append(p102, v258.messageId)
					end)

					if channelNameOverride then
						v53(function(p103) -- line: 559
							-- upvalues: channelNameOverride (ref), List (copy), v258 (copy), Dictionary (copy)
							local v485 = p103[channelNameOverride] or {}
							local v486 = List.append(v485, v258.messageId)

							return Dictionary.join(p103, {
								[channelNameOverride] = v486
							})
						end)
					end

					if FFlagExpChatEnableV2ChatWindow then
						local v265 = v74(false)

						if v265 == nil or v265 == channelNameOverride then
							updateNextMessageComponent(v258.messageId)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(v137)

				return
			end

			v137()
		end,
		handleLegacyBubbleCreated = function(t17: {[any]: any}) -- line: 1200
			-- upvalues: v46 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v51 (copy), List (copy), resolveChannelNameForMapOrder (copy), v53 (copy), Dictionary (copy), v47 (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v63 (copy), HttpService (copy), v62 (copy), v64 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v65 (copy), v50 (copy), v52 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v61 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local timestamp = t17.timestamp
			local v158 = if not timestamp then DateTime.now() else DateTime.fromUnixTimestampMillis(timestamp)
			local t18 = {
				prefixText = "",
				shouldOverrideBubbleChatSettings = true,
				isVisibleInBubbleChat = true,
				isVisibleInChatWindow = false,
				translation = nil,
				useTranslation = false,
				textChannel = nil,
				bubbleChatMessageProperties = nil,
				chatWindowMessageProperties = nil,
				userId = t17.userId,
				text = t17.text,
				messageId = t17.id,
				status = Enum.TextChatMessageStatus.Success,
				timestamp = v158,
				partOrModel = t17.adornee
			}

			local function v160() -- line: 270
				-- upvalues: v46 (copy), t18 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v51 (copy), List (copy), resolveChannelNameForMapOrder (copy), v53 (copy), Dictionary (copy), v47 (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v63 (copy), HttpService (copy), v62 (copy), v64 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v65 (copy), v50 (copy), v52 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v61 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), updateNextMessageComponent (ref)
				local v294 = v46(false)

				if v294 and v294[t18.messageId] then
					if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t18.status == Enum.TextChatMessageStatus.Floodchecked or t18.status == Enum.TextChatMessageStatus.MessageTooLong) then
						v51(function(p104) -- line: 281
							-- upvalues: List (copy), t18 (copy)
							return List.filter(p104, function(p105) -- line: 282
								-- upvalues: t18 (copy)
								return p105 ~= t18.messageId
							end)
						end)

						local v295 = resolveChannelNameForMapOrder(t18, t18.channelNameOverride)

						if v295 then
							v53(function(p106) -- line: 289
								-- upvalues: v295 (copy), List (copy), t18 (copy), Dictionary (copy)
								local v548 = p106[v295]

								if not v548 then
									return p106
								end

								local v549 = List.filter(v548, function(p107) -- line: 294
									-- upvalues: t18 (copy)
									return p107 ~= t18.messageId
								end)

								return Dictionary.join(p106, {
									[v295] = v549
								})
							end)
						end

						v47(function(p108) -- line: 303
							-- upvalues: Dictionary (copy), t18 (copy)
							return Dictionary.removeKey(p108, t18.messageId)
						end)

						if t18.userId then
							v49(function(p109) -- line: 308
								-- upvalues: t18 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
								local v552 = p109[t18.userId]

								if not v552 then
									return p109
								end

								local v553 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v552, function(p110) -- line: 319
									-- upvalues: t18 (copy)
									return p110.messageId ~= t18.messageId
								end) else List.filter(v552, function(p111) -- line: 315
									-- upvalues: t18 (copy)
									return p111 ~= t18.messageId
								end)

								if #v553 == 0 then
									return Dictionary.removeKey(p109, t18.userId)
								end

								return Dictionary.join(p109, {
									[t18.userId] = v553
								})
							end)
						end

						return
					end

					v47(function(p112) -- line: 336
						-- upvalues: Dictionary (copy), t18 (copy)
						return Dictionary.join(p112, {
							[t18.messageId] = t18
						})
					end)

					if not FFlagExpChatMessagesStoreMemoryCleanup and t18.userId then
						v49(function(p113) -- line: 342
							-- upvalues: t18 (copy), List (copy), Dictionary (copy)
							local v556 = p113[t18.userId] or {}
							local v557 = nil

							for i, v in ipairs(v556) do
								if v.messageId == t18.messageId then
									v557 = i

									break
								end
							end

							if v557 then
								local v560 = List.set(v556, v557, t18)

								return Dictionary.join(p113, {
									[t18.userId] = v560
								})
							end

							return p113
						end)
					end

					return
				end

				local userId = t18.userId
				local partOrModel = t18.partOrModel

				if not userId and partOrModel then
					userId = v63(false)[partOrModel]

					if not userId then
						userId = HttpService:GenerateGUID(false)
						v62(function(p114) -- line: 378
							-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
							return Dictionary.join(p114, {
								[userId] = partOrModel
							})
						end)
						v64(function(p115) -- line: 385
							-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
							return Dictionary.join(p115, {
								[partOrModel] = userId
							})
						end)
					end
				end

				local v298 = if userId == t18.userId then t18 else Dictionary.join(t18, {
					userId = userId
				})
				local channelNameOverride = nil

				if GetFFlagTextChatEnableUniverseChatTabs() and v298.channelNameOverride then
					channelNameOverride = v298.channelNameOverride
				elseif v298.textChannel then
					channelNameOverride = if v298.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v65(false)) then v298.textChannel.Name else "RBXGeneral"
				end

				if v298.isVisibleInChatWindow then
					local v300 = v50(false)
					local v301 = if not channelNameOverride then {} else v52(false)[channelNameOverride] or {}

					if #v300 >= t1.messageLimit then
						local v302 = v300[1]
						local v303 = v294 and v294[v302]

						if v303 then
							if not FFlagExpChatMessagesStoreKeepInByMessageId then
								v47(function(p116) -- line: 427
									-- upvalues: Dictionary (copy), v302 (copy)
									return Dictionary.removeKey(p116, v302)
								end)
							end

							if v303.userId then
								v49(function(p117) -- line: 434
									-- upvalues: v303 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v302 (copy), v61 (copy), v64 (copy), Dictionary (copy), v62 (copy)
									local v565 = p117[v303.userId]

									if v565 then
										local v566 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v565, function(p118) -- line: 443
											-- upvalues: v302 (copy)
											return p118.messageId ~= v302
										end) else List.filter(v565, function(p119) -- line: 439
											-- upvalues: v302 (copy)
											return p119 ~= v302
										end)

										if #v566 == 0 then
											local v567 = v61(false)

											if v567[v303.userId] then
												local v568 = v567[v303.userId]

												v64(function(p120) -- line: 455
													-- upvalues: Dictionary (copy), v568 (copy)
													return Dictionary.removeKey(p120, v568)
												end)
												v62(function(p121) -- line: 459
													-- upvalues: Dictionary (copy), v303 (copy)
													return Dictionary.removeKey(p121, v303.userId)
												end)
											end

											return Dictionary.removeKey(p117, v303.userId)
										end

										return Dictionary.join(p117, {
											[v303.userId] = v566
										})
									end

									return p117
								end)
							end

							v51(function(p122) -- line: 476
								-- upvalues: List (copy)
								return List.removeIndex(p122, 1)
							end)

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v302] = nil
							end
						end
					end

					if channelNameOverride and #v301 >= t1.messageLimit then
						local v304 = v301[1]

						if v304 then
							v53(function(p123) -- line: 490
								-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
								local v571 = p123[channelNameOverride] or {}
								local v572 = List.removeIndex(v571, 1)

								return Dictionary.join(p123, {
									[channelNameOverride] = v572
								})
							end)

							if v294 and v294[v304] then
								v47(function(p124) -- line: 499
									-- upvalues: Dictionary (copy), v304 (copy)
									return Dictionary.removeKey(p124, v304)
								end)
							end

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v304] = nil
							end
						end
					end
				end

				v47(function(p125) -- line: 511
					-- upvalues: Dictionary (copy), v298 (copy)
					return Dictionary.join(p125, {
						[v298.messageId] = v298
					})
				end)

				if v298.userId then
					v49(function(p126) -- line: 516
						-- upvalues: v298 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
						local v576 = p126[v298.userId] or {}
						local v577 = false

						if FFlagExpChatMessagesStoreMemoryCleanup then
							for _, v in ipairs(v576) do
								if v == v298.messageId then
									v577 = true

									break
								end
							end
						else
							for _, v in ipairs(v576) do
								if v.messageId == v298.messageId then
									v577 = true

									break
								end
							end
						end

						if not v577 then
							local v582 = if not FFlagExpChatMessagesStoreMemoryCleanup then v298 else v298.messageId
							local v583 = List.append(v576, v582)

							return Dictionary.join(p126, {
								[v298.userId] = v583
							})
						end

						return p126
					end)
				end

				if v298.isVisibleInChatWindow then
					v51(function(p127) -- line: 553
						-- upvalues: List (copy), v298 (copy)
						return List.append(p127, v298.messageId)
					end)

					if channelNameOverride then
						v53(function(p128) -- line: 559
							-- upvalues: channelNameOverride (ref), List (copy), v298 (copy), Dictionary (copy)
							local v586 = p128[channelNameOverride] or {}
							local v587 = List.append(v586, v298.messageId)

							return Dictionary.join(p128, {
								[channelNameOverride] = v587
							})
						end)
					end

					if FFlagExpChatEnableV2ChatWindow then
						local v305 = v74(false)

						if v305 == nil or v305 == channelNameOverride then
							updateNextMessageComponent(v298.messageId)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(v160)

				return
			end

			v160()
		end,
		handleLegacyBubbleTextUpdated = function(s19: string, s20: string) -- line: 1237
			-- upvalues: v47 (copy), Dictionary (copy)
			v47(function(p129) -- line: 1238
				-- upvalues: s19 (copy), Dictionary (copy), s20 (copy)
				if not p129 then
					return {}
				end

				if p129[s19] then
					local v307 = p129[s19]
					local v308 = Dictionary.join(v307, {
						text = s20
					})

					return Dictionary.join(p129, {
						[s19] = v308
					})
				end

				return p129
			end)
		end,
		handleHiddenMessageReceived = function(p130) -- line: 921
			-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), FIntExpChatRandomCharChangeLowerBound (copy), FIntExpChatRandomCharChangeUpperBound (copy), Config (copy), getFFlagExpChatTelemetryEventTrigger (copy), v46 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v51 (copy), List (copy), resolveChannelNameForMapOrder (copy), v53 (copy), Dictionary (copy), v47 (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v63 (copy), HttpService (copy), v62 (copy), v64 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v65 (copy), v50 (copy), v52 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v61 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local v139 = string.len(if not getFFlagExpChatProtectedChatInternalAPIs() then p130.Text else p130.TextInternal)
			local v140 = math.max(FIntExpChatRandomCharChangeLowerBound, -(v139 - 1))
			local v141 = FIntExpChatRandomCharChangeUpperBound
			local v142 = math.random(v140, v141)
			local v143 = string.rep(Config.DOT_TEXT, v139 + v142)
			local t19 = {
				userId = nil,
				isVisibleInBubbleChat = false,
				isVisibleInChatWindow = true,
				isHiddenMessage = true,
				prefixText = Config.LOCK_EMOJI .. " :",
				text = v143,
				textChannel = p130.TextChannel,
				messageId = p130.MessageId,
				status = p130.Status,
				timestamp = p130.Timestamp,
				textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else p130
			}

			local function v145() -- line: 270
				-- upvalues: v46 (copy), t19 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v51 (copy), List (copy), resolveChannelNameForMapOrder (copy), v53 (copy), Dictionary (copy), v47 (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v63 (copy), HttpService (copy), v62 (copy), v64 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v65 (copy), v50 (copy), v52 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v61 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), updateNextMessageComponent (ref)
				local v266 = v46(false)

				if v266 and v266[t19.messageId] then
					if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t19.status == Enum.TextChatMessageStatus.Floodchecked or t19.status == Enum.TextChatMessageStatus.MessageTooLong) then
						v51(function(p131) -- line: 281
							-- upvalues: List (copy), t19 (copy)
							return List.filter(p131, function(p132) -- line: 282
								-- upvalues: t19 (copy)
								return p132 ~= t19.messageId
							end)
						end)

						local v267 = resolveChannelNameForMapOrder(t19, t19.channelNameOverride)

						if v267 then
							v53(function(p133) -- line: 289
								-- upvalues: v267 (copy), List (copy), t19 (copy), Dictionary (copy)
								local v489 = p133[v267]

								if not v489 then
									return p133
								end

								local v490 = List.filter(v489, function(p134) -- line: 294
									-- upvalues: t19 (copy)
									return p134 ~= t19.messageId
								end)

								return Dictionary.join(p133, {
									[v267] = v490
								})
							end)
						end

						v47(function(p135) -- line: 303
							-- upvalues: Dictionary (copy), t19 (copy)
							return Dictionary.removeKey(p135, t19.messageId)
						end)

						if t19.userId then
							v49(function(p136) -- line: 308
								-- upvalues: t19 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
								local v493 = p136[t19.userId]

								if not v493 then
									return p136
								end

								local v494 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v493, function(p137) -- line: 319
									-- upvalues: t19 (copy)
									return p137.messageId ~= t19.messageId
								end) else List.filter(v493, function(p138) -- line: 315
									-- upvalues: t19 (copy)
									return p138 ~= t19.messageId
								end)

								if #v494 == 0 then
									return Dictionary.removeKey(p136, t19.userId)
								end

								return Dictionary.join(p136, {
									[t19.userId] = v494
								})
							end)
						end

						return
					end

					v47(function(p139) -- line: 336
						-- upvalues: Dictionary (copy), t19 (copy)
						return Dictionary.join(p139, {
							[t19.messageId] = t19
						})
					end)

					if not FFlagExpChatMessagesStoreMemoryCleanup and t19.userId then
						v49(function(p140) -- line: 342
							-- upvalues: t19 (copy), List (copy), Dictionary (copy)
							local v497 = p140[t19.userId] or {}
							local v498 = nil

							for i, v in ipairs(v497) do
								if v.messageId == t19.messageId then
									v498 = i

									break
								end
							end

							if v498 then
								local v501 = List.set(v497, v498, t19)

								return Dictionary.join(p140, {
									[t19.userId] = v501
								})
							end

							return p140
						end)
					end

					return
				end

				local userId = t19.userId
				local partOrModel = t19.partOrModel

				if not userId and partOrModel then
					userId = v63(false)[partOrModel]

					if not userId then
						userId = HttpService:GenerateGUID(false)
						v62(function(p141) -- line: 378
							-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
							return Dictionary.join(p141, {
								[userId] = partOrModel
							})
						end)
						v64(function(p142) -- line: 385
							-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
							return Dictionary.join(p142, {
								[partOrModel] = userId
							})
						end)
					end
				end

				local v270 = if userId == t19.userId then t19 else Dictionary.join(t19, {
					userId = userId
				})
				local channelNameOverride = nil

				if GetFFlagTextChatEnableUniverseChatTabs() and v270.channelNameOverride then
					channelNameOverride = v270.channelNameOverride
				elseif v270.textChannel then
					channelNameOverride = if v270.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v65(false)) then v270.textChannel.Name else "RBXGeneral"
				end

				if v270.isVisibleInChatWindow then
					local v272 = v50(false)
					local v273 = if not channelNameOverride then {} else v52(false)[channelNameOverride] or {}

					if #v272 >= t1.messageLimit then
						local v274 = v272[1]
						local v275 = v266 and v266[v274]

						if v275 then
							if not FFlagExpChatMessagesStoreKeepInByMessageId then
								v47(function(p143) -- line: 427
									-- upvalues: Dictionary (copy), v274 (copy)
									return Dictionary.removeKey(p143, v274)
								end)
							end

							if v275.userId then
								v49(function(p144) -- line: 434
									-- upvalues: v275 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v274 (copy), v61 (copy), v64 (copy), Dictionary (copy), v62 (copy)
									local v506 = p144[v275.userId]

									if v506 then
										local v507 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v506, function(p145) -- line: 443
											-- upvalues: v274 (copy)
											return p145.messageId ~= v274
										end) else List.filter(v506, function(p146) -- line: 439
											-- upvalues: v274 (copy)
											return p146 ~= v274
										end)

										if #v507 == 0 then
											local v508 = v61(false)

											if v508[v275.userId] then
												local v509 = v508[v275.userId]

												v64(function(p147) -- line: 455
													-- upvalues: Dictionary (copy), v509 (copy)
													return Dictionary.removeKey(p147, v509)
												end)
												v62(function(p148) -- line: 459
													-- upvalues: Dictionary (copy), v275 (copy)
													return Dictionary.removeKey(p148, v275.userId)
												end)
											end

											return Dictionary.removeKey(p144, v275.userId)
										end

										return Dictionary.join(p144, {
											[v275.userId] = v507
										})
									end

									return p144
								end)
							end

							v51(function(p149) -- line: 476
								-- upvalues: List (copy)
								return List.removeIndex(p149, 1)
							end)

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v274] = nil
							end
						end
					end

					if channelNameOverride and #v273 >= t1.messageLimit then
						local v276 = v273[1]

						if v276 then
							v53(function(p150) -- line: 490
								-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
								local v512 = p150[channelNameOverride] or {}
								local v513 = List.removeIndex(v512, 1)

								return Dictionary.join(p150, {
									[channelNameOverride] = v513
								})
							end)

							if v266 and v266[v276] then
								v47(function(p151) -- line: 499
									-- upvalues: Dictionary (copy), v276 (copy)
									return Dictionary.removeKey(p151, v276)
								end)
							end

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v276] = nil
							end
						end
					end
				end

				v47(function(p152) -- line: 511
					-- upvalues: Dictionary (copy), v270 (copy)
					return Dictionary.join(p152, {
						[v270.messageId] = v270
					})
				end)

				if v270.userId then
					v49(function(p153) -- line: 516
						-- upvalues: v270 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
						local v517 = p153[v270.userId] or {}
						local v518 = false

						if FFlagExpChatMessagesStoreMemoryCleanup then
							for _, v in ipairs(v517) do
								if v == v270.messageId then
									v518 = true

									break
								end
							end
						else
							for _, v in ipairs(v517) do
								if v.messageId == v270.messageId then
									v518 = true

									break
								end
							end
						end

						if not v518 then
							local v523 = if not FFlagExpChatMessagesStoreMemoryCleanup then v270 else v270.messageId
							local v524 = List.append(v517, v523)

							return Dictionary.join(p153, {
								[v270.userId] = v524
							})
						end

						return p153
					end)
				end

				if v270.isVisibleInChatWindow then
					v51(function(p154) -- line: 553
						-- upvalues: List (copy), v270 (copy)
						return List.append(p154, v270.messageId)
					end)

					if channelNameOverride then
						v53(function(p155) -- line: 559
							-- upvalues: channelNameOverride (ref), List (copy), v270 (copy), Dictionary (copy)
							local v527 = p155[channelNameOverride] or {}
							local v528 = List.append(v527, v270.messageId)

							return Dictionary.join(p155, {
								[channelNameOverride] = v528
							})
						end)
					end

					if FFlagExpChatEnableV2ChatWindow then
						local v277 = v74(false)

						if v277 == nil or v277 == channelNameOverride then
							updateNextMessageComponent(v270.messageId)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(v145)

				return
			end

			v145()
		end,
		handleHiddenMessagesCleared = function() -- line: 1063
			-- upvalues: FFlagExpChatClearHiddenMessagesPostAgeCheck (copy), v47 (copy), Dictionary (copy), v51 (copy), List (copy), v46 (copy), v53 (copy)
			if not FFlagExpChatClearHiddenMessagesPostAgeCheck then
				return
			end

			v47(function(p156) -- line: 1070
				-- upvalues: Dictionary (copy)
				return Dictionary.map(p156, function(p157) -- line: 1071
					-- upvalues: Dictionary (copy)
					if p157.isHiddenMessage then
						return Dictionary.join(p157, {
							isVisibleInChatWindow = false
						})
					end

					return p157
				end)
			end)
			v51(function(p158) -- line: 1083
				-- upvalues: List (copy), v46 (copy)
				return List.filter(p158, function(p159) -- line: 1084
					-- upvalues: v46 (copy)
					local v539 = v46(false)[p159]

					return v539 and not v539.isHiddenMessage
				end)
			end)
			v53(function(p160) -- line: 1091
				-- upvalues: Dictionary (copy), List (copy), v46 (copy)
				return Dictionary.map(p160, function(p161) -- line: 1092
					-- upvalues: List (copy), v46 (copy)
					return List.filter(p161, function(p162) -- line: 1093
						-- upvalues: v46 (copy)
						local v633 = v46(false)[p162]

						return v633 and not v633.isHiddenMessage
					end)
				end)
			end)
		end,
		addSystemMessage = function(s21: string, s22: string, s23: string?, p163: ((...any) -> ...any)?, b5: boolean?) -- line: 689
			-- upvalues: sanitizeForRichText (copy), GetFFlagExpChatSyntheticSystemMessageRichText (copy), generateRichSystemMessageTextFormat (copy), FFlagExpChatDictation (copy), FFlagExpChatEnablePostProcessRichSystemMessageTextFormat (copy), HttpService (copy), v46 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v51 (copy), List (copy), resolveChannelNameForMapOrder (copy), v53 (copy), Dictionary (copy), v47 (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v63 (copy), v62 (copy), v64 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v65 (copy), v50 (copy), v52 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v61 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local v108 = sanitizeForRichText(s21)
			local v109 = if not GetFFlagExpChatSyntheticSystemMessageRichText() then v108 else generateRichSystemMessageTextFormat(v108, if not FFlagExpChatDictation then nil else b5, if not FFlagExpChatEnablePostProcessRichSystemMessageTextFormat then nil else p163)
			local guid = HttpService:GenerateGUID(false)
			local t20 = {
				userId = nil,
				prefixText = "",
				translation = nil,
				useTranslation = false,
				isVisibleInChatWindow = true,
				isVisibleInBubbleChat = false,
				shouldOverrideBubbleChatSettings = false,
				textChannel = nil,
				bubbleChatMessageProperties = nil,
				chatWindowMessageProperties = nil,
				textChatMessageInstance = nil,
				partOrModel = nil,
				text = v109,
				messageId = guid,
				timestamp = DateTime.fromUnixTimestampMillis(workspace:GetServerTimeNow() * 1000),
				status = Enum.TextChatMessageStatus.Success,
				channelNameOverride = s22,
				metadata = s23
			}

			local function v112() -- line: 270
				-- upvalues: v46 (copy), t20 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v51 (copy), List (copy), resolveChannelNameForMapOrder (copy), v53 (copy), Dictionary (copy), v47 (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v63 (copy), HttpService (copy), v62 (copy), v64 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v65 (copy), v50 (copy), v52 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v61 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), updateNextMessageComponent (ref)
				local v230 = v46(false)

				if v230 and v230[t20.messageId] then
					if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t20.status == Enum.TextChatMessageStatus.Floodchecked or t20.status == Enum.TextChatMessageStatus.MessageTooLong) then
						v51(function(p164) -- line: 281
							-- upvalues: List (copy), t20 (copy)
							return List.filter(p164, function(p165) -- line: 282
								-- upvalues: t20 (copy)
								return p165 ~= t20.messageId
							end)
						end)

						local v231 = resolveChannelNameForMapOrder(t20, t20.channelNameOverride)

						if v231 then
							v53(function(p166) -- line: 289
								-- upvalues: v231 (copy), List (copy), t20 (copy), Dictionary (copy)
								local v363 = p166[v231]

								if not v363 then
									return p166
								end

								local v364 = List.filter(v363, function(p167) -- line: 294
									-- upvalues: t20 (copy)
									return p167 ~= t20.messageId
								end)

								return Dictionary.join(p166, {
									[v231] = v364
								})
							end)
						end

						v47(function(p168) -- line: 303
							-- upvalues: Dictionary (copy), t20 (copy)
							return Dictionary.removeKey(p168, t20.messageId)
						end)

						if t20.userId then
							v49(function(p169) -- line: 308
								-- upvalues: t20 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
								local v367 = p169[t20.userId]

								if not v367 then
									return p169
								end

								local v368 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v367, function(p170) -- line: 319
									-- upvalues: t20 (copy)
									return p170.messageId ~= t20.messageId
								end) else List.filter(v367, function(p171) -- line: 315
									-- upvalues: t20 (copy)
									return p171 ~= t20.messageId
								end)

								if #v368 == 0 then
									return Dictionary.removeKey(p169, t20.userId)
								end

								return Dictionary.join(p169, {
									[t20.userId] = v368
								})
							end)
						end

						return
					end

					v47(function(p172) -- line: 336
						-- upvalues: Dictionary (copy), t20 (copy)
						return Dictionary.join(p172, {
							[t20.messageId] = t20
						})
					end)

					if not FFlagExpChatMessagesStoreMemoryCleanup and t20.userId then
						v49(function(p173) -- line: 342
							-- upvalues: t20 (copy), List (copy), Dictionary (copy)
							local v371 = p173[t20.userId] or {}
							local v372 = nil

							for i, v in ipairs(v371) do
								if v.messageId == t20.messageId then
									v372 = i

									break
								end
							end

							if v372 then
								local v375 = List.set(v371, v372, t20)

								return Dictionary.join(p173, {
									[t20.userId] = v375
								})
							end

							return p173
						end)
					end

					return
				end

				local userId = t20.userId
				local partOrModel = t20.partOrModel

				if not userId and partOrModel then
					userId = v63(false)[partOrModel]

					if not userId then
						userId = HttpService:GenerateGUID(false)
						v62(function(p174) -- line: 378
							-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
							return Dictionary.join(p174, {
								[userId] = partOrModel
							})
						end)
						v64(function(p175) -- line: 385
							-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
							return Dictionary.join(p175, {
								[partOrModel] = userId
							})
						end)
					end
				end

				local v234 = if userId == t20.userId then t20 else Dictionary.join(t20, {
					userId = userId
				})
				local channelNameOverride = nil

				if GetFFlagTextChatEnableUniverseChatTabs() and v234.channelNameOverride then
					channelNameOverride = v234.channelNameOverride
				elseif v234.textChannel then
					channelNameOverride = if v234.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v65(false)) then v234.textChannel.Name else "RBXGeneral"
				end

				if v234.isVisibleInChatWindow then
					local v236 = v50(false)
					local v237 = if not channelNameOverride then {} else v52(false)[channelNameOverride] or {}

					if #v236 >= t1.messageLimit then
						local v238 = v236[1]
						local v239 = v230 and v230[v238]

						if v239 then
							if not FFlagExpChatMessagesStoreKeepInByMessageId then
								v47(function(p176) -- line: 427
									-- upvalues: Dictionary (copy), v238 (copy)
									return Dictionary.removeKey(p176, v238)
								end)
							end

							if v239.userId then
								v49(function(p177) -- line: 434
									-- upvalues: v239 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v238 (copy), v61 (copy), v64 (copy), Dictionary (copy), v62 (copy)
									local v380 = p177[v239.userId]

									if v380 then
										local v381 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v380, function(p178) -- line: 443
											-- upvalues: v238 (copy)
											return p178.messageId ~= v238
										end) else List.filter(v380, function(p179) -- line: 439
											-- upvalues: v238 (copy)
											return p179 ~= v238
										end)

										if #v381 == 0 then
											local v382 = v61(false)

											if v382[v239.userId] then
												local v383 = v382[v239.userId]

												v64(function(p180) -- line: 455
													-- upvalues: Dictionary (copy), v383 (copy)
													return Dictionary.removeKey(p180, v383)
												end)
												v62(function(p181) -- line: 459
													-- upvalues: Dictionary (copy), v239 (copy)
													return Dictionary.removeKey(p181, v239.userId)
												end)
											end

											return Dictionary.removeKey(p177, v239.userId)
										end

										return Dictionary.join(p177, {
											[v239.userId] = v381
										})
									end

									return p177
								end)
							end

							v51(function(p182) -- line: 476
								-- upvalues: List (copy)
								return List.removeIndex(p182, 1)
							end)

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v238] = nil
							end
						end
					end

					if channelNameOverride and #v237 >= t1.messageLimit then
						local v240 = v237[1]

						if v240 then
							v53(function(p183) -- line: 490
								-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
								local v386 = p183[channelNameOverride] or {}
								local v387 = List.removeIndex(v386, 1)

								return Dictionary.join(p183, {
									[channelNameOverride] = v387
								})
							end)

							if v230 and v230[v240] then
								v47(function(p184) -- line: 499
									-- upvalues: Dictionary (copy), v240 (copy)
									return Dictionary.removeKey(p184, v240)
								end)
							end

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v240] = nil
							end
						end
					end
				end

				v47(function(p185) -- line: 511
					-- upvalues: Dictionary (copy), v234 (copy)
					return Dictionary.join(p185, {
						[v234.messageId] = v234
					})
				end)

				if v234.userId then
					v49(function(p186) -- line: 516
						-- upvalues: v234 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
						local v391 = p186[v234.userId] or {}
						local v392 = false

						if FFlagExpChatMessagesStoreMemoryCleanup then
							for _, v in ipairs(v391) do
								if v == v234.messageId then
									v392 = true

									break
								end
							end
						else
							for _, v in ipairs(v391) do
								if v.messageId == v234.messageId then
									v392 = true

									break
								end
							end
						end

						if not v392 then
							local v397 = if not FFlagExpChatMessagesStoreMemoryCleanup then v234 else v234.messageId
							local v398 = List.append(v391, v397)

							return Dictionary.join(p186, {
								[v234.userId] = v398
							})
						end

						return p186
					end)
				end

				if v234.isVisibleInChatWindow then
					v51(function(p187) -- line: 553
						-- upvalues: List (copy), v234 (copy)
						return List.append(p187, v234.messageId)
					end)

					if channelNameOverride then
						v53(function(p188) -- line: 559
							-- upvalues: channelNameOverride (ref), List (copy), v234 (copy), Dictionary (copy)
							local v401 = p188[channelNameOverride] or {}
							local v402 = List.append(v401, v234.messageId)

							return Dictionary.join(p188, {
								[channelNameOverride] = v402
							})
						end)
					end

					if FFlagExpChatEnableV2ChatWindow then
						local v241 = v74(false)

						if v241 == nil or v241 == channelNameOverride then
							updateNextMessageComponent(v234.messageId)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(v112)

				return
			end

			v112()
		end,
		getChannelTabsConfigurationEnabled = v65,
		setChannelTabsConfigurationEnabled = v66
	}
end

return createMessagesStore
