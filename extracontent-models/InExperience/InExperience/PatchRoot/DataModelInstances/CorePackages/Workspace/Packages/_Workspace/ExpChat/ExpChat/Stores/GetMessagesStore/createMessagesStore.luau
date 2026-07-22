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
local createProxy = SignalsExperimental.createProxy
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
local FFlagExpChatMessagesStoreKeepInByMessageId = require(ExpChat.Flags.FFlagExpChatMessagesStoreKeepInByMessageId)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation
local FFlagExpChatMessagesStoreBatch = require(ExpChat.Flags.FFlagExpChatMessagesStoreBatch)
local FFlagExpChatMessagesStoreUseProxy = require(ExpChat.Flags.FFlagExpChatMessagesStoreUseProxy)
local FFlagExpChatMessagesStoreMemoryCleanup = require(ExpChat.Flags.FFlagExpChatMessagesStoreMemoryCleanup)
local FFlagExpChatEvictFloodcheckedFromWindowOrder = require(ExpChat.Flags.FFlagExpChatEvictFloodcheckedFromWindowOrder)

function getChatTranslationEnabled() -- line: 54
	-- upvalues: TextChatService (copy)
	return TextChatService.ChatTranslationEnabled
end

local function createMessagesStore(p1) -- line: 176
	-- upvalues: createSignal (copy), FFlagExpChatMessagesStoreUseProxy (copy), createProxy (copy), createComputed (copy), Dictionary (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), List (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), HttpService (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), FFlagExpChatEnableV2ChatWindow (copy), Set (copy), sanitizeForRichText (copy), GetFFlagExpChatSyntheticSystemMessageRichText (copy), generateRichSystemMessageTextFormat (copy), FFlagExpChatDictation (copy), computeNameColor (copy), Players (copy), FFlagEnableInExpChatRewrite (copy), getTextAndTranslation (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), isWhiteSpaceOnly (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), ExpChatShared (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatDisableUniverseBubbleChat (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), FIntExpChatRandomCharChangeLowerBound (copy), FIntExpChatRandomCharChangeUpperBound (copy), Config (copy), FFlagExpChatClearHiddenMessagesPostAgeCheck (copy)
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
	local v47, v48 = createSignal(t1.byMessageId)
	local v49 = if not FFlagExpChatMessagesStoreUseProxy then nil else createProxy({})
	local v50, v51 = createSignal(t1.messagesBySenderId)
	local v52 = if not FFlagExpChatMessagesStoreUseProxy then nil else createProxy({})
	local v53, v54 = createSignal(t1.windowMessagesInOrder)
	local v55, v56 = createSignal(t1.windowMessagesInOrderByTabId)
	local v57, v58 = createSignal(t1.mutedUserIds)
	local v59 = if p1 == nil then v57 else createComputed(function(p2) -- line: 209
		-- upvalues: v57 (copy), p1 (copy)
		local v100 = v57(p2)
		local v101 = p1(p2)
		local v102 = table.clone(v100)

		for v103 in v101 do
			v102[v103] = true
		end

		return v102
	end)
	local v60, v61 = createSignal(t1.canLocalUserChat)
	local v62, _ = createSignal(t1.isBubbleChatEnabled)
	local v64, v65 = createSignal(t1.mockUserIdToPartOrModel)
	local v66, v67 = createSignal(t1.partOrModelToMockUserId)
	local v68, v69 = createSignal(false)
	local v70, v71 = createSignal(t1.messageComponentRingBuffer)
	local v72, v73 = createSignal(t1.nextMessageComponentPointer)
	local t2 = {}
	local n1 = 0
	local t3 = {}
	local v77, v78 = createSignal(nil)
	local updateNextMessageComponent = nil
	local t4 = {}

	local function readByMessageId() -- line: 251
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			return v49
		end

		return v47(false)
	end
	local function readByMessageIdReactive(p3) -- line: 258
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			return v49(p3)
		end

		return v47(p3)
	end
	local function writeByMessageId(s1: string, t5: {[any]: any}?) -- line: 265
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v48 (copy), Dictionary (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			v49[s1] = t5

			return
		end

		if t5 ~= nil then
			v48(function(p4) -- line: 269
				-- upvalues: Dictionary (copy), s1 (copy), t5 (copy)
				return Dictionary.join(p4, {
					[s1] = t5
				})
			end)

			return
		end

		v48(function(p5) -- line: 273
			-- upvalues: Dictionary (copy), s1 (copy)
			return Dictionary.removeKey(p5, s1)
		end)
	end
	local function updateByMessageId(s2: string, p6: ((...any) -> ...any)) -- line: 280
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v48 (copy), Dictionary (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			local v109 = v49[s2]

			if v109 then
				local v110 = p6(v109)

				if v110 then
					v49[s2] = v110

					return
				end
			end
		else
			v48(function(p7) -- line: 290
				-- upvalues: s2 (copy), p6 (copy), Dictionary (copy)
				if not p7 or not p7[s2] then
					return p7 or {}
				end

				local v232 = p6(p7[s2])

				if v232 then
					return Dictionary.join(p7, {
						[s2] = v232
					})
				end

				return p7
			end)
		end
	end
	local function forEachByMessageId(p8: ((...any) -> ...any)) -- line: 303
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v48 (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			for v112 in v49 do
				local v113 = v49[v112]

				if v113 then
					local v114 = p8(v112, v113)

					if v114 then
						v49[v112] = v114
					end
				end
			end

			return
		end

		v48(function(p9) -- line: 315
			-- upvalues: p8 (copy)
			if not p9 then
				return {}
			end

			local t6 = {}

			for v235, v236 in p9 do
				t6[v235] = p8(v235, v236) or v236
			end

			return t6
		end)
	end
	local function readMessagesBySenderIdReactive(p10) -- line: 331
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v52 (copy), v50 (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			return v52(p10)
		end

		return v50(p10)
	end
	local function writeMessagesBySenderId(s3: string, p11) -- line: 338
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v52 (copy), v51 (copy), Dictionary (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			v52[s3] = p11

			return
		end

		if p11 ~= nil then
			v51(function(p12) -- line: 342
				-- upvalues: Dictionary (copy), s3 (copy), p11 (copy)
				return Dictionary.join(p12, {
					[s3] = p11
				})
			end)

			return
		end

		v51(function(p13) -- line: 346
			-- upvalues: Dictionary (copy), s3 (copy)
			return Dictionary.removeKey(p13, s3)
		end)
	end
	local function updateMessagesBySenderId(s4: string, p14: ((...any) -> ...any)) -- line: 352
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v52 (copy), v51 (copy), Dictionary (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			v52[s4] = p14(v52[s4])

			return
		end

		v51(function(p15) -- line: 357
			-- upvalues: p14 (copy), s4 (copy), Dictionary (copy)
			local v240 = p14(p15[s4])

			if v240 == nil then
				return Dictionary.removeKey(p15, s4)
			end

			return Dictionary.join(p15, {
				[s4] = v240
			})
		end)
	end
	local function resolveChannelNameForMapOrder(t7: {[any]: any}, s5: string?) -- line: 367
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), v68 (copy)
		if GetFFlagTextChatEnableUniverseChatTabs() then
			if s5 then
				return s5
			end

			if t7.textChannel then
				if t7.textChannel.Name == "RBXSystem" or not v68(false) then
					return "RBXGeneral"
				end

				return t7.textChannel.Name
			end

			return nil
		end

		if t7.textChannel then
			if t7.textChannel.Name == "RBXSystem" then
				return "RBXGeneral"
			end

			return t7.textChannel.Name
		end

		return nil
	end
	local function maybeBatch(p16: ((...any) -> ...any)) -- line: 387
		-- upvalues: FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
		if FFlagExpChatMessagesStoreBatch then
			SignalsExperimental.batch(p16)

			return
		end

		p16()
	end
	local function addMessage(t8: {[any]: any}) -- line: 395
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v54 (copy), List (copy), resolveChannelNameForMapOrder (copy), v56 (copy), Dictionary (copy), v48 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v52 (copy), v51 (copy), writeByMessageId (copy), v66 (copy), HttpService (copy), v65 (copy), v67 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v68 (copy), v53 (copy), v55 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v64 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v77 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
		local function v124() -- line: 396
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), t8 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v54 (copy), List (copy), resolveChannelNameForMapOrder (copy), v56 (copy), Dictionary (copy), v48 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v52 (copy), v51 (copy), writeByMessageId (copy), v66 (copy), HttpService (copy), v65 (copy), v67 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v68 (copy), v53 (copy), v55 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v64 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v77 (copy), updateNextMessageComponent (ref)
			local v241 = if not FFlagExpChatMessagesStoreUseProxy then v47(false) else v49

			if v241 and v241[t8.messageId] then
				if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t8.status == Enum.TextChatMessageStatus.Floodchecked or t8.status == Enum.TextChatMessageStatus.MessageTooLong) then
					v54(function(p17) -- line: 407
						-- upvalues: List (copy), t8 (copy)
						return List.filter(p17, function(p18) -- line: 408
							-- upvalues: t8 (copy)
							return p18 ~= t8.messageId
						end)
					end)

					local v242 = resolveChannelNameForMapOrder(t8, t8.channelNameOverride)

					if v242 then
						v56(function(p19) -- line: 415
							-- upvalues: v242 (copy), List (copy), t8 (copy), Dictionary (copy)
							local v432 = p19[v242]

							if not v432 then
								return p19
							end

							local v433 = List.filter(v432, function(p20) -- line: 420
								-- upvalues: t8 (copy)
								return p20 ~= t8.messageId
							end)

							return Dictionary.join(p19, {
								[v242] = v433
							})
						end)
					end

					local messageId = t8.messageId

					if FFlagExpChatMessagesStoreUseProxy then
						v49[messageId] = nil
					else
						v48(function(p21) -- line: 273
							-- upvalues: Dictionary (copy), messageId (copy)
							return Dictionary.removeKey(p21, messageId)
						end)
					end

					if t8.userId then
						local userId = t8.userId

						local function v245(p22) -- line: 432
							-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), t8 (copy)
							if not p22 then
								return nil
							end

							local v436 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p22, function(p23) -- line: 442
								-- upvalues: t8 (copy)
								return p23.messageId ~= t8.messageId
							end) else List.filter(p22, function(p24) -- line: 438
								-- upvalues: t8 (copy)
								return p24 ~= t8.messageId
							end)

							if #v436 == 0 then
								return nil
							end

							return v436
						end

						if FFlagExpChatMessagesStoreUseProxy then
							v52[userId] = v245(v52[userId])

							return
						end

						v51(function(p25) -- line: 357
							-- upvalues: v245 (copy), userId (copy), Dictionary (copy)
							local v438 = v245(p25[userId])

							if v438 == nil then
								return Dictionary.removeKey(p25, userId)
							end

							return Dictionary.join(p25, {
								[userId] = v438
							})
						end)
					end

					return
				end

				writeByMessageId(t8.messageId, t8)

				if not FFlagExpChatMessagesStoreMemoryCleanup and t8.userId then
					local userId = t8.userId

					local function v247(p26) -- line: 461
						-- upvalues: t8 (copy), List (copy)
						if not p26 then
							return nil
						end

						local v440 = nil

						for i, v in ipairs(p26) do
							if v.messageId == t8.messageId then
								v440 = i

								break
							end
						end

						if v440 then
							return List.set(p26, v440, t8)
						end

						return p26
					end

					if FFlagExpChatMessagesStoreUseProxy then
						v52[userId] = v247(v52[userId])

						return
					end

					v51(function(p27) -- line: 357
						-- upvalues: v247 (copy), userId (copy), Dictionary (copy)
						local v444 = v247(p27[userId])

						if v444 == nil then
							return Dictionary.removeKey(p27, userId)
						end

						return Dictionary.join(p27, {
							[userId] = v444
						})
					end)
				end

				return
			end

			local userId = t8.userId
			local partOrModel = t8.partOrModel

			if not userId and partOrModel then
				userId = v66(false)[partOrModel]

				if not userId then
					userId = HttpService:GenerateGUID(false)
					v65(function(p28) -- line: 496
						-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
						return Dictionary.join(p28, {
							[userId] = partOrModel
						})
					end)
					v67(function(p29) -- line: 503
						-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
						return Dictionary.join(p29, {
							[partOrModel] = userId
						})
					end)
				end
			end

			local v250 = if userId == t8.userId then t8 else Dictionary.join(t8, {
				userId = userId
			})
			local channelNameOverride = nil

			if GetFFlagTextChatEnableUniverseChatTabs() and v250.channelNameOverride then
				channelNameOverride = v250.channelNameOverride
			elseif v250.textChannel then
				channelNameOverride = if v250.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v68(false)) then v250.textChannel.Name else "RBXGeneral"
			end

			if v250.isVisibleInChatWindow then
				local v252 = v53(false)
				local v253 = if not channelNameOverride then {} else v55(false)[channelNameOverride] or {}

				if #v252 >= t1.messageLimit then
					local v254 = v252[1]
					local v255 = v241 and v241[v254]

					if v255 then
						if not FFlagExpChatMessagesStoreKeepInByMessageId then
							if FFlagExpChatMessagesStoreUseProxy then
								v49[v254] = nil
							else
								v48(function(p30) -- line: 273
									-- upvalues: Dictionary (copy), v254 (copy)
									return Dictionary.removeKey(p30, v254)
								end)
							end
						end

						if v255.userId then
							local userId2 = v255.userId

							local function v257(p31) -- line: 550
								-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v254 (copy), v64 (copy), v255 (copy), v67 (copy), Dictionary (copy), v65 (copy)
								if not p31 then
									return nil
								end

								local v449 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p31, function(p32) -- line: 560
									-- upvalues: v254 (copy)
									return p32.messageId ~= v254
								end) else List.filter(p31, function(p33) -- line: 556
									-- upvalues: v254 (copy)
									return p33 ~= v254
								end)

								if #v449 == 0 then
									local v450 = v64(false)

									if v450[v255.userId] then
										local v451 = v450[v255.userId]

										v67(function(p34) -- line: 571
											-- upvalues: Dictionary (copy), v451 (copy)
											return Dictionary.removeKey(p34, v451)
										end)
										v65(function(p35) -- line: 575
											-- upvalues: Dictionary (copy), v255 (copy)
											return Dictionary.removeKey(p35, v255.userId)
										end)
									end

									return nil
								end

								return v449
							end

							if FFlagExpChatMessagesStoreUseProxy then
								v52[userId2] = v257(v52[userId2])
							else
								v51(function(p36) -- line: 357
									-- upvalues: v257 (copy), userId2 (copy), Dictionary (copy)
									local v453 = v257(p36[userId2])

									if v453 == nil then
										return Dictionary.removeKey(p36, userId2)
									end

									return Dictionary.join(p36, {
										[userId2] = v453
									})
								end)
							end
						end

						v54(function(p37) -- line: 587
							-- upvalues: List (copy)
							return List.removeIndex(p37, 1)
						end)

						if FFlagExpChatMessagesStoreMemoryCleanup then
							t4[v254] = nil
						end
					end
				end

				if channelNameOverride and #v253 >= t1.messageLimit then
					local v258 = v253[1]

					if v258 then
						v56(function(p38) -- line: 601
							-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
							local v456 = p38[channelNameOverride] or {}
							local v457 = List.removeIndex(v456, 1)

							return Dictionary.join(p38, {
								[channelNameOverride] = v457
							})
						end)

						if v241 and v241[v258] then
							if FFlagExpChatMessagesStoreUseProxy then
								v49[v258] = nil
							else
								v48(function(p39) -- line: 273
									-- upvalues: Dictionary (copy), v258 (copy)
									return Dictionary.removeKey(p39, v258)
								end)
							end
						end

						if FFlagExpChatMessagesStoreMemoryCleanup then
							t4[v258] = nil
						end
					end
				end
			end

			writeByMessageId(v250.messageId, v250)

			if v250.userId then
				local userId3 = v250.userId

				local function v260(p40) -- line: 623
					-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), v250 (copy), List (copy)
					local v460 = p40 or {}
					local v461 = false

					if FFlagExpChatMessagesStoreMemoryCleanup then
						for _, v in ipairs(v460) do
							if v == v250.messageId then
								v461 = true

								break
							end
						end
					else
						for _, v in ipairs(v460) do
							if v.messageId == v250.messageId then
								v461 = true

								break
							end
						end
					end

					if not v461 then
						local v466 = if not FFlagExpChatMessagesStoreMemoryCleanup then v250 else v250.messageId

						return List.append(v460, v466)
					end

					return v460
				end

				if FFlagExpChatMessagesStoreUseProxy then
					v52[userId3] = v260(v52[userId3])
				else
					v51(function(p41) -- line: 357
						-- upvalues: v260 (copy), userId3 (copy), Dictionary (copy)
						local v468 = v260(p41[userId3])

						if v468 == nil then
							return Dictionary.removeKey(p41, userId3)
						end

						return Dictionary.join(p41, {
							[userId3] = v468
						})
					end)
				end
			end

			if v250.isVisibleInChatWindow then
				v54(function(p42) -- line: 656
					-- upvalues: List (copy), v250 (copy)
					return List.append(p42, v250.messageId)
				end)

				if channelNameOverride then
					v56(function(p43) -- line: 662
						-- upvalues: channelNameOverride (ref), List (copy), v250 (copy), Dictionary (copy)
						local v471 = p43[channelNameOverride] or {}
						local v472 = List.append(v471, v250.messageId)

						return Dictionary.join(p43, {
							[channelNameOverride] = v472
						})
					end)
				end

				if FFlagExpChatEnableV2ChatWindow then
					local v261 = v77(false)

					if v261 == nil or v261 == channelNameOverride then
						updateNextMessageComponent(v250.messageId)
					end
				end
			end
		end

		if FFlagExpChatMessagesStoreBatch then
			SignalsExperimental.batch(v124)

			return
		end

		v124()
	end

	local t9 = {}

	local function getUserMessageCache(s6: string) -- line: 713
		-- upvalues: t9 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), createComputed (copy), FFlagExpChatMessagesStoreUseProxy (copy), v52 (copy), v50 (copy), v49 (copy), v47 (copy), v59 (copy), Set (copy)
		local str = tostring(s6)

		if not t9[str] then
			t9[str] = {}

			if not FFlagExpChatMessagesStoreMemoryCleanup then
				t9[str].messages = createComputed(function(p44) -- line: 719
					-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v52 (copy), v50 (copy), str (copy)
					return ((if not FFlagExpChatMessagesStoreUseProxy then v50(p44) else v52(p44)))[str] or {}
				end)
			end

			if FFlagExpChatMessagesStoreMemoryCleanup then
				t9[str].bubbleMessages = createComputed(function(p45) -- line: 726
					-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v52 (copy), v50 (copy), str (copy), v49 (copy), v47 (copy), v59 (copy), Set (copy)
					local v267 = ((if not FFlagExpChatMessagesStoreUseProxy then v50(p45) else v52(p45)))[str] or {}
					local v268 = if not FFlagExpChatMessagesStoreUseProxy then v47(p45) else v49(p45)
					local v269 = v59(p45)
					local t10 = {}

					for _, v in ipairs(v267) do
						local v273 = v268[v]

						if v273 then
							local v274 = not not v273.userId and (Set.has(v269, v273.userId) or false)

							if v273.isVisibleInBubbleChat and not v274 then
								table.insert(t10, v273)
							end
						end
					end

					return t10
				end)
			else
				t9[str].bubbleMessages = createComputed(function(p46) -- line: 744
					-- upvalues: t9 (copy), str (copy), v59 (copy), Set (copy)
					local v276 = t9[str].messages(p46)
					local v277 = v59(p46)
					local t11 = {}

					for _, v in ipairs(v276) do
						local v281 = not not v.userId and (Set.has(v277, v.userId) or false)

						if v.isVisibleInBubbleChat and not v281 then
							table.insert(t11, v)
						end
					end

					return t11
				end)
			end

			if not FFlagExpChatMessagesStoreMemoryCleanup then
				t9[str].lastMessage = createComputed(function(p47) -- line: 759
					-- upvalues: t9 (copy), str (copy)
					local v283 = t9[str].messages(p47)

					if #v283 > 0 then
						return v283[#v283]
					end

					return nil
				end)
			end
		end

		return t9[str]
	end
	local function getUserMessages(s7: string) -- line: 771
		-- upvalues: getUserMessageCache (copy)
		return getUserMessageCache(s7).messages
	end
	local function getUserLastMessage(s8: string) -- line: 781
		-- upvalues: getUserMessageCache (copy)
		return getUserMessageCache(s8).lastMessage
	end
	local function createMessagesArraySignal() -- line: 786
		-- upvalues: createComputed (copy), FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy)
		return createComputed(function(p48) -- line: 787
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy)
			local v285 = if not FFlagExpChatMessagesStoreUseProxy then v47(p48) else v49(p48)

			if not v285 then
				return {}
			end

			local t12 = {}

			for _, v288 in v285 do
				table.insert(t12, v288)
			end

			return t12
		end)
	end
	local function formatPrefixForUniverseChatTabs(s9: string, s10: string?, p49) -- line: 839
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), computeNameColor (copy), Players (copy)
		if not GetFFlagTextChatEnableUniverseChatTabs() or (not s10 or #s9 == 0) then
			return s9
		end

		return `<font color="#{ ((if not p49.TextSource then computeNameColor(not Players.LocalPlayer and "" or Players.LocalPlayer.Name) else computeNameColor(p49.TextSource.Username))):ToHex() }">{ s9 }</font>`
	end
	local function rebuildMessageWithTranslation(t13: {[any]: any}, b1: boolean) -- line: 1197
		-- upvalues: getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
		return {
			prefixText = t13.prefixText,
			text = t13.text,
			translation = t13.translation,
			useTranslation = b1,
			messageId = t13.messageId,
			status = t13.status,
			timestamp = t13.timestamp,
			isVisibleInBubbleChat = t13.isVisibleInBubbleChat,
			isVisibleInChatWindow = t13.isVisibleInChatWindow,
			partOrModel = t13.partOrModel,
			shouldOverrideBubbleChatSettings = t13.shouldOverrideBubbleChatSettings,
			bubbleChatMessageProperties = t13.bubbleChatMessageProperties,
			chatWindowMessageProperties = t13.chatWindowMessageProperties,
			textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else t13.textChatMessageInstance,
			userId = t13.userId,
			textChannel = t13.textChannel,
			wasRewritten = if not FFlagEnableInExpChatRewrite then nil else t13.wasRewritten,
			originalText = if not FFlagEnableInExpChatRewrite then nil else t13.originalText,
			chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else t13.chatActionType,
			presetId = if not FFlagExpChatPresetChatEnabled then nil else t13.presetId,
			presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else t13.presetChatVersion
		}
	end

	function updateNextMessageComponent(s11: string) -- line: 1375
		-- upvalues: v70 (copy), v72 (copy), v73 (copy), t2 (copy), FFlagEnableInExpChatRewrite (copy), n1 (ref), t3 (copy)
		local v216 = v70(false)

		if #v216 == 0 then
			return
		end

		local v217 = v72(false)
		local v218 = v216[v217]

		if not v218 then
			v73(1)

			return
		end

		local v219 = t2[v218]

		if v219 then
			v219.setter(s11)
		end

		local v220 = not FFlagEnableInExpChatRewrite and 1 or 10

		n1 += v220

		local v221 = t3[v218]

		if v221 then
			v221.setter(n1)
		end

		local v222 = v217 % #v216 + 1

		v73(v222)
	end

	return {
		getByMessageId = if not FFlagExpChatMessagesStoreUseProxy then v47 else v49,
		getMessages = if not FFlagExpChatMessagesStoreMemoryCleanup then createComputed(function(p50) -- line: 787
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy)
			local v225 = if not FFlagExpChatMessagesStoreUseProxy then v47(p50) else v49(p50)

			if not v225 then
				return {}
			end

			local t14 = {}

			for _, v228 in v225 do
				table.insert(t14, v228)
			end

			return t14
		end) else nil,
		getMessagesBySenderId = if not FFlagExpChatMessagesStoreUseProxy then v50 else v52,
		getWindowMessagesInOrder = v53,
		getWindowMessagesInOrderByTabId = v55,
		getMutedUserIds = v59,
		getCanLocalUserChat = v60,
		getIsBubbleChatEnabled = v62,
		getMockUserIdToPartOrModel = v64,
		getPartOrModelToMockUserId = v66,
		getMessage = function(s12: string) -- line: 694
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), t4 (copy), createComputed (copy)
			if FFlagExpChatMessagesStoreUseProxy then
				return function(p51) -- line: 696
					-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), s12 (copy)
					return ((if not FFlagExpChatMessagesStoreUseProxy then v47(p51) else v49(p51)))[s12]
				end
			end

			if not t4[s12] then
				t4[s12] = createComputed(function(p52) -- line: 702
					-- upvalues: v47 (copy), s12 (copy)
					local v264 = v47(p52)

					if not v264 or not v264[s12] then
						return nil
					end

					return v264[s12]
				end)
			end

			return t4[s12]
		end,
		getUserMessages = if not FFlagExpChatMessagesStoreMemoryCleanup then getUserMessages else nil,
		getUserBubbleMessages = function(s13: string) -- line: 776
			-- upvalues: getUserMessageCache (copy)
			return getUserMessageCache(s13).bubbleMessages
		end,
		getUserLastMessage = if not FFlagExpChatMessagesStoreMemoryCleanup then getUserLastMessage else nil,
		registerMessageComponent = function(s14: string) -- line: 1288
			-- upvalues: t2 (copy), createSignal (copy), t3 (copy), v71 (copy), List (copy)
			if not t2[s14] then
				local v201, v202 = createSignal(nil)

				t2[s14] = {
					getter = v201,
					setter = v202
				}

				local v203, v204 = createSignal(0)

				t3[s14] = {
					getter = v203,
					setter = v204
				}
				v71(function(p53) -- line: 1303
					-- upvalues: List (copy), s14 (copy)
					return List.append(p53, s14)
				end)
			end

			return t2[s14].getter
		end,
		unregisterMessageComponent = function(s15: string) -- line: 1312
			-- upvalues: v70 (copy), t2 (copy), t3 (copy), v71 (copy), List (copy), v72 (copy), v73 (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local v206 = v70(false)
			local u207 = nil

			for i, v in ipairs(v206) do
				if v == s15 then
					u207 = i

					break
				end
			end

			if t2[s15] then
				t2[s15] = nil
			end

			if t3[s15] then
				t3[s15] = nil
			end

			if u207 then
				local function doUnregister() -- line: 1335
					-- upvalues: v71 (copy), List (copy), s15 (copy), v70 (copy), v72 (copy), v73 (copy), u207 (ref)
					v71(function(p54) -- line: 1336
						-- upvalues: List (copy), s15 (copy)
						return List.filter(p54, function(p55) -- line: 1337
							-- upvalues: s15 (copy)
							return p55 ~= s15
						end)
					end)

					local v421 = v70(false)
					local v422 = v72(false)

					if #v421 == 0 then
						v73(1)

						return
					end

					if v422 > u207 then
						v73(v422 - 1)

						return
					end

					if v422 > #v421 then
						v73(1)
					end
				end

				if FFlagExpChatMessagesStoreBatch then
					SignalsExperimental.batch(doUnregister)
				else
					doUnregister()
				end
			end
		end,
		repopulateMessageComponents = function() -- line: 1412
			-- upvalues: v77 (copy), v55 (copy), v53 (copy), v73 (copy), n1 (ref), updateNextMessageComponent (ref), v70 (copy), v72 (copy), t2 (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local function doRepopulate() -- line: 1413
				-- upvalues: v77 (copy), v55 (copy), v53 (copy), v73 (copy), n1 (ref), updateNextMessageComponent (ref), v70 (copy), v72 (copy), t2 (copy)
				local v423 = v77(false)
				local v424 = if not v423 then v53(false) else v55(false)[v423] or {}

				v73(1)
				n1 = 0

				for _, v in ipairs(v424) do
					updateNextMessageComponent(v)
				end

				local v427 = v70(false)

				if #v424 < #v427 then
					for i = v72(false), #v427 do
						local v429 = t2[v427[i]]

						if v429 then
							v429.setter(nil)
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
		getMessageComponentSignal = function(s16: string) -- line: 1363
			-- upvalues: t2 (copy)
			local v212 = t2[s16]

			if v212 then
				return v212.getter
			end

			return nil
		end,
		getLayoutOrderSignal = function(s17: string) -- line: 1369
			-- upvalues: t3 (copy)
			local v214 = t3[s17]

			if v214 then
				return v214.getter
			end

			return nil
		end,
		updateNextMessageComponent = updateNextMessageComponent,
		getMessageComponentRingBuffer = v70,
		getNextMessageComponentPointer = v72,
		setActiveChannelFilter = v78,
		getActiveChannelFilter = v77,
		setCanLocalUserChat = v61,
		muteUser = function(s18: string) -- line: 1110
			-- upvalues: v58 (copy), Set (copy)
			v58(function(p56) -- line: 1111
				-- upvalues: Set (copy), s18 (copy)
				if not p56 then
					return {}
				end

				return (Set.add(p56, s18))
			end)
		end,
		unmuteUser = function(s19: string) -- line: 1120
			-- upvalues: v58 (copy), Set (copy)
			v58(function(p57) -- line: 1121
				-- upvalues: Set (copy), s19 (copy)
				if not p57 then
					return {}
				end

				return (Set.subtract(p57, s19))
			end)
		end,
		handlePlayerRemoved = function(s20: string) -- line: 1065
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v52 (copy), v51 (copy), Dictionary (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), t9 (copy), v58 (copy), Set (copy), v50 (copy), v64 (copy), v67 (copy), v65 (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local str = tostring(s20)

			local function doHandlePlayerRemoved() -- line: 1068
				-- upvalues: str (copy), FFlagExpChatMessagesStoreUseProxy (copy), v52 (copy), v51 (copy), Dictionary (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), t9 (copy), v58 (copy), Set (copy), v50 (copy), v64 (copy), v67 (copy), v65 (copy)
				local v373 = str

				if FFlagExpChatMessagesStoreUseProxy then
					v52[v373] = nil
				else
					v51(function(p58) -- line: 346
						-- upvalues: Dictionary (copy), v373 (copy)
						return Dictionary.removeKey(p58, v373)
					end)
				end

				if FFlagExpChatMessagesStoreMemoryCleanup then
					t9[str] = nil
				end

				v58(function(p59) -- line: 1076
					-- upvalues: Set (copy), str (copy), FFlagExpChatMessagesStoreUseProxy (copy), v52 (copy), v50 (copy), v64 (copy), v67 (copy), Dictionary (copy), v65 (copy)
					if not p59 then
						return {}
					end

					local v647 = Set.has(p59, str)

					if #(((if not FFlagExpChatMessagesStoreUseProxy then v50(false) else v52))[str] or {}) == 0 and not v647 then
						return p59
					end

					local v648 = v64(false)

					if v648[str] then
						local v649 = v648[str]

						v67(function(p60) -- line: 1094
							-- upvalues: Dictionary (copy), v649 (copy)
							return Dictionary.removeKey(p60, v649)
						end)
						v65(function(p61) -- line: 1098
							-- upvalues: Dictionary (copy), str (copy)
							return Dictionary.removeKey(p61, str)
						end)
					end

					return Set.subtract(p59, str)
				end)
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(doHandlePlayerRemoved)

				return
			end

			if FFlagExpChatMessagesStoreUseProxy then
				v52[str] = nil
			else
				v51(function(p62) -- line: 346
					-- upvalues: Dictionary (copy), str (copy)
					return Dictionary.removeKey(p62, str)
				end)
			end

			if FFlagExpChatMessagesStoreMemoryCleanup then
				t9[str] = nil
			end

			v58(function(p63) -- line: 1076
				-- upvalues: Set (copy), str (copy), FFlagExpChatMessagesStoreUseProxy (copy), v52 (copy), v50 (copy), v64 (copy), v67 (copy), Dictionary (copy), v65 (copy)
				if not p63 then
					return {}
				end

				local v376 = Set.has(p63, str)

				if #(((if not FFlagExpChatMessagesStoreUseProxy then v50(false) else v52))[str] or {}) == 0 and not v376 then
					return p63
				end

				local v377 = v64(false)

				if v377[str] then
					local v378 = v377[str]

					v67(function(p64) -- line: 1094
						-- upvalues: Dictionary (copy), v378 (copy)
						return Dictionary.removeKey(p64, v378)
					end)
					v65(function(p65) -- line: 1098
						-- upvalues: Dictionary (copy), str (copy)
						return Dictionary.removeKey(p65, str)
					end)
				end

				return Set.subtract(p63, str)
			end)
		end,
		clearWindowMessages = function() -- line: 1130
			-- upvalues: forEachByMessageId (copy), Dictionary (copy), v54 (copy), v56 (copy), FFlagExpChatEnableV2ChatWindow (copy), v73 (copy), n1 (ref), v70 (copy), t2 (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local function doClearWindowMessages() -- line: 1131
				-- upvalues: forEachByMessageId (copy), Dictionary (copy), v54 (copy), v56 (copy), FFlagExpChatEnableV2ChatWindow (copy), v73 (copy), n1 (ref), v70 (copy), t2 (copy)
				forEachByMessageId(function(_, p67) -- line: 1132
					-- upvalues: Dictionary (copy)
					return Dictionary.join(p67, {
						isVisibleInChatWindow = false
					})
				end)
				v54(function(_) -- line: 1137
					return {}
				end)
				v56(function(_) -- line: 1142
					return {}
				end)

				if FFlagExpChatEnableV2ChatWindow then
					v73(1)
					n1 = 0

					local v381 = v70(false)

					for _, v in ipairs(v381) do
						local v384 = t2[v]

						if v384 then
							v384.setter(nil)
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
		toggleGlobalTranslation = function(b2: boolean) -- line: 1227
			-- upvalues: forEachByMessageId (copy), rebuildMessageWithTranslation (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local function doToggleGlobalTranslation() -- line: 1228
				-- upvalues: forEachByMessageId (copy), rebuildMessageWithTranslation (copy), b2 (copy)
				forEachByMessageId(function(_, p71) -- line: 1229
					-- upvalues: rebuildMessageWithTranslation (copy), b2 (copy)
					return (rebuildMessageWithTranslation(p71, b2))
				end)
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(doToggleGlobalTranslation)

				return
			end

			forEachByMessageId(function(_, p73) -- line: 1229
				-- upvalues: rebuildMessageWithTranslation (copy), b2 (copy)
				return (rebuildMessageWithTranslation(p73, b2))
			end)
		end,
		toggleMessageTranslation = function(b3: boolean, s21: string) -- line: 1237
			-- upvalues: rebuildMessageWithTranslation (copy), FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v48 (copy), Dictionary (copy)
			local function v187(p74) -- line: 1238
				-- upvalues: rebuildMessageWithTranslation (copy), b3 (copy)
				return (rebuildMessageWithTranslation(p74, b3))
			end

			if FFlagExpChatMessagesStoreUseProxy then
				local v188 = v49[s21]

				if v188 then
					local v189 = rebuildMessageWithTranslation(v188, b3)

					if v189 then
						v49[s21] = v189

						return
					end
				end
			else
				v48(function(p75) -- line: 290
					-- upvalues: s21 (copy), v187 (copy), Dictionary (copy)
					if not p75 or not p75[s21] then
						return p75 or {}
					end

					local v395 = v187(p75[s21])

					if v395 then
						return Dictionary.join(p75, {
							[s21] = v395
						})
					end

					return p75
				end)
			end
		end,
		handleIncomingOrOutgoingMessage = function(p76, _: boolean, s22: string?, b5: boolean?) -- line: 862
			-- upvalues: FFlagEnableInExpChatRewrite (copy), getTextAndTranslation (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), isWhiteSpaceOnly (copy), FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), v60 (copy), FFlagExpChatPresetChatEnabled (copy), v59 (copy), Set (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), ExpChatShared (copy), v62 (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatDisableUniverseBubbleChat (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), formatPrefixForUniverseChatTabs (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v54 (copy), List (copy), resolveChannelNameForMapOrder (copy), v56 (copy), Dictionary (copy), v48 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v52 (copy), v51 (copy), writeByMessageId (copy), v66 (copy), HttpService (copy), v65 (copy), v67 (copy), v68 (copy), v53 (copy), v55 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v64 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v77 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local v148, v149

			if FFlagEnableInExpChatRewrite then
				v148, v149 = getTextAndTranslation(p76)
			else
				v148 = if not getFFlagExpChatProtectedChatInternalAPIs() then p76.Text else p76.TextInternal
				v149 = if not getFFlagExpChatProtectedChatInternalAPIs() then p76.Translation else p76.TranslationInternal
			end

			if isWhiteSpaceOnly(v148) and p76.Status ~= Enum.TextChatMessageStatus.Floodchecked and p76.Status ~= Enum.TextChatMessageStatus.MessageTooLong then
				return
			end

			local v150 = if not p76.TextSource then nil else tostring(p76.TextSource.UserId)

			if not if not FFlagExpChatMessagesStoreUseProxy then v47(false) else v49 then
				return
			end

			local v151 = v60(false)
			local v152 = v150 == nil or (v151 or not not FFlagExpChatPresetChatEnabled and (p76.PresetId or "") ~= "") and (p76.Status == Enum.TextChatMessageStatus.Success or p76.Status == Enum.TextChatMessageStatus.Sending)
			local v153 = not not v150 and (not not v59(false) and Set.has(v59(false), v150))
			local v154 = v152 and not v153
			local v155 = false
			local v156

			if FFlagExpChatUseChatConfigStore then
				v156 = GetChatConfigurationStore(false).getIsBubbleChatEnabled(false)
			else
				local v157 = ExpChatShared.context and ExpChatShared.context.store

				v156 = if not v157 then v62(false) else v157:getState().Messages.isBubbleChatEnabled
			end

			if v156 and v154 and (not FFlagEnableInExpChatSummaryOnLua or v150 ~= nil) and (p76.Status == Enum.TextChatMessageStatus.Success or p76.Status == Enum.TextChatMessageStatus.Sending) then
				v155 = true
			end

			if FFlagExpChatDisableUniverseBubbleChat and GetFFlagTextChatEnableUniverseChatTabs() and b5 == true then
				v155 = false
			end

			if p76.Status ~= Enum.TextChatMessageStatus.Success and p76.Status ~= Enum.TextChatMessageStatus.Sending then
				v154 = false
				v155 = false
			end

			local v158 = formatPrefixForUniverseChatTabs(if not getFFlagExpChatProtectedChatInternalAPIs() then p76.PrefixText else p76.PrefixTextInternal, s22, p76)
			local t15 = {
				shouldOverrideBubbleChatSettings = false,
				userId = v150,
				prefixText = v158,
				text = v148,
				translation = v149,
				useTranslation = getChatTranslationEnabled() and v149 ~= nil,
				messageId = p76.MessageId,
				status = p76.Status,
				timestamp = p76.Timestamp,
				isVisibleInBubbleChat = v155,
				isVisibleInChatWindow = v154,
				textChannel = p76.TextChannel,
				bubbleChatMessageProperties = p76.BubbleChatMessageProperties,
				chatWindowMessageProperties = p76.ChatWindowMessageProperties,
				textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else p76,
				partOrModel = p76.TextSource and p76.TextSource.Parent or nil,
				wasRewritten = if not FFlagEnableInExpChatRewrite then nil else p76.WasRewritten,
				originalText = if not FFlagEnableInExpChatRewrite then nil else p76.OriginalText,
				channelNameOverride = GetFFlagTextChatEnableUniverseChatTabs() and s22 or nil,
				chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else p76.ChatActionType,
				isUniverseChat = if not FFlagChatLineReportingGlobalMuteEnabled then nil else b5,
				presetId = if not FFlagExpChatPresetChatEnabled then nil else p76.PresetId,
				presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else p76.PresetChatVersion
			}
			local v160 = if not FFlagExpChatMessagesStoreUseProxy then v47(false) else v49
			local v161 = v160 and v160[t15.messageId] ~= nil

			if t15.isVisibleInChatWindow or t15.isVisibleInBubbleChat or v161 then
				local function v162() -- line: 396
					-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), t15 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v54 (copy), List (copy), resolveChannelNameForMapOrder (copy), v56 (copy), Dictionary (copy), v48 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v52 (copy), v51 (copy), writeByMessageId (copy), v66 (copy), HttpService (copy), v65 (copy), v67 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v68 (copy), v53 (copy), v55 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v64 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v77 (copy), updateNextMessageComponent (ref)
					local v310 = if not FFlagExpChatMessagesStoreUseProxy then v47(false) else v49

					if v310 and v310[t15.messageId] then
						if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t15.status == Enum.TextChatMessageStatus.Floodchecked or t15.status == Enum.TextChatMessageStatus.MessageTooLong) then
							v54(function(p77) -- line: 407
								-- upvalues: List (copy), t15 (copy)
								return List.filter(p77, function(p78) -- line: 408
									-- upvalues: t15 (copy)
									return p78 ~= t15.messageId
								end)
							end)

							local v311 = resolveChannelNameForMapOrder(t15, t15.channelNameOverride)

							if v311 then
								v56(function(p79) -- line: 415
									-- upvalues: v311 (copy), List (copy), t15 (copy), Dictionary (copy)
									local v518 = p79[v311]

									if not v518 then
										return p79
									end

									local v519 = List.filter(v518, function(p80) -- line: 420
										-- upvalues: t15 (copy)
										return p80 ~= t15.messageId
									end)

									return Dictionary.join(p79, {
										[v311] = v519
									})
								end)
							end

							local messageId = t15.messageId

							if FFlagExpChatMessagesStoreUseProxy then
								v49[messageId] = nil
							else
								v48(function(p81) -- line: 273
									-- upvalues: Dictionary (copy), messageId (copy)
									return Dictionary.removeKey(p81, messageId)
								end)
							end

							if t15.userId then
								local userId = t15.userId

								local function v314(p82) -- line: 432
									-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), t15 (copy)
									if not p82 then
										return nil
									end

									local v522 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p82, function(p83) -- line: 442
										-- upvalues: t15 (copy)
										return p83.messageId ~= t15.messageId
									end) else List.filter(p82, function(p84) -- line: 438
										-- upvalues: t15 (copy)
										return p84 ~= t15.messageId
									end)

									if #v522 == 0 then
										return nil
									end

									return v522
								end

								if FFlagExpChatMessagesStoreUseProxy then
									v52[userId] = v314(v52[userId])

									return
								end

								v51(function(p85) -- line: 357
									-- upvalues: v314 (copy), userId (copy), Dictionary (copy)
									local v524 = v314(p85[userId])

									if v524 == nil then
										return Dictionary.removeKey(p85, userId)
									end

									return Dictionary.join(p85, {
										[userId] = v524
									})
								end)
							end

							return
						end

						writeByMessageId(t15.messageId, t15)

						if not FFlagExpChatMessagesStoreMemoryCleanup and t15.userId then
							local userId = t15.userId

							local function v316(p86) -- line: 461
								-- upvalues: t15 (copy), List (copy)
								if not p86 then
									return nil
								end

								local v526 = nil

								for i, v in ipairs(p86) do
									if v.messageId == t15.messageId then
										v526 = i

										break
									end
								end

								if v526 then
									return List.set(p86, v526, t15)
								end

								return p86
							end

							if FFlagExpChatMessagesStoreUseProxy then
								v52[userId] = v316(v52[userId])

								return
							end

							v51(function(p87) -- line: 357
								-- upvalues: v316 (copy), userId (copy), Dictionary (copy)
								local v530 = v316(p87[userId])

								if v530 == nil then
									return Dictionary.removeKey(p87, userId)
								end

								return Dictionary.join(p87, {
									[userId] = v530
								})
							end)
						end

						return
					end

					local userId = t15.userId
					local partOrModel = t15.partOrModel

					if not userId and partOrModel then
						userId = v66(false)[partOrModel]

						if not userId then
							userId = HttpService:GenerateGUID(false)
							v65(function(p88) -- line: 496
								-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
								return Dictionary.join(p88, {
									[userId] = partOrModel
								})
							end)
							v67(function(p89) -- line: 503
								-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
								return Dictionary.join(p89, {
									[partOrModel] = userId
								})
							end)
						end
					end

					local v319 = if userId == t15.userId then t15 else Dictionary.join(t15, {
						userId = userId
					})
					local channelNameOverride = nil

					if GetFFlagTextChatEnableUniverseChatTabs() and v319.channelNameOverride then
						channelNameOverride = v319.channelNameOverride
					elseif v319.textChannel then
						channelNameOverride = if v319.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v68(false)) then v319.textChannel.Name else "RBXGeneral"
					end

					if v319.isVisibleInChatWindow then
						local v321 = v53(false)
						local v322 = if not channelNameOverride then {} else v55(false)[channelNameOverride] or {}

						if #v321 >= t1.messageLimit then
							local v323 = v321[1]
							local v324 = v310 and v310[v323]

							if v324 then
								if not FFlagExpChatMessagesStoreKeepInByMessageId then
									if FFlagExpChatMessagesStoreUseProxy then
										v49[v323] = nil
									else
										v48(function(p90) -- line: 273
											-- upvalues: Dictionary (copy), v323 (copy)
											return Dictionary.removeKey(p90, v323)
										end)
									end
								end

								if v324.userId then
									local userId4 = v324.userId

									local function v326(p91) -- line: 550
										-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v323 (copy), v64 (copy), v324 (copy), v67 (copy), Dictionary (copy), v65 (copy)
										if not p91 then
											return nil
										end

										local v535 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p91, function(p92) -- line: 560
											-- upvalues: v323 (copy)
											return p92.messageId ~= v323
										end) else List.filter(p91, function(p93) -- line: 556
											-- upvalues: v323 (copy)
											return p93 ~= v323
										end)

										if #v535 == 0 then
											local v536 = v64(false)

											if v536[v324.userId] then
												local v537 = v536[v324.userId]

												v67(function(p94) -- line: 571
													-- upvalues: Dictionary (copy), v537 (copy)
													return Dictionary.removeKey(p94, v537)
												end)
												v65(function(p95) -- line: 575
													-- upvalues: Dictionary (copy), v324 (copy)
													return Dictionary.removeKey(p95, v324.userId)
												end)
											end

											return nil
										end

										return v535
									end

									if FFlagExpChatMessagesStoreUseProxy then
										v52[userId4] = v326(v52[userId4])
									else
										v51(function(p96) -- line: 357
											-- upvalues: v326 (copy), userId4 (copy), Dictionary (copy)
											local v539 = v326(p96[userId4])

											if v539 == nil then
												return Dictionary.removeKey(p96, userId4)
											end

											return Dictionary.join(p96, {
												[userId4] = v539
											})
										end)
									end
								end

								v54(function(p97) -- line: 587
									-- upvalues: List (copy)
									return List.removeIndex(p97, 1)
								end)

								if FFlagExpChatMessagesStoreMemoryCleanup then
									t4[v323] = nil
								end
							end
						end

						if channelNameOverride and #v322 >= t1.messageLimit then
							local v327 = v322[1]

							if v327 then
								v56(function(p98) -- line: 601
									-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
									local v542 = p98[channelNameOverride] or {}
									local v543 = List.removeIndex(v542, 1)

									return Dictionary.join(p98, {
										[channelNameOverride] = v543
									})
								end)

								if v310 and v310[v327] then
									if FFlagExpChatMessagesStoreUseProxy then
										v49[v327] = nil
									else
										v48(function(p99) -- line: 273
											-- upvalues: Dictionary (copy), v327 (copy)
											return Dictionary.removeKey(p99, v327)
										end)
									end
								end

								if FFlagExpChatMessagesStoreMemoryCleanup then
									t4[v327] = nil
								end
							end
						end
					end

					writeByMessageId(v319.messageId, v319)

					if v319.userId then
						local userId5 = v319.userId

						local function v329(p100) -- line: 623
							-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), v319 (copy), List (copy)
							local v546 = p100 or {}
							local v547 = false

							if FFlagExpChatMessagesStoreMemoryCleanup then
								for _, v in ipairs(v546) do
									if v == v319.messageId then
										v547 = true

										break
									end
								end
							else
								for _, v in ipairs(v546) do
									if v.messageId == v319.messageId then
										v547 = true

										break
									end
								end
							end

							if not v547 then
								local v552 = if not FFlagExpChatMessagesStoreMemoryCleanup then v319 else v319.messageId

								return List.append(v546, v552)
							end

							return v546
						end

						if FFlagExpChatMessagesStoreUseProxy then
							v52[userId5] = v329(v52[userId5])
						else
							v51(function(p101) -- line: 357
								-- upvalues: v329 (copy), userId5 (copy), Dictionary (copy)
								local v554 = v329(p101[userId5])

								if v554 == nil then
									return Dictionary.removeKey(p101, userId5)
								end

								return Dictionary.join(p101, {
									[userId5] = v554
								})
							end)
						end
					end

					if v319.isVisibleInChatWindow then
						v54(function(p102) -- line: 656
							-- upvalues: List (copy), v319 (copy)
							return List.append(p102, v319.messageId)
						end)

						if channelNameOverride then
							v56(function(p103) -- line: 662
								-- upvalues: channelNameOverride (ref), List (copy), v319 (copy), Dictionary (copy)
								local v557 = p103[channelNameOverride] or {}
								local v558 = List.append(v557, v319.messageId)

								return Dictionary.join(p103, {
									[channelNameOverride] = v558
								})
							end)
						end

						if FFlagExpChatEnableV2ChatWindow then
							local v330 = v77(false)

							if v330 == nil or v330 == channelNameOverride then
								updateNextMessageComponent(v319.messageId)
							end
						end
					end
				end

				if FFlagExpChatMessagesStoreBatch then
					SignalsExperimental.batch(v162)

					return
				end

				v162()
			end
		end,
		handleIncomingBubbleChatMessage = function(t16: {[any]: any}) -- line: 1009
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v54 (copy), List (copy), resolveChannelNameForMapOrder (copy), v56 (copy), Dictionary (copy), v48 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v52 (copy), v51 (copy), writeByMessageId (copy), v66 (copy), HttpService (copy), v65 (copy), v67 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v68 (copy), v53 (copy), v55 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v64 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v77 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local t17 = {
				prefixText = "",
				textChannel = nil,
				shouldOverrideBubbleChatSettings = true,
				isVisibleInBubbleChat = true,
				isVisibleInChatWindow = false,
				chatWindowMessageProperties = nil,
				userId = t16.bubbleChatMessageUserId,
				text = t16.message,
				translation = t16.translation,
				useTranslation = getChatTranslationEnabled(),
				messageId = t16.bubbleChatMessageId,
				status = Enum.TextChatMessageStatus.Success,
				timestamp = t16.timestamp,
				partOrModel = t16.partOrModel,
				bubbleChatMessageProperties = t16.bubbleChatMessageProperties
			}

			local function v165() -- line: 396
				-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), t17 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v54 (copy), List (copy), resolveChannelNameForMapOrder (copy), v56 (copy), Dictionary (copy), v48 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v52 (copy), v51 (copy), writeByMessageId (copy), v66 (copy), HttpService (copy), v65 (copy), v67 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v68 (copy), v53 (copy), v55 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v64 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v77 (copy), updateNextMessageComponent (ref)
				local v331 = if not FFlagExpChatMessagesStoreUseProxy then v47(false) else v49

				if v331 and v331[t17.messageId] then
					if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t17.status == Enum.TextChatMessageStatus.Floodchecked or t17.status == Enum.TextChatMessageStatus.MessageTooLong) then
						v54(function(p104) -- line: 407
							-- upvalues: List (copy), t17 (copy)
							return List.filter(p104, function(p105) -- line: 408
								-- upvalues: t17 (copy)
								return p105 ~= t17.messageId
							end)
						end)

						local v332 = resolveChannelNameForMapOrder(t17, t17.channelNameOverride)

						if v332 then
							v56(function(p106) -- line: 415
								-- upvalues: v332 (copy), List (copy), t17 (copy), Dictionary (copy)
								local v561 = p106[v332]

								if not v561 then
									return p106
								end

								local v562 = List.filter(v561, function(p107) -- line: 420
									-- upvalues: t17 (copy)
									return p107 ~= t17.messageId
								end)

								return Dictionary.join(p106, {
									[v332] = v562
								})
							end)
						end

						local messageId = t17.messageId

						if FFlagExpChatMessagesStoreUseProxy then
							v49[messageId] = nil
						else
							v48(function(p108) -- line: 273
								-- upvalues: Dictionary (copy), messageId (copy)
								return Dictionary.removeKey(p108, messageId)
							end)
						end

						if t17.userId then
							local userId = t17.userId

							local function v335(p109) -- line: 432
								-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), t17 (copy)
								if not p109 then
									return nil
								end

								local v565 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p109, function(p110) -- line: 442
									-- upvalues: t17 (copy)
									return p110.messageId ~= t17.messageId
								end) else List.filter(p109, function(p111) -- line: 438
									-- upvalues: t17 (copy)
									return p111 ~= t17.messageId
								end)

								if #v565 == 0 then
									return nil
								end

								return v565
							end

							if FFlagExpChatMessagesStoreUseProxy then
								v52[userId] = v335(v52[userId])

								return
							end

							v51(function(p112) -- line: 357
								-- upvalues: v335 (copy), userId (copy), Dictionary (copy)
								local v567 = v335(p112[userId])

								if v567 == nil then
									return Dictionary.removeKey(p112, userId)
								end

								return Dictionary.join(p112, {
									[userId] = v567
								})
							end)
						end

						return
					end

					writeByMessageId(t17.messageId, t17)

					if not FFlagExpChatMessagesStoreMemoryCleanup and t17.userId then
						local userId = t17.userId

						local function v337(p113) -- line: 461
							-- upvalues: t17 (copy), List (copy)
							if not p113 then
								return nil
							end

							local v569 = nil

							for i, v in ipairs(p113) do
								if v.messageId == t17.messageId then
									v569 = i

									break
								end
							end

							if v569 then
								return List.set(p113, v569, t17)
							end

							return p113
						end

						if FFlagExpChatMessagesStoreUseProxy then
							v52[userId] = v337(v52[userId])

							return
						end

						v51(function(p114) -- line: 357
							-- upvalues: v337 (copy), userId (copy), Dictionary (copy)
							local v573 = v337(p114[userId])

							if v573 == nil then
								return Dictionary.removeKey(p114, userId)
							end

							return Dictionary.join(p114, {
								[userId] = v573
							})
						end)
					end

					return
				end

				local userId = t17.userId
				local partOrModel = t17.partOrModel

				if not userId and partOrModel then
					userId = v66(false)[partOrModel]

					if not userId then
						userId = HttpService:GenerateGUID(false)
						v65(function(p115) -- line: 496
							-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
							return Dictionary.join(p115, {
								[userId] = partOrModel
							})
						end)
						v67(function(p116) -- line: 503
							-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
							return Dictionary.join(p116, {
								[partOrModel] = userId
							})
						end)
					end
				end

				local v340 = if userId == t17.userId then t17 else Dictionary.join(t17, {
					userId = userId
				})
				local channelNameOverride = nil

				if GetFFlagTextChatEnableUniverseChatTabs() and v340.channelNameOverride then
					channelNameOverride = v340.channelNameOverride
				elseif v340.textChannel then
					channelNameOverride = if v340.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v68(false)) then v340.textChannel.Name else "RBXGeneral"
				end

				if v340.isVisibleInChatWindow then
					local v342 = v53(false)
					local v343 = if not channelNameOverride then {} else v55(false)[channelNameOverride] or {}

					if #v342 >= t1.messageLimit then
						local v344 = v342[1]
						local v345 = v331 and v331[v344]

						if v345 then
							if not FFlagExpChatMessagesStoreKeepInByMessageId then
								if FFlagExpChatMessagesStoreUseProxy then
									v49[v344] = nil
								else
									v48(function(p117) -- line: 273
										-- upvalues: Dictionary (copy), v344 (copy)
										return Dictionary.removeKey(p117, v344)
									end)
								end
							end

							if v345.userId then
								local userId6 = v345.userId

								local function v347(p118) -- line: 550
									-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v344 (copy), v64 (copy), v345 (copy), v67 (copy), Dictionary (copy), v65 (copy)
									if not p118 then
										return nil
									end

									local v578 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p118, function(p119) -- line: 560
										-- upvalues: v344 (copy)
										return p119.messageId ~= v344
									end) else List.filter(p118, function(p120) -- line: 556
										-- upvalues: v344 (copy)
										return p120 ~= v344
									end)

									if #v578 == 0 then
										local v579 = v64(false)

										if v579[v345.userId] then
											local v580 = v579[v345.userId]

											v67(function(p121) -- line: 571
												-- upvalues: Dictionary (copy), v580 (copy)
												return Dictionary.removeKey(p121, v580)
											end)
											v65(function(p122) -- line: 575
												-- upvalues: Dictionary (copy), v345 (copy)
												return Dictionary.removeKey(p122, v345.userId)
											end)
										end

										return nil
									end

									return v578
								end

								if FFlagExpChatMessagesStoreUseProxy then
									v52[userId6] = v347(v52[userId6])
								else
									v51(function(p123) -- line: 357
										-- upvalues: v347 (copy), userId6 (copy), Dictionary (copy)
										local v582 = v347(p123[userId6])

										if v582 == nil then
											return Dictionary.removeKey(p123, userId6)
										end

										return Dictionary.join(p123, {
											[userId6] = v582
										})
									end)
								end
							end

							v54(function(p124) -- line: 587
								-- upvalues: List (copy)
								return List.removeIndex(p124, 1)
							end)

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v344] = nil
							end
						end
					end

					if channelNameOverride and #v343 >= t1.messageLimit then
						local v348 = v343[1]

						if v348 then
							v56(function(p125) -- line: 601
								-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
								local v585 = p125[channelNameOverride] or {}
								local v586 = List.removeIndex(v585, 1)

								return Dictionary.join(p125, {
									[channelNameOverride] = v586
								})
							end)

							if v331 and v331[v348] then
								if FFlagExpChatMessagesStoreUseProxy then
									v49[v348] = nil
								else
									v48(function(p126) -- line: 273
										-- upvalues: Dictionary (copy), v348 (copy)
										return Dictionary.removeKey(p126, v348)
									end)
								end
							end

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v348] = nil
							end
						end
					end
				end

				writeByMessageId(v340.messageId, v340)

				if v340.userId then
					local userId7 = v340.userId

					local function v350(p127) -- line: 623
						-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), v340 (copy), List (copy)
						local v589 = p127 or {}
						local v590 = false

						if FFlagExpChatMessagesStoreMemoryCleanup then
							for _, v in ipairs(v589) do
								if v == v340.messageId then
									v590 = true

									break
								end
							end
						else
							for _, v in ipairs(v589) do
								if v.messageId == v340.messageId then
									v590 = true

									break
								end
							end
						end

						if not v590 then
							local v595 = if not FFlagExpChatMessagesStoreMemoryCleanup then v340 else v340.messageId

							return List.append(v589, v595)
						end

						return v589
					end

					if FFlagExpChatMessagesStoreUseProxy then
						v52[userId7] = v350(v52[userId7])
					else
						v51(function(p128) -- line: 357
							-- upvalues: v350 (copy), userId7 (copy), Dictionary (copy)
							local v597 = v350(p128[userId7])

							if v597 == nil then
								return Dictionary.removeKey(p128, userId7)
							end

							return Dictionary.join(p128, {
								[userId7] = v597
							})
						end)
					end
				end

				if v340.isVisibleInChatWindow then
					v54(function(p129) -- line: 656
						-- upvalues: List (copy), v340 (copy)
						return List.append(p129, v340.messageId)
					end)

					if channelNameOverride then
						v56(function(p130) -- line: 662
							-- upvalues: channelNameOverride (ref), List (copy), v340 (copy), Dictionary (copy)
							local v600 = p130[channelNameOverride] or {}
							local v601 = List.append(v600, v340.messageId)

							return Dictionary.join(p130, {
								[channelNameOverride] = v601
							})
						end)
					end

					if FFlagExpChatEnableV2ChatWindow then
						local v351 = v77(false)

						if v351 == nil or v351 == channelNameOverride then
							updateNextMessageComponent(v340.messageId)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(v165)

				return
			end

			v165()
		end,
		handleLegacyBubbleCreated = function(t18: {[any]: any}) -- line: 1243
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v54 (copy), List (copy), resolveChannelNameForMapOrder (copy), v56 (copy), Dictionary (copy), v48 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v52 (copy), v51 (copy), writeByMessageId (copy), v66 (copy), HttpService (copy), v65 (copy), v67 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v68 (copy), v53 (copy), v55 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v64 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v77 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local timestamp = t18.timestamp
			local v192 = if not timestamp then DateTime.now() else DateTime.fromUnixTimestampMillis(timestamp)
			local t19 = {
				prefixText = "",
				shouldOverrideBubbleChatSettings = true,
				isVisibleInBubbleChat = true,
				isVisibleInChatWindow = false,
				translation = nil,
				useTranslation = false,
				textChannel = nil,
				bubbleChatMessageProperties = nil,
				chatWindowMessageProperties = nil,
				userId = t18.userId,
				text = t18.text,
				messageId = t18.id,
				status = Enum.TextChatMessageStatus.Success,
				timestamp = v192,
				partOrModel = t18.adornee
			}

			local function v194() -- line: 396
				-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), t19 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v54 (copy), List (copy), resolveChannelNameForMapOrder (copy), v56 (copy), Dictionary (copy), v48 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v52 (copy), v51 (copy), writeByMessageId (copy), v66 (copy), HttpService (copy), v65 (copy), v67 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v68 (copy), v53 (copy), v55 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v64 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v77 (copy), updateNextMessageComponent (ref)
				local v396 = if not FFlagExpChatMessagesStoreUseProxy then v47(false) else v49

				if v396 and v396[t19.messageId] then
					if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t19.status == Enum.TextChatMessageStatus.Floodchecked or t19.status == Enum.TextChatMessageStatus.MessageTooLong) then
						v54(function(p131) -- line: 407
							-- upvalues: List (copy), t19 (copy)
							return List.filter(p131, function(p132) -- line: 408
								-- upvalues: t19 (copy)
								return p132 ~= t19.messageId
							end)
						end)

						local v397 = resolveChannelNameForMapOrder(t19, t19.channelNameOverride)

						if v397 then
							v56(function(p133) -- line: 415
								-- upvalues: v397 (copy), List (copy), t19 (copy), Dictionary (copy)
								local v661 = p133[v397]

								if not v661 then
									return p133
								end

								local v662 = List.filter(v661, function(p134) -- line: 420
									-- upvalues: t19 (copy)
									return p134 ~= t19.messageId
								end)

								return Dictionary.join(p133, {
									[v397] = v662
								})
							end)
						end

						local messageId = t19.messageId

						if FFlagExpChatMessagesStoreUseProxy then
							v49[messageId] = nil
						else
							v48(function(p135) -- line: 273
								-- upvalues: Dictionary (copy), messageId (copy)
								return Dictionary.removeKey(p135, messageId)
							end)
						end

						if t19.userId then
							local userId = t19.userId

							local function v400(p136) -- line: 432
								-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), t19 (copy)
								if not p136 then
									return nil
								end

								local v665 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p136, function(p137) -- line: 442
									-- upvalues: t19 (copy)
									return p137.messageId ~= t19.messageId
								end) else List.filter(p136, function(p138) -- line: 438
									-- upvalues: t19 (copy)
									return p138 ~= t19.messageId
								end)

								if #v665 == 0 then
									return nil
								end

								return v665
							end

							if FFlagExpChatMessagesStoreUseProxy then
								v52[userId] = v400(v52[userId])

								return
							end

							v51(function(p139) -- line: 357
								-- upvalues: v400 (copy), userId (copy), Dictionary (copy)
								local v667 = v400(p139[userId])

								if v667 == nil then
									return Dictionary.removeKey(p139, userId)
								end

								return Dictionary.join(p139, {
									[userId] = v667
								})
							end)
						end

						return
					end

					writeByMessageId(t19.messageId, t19)

					if not FFlagExpChatMessagesStoreMemoryCleanup and t19.userId then
						local userId = t19.userId

						local function v402(p140) -- line: 461
							-- upvalues: t19 (copy), List (copy)
							if not p140 then
								return nil
							end

							local v669 = nil

							for i, v in ipairs(p140) do
								if v.messageId == t19.messageId then
									v669 = i

									break
								end
							end

							if v669 then
								return List.set(p140, v669, t19)
							end

							return p140
						end

						if FFlagExpChatMessagesStoreUseProxy then
							v52[userId] = v402(v52[userId])

							return
						end

						v51(function(p141) -- line: 357
							-- upvalues: v402 (copy), userId (copy), Dictionary (copy)
							local v673 = v402(p141[userId])

							if v673 == nil then
								return Dictionary.removeKey(p141, userId)
							end

							return Dictionary.join(p141, {
								[userId] = v673
							})
						end)
					end

					return
				end

				local userId = t19.userId
				local partOrModel = t19.partOrModel

				if not userId and partOrModel then
					userId = v66(false)[partOrModel]

					if not userId then
						userId = HttpService:GenerateGUID(false)
						v65(function(p142) -- line: 496
							-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
							return Dictionary.join(p142, {
								[userId] = partOrModel
							})
						end)
						v67(function(p143) -- line: 503
							-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
							return Dictionary.join(p143, {
								[partOrModel] = userId
							})
						end)
					end
				end

				local v405 = if userId == t19.userId then t19 else Dictionary.join(t19, {
					userId = userId
				})
				local channelNameOverride = nil

				if GetFFlagTextChatEnableUniverseChatTabs() and v405.channelNameOverride then
					channelNameOverride = v405.channelNameOverride
				elseif v405.textChannel then
					channelNameOverride = if v405.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v68(false)) then v405.textChannel.Name else "RBXGeneral"
				end

				if v405.isVisibleInChatWindow then
					local v407 = v53(false)
					local v408 = if not channelNameOverride then {} else v55(false)[channelNameOverride] or {}

					if #v407 >= t1.messageLimit then
						local v409 = v407[1]
						local v410 = v396 and v396[v409]

						if v410 then
							if not FFlagExpChatMessagesStoreKeepInByMessageId then
								if FFlagExpChatMessagesStoreUseProxy then
									v49[v409] = nil
								else
									v48(function(p144) -- line: 273
										-- upvalues: Dictionary (copy), v409 (copy)
										return Dictionary.removeKey(p144, v409)
									end)
								end
							end

							if v410.userId then
								local userId8 = v410.userId

								local function v412(p145) -- line: 550
									-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v409 (copy), v64 (copy), v410 (copy), v67 (copy), Dictionary (copy), v65 (copy)
									if not p145 then
										return nil
									end

									local v678 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p145, function(p146) -- line: 560
										-- upvalues: v409 (copy)
										return p146.messageId ~= v409
									end) else List.filter(p145, function(p147) -- line: 556
										-- upvalues: v409 (copy)
										return p147 ~= v409
									end)

									if #v678 == 0 then
										local v679 = v64(false)

										if v679[v410.userId] then
											local v680 = v679[v410.userId]

											v67(function(p148) -- line: 571
												-- upvalues: Dictionary (copy), v680 (copy)
												return Dictionary.removeKey(p148, v680)
											end)
											v65(function(p149) -- line: 575
												-- upvalues: Dictionary (copy), v410 (copy)
												return Dictionary.removeKey(p149, v410.userId)
											end)
										end

										return nil
									end

									return v678
								end

								if FFlagExpChatMessagesStoreUseProxy then
									v52[userId8] = v412(v52[userId8])
								else
									v51(function(p150) -- line: 357
										-- upvalues: v412 (copy), userId8 (copy), Dictionary (copy)
										local v682 = v412(p150[userId8])

										if v682 == nil then
											return Dictionary.removeKey(p150, userId8)
										end

										return Dictionary.join(p150, {
											[userId8] = v682
										})
									end)
								end
							end

							v54(function(p151) -- line: 587
								-- upvalues: List (copy)
								return List.removeIndex(p151, 1)
							end)

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v409] = nil
							end
						end
					end

					if channelNameOverride and #v408 >= t1.messageLimit then
						local v413 = v408[1]

						if v413 then
							v56(function(p152) -- line: 601
								-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
								local v685 = p152[channelNameOverride] or {}
								local v686 = List.removeIndex(v685, 1)

								return Dictionary.join(p152, {
									[channelNameOverride] = v686
								})
							end)

							if v396 and v396[v413] then
								if FFlagExpChatMessagesStoreUseProxy then
									v49[v413] = nil
								else
									v48(function(p153) -- line: 273
										-- upvalues: Dictionary (copy), v413 (copy)
										return Dictionary.removeKey(p153, v413)
									end)
								end
							end

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v413] = nil
							end
						end
					end
				end

				writeByMessageId(v405.messageId, v405)

				if v405.userId then
					local userId9 = v405.userId

					local function v415(p154) -- line: 623
						-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), v405 (copy), List (copy)
						local v689 = p154 or {}
						local v690 = false

						if FFlagExpChatMessagesStoreMemoryCleanup then
							for _, v in ipairs(v689) do
								if v == v405.messageId then
									v690 = true

									break
								end
							end
						else
							for _, v in ipairs(v689) do
								if v.messageId == v405.messageId then
									v690 = true

									break
								end
							end
						end

						if not v690 then
							local v695 = if not FFlagExpChatMessagesStoreMemoryCleanup then v405 else v405.messageId

							return List.append(v689, v695)
						end

						return v689
					end

					if FFlagExpChatMessagesStoreUseProxy then
						v52[userId9] = v415(v52[userId9])
					else
						v51(function(p155) -- line: 357
							-- upvalues: v415 (copy), userId9 (copy), Dictionary (copy)
							local v697 = v415(p155[userId9])

							if v697 == nil then
								return Dictionary.removeKey(p155, userId9)
							end

							return Dictionary.join(p155, {
								[userId9] = v697
							})
						end)
					end
				end

				if v405.isVisibleInChatWindow then
					v54(function(p156) -- line: 656
						-- upvalues: List (copy), v405 (copy)
						return List.append(p156, v405.messageId)
					end)

					if channelNameOverride then
						v56(function(p157) -- line: 662
							-- upvalues: channelNameOverride (ref), List (copy), v405 (copy), Dictionary (copy)
							local v700 = p157[channelNameOverride] or {}
							local v701 = List.append(v700, v405.messageId)

							return Dictionary.join(p157, {
								[channelNameOverride] = v701
							})
						end)
					end

					if FFlagExpChatEnableV2ChatWindow then
						local v416 = v77(false)

						if v416 == nil or v416 == channelNameOverride then
							updateNextMessageComponent(v405.messageId)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(v194)

				return
			end

			v194()
		end,
		handleLegacyBubbleTextUpdated = function(s23: string, s24: string) -- line: 1280
			-- upvalues: Dictionary (copy), FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v48 (copy)
			local function v197(p158) -- line: 1281
				-- upvalues: Dictionary (copy), s24 (copy)
				return Dictionary.join(p158, {
					text = s24
				})
			end

			if FFlagExpChatMessagesStoreUseProxy then
				local v198 = v49[s23]

				if v198 then
					local v199 = Dictionary.join(v198, {
						text = s24
					})

					if v199 then
						v49[s23] = v199

						return
					end
				end
			else
				v48(function(p159) -- line: 290
					-- upvalues: s23 (copy), v197 (copy), Dictionary (copy)
					if not p159 or not p159[s23] then
						return p159 or {}
					end

					local v419 = v197(p159[s23])

					if v419 then
						return Dictionary.join(p159, {
							[s23] = v419
						})
					end

					return p159
				end)
			end
		end,
		handleHiddenMessageReceived = function(p160) -- line: 1032
			-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), FIntExpChatRandomCharChangeLowerBound (copy), FIntExpChatRandomCharChangeUpperBound (copy), Config (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v54 (copy), List (copy), resolveChannelNameForMapOrder (copy), v56 (copy), Dictionary (copy), v48 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v52 (copy), v51 (copy), writeByMessageId (copy), v66 (copy), HttpService (copy), v65 (copy), v67 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v68 (copy), v53 (copy), v55 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v64 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v77 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local v167 = string.len(if not getFFlagExpChatProtectedChatInternalAPIs() then p160.Text else p160.TextInternal)
			local v168 = math.max(FIntExpChatRandomCharChangeLowerBound, -(v167 - 1))
			local v169 = FIntExpChatRandomCharChangeUpperBound
			local v170 = math.random(v168, v169)
			local v171 = string.rep(Config.DOT_TEXT, v167 + v170)
			local t20 = {
				userId = nil,
				isVisibleInBubbleChat = false,
				isVisibleInChatWindow = true,
				isHiddenMessage = true,
				prefixText = Config.LOCK_EMOJI .. " :",
				text = v171,
				textChannel = p160.TextChannel,
				messageId = p160.MessageId,
				status = p160.Status,
				timestamp = p160.Timestamp,
				textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else p160
			}

			local function v173() -- line: 396
				-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), t20 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v54 (copy), List (copy), resolveChannelNameForMapOrder (copy), v56 (copy), Dictionary (copy), v48 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v52 (copy), v51 (copy), writeByMessageId (copy), v66 (copy), HttpService (copy), v65 (copy), v67 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v68 (copy), v53 (copy), v55 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v64 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v77 (copy), updateNextMessageComponent (ref)
				local v352 = if not FFlagExpChatMessagesStoreUseProxy then v47(false) else v49

				if v352 and v352[t20.messageId] then
					if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t20.status == Enum.TextChatMessageStatus.Floodchecked or t20.status == Enum.TextChatMessageStatus.MessageTooLong) then
						v54(function(p161) -- line: 407
							-- upvalues: List (copy), t20 (copy)
							return List.filter(p161, function(p162) -- line: 408
								-- upvalues: t20 (copy)
								return p162 ~= t20.messageId
							end)
						end)

						local v353 = resolveChannelNameForMapOrder(t20, t20.channelNameOverride)

						if v353 then
							v56(function(p163) -- line: 415
								-- upvalues: v353 (copy), List (copy), t20 (copy), Dictionary (copy)
								local v604 = p163[v353]

								if not v604 then
									return p163
								end

								local v605 = List.filter(v604, function(p164) -- line: 420
									-- upvalues: t20 (copy)
									return p164 ~= t20.messageId
								end)

								return Dictionary.join(p163, {
									[v353] = v605
								})
							end)
						end

						local messageId = t20.messageId

						if FFlagExpChatMessagesStoreUseProxy then
							v49[messageId] = nil
						else
							v48(function(p165) -- line: 273
								-- upvalues: Dictionary (copy), messageId (copy)
								return Dictionary.removeKey(p165, messageId)
							end)
						end

						if t20.userId then
							local userId = t20.userId

							local function v356(p166) -- line: 432
								-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), t20 (copy)
								if not p166 then
									return nil
								end

								local v608 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p166, function(p167) -- line: 442
									-- upvalues: t20 (copy)
									return p167.messageId ~= t20.messageId
								end) else List.filter(p166, function(p168) -- line: 438
									-- upvalues: t20 (copy)
									return p168 ~= t20.messageId
								end)

								if #v608 == 0 then
									return nil
								end

								return v608
							end

							if FFlagExpChatMessagesStoreUseProxy then
								v52[userId] = v356(v52[userId])

								return
							end

							v51(function(p169) -- line: 357
								-- upvalues: v356 (copy), userId (copy), Dictionary (copy)
								local v610 = v356(p169[userId])

								if v610 == nil then
									return Dictionary.removeKey(p169, userId)
								end

								return Dictionary.join(p169, {
									[userId] = v610
								})
							end)
						end

						return
					end

					writeByMessageId(t20.messageId, t20)

					if not FFlagExpChatMessagesStoreMemoryCleanup and t20.userId then
						local userId = t20.userId

						local function v358(p170) -- line: 461
							-- upvalues: t20 (copy), List (copy)
							if not p170 then
								return nil
							end

							local v612 = nil

							for i, v in ipairs(p170) do
								if v.messageId == t20.messageId then
									v612 = i

									break
								end
							end

							if v612 then
								return List.set(p170, v612, t20)
							end

							return p170
						end

						if FFlagExpChatMessagesStoreUseProxy then
							v52[userId] = v358(v52[userId])

							return
						end

						v51(function(p171) -- line: 357
							-- upvalues: v358 (copy), userId (copy), Dictionary (copy)
							local v616 = v358(p171[userId])

							if v616 == nil then
								return Dictionary.removeKey(p171, userId)
							end

							return Dictionary.join(p171, {
								[userId] = v616
							})
						end)
					end

					return
				end

				local userId = t20.userId
				local partOrModel = t20.partOrModel

				if not userId and partOrModel then
					userId = v66(false)[partOrModel]

					if not userId then
						userId = HttpService:GenerateGUID(false)
						v65(function(p172) -- line: 496
							-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
							return Dictionary.join(p172, {
								[userId] = partOrModel
							})
						end)
						v67(function(p173) -- line: 503
							-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
							return Dictionary.join(p173, {
								[partOrModel] = userId
							})
						end)
					end
				end

				local v361 = if userId == t20.userId then t20 else Dictionary.join(t20, {
					userId = userId
				})
				local channelNameOverride = nil

				if GetFFlagTextChatEnableUniverseChatTabs() and v361.channelNameOverride then
					channelNameOverride = v361.channelNameOverride
				elseif v361.textChannel then
					channelNameOverride = if v361.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v68(false)) then v361.textChannel.Name else "RBXGeneral"
				end

				if v361.isVisibleInChatWindow then
					local v363 = v53(false)
					local v364 = if not channelNameOverride then {} else v55(false)[channelNameOverride] or {}

					if #v363 >= t1.messageLimit then
						local v365 = v363[1]
						local v366 = v352 and v352[v365]

						if v366 then
							if not FFlagExpChatMessagesStoreKeepInByMessageId then
								if FFlagExpChatMessagesStoreUseProxy then
									v49[v365] = nil
								else
									v48(function(p174) -- line: 273
										-- upvalues: Dictionary (copy), v365 (copy)
										return Dictionary.removeKey(p174, v365)
									end)
								end
							end

							if v366.userId then
								local userId10 = v366.userId

								local function v368(p175) -- line: 550
									-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v365 (copy), v64 (copy), v366 (copy), v67 (copy), Dictionary (copy), v65 (copy)
									if not p175 then
										return nil
									end

									local v621 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p175, function(p176) -- line: 560
										-- upvalues: v365 (copy)
										return p176.messageId ~= v365
									end) else List.filter(p175, function(p177) -- line: 556
										-- upvalues: v365 (copy)
										return p177 ~= v365
									end)

									if #v621 == 0 then
										local v622 = v64(false)

										if v622[v366.userId] then
											local v623 = v622[v366.userId]

											v67(function(p178) -- line: 571
												-- upvalues: Dictionary (copy), v623 (copy)
												return Dictionary.removeKey(p178, v623)
											end)
											v65(function(p179) -- line: 575
												-- upvalues: Dictionary (copy), v366 (copy)
												return Dictionary.removeKey(p179, v366.userId)
											end)
										end

										return nil
									end

									return v621
								end

								if FFlagExpChatMessagesStoreUseProxy then
									v52[userId10] = v368(v52[userId10])
								else
									v51(function(p180) -- line: 357
										-- upvalues: v368 (copy), userId10 (copy), Dictionary (copy)
										local v625 = v368(p180[userId10])

										if v625 == nil then
											return Dictionary.removeKey(p180, userId10)
										end

										return Dictionary.join(p180, {
											[userId10] = v625
										})
									end)
								end
							end

							v54(function(p181) -- line: 587
								-- upvalues: List (copy)
								return List.removeIndex(p181, 1)
							end)

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v365] = nil
							end
						end
					end

					if channelNameOverride and #v364 >= t1.messageLimit then
						local v369 = v364[1]

						if v369 then
							v56(function(p182) -- line: 601
								-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
								local v628 = p182[channelNameOverride] or {}
								local v629 = List.removeIndex(v628, 1)

								return Dictionary.join(p182, {
									[channelNameOverride] = v629
								})
							end)

							if v352 and v352[v369] then
								if FFlagExpChatMessagesStoreUseProxy then
									v49[v369] = nil
								else
									v48(function(p183) -- line: 273
										-- upvalues: Dictionary (copy), v369 (copy)
										return Dictionary.removeKey(p183, v369)
									end)
								end
							end

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v369] = nil
							end
						end
					end
				end

				writeByMessageId(v361.messageId, v361)

				if v361.userId then
					local userId11 = v361.userId

					local function v371(p184) -- line: 623
						-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), v361 (copy), List (copy)
						local v632 = p184 or {}
						local v633 = false

						if FFlagExpChatMessagesStoreMemoryCleanup then
							for _, v in ipairs(v632) do
								if v == v361.messageId then
									v633 = true

									break
								end
							end
						else
							for _, v in ipairs(v632) do
								if v.messageId == v361.messageId then
									v633 = true

									break
								end
							end
						end

						if not v633 then
							local v638 = if not FFlagExpChatMessagesStoreMemoryCleanup then v361 else v361.messageId

							return List.append(v632, v638)
						end

						return v632
					end

					if FFlagExpChatMessagesStoreUseProxy then
						v52[userId11] = v371(v52[userId11])
					else
						v51(function(p185) -- line: 357
							-- upvalues: v371 (copy), userId11 (copy), Dictionary (copy)
							local v640 = v371(p185[userId11])

							if v640 == nil then
								return Dictionary.removeKey(p185, userId11)
							end

							return Dictionary.join(p185, {
								[userId11] = v640
							})
						end)
					end
				end

				if v361.isVisibleInChatWindow then
					v54(function(p186) -- line: 656
						-- upvalues: List (copy), v361 (copy)
						return List.append(p186, v361.messageId)
					end)

					if channelNameOverride then
						v56(function(p187) -- line: 662
							-- upvalues: channelNameOverride (ref), List (copy), v361 (copy), Dictionary (copy)
							local v643 = p187[channelNameOverride] or {}
							local v644 = List.append(v643, v361.messageId)

							return Dictionary.join(p187, {
								[channelNameOverride] = v644
							})
						end)
					end

					if FFlagExpChatEnableV2ChatWindow then
						local v372 = v77(false)

						if v372 == nil or v372 == channelNameOverride then
							updateNextMessageComponent(v361.messageId)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(v173)

				return
			end

			v173()
		end,
		handleHiddenMessagesCleared = function() -- line: 1165
			-- upvalues: FFlagExpChatClearHiddenMessagesPostAgeCheck (copy), forEachByMessageId (copy), Dictionary (copy), FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), v54 (copy), List (copy), v56 (copy)
			if not FFlagExpChatClearHiddenMessagesPostAgeCheck then
				return
			end

			forEachByMessageId(function(_, p189) -- line: 1172
				-- upvalues: Dictionary (copy)
				if p189 and p189.isHiddenMessage then
					return Dictionary.join(p189, {
						isVisibleInChatWindow = false
					})
				end

				return nil
			end)

			local function isNotHidden(s25: string) -- line: 1179
				-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy)
				local v388 = ((if not FFlagExpChatMessagesStoreUseProxy then v47(false) else v49))[s25]

				return v388 and not v388.isHiddenMessage
			end

			v54(function(p190) -- line: 1185
				-- upvalues: List (copy), isNotHidden (copy)
				return List.filter(p190, isNotHidden)
			end)
			v56(function(p191) -- line: 1190
				-- upvalues: Dictionary (copy), List (copy), isNotHidden (copy)
				return Dictionary.map(p191, function(p192) -- line: 1191
					-- upvalues: List (copy), isNotHidden (copy)
					return List.filter(p192, isNotHidden)
				end)
			end)
		end,
		addSystemMessage = function(s26: string, s27: string, s28: string?, p193: ((...any) -> ...any)?, b6: boolean?) -- line: 800
			-- upvalues: sanitizeForRichText (copy), GetFFlagExpChatSyntheticSystemMessageRichText (copy), generateRichSystemMessageTextFormat (copy), FFlagExpChatDictation (copy), HttpService (copy), FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v54 (copy), List (copy), resolveChannelNameForMapOrder (copy), v56 (copy), Dictionary (copy), v48 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v52 (copy), v51 (copy), writeByMessageId (copy), v66 (copy), v65 (copy), v67 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v68 (copy), v53 (copy), v55 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v64 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v77 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local v136 = sanitizeForRichText(s26)
			local v137 = if not GetFFlagExpChatSyntheticSystemMessageRichText() then v136 else generateRichSystemMessageTextFormat(v136, if not FFlagExpChatDictation then nil else b6, p193)
			local guid = HttpService:GenerateGUID(false)
			local t21 = {
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
				text = v137,
				messageId = guid,
				timestamp = DateTime.fromUnixTimestampMillis(workspace:GetServerTimeNow() * 1000),
				status = Enum.TextChatMessageStatus.Success,
				channelNameOverride = s27,
				metadata = s28
			}

			local function v140() -- line: 396
				-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v49 (copy), v47 (copy), t21 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v54 (copy), List (copy), resolveChannelNameForMapOrder (copy), v56 (copy), Dictionary (copy), v48 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v52 (copy), v51 (copy), writeByMessageId (copy), v66 (copy), HttpService (copy), v65 (copy), v67 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v68 (copy), v53 (copy), v55 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v64 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v77 (copy), updateNextMessageComponent (ref)
				local v289 = if not FFlagExpChatMessagesStoreUseProxy then v47(false) else v49

				if v289 and v289[t21.messageId] then
					if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t21.status == Enum.TextChatMessageStatus.Floodchecked or t21.status == Enum.TextChatMessageStatus.MessageTooLong) then
						v54(function(p194) -- line: 407
							-- upvalues: List (copy), t21 (copy)
							return List.filter(p194, function(p195) -- line: 408
								-- upvalues: t21 (copy)
								return p195 ~= t21.messageId
							end)
						end)

						local v290 = resolveChannelNameForMapOrder(t21, t21.channelNameOverride)

						if v290 then
							v56(function(p196) -- line: 415
								-- upvalues: v290 (copy), List (copy), t21 (copy), Dictionary (copy)
								local v475 = p196[v290]

								if not v475 then
									return p196
								end

								local v476 = List.filter(v475, function(p197) -- line: 420
									-- upvalues: t21 (copy)
									return p197 ~= t21.messageId
								end)

								return Dictionary.join(p196, {
									[v290] = v476
								})
							end)
						end

						local messageId = t21.messageId

						if FFlagExpChatMessagesStoreUseProxy then
							v49[messageId] = nil
						else
							v48(function(p198) -- line: 273
								-- upvalues: Dictionary (copy), messageId (copy)
								return Dictionary.removeKey(p198, messageId)
							end)
						end

						if t21.userId then
							local userId = t21.userId

							local function v293(p199) -- line: 432
								-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), t21 (copy)
								if not p199 then
									return nil
								end

								local v479 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p199, function(p200) -- line: 442
									-- upvalues: t21 (copy)
									return p200.messageId ~= t21.messageId
								end) else List.filter(p199, function(p201) -- line: 438
									-- upvalues: t21 (copy)
									return p201 ~= t21.messageId
								end)

								if #v479 == 0 then
									return nil
								end

								return v479
							end

							if FFlagExpChatMessagesStoreUseProxy then
								v52[userId] = v293(v52[userId])

								return
							end

							v51(function(p202) -- line: 357
								-- upvalues: v293 (copy), userId (copy), Dictionary (copy)
								local v481 = v293(p202[userId])

								if v481 == nil then
									return Dictionary.removeKey(p202, userId)
								end

								return Dictionary.join(p202, {
									[userId] = v481
								})
							end)
						end

						return
					end

					writeByMessageId(t21.messageId, t21)

					if not FFlagExpChatMessagesStoreMemoryCleanup and t21.userId then
						local userId = t21.userId

						local function v295(p203) -- line: 461
							-- upvalues: t21 (copy), List (copy)
							if not p203 then
								return nil
							end

							local v483 = nil

							for i, v in ipairs(p203) do
								if v.messageId == t21.messageId then
									v483 = i

									break
								end
							end

							if v483 then
								return List.set(p203, v483, t21)
							end

							return p203
						end

						if FFlagExpChatMessagesStoreUseProxy then
							v52[userId] = v295(v52[userId])

							return
						end

						v51(function(p204) -- line: 357
							-- upvalues: v295 (copy), userId (copy), Dictionary (copy)
							local v487 = v295(p204[userId])

							if v487 == nil then
								return Dictionary.removeKey(p204, userId)
							end

							return Dictionary.join(p204, {
								[userId] = v487
							})
						end)
					end

					return
				end

				local userId = t21.userId
				local partOrModel = t21.partOrModel

				if not userId and partOrModel then
					userId = v66(false)[partOrModel]

					if not userId then
						userId = HttpService:GenerateGUID(false)
						v65(function(p205) -- line: 496
							-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
							return Dictionary.join(p205, {
								[userId] = partOrModel
							})
						end)
						v67(function(p206) -- line: 503
							-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
							return Dictionary.join(p206, {
								[partOrModel] = userId
							})
						end)
					end
				end

				local v298 = if userId == t21.userId then t21 else Dictionary.join(t21, {
					userId = userId
				})
				local channelNameOverride = nil

				if GetFFlagTextChatEnableUniverseChatTabs() and v298.channelNameOverride then
					channelNameOverride = v298.channelNameOverride
				elseif v298.textChannel then
					channelNameOverride = if v298.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v68(false)) then v298.textChannel.Name else "RBXGeneral"
				end

				if v298.isVisibleInChatWindow then
					local v300 = v53(false)
					local v301 = if not channelNameOverride then {} else v55(false)[channelNameOverride] or {}

					if #v300 >= t1.messageLimit then
						local v302 = v300[1]
						local v303 = v289 and v289[v302]

						if v303 then
							if not FFlagExpChatMessagesStoreKeepInByMessageId then
								if FFlagExpChatMessagesStoreUseProxy then
									v49[v302] = nil
								else
									v48(function(p207) -- line: 273
										-- upvalues: Dictionary (copy), v302 (copy)
										return Dictionary.removeKey(p207, v302)
									end)
								end
							end

							if v303.userId then
								local userId12 = v303.userId

								local function v305(p208) -- line: 550
									-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v302 (copy), v64 (copy), v303 (copy), v67 (copy), Dictionary (copy), v65 (copy)
									if not p208 then
										return nil
									end

									local v492 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p208, function(p209) -- line: 560
										-- upvalues: v302 (copy)
										return p209.messageId ~= v302
									end) else List.filter(p208, function(p210) -- line: 556
										-- upvalues: v302 (copy)
										return p210 ~= v302
									end)

									if #v492 == 0 then
										local v493 = v64(false)

										if v493[v303.userId] then
											local v494 = v493[v303.userId]

											v67(function(p211) -- line: 571
												-- upvalues: Dictionary (copy), v494 (copy)
												return Dictionary.removeKey(p211, v494)
											end)
											v65(function(p212) -- line: 575
												-- upvalues: Dictionary (copy), v303 (copy)
												return Dictionary.removeKey(p212, v303.userId)
											end)
										end

										return nil
									end

									return v492
								end

								if FFlagExpChatMessagesStoreUseProxy then
									v52[userId12] = v305(v52[userId12])
								else
									v51(function(p213) -- line: 357
										-- upvalues: v305 (copy), userId12 (copy), Dictionary (copy)
										local v496 = v305(p213[userId12])

										if v496 == nil then
											return Dictionary.removeKey(p213, userId12)
										end

										return Dictionary.join(p213, {
											[userId12] = v496
										})
									end)
								end
							end

							v54(function(p214) -- line: 587
								-- upvalues: List (copy)
								return List.removeIndex(p214, 1)
							end)

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v302] = nil
							end
						end
					end

					if channelNameOverride and #v301 >= t1.messageLimit then
						local v306 = v301[1]

						if v306 then
							v56(function(p215) -- line: 601
								-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
								local v499 = p215[channelNameOverride] or {}
								local v500 = List.removeIndex(v499, 1)

								return Dictionary.join(p215, {
									[channelNameOverride] = v500
								})
							end)

							if v289 and v289[v306] then
								if FFlagExpChatMessagesStoreUseProxy then
									v49[v306] = nil
								else
									v48(function(p216) -- line: 273
										-- upvalues: Dictionary (copy), v306 (copy)
										return Dictionary.removeKey(p216, v306)
									end)
								end
							end

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v306] = nil
							end
						end
					end
				end

				writeByMessageId(v298.messageId, v298)

				if v298.userId then
					local userId13 = v298.userId

					local function v308(p217) -- line: 623
						-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), v298 (copy), List (copy)
						local v503 = p217 or {}
						local v504 = false

						if FFlagExpChatMessagesStoreMemoryCleanup then
							for _, v in ipairs(v503) do
								if v == v298.messageId then
									v504 = true

									break
								end
							end
						else
							for _, v in ipairs(v503) do
								if v.messageId == v298.messageId then
									v504 = true

									break
								end
							end
						end

						if not v504 then
							local v509 = if not FFlagExpChatMessagesStoreMemoryCleanup then v298 else v298.messageId

							return List.append(v503, v509)
						end

						return v503
					end

					if FFlagExpChatMessagesStoreUseProxy then
						v52[userId13] = v308(v52[userId13])
					else
						v51(function(p218) -- line: 357
							-- upvalues: v308 (copy), userId13 (copy), Dictionary (copy)
							local v511 = v308(p218[userId13])

							if v511 == nil then
								return Dictionary.removeKey(p218, userId13)
							end

							return Dictionary.join(p218, {
								[userId13] = v511
							})
						end)
					end
				end

				if v298.isVisibleInChatWindow then
					v54(function(p219) -- line: 656
						-- upvalues: List (copy), v298 (copy)
						return List.append(p219, v298.messageId)
					end)

					if channelNameOverride then
						v56(function(p220) -- line: 662
							-- upvalues: channelNameOverride (ref), List (copy), v298 (copy), Dictionary (copy)
							local v514 = p220[channelNameOverride] or {}
							local v515 = List.append(v514, v298.messageId)

							return Dictionary.join(p220, {
								[channelNameOverride] = v515
							})
						end)
					end

					if FFlagExpChatEnableV2ChatWindow then
						local v309 = v77(false)

						if v309 == nil or v309 == channelNameOverride then
							updateNextMessageComponent(v298.messageId)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(v140)

				return
			end

			v140()
		end,
		getChannelTabsConfigurationEnabled = v68,
		setChannelTabsConfigurationEnabled = v69
	}
end

return createMessagesStore
