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
local FFlagExpChatFixLocalUserVerifiedBadge = require(ExpChat.Flags.FFlagExpChatFixLocalUserVerifiedBadge)

function getChatTranslationEnabled() -- line: 55
	-- upvalues: TextChatService (copy)
	return TextChatService.ChatTranslationEnabled
end

local function createMessagesStore(p1) -- line: 177
	-- upvalues: createSignal (copy), FFlagExpChatMessagesStoreUseProxy (copy), createProxy (copy), createComputed (copy), Dictionary (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), List (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), HttpService (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), FFlagExpChatEnableV2ChatWindow (copy), Set (copy), sanitizeForRichText (copy), GetFFlagExpChatSyntheticSystemMessageRichText (copy), generateRichSystemMessageTextFormat (copy), FFlagExpChatDictation (copy), computeNameColor (copy), Players (copy), FFlagEnableInExpChatRewrite (copy), getTextAndTranslation (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), isWhiteSpaceOnly (copy), FFlagExpChatFixLocalUserVerifiedBadge (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), ExpChatShared (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatDisableUniverseBubbleChat (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), FIntExpChatRandomCharChangeLowerBound (copy), FIntExpChatRandomCharChangeUpperBound (copy), Config (copy), FFlagExpChatClearHiddenMessagesPostAgeCheck (copy)
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
	local v48, v49 = createSignal(t1.byMessageId)
	local v50 = if not FFlagExpChatMessagesStoreUseProxy then nil else createProxy({})
	local v51, v52 = createSignal(t1.messagesBySenderId)
	local v53 = if not FFlagExpChatMessagesStoreUseProxy then nil else createProxy({})
	local v54, v55 = createSignal(t1.windowMessagesInOrder)
	local v56, v57 = createSignal(t1.windowMessagesInOrderByTabId)
	local v58, v59 = createSignal(t1.mutedUserIds)
	local v60 = if p1 == nil then v58 else createComputed(function(p2) -- line: 210
		-- upvalues: v58 (copy), p1 (copy)
		local v101 = v58(p2)
		local v102 = p1(p2)
		local v103 = table.clone(v101)

		for v104 in v102 do
			v103[v104] = true
		end

		return v103
	end)
	local v61, v62 = createSignal(t1.canLocalUserChat)
	local v63, _ = createSignal(t1.isBubbleChatEnabled)
	local v65, v66 = createSignal(t1.mockUserIdToPartOrModel)
	local v67, v68 = createSignal(t1.partOrModelToMockUserId)
	local v69, v70 = createSignal(false)
	local v71, v72 = createSignal(t1.messageComponentRingBuffer)
	local v73, v74 = createSignal(t1.nextMessageComponentPointer)
	local t2 = {}
	local n1 = 0
	local t3 = {}
	local v78, v79 = createSignal(nil)
	local updateNextMessageComponent = nil
	local t4 = {}

	local function readByMessageId() -- line: 252
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			return v50
		end

		return v48(false)
	end
	local function readByMessageIdReactive(p3) -- line: 259
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			return v50(p3)
		end

		return v48(p3)
	end
	local function writeByMessageId(s1: string, t5: {[any]: any}?) -- line: 266
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v49 (copy), Dictionary (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			v50[s1] = t5

			return
		end

		if t5 ~= nil then
			v49(function(p4) -- line: 270
				-- upvalues: Dictionary (copy), s1 (copy), t5 (copy)
				return Dictionary.join(p4, {
					[s1] = t5
				})
			end)

			return
		end

		v49(function(p5) -- line: 274
			-- upvalues: Dictionary (copy), s1 (copy)
			return Dictionary.removeKey(p5, s1)
		end)
	end
	local function updateByMessageId(s2: string, p6: ((...any) -> ...any)) -- line: 281
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v49 (copy), Dictionary (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			local v110 = v50[s2]

			if v110 then
				local v111 = p6(v110)

				if v111 then
					v50[s2] = v111

					return
				end
			end
		else
			v49(function(p7) -- line: 291
				-- upvalues: s2 (copy), p6 (copy), Dictionary (copy)
				if not p7 or not p7[s2] then
					return p7 or {}
				end

				local v233 = p6(p7[s2])

				if v233 then
					return Dictionary.join(p7, {
						[s2] = v233
					})
				end

				return p7
			end)
		end
	end
	local function forEachByMessageId(p8: ((...any) -> ...any)) -- line: 304
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v49 (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			for v113 in v50 do
				local v114 = v50[v113]

				if v114 then
					local v115 = p8(v113, v114)

					if v115 then
						v50[v113] = v115
					end
				end
			end

			return
		end

		v49(function(p9) -- line: 316
			-- upvalues: p8 (copy)
			if not p9 then
				return {}
			end

			local t6 = {}

			for v236, v237 in p9 do
				t6[v236] = p8(v236, v237) or v237
			end

			return t6
		end)
	end
	local function readMessagesBySenderIdReactive(p10) -- line: 332
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v53 (copy), v51 (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			return v53(p10)
		end

		return v51(p10)
	end
	local function writeMessagesBySenderId(s3: string, p11) -- line: 339
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v53 (copy), v52 (copy), Dictionary (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			v53[s3] = p11

			return
		end

		if p11 ~= nil then
			v52(function(p12) -- line: 343
				-- upvalues: Dictionary (copy), s3 (copy), p11 (copy)
				return Dictionary.join(p12, {
					[s3] = p11
				})
			end)

			return
		end

		v52(function(p13) -- line: 347
			-- upvalues: Dictionary (copy), s3 (copy)
			return Dictionary.removeKey(p13, s3)
		end)
	end
	local function updateMessagesBySenderId(s4: string, p14: ((...any) -> ...any)) -- line: 353
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v53 (copy), v52 (copy), Dictionary (copy)
		if FFlagExpChatMessagesStoreUseProxy then
			v53[s4] = p14(v53[s4])

			return
		end

		v52(function(p15) -- line: 358
			-- upvalues: p14 (copy), s4 (copy), Dictionary (copy)
			local v241 = p14(p15[s4])

			if v241 == nil then
				return Dictionary.removeKey(p15, s4)
			end

			return Dictionary.join(p15, {
				[s4] = v241
			})
		end)
	end
	local function resolveChannelNameForMapOrder(t7: {[any]: any}, s5: string?) -- line: 368
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), v69 (copy)
		if GetFFlagTextChatEnableUniverseChatTabs() then
			if s5 then
				return s5
			end

			if t7.textChannel then
				if t7.textChannel.Name == "RBXSystem" or not v69(false) then
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
	local function maybeBatch(p16: ((...any) -> ...any)) -- line: 388
		-- upvalues: FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
		if FFlagExpChatMessagesStoreBatch then
			SignalsExperimental.batch(p16)

			return
		end

		p16()
	end
	local function addMessage(t8: {[any]: any}) -- line: 396
		-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v55 (copy), List (copy), resolveChannelNameForMapOrder (copy), v57 (copy), Dictionary (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v53 (copy), v52 (copy), writeByMessageId (copy), v67 (copy), HttpService (copy), v66 (copy), v68 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v69 (copy), v54 (copy), v56 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v65 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v78 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
		local function v125() -- line: 397
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), t8 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v55 (copy), List (copy), resolveChannelNameForMapOrder (copy), v57 (copy), Dictionary (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v53 (copy), v52 (copy), writeByMessageId (copy), v67 (copy), HttpService (copy), v66 (copy), v68 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v69 (copy), v54 (copy), v56 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v65 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v78 (copy), updateNextMessageComponent (ref)
			local v242 = if not FFlagExpChatMessagesStoreUseProxy then v48(false) else v50

			if v242 and v242[t8.messageId] then
				if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t8.status == Enum.TextChatMessageStatus.Floodchecked or t8.status == Enum.TextChatMessageStatus.MessageTooLong) then
					v55(function(p17) -- line: 408
						-- upvalues: List (copy), t8 (copy)
						return List.filter(p17, function(p18) -- line: 409
							-- upvalues: t8 (copy)
							return p18 ~= t8.messageId
						end)
					end)

					local v243 = resolveChannelNameForMapOrder(t8, t8.channelNameOverride)

					if v243 then
						v57(function(p19) -- line: 416
							-- upvalues: v243 (copy), List (copy), t8 (copy), Dictionary (copy)
							local v433 = p19[v243]

							if not v433 then
								return p19
							end

							local v434 = List.filter(v433, function(p20) -- line: 421
								-- upvalues: t8 (copy)
								return p20 ~= t8.messageId
							end)

							return Dictionary.join(p19, {
								[v243] = v434
							})
						end)
					end

					local messageId = t8.messageId

					if FFlagExpChatMessagesStoreUseProxy then
						v50[messageId] = nil
					else
						v49(function(p21) -- line: 274
							-- upvalues: Dictionary (copy), messageId (copy)
							return Dictionary.removeKey(p21, messageId)
						end)
					end

					if t8.userId then
						local userId = t8.userId

						local function v246(p22) -- line: 433
							-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), t8 (copy)
							if not p22 then
								return nil
							end

							local v437 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p22, function(p23) -- line: 443
								-- upvalues: t8 (copy)
								return p23.messageId ~= t8.messageId
							end) else List.filter(p22, function(p24) -- line: 439
								-- upvalues: t8 (copy)
								return p24 ~= t8.messageId
							end)

							if #v437 == 0 then
								return nil
							end

							return v437
						end

						if FFlagExpChatMessagesStoreUseProxy then
							v53[userId] = v246(v53[userId])

							return
						end

						v52(function(p25) -- line: 358
							-- upvalues: v246 (copy), userId (copy), Dictionary (copy)
							local v439 = v246(p25[userId])

							if v439 == nil then
								return Dictionary.removeKey(p25, userId)
							end

							return Dictionary.join(p25, {
								[userId] = v439
							})
						end)
					end

					return
				end

				writeByMessageId(t8.messageId, t8)

				if not FFlagExpChatMessagesStoreMemoryCleanup and t8.userId then
					local userId = t8.userId

					local function v248(p26) -- line: 462
						-- upvalues: t8 (copy), List (copy)
						if not p26 then
							return nil
						end

						local v441 = nil

						for i, v in ipairs(p26) do
							if v.messageId == t8.messageId then
								v441 = i

								break
							end
						end

						if v441 then
							return List.set(p26, v441, t8)
						end

						return p26
					end

					if FFlagExpChatMessagesStoreUseProxy then
						v53[userId] = v248(v53[userId])

						return
					end

					v52(function(p27) -- line: 358
						-- upvalues: v248 (copy), userId (copy), Dictionary (copy)
						local v445 = v248(p27[userId])

						if v445 == nil then
							return Dictionary.removeKey(p27, userId)
						end

						return Dictionary.join(p27, {
							[userId] = v445
						})
					end)
				end

				return
			end

			local userId = t8.userId
			local partOrModel = t8.partOrModel

			if not userId and partOrModel then
				userId = v67(false)[partOrModel]

				if not userId then
					userId = HttpService:GenerateGUID(false)
					v66(function(p28) -- line: 497
						-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
						return Dictionary.join(p28, {
							[userId] = partOrModel
						})
					end)
					v68(function(p29) -- line: 504
						-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
						return Dictionary.join(p29, {
							[partOrModel] = userId
						})
					end)
				end
			end

			local v251 = if userId == t8.userId then t8 else Dictionary.join(t8, {
				userId = userId
			})
			local channelNameOverride = nil

			if GetFFlagTextChatEnableUniverseChatTabs() and v251.channelNameOverride then
				channelNameOverride = v251.channelNameOverride
			elseif v251.textChannel then
				channelNameOverride = if v251.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v69(false)) then v251.textChannel.Name else "RBXGeneral"
			end

			if v251.isVisibleInChatWindow then
				local v253 = v54(false)
				local v254 = if not channelNameOverride then {} else v56(false)[channelNameOverride] or {}

				if #v253 >= t1.messageLimit then
					local v255 = v253[1]
					local v256 = v242 and v242[v255]

					if v256 then
						if not FFlagExpChatMessagesStoreKeepInByMessageId then
							if FFlagExpChatMessagesStoreUseProxy then
								v50[v255] = nil
							else
								v49(function(p30) -- line: 274
									-- upvalues: Dictionary (copy), v255 (copy)
									return Dictionary.removeKey(p30, v255)
								end)
							end
						end

						if v256.userId then
							local userId2 = v256.userId

							local function v258(p31) -- line: 551
								-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v255 (copy), v65 (copy), v256 (copy), v68 (copy), Dictionary (copy), v66 (copy)
								if not p31 then
									return nil
								end

								local v450 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p31, function(p32) -- line: 561
									-- upvalues: v255 (copy)
									return p32.messageId ~= v255
								end) else List.filter(p31, function(p33) -- line: 557
									-- upvalues: v255 (copy)
									return p33 ~= v255
								end)

								if #v450 == 0 then
									local v451 = v65(false)

									if v451[v256.userId] then
										local v452 = v451[v256.userId]

										v68(function(p34) -- line: 572
											-- upvalues: Dictionary (copy), v452 (copy)
											return Dictionary.removeKey(p34, v452)
										end)
										v66(function(p35) -- line: 576
											-- upvalues: Dictionary (copy), v256 (copy)
											return Dictionary.removeKey(p35, v256.userId)
										end)
									end

									return nil
								end

								return v450
							end

							if FFlagExpChatMessagesStoreUseProxy then
								v53[userId2] = v258(v53[userId2])
							else
								v52(function(p36) -- line: 358
									-- upvalues: v258 (copy), userId2 (copy), Dictionary (copy)
									local v454 = v258(p36[userId2])

									if v454 == nil then
										return Dictionary.removeKey(p36, userId2)
									end

									return Dictionary.join(p36, {
										[userId2] = v454
									})
								end)
							end
						end

						v55(function(p37) -- line: 588
							-- upvalues: List (copy)
							return List.removeIndex(p37, 1)
						end)

						if FFlagExpChatMessagesStoreMemoryCleanup then
							t4[v255] = nil
						end
					end
				end

				if channelNameOverride and #v254 >= t1.messageLimit then
					local v259 = v254[1]

					if v259 then
						v57(function(p38) -- line: 602
							-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
							local v457 = p38[channelNameOverride] or {}
							local v458 = List.removeIndex(v457, 1)

							return Dictionary.join(p38, {
								[channelNameOverride] = v458
							})
						end)

						if v242 and v242[v259] then
							if FFlagExpChatMessagesStoreUseProxy then
								v50[v259] = nil
							else
								v49(function(p39) -- line: 274
									-- upvalues: Dictionary (copy), v259 (copy)
									return Dictionary.removeKey(p39, v259)
								end)
							end
						end

						if FFlagExpChatMessagesStoreMemoryCleanup then
							t4[v259] = nil
						end
					end
				end
			end

			writeByMessageId(v251.messageId, v251)

			if v251.userId then
				local userId3 = v251.userId

				local function v261(p40) -- line: 624
					-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), v251 (copy), List (copy)
					local v461 = p40 or {}
					local v462 = false

					if FFlagExpChatMessagesStoreMemoryCleanup then
						for _, v in ipairs(v461) do
							if v == v251.messageId then
								v462 = true

								break
							end
						end
					else
						for _, v in ipairs(v461) do
							if v.messageId == v251.messageId then
								v462 = true

								break
							end
						end
					end

					if not v462 then
						local v467 = if not FFlagExpChatMessagesStoreMemoryCleanup then v251 else v251.messageId

						return List.append(v461, v467)
					end

					return v461
				end

				if FFlagExpChatMessagesStoreUseProxy then
					v53[userId3] = v261(v53[userId3])
				else
					v52(function(p41) -- line: 358
						-- upvalues: v261 (copy), userId3 (copy), Dictionary (copy)
						local v469 = v261(p41[userId3])

						if v469 == nil then
							return Dictionary.removeKey(p41, userId3)
						end

						return Dictionary.join(p41, {
							[userId3] = v469
						})
					end)
				end
			end

			if v251.isVisibleInChatWindow then
				v55(function(p42) -- line: 657
					-- upvalues: List (copy), v251 (copy)
					return List.append(p42, v251.messageId)
				end)

				if channelNameOverride then
					v57(function(p43) -- line: 663
						-- upvalues: channelNameOverride (ref), List (copy), v251 (copy), Dictionary (copy)
						local v472 = p43[channelNameOverride] or {}
						local v473 = List.append(v472, v251.messageId)

						return Dictionary.join(p43, {
							[channelNameOverride] = v473
						})
					end)
				end

				if FFlagExpChatEnableV2ChatWindow then
					local v262 = v78(false)

					if v262 == nil or v262 == channelNameOverride then
						updateNextMessageComponent(v251.messageId)
					end
				end
			end
		end

		if FFlagExpChatMessagesStoreBatch then
			SignalsExperimental.batch(v125)

			return
		end

		v125()
	end

	local t9 = {}

	local function getUserMessageCache(s6: string) -- line: 714
		-- upvalues: t9 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), createComputed (copy), FFlagExpChatMessagesStoreUseProxy (copy), v53 (copy), v51 (copy), v50 (copy), v48 (copy), v60 (copy), Set (copy)
		local str = tostring(s6)

		if not t9[str] then
			t9[str] = {}

			if not FFlagExpChatMessagesStoreMemoryCleanup then
				t9[str].messages = createComputed(function(p44) -- line: 720
					-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v53 (copy), v51 (copy), str (copy)
					return ((if not FFlagExpChatMessagesStoreUseProxy then v51(p44) else v53(p44)))[str] or {}
				end)
			end

			if FFlagExpChatMessagesStoreMemoryCleanup then
				t9[str].bubbleMessages = createComputed(function(p45) -- line: 727
					-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v53 (copy), v51 (copy), str (copy), v50 (copy), v48 (copy), v60 (copy), Set (copy)
					local v268 = ((if not FFlagExpChatMessagesStoreUseProxy then v51(p45) else v53(p45)))[str] or {}
					local v269 = if not FFlagExpChatMessagesStoreUseProxy then v48(p45) else v50(p45)
					local v270 = v60(p45)
					local t10 = {}

					for _, v in ipairs(v268) do
						local v274 = v269[v]

						if v274 then
							local v275 = not not v274.userId and (Set.has(v270, v274.userId) or false)

							if v274.isVisibleInBubbleChat and not v275 then
								table.insert(t10, v274)
							end
						end
					end

					return t10
				end)
			else
				t9[str].bubbleMessages = createComputed(function(p46) -- line: 745
					-- upvalues: t9 (copy), str (copy), v60 (copy), Set (copy)
					local v277 = t9[str].messages(p46)
					local v278 = v60(p46)
					local t11 = {}

					for _, v in ipairs(v277) do
						local v282 = not not v.userId and (Set.has(v278, v.userId) or false)

						if v.isVisibleInBubbleChat and not v282 then
							table.insert(t11, v)
						end
					end

					return t11
				end)
			end

			if not FFlagExpChatMessagesStoreMemoryCleanup then
				t9[str].lastMessage = createComputed(function(p47) -- line: 760
					-- upvalues: t9 (copy), str (copy)
					local v284 = t9[str].messages(p47)

					if #v284 > 0 then
						return v284[#v284]
					end

					return nil
				end)
			end
		end

		return t9[str]
	end
	local function getUserMessages(s7: string) -- line: 772
		-- upvalues: getUserMessageCache (copy)
		return getUserMessageCache(s7).messages
	end
	local function getUserLastMessage(s8: string) -- line: 782
		-- upvalues: getUserMessageCache (copy)
		return getUserMessageCache(s8).lastMessage
	end
	local function createMessagesArraySignal() -- line: 787
		-- upvalues: createComputed (copy), FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy)
		return createComputed(function(p48) -- line: 788
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy)
			local v286 = if not FFlagExpChatMessagesStoreUseProxy then v48(p48) else v50(p48)

			if not v286 then
				return {}
			end

			local t12 = {}

			for _, v289 in v286 do
				table.insert(t12, v289)
			end

			return t12
		end)
	end
	local function formatPrefixForUniverseChatTabs(s9: string, s10: string?, p49) -- line: 840
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), computeNameColor (copy), Players (copy)
		if not GetFFlagTextChatEnableUniverseChatTabs() or (not s10 or #s9 == 0) then
			return s9
		end

		return `<font color="#{ ((if not p49.TextSource then computeNameColor(not Players.LocalPlayer and "" or Players.LocalPlayer.Name) else computeNameColor(p49.TextSource.Username))):ToHex() }">{ s9 }</font>`
	end
	local function rebuildMessageWithTranslation(t13: {[any]: any}, b1: boolean) -- line: 1205
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

	function updateNextMessageComponent(s11: string) -- line: 1383
		-- upvalues: v71 (copy), v73 (copy), v74 (copy), t2 (copy), FFlagEnableInExpChatRewrite (copy), n1 (ref), t3 (copy)
		local v217 = v71(false)

		if #v217 == 0 then
			return
		end

		local v218 = v73(false)
		local v219 = v217[v218]

		if not v219 then
			v74(1)

			return
		end

		local v220 = t2[v219]

		if v220 then
			v220.setter(s11)
		end

		local v221 = not FFlagEnableInExpChatRewrite and 1 or 10

		n1 += v221

		local v222 = t3[v219]

		if v222 then
			v222.setter(n1)
		end

		local v223 = v218 % #v217 + 1

		v74(v223)
	end

	return {
		getByMessageId = if not FFlagExpChatMessagesStoreUseProxy then v48 else v50,
		getMessages = if not FFlagExpChatMessagesStoreMemoryCleanup then createComputed(function(p50) -- line: 788
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy)
			local v226 = if not FFlagExpChatMessagesStoreUseProxy then v48(p50) else v50(p50)

			if not v226 then
				return {}
			end

			local t14 = {}

			for _, v229 in v226 do
				table.insert(t14, v229)
			end

			return t14
		end) else nil,
		getMessagesBySenderId = if not FFlagExpChatMessagesStoreUseProxy then v51 else v53,
		getWindowMessagesInOrder = v54,
		getWindowMessagesInOrderByTabId = v56,
		getMutedUserIds = v60,
		getCanLocalUserChat = v61,
		getIsBubbleChatEnabled = v63,
		getMockUserIdToPartOrModel = v65,
		getPartOrModelToMockUserId = v67,
		getMessage = function(s12: string) -- line: 695
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), t4 (copy), createComputed (copy)
			if FFlagExpChatMessagesStoreUseProxy then
				return function(p51) -- line: 697
					-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), s12 (copy)
					return ((if not FFlagExpChatMessagesStoreUseProxy then v48(p51) else v50(p51)))[s12]
				end
			end

			if not t4[s12] then
				t4[s12] = createComputed(function(p52) -- line: 703
					-- upvalues: v48 (copy), s12 (copy)
					local v265 = v48(p52)

					if not v265 or not v265[s12] then
						return nil
					end

					return v265[s12]
				end)
			end

			return t4[s12]
		end,
		getUserMessages = if not FFlagExpChatMessagesStoreMemoryCleanup then getUserMessages else nil,
		getUserBubbleMessages = function(s13: string) -- line: 777
			-- upvalues: getUserMessageCache (copy)
			return getUserMessageCache(s13).bubbleMessages
		end,
		getUserLastMessage = if not FFlagExpChatMessagesStoreMemoryCleanup then getUserLastMessage else nil,
		registerMessageComponent = function(s14: string) -- line: 1296
			-- upvalues: t2 (copy), createSignal (copy), t3 (copy), v72 (copy), List (copy)
			if not t2[s14] then
				local v202, v203 = createSignal(nil)

				t2[s14] = {
					getter = v202,
					setter = v203
				}

				local v204, v205 = createSignal(0)

				t3[s14] = {
					getter = v204,
					setter = v205
				}
				v72(function(p53) -- line: 1311
					-- upvalues: List (copy), s14 (copy)
					return List.append(p53, s14)
				end)
			end

			return t2[s14].getter
		end,
		unregisterMessageComponent = function(s15: string) -- line: 1320
			-- upvalues: v71 (copy), t2 (copy), t3 (copy), v72 (copy), List (copy), v73 (copy), v74 (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local v207 = v71(false)
			local u208 = nil

			for i, v in ipairs(v207) do
				if v == s15 then
					u208 = i

					break
				end
			end

			if t2[s15] then
				t2[s15] = nil
			end

			if t3[s15] then
				t3[s15] = nil
			end

			if u208 then
				local function doUnregister() -- line: 1343
					-- upvalues: v72 (copy), List (copy), s15 (copy), v71 (copy), v73 (copy), v74 (copy), u208 (ref)
					v72(function(p54) -- line: 1344
						-- upvalues: List (copy), s15 (copy)
						return List.filter(p54, function(p55) -- line: 1345
							-- upvalues: s15 (copy)
							return p55 ~= s15
						end)
					end)

					local v422 = v71(false)
					local v423 = v73(false)

					if #v422 == 0 then
						v74(1)

						return
					end

					if v423 > u208 then
						v74(v423 - 1)

						return
					end

					if v423 > #v422 then
						v74(1)
					end
				end

				if FFlagExpChatMessagesStoreBatch then
					SignalsExperimental.batch(doUnregister)
				else
					doUnregister()
				end
			end
		end,
		repopulateMessageComponents = function() -- line: 1420
			-- upvalues: v78 (copy), v56 (copy), v54 (copy), v74 (copy), n1 (ref), updateNextMessageComponent (ref), v71 (copy), v73 (copy), t2 (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local function doRepopulate() -- line: 1421
				-- upvalues: v78 (copy), v56 (copy), v54 (copy), v74 (copy), n1 (ref), updateNextMessageComponent (ref), v71 (copy), v73 (copy), t2 (copy)
				local v424 = v78(false)
				local v425 = if not v424 then v54(false) else v56(false)[v424] or {}

				v74(1)
				n1 = 0

				for _, v in ipairs(v425) do
					updateNextMessageComponent(v)
				end

				local v428 = v71(false)

				if #v425 < #v428 then
					for i = v73(false), #v428 do
						local v430 = t2[v428[i]]

						if v430 then
							v430.setter(nil)
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
		getMessageComponentSignal = function(s16: string) -- line: 1371
			-- upvalues: t2 (copy)
			local v213 = t2[s16]

			if v213 then
				return v213.getter
			end

			return nil
		end,
		getLayoutOrderSignal = function(s17: string) -- line: 1377
			-- upvalues: t3 (copy)
			local v215 = t3[s17]

			if v215 then
				return v215.getter
			end

			return nil
		end,
		updateNextMessageComponent = updateNextMessageComponent,
		getMessageComponentRingBuffer = v71,
		getNextMessageComponentPointer = v73,
		setActiveChannelFilter = v79,
		getActiveChannelFilter = v78,
		setCanLocalUserChat = v62,
		muteUser = function(s18: string) -- line: 1118
			-- upvalues: v59 (copy), Set (copy)
			v59(function(p56) -- line: 1119
				-- upvalues: Set (copy), s18 (copy)
				if not p56 then
					return {}
				end

				return (Set.add(p56, s18))
			end)
		end,
		unmuteUser = function(s19: string) -- line: 1128
			-- upvalues: v59 (copy), Set (copy)
			v59(function(p57) -- line: 1129
				-- upvalues: Set (copy), s19 (copy)
				if not p57 then
					return {}
				end

				return (Set.subtract(p57, s19))
			end)
		end,
		handlePlayerRemoved = function(s20: string) -- line: 1073
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v53 (copy), v52 (copy), Dictionary (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), t9 (copy), v59 (copy), Set (copy), v51 (copy), v65 (copy), v68 (copy), v66 (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local str = tostring(s20)

			local function doHandlePlayerRemoved() -- line: 1076
				-- upvalues: str (copy), FFlagExpChatMessagesStoreUseProxy (copy), v53 (copy), v52 (copy), Dictionary (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), t9 (copy), v59 (copy), Set (copy), v51 (copy), v65 (copy), v68 (copy), v66 (copy)
				local v374 = str

				if FFlagExpChatMessagesStoreUseProxy then
					v53[v374] = nil
				else
					v52(function(p58) -- line: 347
						-- upvalues: Dictionary (copy), v374 (copy)
						return Dictionary.removeKey(p58, v374)
					end)
				end

				if FFlagExpChatMessagesStoreMemoryCleanup then
					t9[str] = nil
				end

				v59(function(p59) -- line: 1084
					-- upvalues: Set (copy), str (copy), FFlagExpChatMessagesStoreUseProxy (copy), v53 (copy), v51 (copy), v65 (copy), v68 (copy), Dictionary (copy), v66 (copy)
					if not p59 then
						return {}
					end

					local v648 = Set.has(p59, str)

					if #(((if not FFlagExpChatMessagesStoreUseProxy then v51(false) else v53))[str] or {}) == 0 and not v648 then
						return p59
					end

					local v649 = v65(false)

					if v649[str] then
						local v650 = v649[str]

						v68(function(p60) -- line: 1102
							-- upvalues: Dictionary (copy), v650 (copy)
							return Dictionary.removeKey(p60, v650)
						end)
						v66(function(p61) -- line: 1106
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
				v53[str] = nil
			else
				v52(function(p62) -- line: 347
					-- upvalues: Dictionary (copy), str (copy)
					return Dictionary.removeKey(p62, str)
				end)
			end

			if FFlagExpChatMessagesStoreMemoryCleanup then
				t9[str] = nil
			end

			v59(function(p63) -- line: 1084
				-- upvalues: Set (copy), str (copy), FFlagExpChatMessagesStoreUseProxy (copy), v53 (copy), v51 (copy), v65 (copy), v68 (copy), Dictionary (copy), v66 (copy)
				if not p63 then
					return {}
				end

				local v377 = Set.has(p63, str)

				if #(((if not FFlagExpChatMessagesStoreUseProxy then v51(false) else v53))[str] or {}) == 0 and not v377 then
					return p63
				end

				local v378 = v65(false)

				if v378[str] then
					local v379 = v378[str]

					v68(function(p64) -- line: 1102
						-- upvalues: Dictionary (copy), v379 (copy)
						return Dictionary.removeKey(p64, v379)
					end)
					v66(function(p65) -- line: 1106
						-- upvalues: Dictionary (copy), str (copy)
						return Dictionary.removeKey(p65, str)
					end)
				end

				return Set.subtract(p63, str)
			end)
		end,
		clearWindowMessages = function() -- line: 1138
			-- upvalues: forEachByMessageId (copy), Dictionary (copy), v55 (copy), v57 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), n1 (ref), v71 (copy), t2 (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local function doClearWindowMessages() -- line: 1139
				-- upvalues: forEachByMessageId (copy), Dictionary (copy), v55 (copy), v57 (copy), FFlagExpChatEnableV2ChatWindow (copy), v74 (copy), n1 (ref), v71 (copy), t2 (copy)
				forEachByMessageId(function(_, p67) -- line: 1140
					-- upvalues: Dictionary (copy)
					return Dictionary.join(p67, {
						isVisibleInChatWindow = false
					})
				end)
				v55(function(_) -- line: 1145
					return {}
				end)
				v57(function(_) -- line: 1150
					return {}
				end)

				if FFlagExpChatEnableV2ChatWindow then
					v74(1)
					n1 = 0

					local v382 = v71(false)

					for _, v in ipairs(v382) do
						local v385 = t2[v]

						if v385 then
							v385.setter(nil)
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
		toggleGlobalTranslation = function(b2: boolean) -- line: 1235
			-- upvalues: forEachByMessageId (copy), rebuildMessageWithTranslation (copy), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local function doToggleGlobalTranslation() -- line: 1236
				-- upvalues: forEachByMessageId (copy), rebuildMessageWithTranslation (copy), b2 (copy)
				forEachByMessageId(function(_, p71) -- line: 1237
					-- upvalues: rebuildMessageWithTranslation (copy), b2 (copy)
					return (rebuildMessageWithTranslation(p71, b2))
				end)
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(doToggleGlobalTranslation)

				return
			end

			forEachByMessageId(function(_, p73) -- line: 1237
				-- upvalues: rebuildMessageWithTranslation (copy), b2 (copy)
				return (rebuildMessageWithTranslation(p73, b2))
			end)
		end,
		toggleMessageTranslation = function(b3: boolean, s21: string) -- line: 1245
			-- upvalues: rebuildMessageWithTranslation (copy), FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v49 (copy), Dictionary (copy)
			local function v188(p74) -- line: 1246
				-- upvalues: rebuildMessageWithTranslation (copy), b3 (copy)
				return (rebuildMessageWithTranslation(p74, b3))
			end

			if FFlagExpChatMessagesStoreUseProxy then
				local v189 = v50[s21]

				if v189 then
					local v190 = rebuildMessageWithTranslation(v189, b3)

					if v190 then
						v50[s21] = v190

						return
					end
				end
			else
				v49(function(p75) -- line: 291
					-- upvalues: s21 (copy), v188 (copy), Dictionary (copy)
					if not p75 or not p75[s21] then
						return p75 or {}
					end

					local v396 = v188(p75[s21])

					if v396 then
						return Dictionary.join(p75, {
							[s21] = v396
						})
					end

					return p75
				end)
			end
		end,
		handleIncomingOrOutgoingMessage = function(p76, b4: boolean, s22: string?, b5: boolean?) -- line: 863
			-- upvalues: FFlagEnableInExpChatRewrite (copy), getTextAndTranslation (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), isWhiteSpaceOnly (copy), FFlagExpChatFixLocalUserVerifiedBadge (copy), Players (copy), FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), v61 (copy), FFlagExpChatPresetChatEnabled (copy), v60 (copy), Set (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), ExpChatShared (copy), v63 (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatDisableUniverseBubbleChat (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), formatPrefixForUniverseChatTabs (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v55 (copy), List (copy), resolveChannelNameForMapOrder (copy), v57 (copy), Dictionary (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v53 (copy), v52 (copy), writeByMessageId (copy), v67 (copy), HttpService (copy), v66 (copy), v68 (copy), v69 (copy), v54 (copy), v56 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v65 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v78 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local v149, v150

			if FFlagEnableInExpChatRewrite then
				v149, v150 = getTextAndTranslation(p76)
			else
				v149 = if not getFFlagExpChatProtectedChatInternalAPIs() then p76.Text else p76.TextInternal
				v150 = if not getFFlagExpChatProtectedChatInternalAPIs() then p76.Translation else p76.TranslationInternal
			end

			if isWhiteSpaceOnly(v149) and p76.Status ~= Enum.TextChatMessageStatus.Floodchecked and p76.Status ~= Enum.TextChatMessageStatus.MessageTooLong then
				return
			end

			local v151 = if not p76.TextSource then if not FFlagExpChatFixLocalUserVerifiedBadge or (not b4 or not Players.LocalPlayer) then nil else tostring(Players.LocalPlayer.UserId) else tostring(p76.TextSource.UserId)

			if not if not FFlagExpChatMessagesStoreUseProxy then v48(false) else v50 then
				return
			end

			local v152 = v61(false)
			local v153 = v151 == nil or (v152 or not not FFlagExpChatPresetChatEnabled and (p76.PresetId or "") ~= "") and (p76.Status == Enum.TextChatMessageStatus.Success or p76.Status == Enum.TextChatMessageStatus.Sending)
			local v154 = not not v151 and (not not v60(false) and Set.has(v60(false), v151))
			local v155 = v153 and not v154
			local v156 = false
			local v157

			if FFlagExpChatUseChatConfigStore then
				v157 = GetChatConfigurationStore(false).getIsBubbleChatEnabled(false)
			else
				local v158 = ExpChatShared.context and ExpChatShared.context.store

				v157 = if not v158 then v63(false) else v158:getState().Messages.isBubbleChatEnabled
			end

			if v157 and v155 and (not FFlagEnableInExpChatSummaryOnLua or v151 ~= nil) and (p76.Status == Enum.TextChatMessageStatus.Success or p76.Status == Enum.TextChatMessageStatus.Sending) then
				v156 = true
			end

			if FFlagExpChatDisableUniverseBubbleChat and GetFFlagTextChatEnableUniverseChatTabs() and b5 == true then
				v156 = false
			end

			if p76.Status ~= Enum.TextChatMessageStatus.Success and p76.Status ~= Enum.TextChatMessageStatus.Sending then
				v155 = false
				v156 = false
			end

			local v159 = formatPrefixForUniverseChatTabs(if not getFFlagExpChatProtectedChatInternalAPIs() then p76.PrefixText else p76.PrefixTextInternal, s22, p76)
			local t15 = {
				shouldOverrideBubbleChatSettings = false,
				userId = v151,
				prefixText = v159,
				text = v149,
				translation = v150,
				useTranslation = getChatTranslationEnabled() and v150 ~= nil,
				messageId = p76.MessageId,
				status = p76.Status,
				timestamp = p76.Timestamp,
				isVisibleInBubbleChat = v156,
				isVisibleInChatWindow = v155,
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
			local v161 = if not FFlagExpChatMessagesStoreUseProxy then v48(false) else v50
			local v162 = v161 and v161[t15.messageId] ~= nil

			if t15.isVisibleInChatWindow or t15.isVisibleInBubbleChat or v162 then
				local function v163() -- line: 397
					-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), t15 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v55 (copy), List (copy), resolveChannelNameForMapOrder (copy), v57 (copy), Dictionary (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v53 (copy), v52 (copy), writeByMessageId (copy), v67 (copy), HttpService (copy), v66 (copy), v68 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v69 (copy), v54 (copy), v56 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v65 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v78 (copy), updateNextMessageComponent (ref)
					local v311 = if not FFlagExpChatMessagesStoreUseProxy then v48(false) else v50

					if v311 and v311[t15.messageId] then
						if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t15.status == Enum.TextChatMessageStatus.Floodchecked or t15.status == Enum.TextChatMessageStatus.MessageTooLong) then
							v55(function(p77) -- line: 408
								-- upvalues: List (copy), t15 (copy)
								return List.filter(p77, function(p78) -- line: 409
									-- upvalues: t15 (copy)
									return p78 ~= t15.messageId
								end)
							end)

							local v312 = resolveChannelNameForMapOrder(t15, t15.channelNameOverride)

							if v312 then
								v57(function(p79) -- line: 416
									-- upvalues: v312 (copy), List (copy), t15 (copy), Dictionary (copy)
									local v519 = p79[v312]

									if not v519 then
										return p79
									end

									local v520 = List.filter(v519, function(p80) -- line: 421
										-- upvalues: t15 (copy)
										return p80 ~= t15.messageId
									end)

									return Dictionary.join(p79, {
										[v312] = v520
									})
								end)
							end

							local messageId = t15.messageId

							if FFlagExpChatMessagesStoreUseProxy then
								v50[messageId] = nil
							else
								v49(function(p81) -- line: 274
									-- upvalues: Dictionary (copy), messageId (copy)
									return Dictionary.removeKey(p81, messageId)
								end)
							end

							if t15.userId then
								local userId = t15.userId

								local function v315(p82) -- line: 433
									-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), t15 (copy)
									if not p82 then
										return nil
									end

									local v523 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p82, function(p83) -- line: 443
										-- upvalues: t15 (copy)
										return p83.messageId ~= t15.messageId
									end) else List.filter(p82, function(p84) -- line: 439
										-- upvalues: t15 (copy)
										return p84 ~= t15.messageId
									end)

									if #v523 == 0 then
										return nil
									end

									return v523
								end

								if FFlagExpChatMessagesStoreUseProxy then
									v53[userId] = v315(v53[userId])

									return
								end

								v52(function(p85) -- line: 358
									-- upvalues: v315 (copy), userId (copy), Dictionary (copy)
									local v525 = v315(p85[userId])

									if v525 == nil then
										return Dictionary.removeKey(p85, userId)
									end

									return Dictionary.join(p85, {
										[userId] = v525
									})
								end)
							end

							return
						end

						writeByMessageId(t15.messageId, t15)

						if not FFlagExpChatMessagesStoreMemoryCleanup and t15.userId then
							local userId = t15.userId

							local function v317(p86) -- line: 462
								-- upvalues: t15 (copy), List (copy)
								if not p86 then
									return nil
								end

								local v527 = nil

								for i, v in ipairs(p86) do
									if v.messageId == t15.messageId then
										v527 = i

										break
									end
								end

								if v527 then
									return List.set(p86, v527, t15)
								end

								return p86
							end

							if FFlagExpChatMessagesStoreUseProxy then
								v53[userId] = v317(v53[userId])

								return
							end

							v52(function(p87) -- line: 358
								-- upvalues: v317 (copy), userId (copy), Dictionary (copy)
								local v531 = v317(p87[userId])

								if v531 == nil then
									return Dictionary.removeKey(p87, userId)
								end

								return Dictionary.join(p87, {
									[userId] = v531
								})
							end)
						end

						return
					end

					local userId = t15.userId
					local partOrModel = t15.partOrModel

					if not userId and partOrModel then
						userId = v67(false)[partOrModel]

						if not userId then
							userId = HttpService:GenerateGUID(false)
							v66(function(p88) -- line: 497
								-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
								return Dictionary.join(p88, {
									[userId] = partOrModel
								})
							end)
							v68(function(p89) -- line: 504
								-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
								return Dictionary.join(p89, {
									[partOrModel] = userId
								})
							end)
						end
					end

					local v320 = if userId == t15.userId then t15 else Dictionary.join(t15, {
						userId = userId
					})
					local channelNameOverride = nil

					if GetFFlagTextChatEnableUniverseChatTabs() and v320.channelNameOverride then
						channelNameOverride = v320.channelNameOverride
					elseif v320.textChannel then
						channelNameOverride = if v320.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v69(false)) then v320.textChannel.Name else "RBXGeneral"
					end

					if v320.isVisibleInChatWindow then
						local v322 = v54(false)
						local v323 = if not channelNameOverride then {} else v56(false)[channelNameOverride] or {}

						if #v322 >= t1.messageLimit then
							local v324 = v322[1]
							local v325 = v311 and v311[v324]

							if v325 then
								if not FFlagExpChatMessagesStoreKeepInByMessageId then
									if FFlagExpChatMessagesStoreUseProxy then
										v50[v324] = nil
									else
										v49(function(p90) -- line: 274
											-- upvalues: Dictionary (copy), v324 (copy)
											return Dictionary.removeKey(p90, v324)
										end)
									end
								end

								if v325.userId then
									local userId4 = v325.userId

									local function v327(p91) -- line: 551
										-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v324 (copy), v65 (copy), v325 (copy), v68 (copy), Dictionary (copy), v66 (copy)
										if not p91 then
											return nil
										end

										local v536 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p91, function(p92) -- line: 561
											-- upvalues: v324 (copy)
											return p92.messageId ~= v324
										end) else List.filter(p91, function(p93) -- line: 557
											-- upvalues: v324 (copy)
											return p93 ~= v324
										end)

										if #v536 == 0 then
											local v537 = v65(false)

											if v537[v325.userId] then
												local v538 = v537[v325.userId]

												v68(function(p94) -- line: 572
													-- upvalues: Dictionary (copy), v538 (copy)
													return Dictionary.removeKey(p94, v538)
												end)
												v66(function(p95) -- line: 576
													-- upvalues: Dictionary (copy), v325 (copy)
													return Dictionary.removeKey(p95, v325.userId)
												end)
											end

											return nil
										end

										return v536
									end

									if FFlagExpChatMessagesStoreUseProxy then
										v53[userId4] = v327(v53[userId4])
									else
										v52(function(p96) -- line: 358
											-- upvalues: v327 (copy), userId4 (copy), Dictionary (copy)
											local v540 = v327(p96[userId4])

											if v540 == nil then
												return Dictionary.removeKey(p96, userId4)
											end

											return Dictionary.join(p96, {
												[userId4] = v540
											})
										end)
									end
								end

								v55(function(p97) -- line: 588
									-- upvalues: List (copy)
									return List.removeIndex(p97, 1)
								end)

								if FFlagExpChatMessagesStoreMemoryCleanup then
									t4[v324] = nil
								end
							end
						end

						if channelNameOverride and #v323 >= t1.messageLimit then
							local v328 = v323[1]

							if v328 then
								v57(function(p98) -- line: 602
									-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
									local v543 = p98[channelNameOverride] or {}
									local v544 = List.removeIndex(v543, 1)

									return Dictionary.join(p98, {
										[channelNameOverride] = v544
									})
								end)

								if v311 and v311[v328] then
									if FFlagExpChatMessagesStoreUseProxy then
										v50[v328] = nil
									else
										v49(function(p99) -- line: 274
											-- upvalues: Dictionary (copy), v328 (copy)
											return Dictionary.removeKey(p99, v328)
										end)
									end
								end

								if FFlagExpChatMessagesStoreMemoryCleanup then
									t4[v328] = nil
								end
							end
						end
					end

					writeByMessageId(v320.messageId, v320)

					if v320.userId then
						local userId5 = v320.userId

						local function v330(p100) -- line: 624
							-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), v320 (copy), List (copy)
							local v547 = p100 or {}
							local v548 = false

							if FFlagExpChatMessagesStoreMemoryCleanup then
								for _, v in ipairs(v547) do
									if v == v320.messageId then
										v548 = true

										break
									end
								end
							else
								for _, v in ipairs(v547) do
									if v.messageId == v320.messageId then
										v548 = true

										break
									end
								end
							end

							if not v548 then
								local v553 = if not FFlagExpChatMessagesStoreMemoryCleanup then v320 else v320.messageId

								return List.append(v547, v553)
							end

							return v547
						end

						if FFlagExpChatMessagesStoreUseProxy then
							v53[userId5] = v330(v53[userId5])
						else
							v52(function(p101) -- line: 358
								-- upvalues: v330 (copy), userId5 (copy), Dictionary (copy)
								local v555 = v330(p101[userId5])

								if v555 == nil then
									return Dictionary.removeKey(p101, userId5)
								end

								return Dictionary.join(p101, {
									[userId5] = v555
								})
							end)
						end
					end

					if v320.isVisibleInChatWindow then
						v55(function(p102) -- line: 657
							-- upvalues: List (copy), v320 (copy)
							return List.append(p102, v320.messageId)
						end)

						if channelNameOverride then
							v57(function(p103) -- line: 663
								-- upvalues: channelNameOverride (ref), List (copy), v320 (copy), Dictionary (copy)
								local v558 = p103[channelNameOverride] or {}
								local v559 = List.append(v558, v320.messageId)

								return Dictionary.join(p103, {
									[channelNameOverride] = v559
								})
							end)
						end

						if FFlagExpChatEnableV2ChatWindow then
							local v331 = v78(false)

							if v331 == nil or v331 == channelNameOverride then
								updateNextMessageComponent(v320.messageId)
							end
						end
					end
				end

				if FFlagExpChatMessagesStoreBatch then
					SignalsExperimental.batch(v163)

					return
				end

				v163()
			end
		end,
		handleIncomingBubbleChatMessage = function(t16: {[any]: any}) -- line: 1017
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v55 (copy), List (copy), resolveChannelNameForMapOrder (copy), v57 (copy), Dictionary (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v53 (copy), v52 (copy), writeByMessageId (copy), v67 (copy), HttpService (copy), v66 (copy), v68 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v69 (copy), v54 (copy), v56 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v65 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v78 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
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

			local function v166() -- line: 397
				-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), t17 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v55 (copy), List (copy), resolveChannelNameForMapOrder (copy), v57 (copy), Dictionary (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v53 (copy), v52 (copy), writeByMessageId (copy), v67 (copy), HttpService (copy), v66 (copy), v68 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v69 (copy), v54 (copy), v56 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v65 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v78 (copy), updateNextMessageComponent (ref)
				local v332 = if not FFlagExpChatMessagesStoreUseProxy then v48(false) else v50

				if v332 and v332[t17.messageId] then
					if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t17.status == Enum.TextChatMessageStatus.Floodchecked or t17.status == Enum.TextChatMessageStatus.MessageTooLong) then
						v55(function(p104) -- line: 408
							-- upvalues: List (copy), t17 (copy)
							return List.filter(p104, function(p105) -- line: 409
								-- upvalues: t17 (copy)
								return p105 ~= t17.messageId
							end)
						end)

						local v333 = resolveChannelNameForMapOrder(t17, t17.channelNameOverride)

						if v333 then
							v57(function(p106) -- line: 416
								-- upvalues: v333 (copy), List (copy), t17 (copy), Dictionary (copy)
								local v562 = p106[v333]

								if not v562 then
									return p106
								end

								local v563 = List.filter(v562, function(p107) -- line: 421
									-- upvalues: t17 (copy)
									return p107 ~= t17.messageId
								end)

								return Dictionary.join(p106, {
									[v333] = v563
								})
							end)
						end

						local messageId = t17.messageId

						if FFlagExpChatMessagesStoreUseProxy then
							v50[messageId] = nil
						else
							v49(function(p108) -- line: 274
								-- upvalues: Dictionary (copy), messageId (copy)
								return Dictionary.removeKey(p108, messageId)
							end)
						end

						if t17.userId then
							local userId = t17.userId

							local function v336(p109) -- line: 433
								-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), t17 (copy)
								if not p109 then
									return nil
								end

								local v566 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p109, function(p110) -- line: 443
									-- upvalues: t17 (copy)
									return p110.messageId ~= t17.messageId
								end) else List.filter(p109, function(p111) -- line: 439
									-- upvalues: t17 (copy)
									return p111 ~= t17.messageId
								end)

								if #v566 == 0 then
									return nil
								end

								return v566
							end

							if FFlagExpChatMessagesStoreUseProxy then
								v53[userId] = v336(v53[userId])

								return
							end

							v52(function(p112) -- line: 358
								-- upvalues: v336 (copy), userId (copy), Dictionary (copy)
								local v568 = v336(p112[userId])

								if v568 == nil then
									return Dictionary.removeKey(p112, userId)
								end

								return Dictionary.join(p112, {
									[userId] = v568
								})
							end)
						end

						return
					end

					writeByMessageId(t17.messageId, t17)

					if not FFlagExpChatMessagesStoreMemoryCleanup and t17.userId then
						local userId = t17.userId

						local function v338(p113) -- line: 462
							-- upvalues: t17 (copy), List (copy)
							if not p113 then
								return nil
							end

							local v570 = nil

							for i, v in ipairs(p113) do
								if v.messageId == t17.messageId then
									v570 = i

									break
								end
							end

							if v570 then
								return List.set(p113, v570, t17)
							end

							return p113
						end

						if FFlagExpChatMessagesStoreUseProxy then
							v53[userId] = v338(v53[userId])

							return
						end

						v52(function(p114) -- line: 358
							-- upvalues: v338 (copy), userId (copy), Dictionary (copy)
							local v574 = v338(p114[userId])

							if v574 == nil then
								return Dictionary.removeKey(p114, userId)
							end

							return Dictionary.join(p114, {
								[userId] = v574
							})
						end)
					end

					return
				end

				local userId = t17.userId
				local partOrModel = t17.partOrModel

				if not userId and partOrModel then
					userId = v67(false)[partOrModel]

					if not userId then
						userId = HttpService:GenerateGUID(false)
						v66(function(p115) -- line: 497
							-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
							return Dictionary.join(p115, {
								[userId] = partOrModel
							})
						end)
						v68(function(p116) -- line: 504
							-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
							return Dictionary.join(p116, {
								[partOrModel] = userId
							})
						end)
					end
				end

				local v341 = if userId == t17.userId then t17 else Dictionary.join(t17, {
					userId = userId
				})
				local channelNameOverride = nil

				if GetFFlagTextChatEnableUniverseChatTabs() and v341.channelNameOverride then
					channelNameOverride = v341.channelNameOverride
				elseif v341.textChannel then
					channelNameOverride = if v341.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v69(false)) then v341.textChannel.Name else "RBXGeneral"
				end

				if v341.isVisibleInChatWindow then
					local v343 = v54(false)
					local v344 = if not channelNameOverride then {} else v56(false)[channelNameOverride] or {}

					if #v343 >= t1.messageLimit then
						local v345 = v343[1]
						local v346 = v332 and v332[v345]

						if v346 then
							if not FFlagExpChatMessagesStoreKeepInByMessageId then
								if FFlagExpChatMessagesStoreUseProxy then
									v50[v345] = nil
								else
									v49(function(p117) -- line: 274
										-- upvalues: Dictionary (copy), v345 (copy)
										return Dictionary.removeKey(p117, v345)
									end)
								end
							end

							if v346.userId then
								local userId6 = v346.userId

								local function v348(p118) -- line: 551
									-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v345 (copy), v65 (copy), v346 (copy), v68 (copy), Dictionary (copy), v66 (copy)
									if not p118 then
										return nil
									end

									local v579 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p118, function(p119) -- line: 561
										-- upvalues: v345 (copy)
										return p119.messageId ~= v345
									end) else List.filter(p118, function(p120) -- line: 557
										-- upvalues: v345 (copy)
										return p120 ~= v345
									end)

									if #v579 == 0 then
										local v580 = v65(false)

										if v580[v346.userId] then
											local v581 = v580[v346.userId]

											v68(function(p121) -- line: 572
												-- upvalues: Dictionary (copy), v581 (copy)
												return Dictionary.removeKey(p121, v581)
											end)
											v66(function(p122) -- line: 576
												-- upvalues: Dictionary (copy), v346 (copy)
												return Dictionary.removeKey(p122, v346.userId)
											end)
										end

										return nil
									end

									return v579
								end

								if FFlagExpChatMessagesStoreUseProxy then
									v53[userId6] = v348(v53[userId6])
								else
									v52(function(p123) -- line: 358
										-- upvalues: v348 (copy), userId6 (copy), Dictionary (copy)
										local v583 = v348(p123[userId6])

										if v583 == nil then
											return Dictionary.removeKey(p123, userId6)
										end

										return Dictionary.join(p123, {
											[userId6] = v583
										})
									end)
								end
							end

							v55(function(p124) -- line: 588
								-- upvalues: List (copy)
								return List.removeIndex(p124, 1)
							end)

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v345] = nil
							end
						end
					end

					if channelNameOverride and #v344 >= t1.messageLimit then
						local v349 = v344[1]

						if v349 then
							v57(function(p125) -- line: 602
								-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
								local v586 = p125[channelNameOverride] or {}
								local v587 = List.removeIndex(v586, 1)

								return Dictionary.join(p125, {
									[channelNameOverride] = v587
								})
							end)

							if v332 and v332[v349] then
								if FFlagExpChatMessagesStoreUseProxy then
									v50[v349] = nil
								else
									v49(function(p126) -- line: 274
										-- upvalues: Dictionary (copy), v349 (copy)
										return Dictionary.removeKey(p126, v349)
									end)
								end
							end

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v349] = nil
							end
						end
					end
				end

				writeByMessageId(v341.messageId, v341)

				if v341.userId then
					local userId7 = v341.userId

					local function v351(p127) -- line: 624
						-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), v341 (copy), List (copy)
						local v590 = p127 or {}
						local v591 = false

						if FFlagExpChatMessagesStoreMemoryCleanup then
							for _, v in ipairs(v590) do
								if v == v341.messageId then
									v591 = true

									break
								end
							end
						else
							for _, v in ipairs(v590) do
								if v.messageId == v341.messageId then
									v591 = true

									break
								end
							end
						end

						if not v591 then
							local v596 = if not FFlagExpChatMessagesStoreMemoryCleanup then v341 else v341.messageId

							return List.append(v590, v596)
						end

						return v590
					end

					if FFlagExpChatMessagesStoreUseProxy then
						v53[userId7] = v351(v53[userId7])
					else
						v52(function(p128) -- line: 358
							-- upvalues: v351 (copy), userId7 (copy), Dictionary (copy)
							local v598 = v351(p128[userId7])

							if v598 == nil then
								return Dictionary.removeKey(p128, userId7)
							end

							return Dictionary.join(p128, {
								[userId7] = v598
							})
						end)
					end
				end

				if v341.isVisibleInChatWindow then
					v55(function(p129) -- line: 657
						-- upvalues: List (copy), v341 (copy)
						return List.append(p129, v341.messageId)
					end)

					if channelNameOverride then
						v57(function(p130) -- line: 663
							-- upvalues: channelNameOverride (ref), List (copy), v341 (copy), Dictionary (copy)
							local v601 = p130[channelNameOverride] or {}
							local v602 = List.append(v601, v341.messageId)

							return Dictionary.join(p130, {
								[channelNameOverride] = v602
							})
						end)
					end

					if FFlagExpChatEnableV2ChatWindow then
						local v352 = v78(false)

						if v352 == nil or v352 == channelNameOverride then
							updateNextMessageComponent(v341.messageId)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(v166)

				return
			end

			v166()
		end,
		handleLegacyBubbleCreated = function(t18: {[any]: any}) -- line: 1251
			-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v55 (copy), List (copy), resolveChannelNameForMapOrder (copy), v57 (copy), Dictionary (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v53 (copy), v52 (copy), writeByMessageId (copy), v67 (copy), HttpService (copy), v66 (copy), v68 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v69 (copy), v54 (copy), v56 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v65 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v78 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local timestamp = t18.timestamp
			local v193 = if not timestamp then DateTime.now() else DateTime.fromUnixTimestampMillis(timestamp)
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
				timestamp = v193,
				partOrModel = t18.adornee
			}

			local function v195() -- line: 397
				-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), t19 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v55 (copy), List (copy), resolveChannelNameForMapOrder (copy), v57 (copy), Dictionary (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v53 (copy), v52 (copy), writeByMessageId (copy), v67 (copy), HttpService (copy), v66 (copy), v68 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v69 (copy), v54 (copy), v56 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v65 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v78 (copy), updateNextMessageComponent (ref)
				local v397 = if not FFlagExpChatMessagesStoreUseProxy then v48(false) else v50

				if v397 and v397[t19.messageId] then
					if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t19.status == Enum.TextChatMessageStatus.Floodchecked or t19.status == Enum.TextChatMessageStatus.MessageTooLong) then
						v55(function(p131) -- line: 408
							-- upvalues: List (copy), t19 (copy)
							return List.filter(p131, function(p132) -- line: 409
								-- upvalues: t19 (copy)
								return p132 ~= t19.messageId
							end)
						end)

						local v398 = resolveChannelNameForMapOrder(t19, t19.channelNameOverride)

						if v398 then
							v57(function(p133) -- line: 416
								-- upvalues: v398 (copy), List (copy), t19 (copy), Dictionary (copy)
								local v662 = p133[v398]

								if not v662 then
									return p133
								end

								local v663 = List.filter(v662, function(p134) -- line: 421
									-- upvalues: t19 (copy)
									return p134 ~= t19.messageId
								end)

								return Dictionary.join(p133, {
									[v398] = v663
								})
							end)
						end

						local messageId = t19.messageId

						if FFlagExpChatMessagesStoreUseProxy then
							v50[messageId] = nil
						else
							v49(function(p135) -- line: 274
								-- upvalues: Dictionary (copy), messageId (copy)
								return Dictionary.removeKey(p135, messageId)
							end)
						end

						if t19.userId then
							local userId = t19.userId

							local function v401(p136) -- line: 433
								-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), t19 (copy)
								if not p136 then
									return nil
								end

								local v666 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p136, function(p137) -- line: 443
									-- upvalues: t19 (copy)
									return p137.messageId ~= t19.messageId
								end) else List.filter(p136, function(p138) -- line: 439
									-- upvalues: t19 (copy)
									return p138 ~= t19.messageId
								end)

								if #v666 == 0 then
									return nil
								end

								return v666
							end

							if FFlagExpChatMessagesStoreUseProxy then
								v53[userId] = v401(v53[userId])

								return
							end

							v52(function(p139) -- line: 358
								-- upvalues: v401 (copy), userId (copy), Dictionary (copy)
								local v668 = v401(p139[userId])

								if v668 == nil then
									return Dictionary.removeKey(p139, userId)
								end

								return Dictionary.join(p139, {
									[userId] = v668
								})
							end)
						end

						return
					end

					writeByMessageId(t19.messageId, t19)

					if not FFlagExpChatMessagesStoreMemoryCleanup and t19.userId then
						local userId = t19.userId

						local function v403(p140) -- line: 462
							-- upvalues: t19 (copy), List (copy)
							if not p140 then
								return nil
							end

							local v670 = nil

							for i, v in ipairs(p140) do
								if v.messageId == t19.messageId then
									v670 = i

									break
								end
							end

							if v670 then
								return List.set(p140, v670, t19)
							end

							return p140
						end

						if FFlagExpChatMessagesStoreUseProxy then
							v53[userId] = v403(v53[userId])

							return
						end

						v52(function(p141) -- line: 358
							-- upvalues: v403 (copy), userId (copy), Dictionary (copy)
							local v674 = v403(p141[userId])

							if v674 == nil then
								return Dictionary.removeKey(p141, userId)
							end

							return Dictionary.join(p141, {
								[userId] = v674
							})
						end)
					end

					return
				end

				local userId = t19.userId
				local partOrModel = t19.partOrModel

				if not userId and partOrModel then
					userId = v67(false)[partOrModel]

					if not userId then
						userId = HttpService:GenerateGUID(false)
						v66(function(p142) -- line: 497
							-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
							return Dictionary.join(p142, {
								[userId] = partOrModel
							})
						end)
						v68(function(p143) -- line: 504
							-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
							return Dictionary.join(p143, {
								[partOrModel] = userId
							})
						end)
					end
				end

				local v406 = if userId == t19.userId then t19 else Dictionary.join(t19, {
					userId = userId
				})
				local channelNameOverride = nil

				if GetFFlagTextChatEnableUniverseChatTabs() and v406.channelNameOverride then
					channelNameOverride = v406.channelNameOverride
				elseif v406.textChannel then
					channelNameOverride = if v406.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v69(false)) then v406.textChannel.Name else "RBXGeneral"
				end

				if v406.isVisibleInChatWindow then
					local v408 = v54(false)
					local v409 = if not channelNameOverride then {} else v56(false)[channelNameOverride] or {}

					if #v408 >= t1.messageLimit then
						local v410 = v408[1]
						local v411 = v397 and v397[v410]

						if v411 then
							if not FFlagExpChatMessagesStoreKeepInByMessageId then
								if FFlagExpChatMessagesStoreUseProxy then
									v50[v410] = nil
								else
									v49(function(p144) -- line: 274
										-- upvalues: Dictionary (copy), v410 (copy)
										return Dictionary.removeKey(p144, v410)
									end)
								end
							end

							if v411.userId then
								local userId8 = v411.userId

								local function v413(p145) -- line: 551
									-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v410 (copy), v65 (copy), v411 (copy), v68 (copy), Dictionary (copy), v66 (copy)
									if not p145 then
										return nil
									end

									local v679 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p145, function(p146) -- line: 561
										-- upvalues: v410 (copy)
										return p146.messageId ~= v410
									end) else List.filter(p145, function(p147) -- line: 557
										-- upvalues: v410 (copy)
										return p147 ~= v410
									end)

									if #v679 == 0 then
										local v680 = v65(false)

										if v680[v411.userId] then
											local v681 = v680[v411.userId]

											v68(function(p148) -- line: 572
												-- upvalues: Dictionary (copy), v681 (copy)
												return Dictionary.removeKey(p148, v681)
											end)
											v66(function(p149) -- line: 576
												-- upvalues: Dictionary (copy), v411 (copy)
												return Dictionary.removeKey(p149, v411.userId)
											end)
										end

										return nil
									end

									return v679
								end

								if FFlagExpChatMessagesStoreUseProxy then
									v53[userId8] = v413(v53[userId8])
								else
									v52(function(p150) -- line: 358
										-- upvalues: v413 (copy), userId8 (copy), Dictionary (copy)
										local v683 = v413(p150[userId8])

										if v683 == nil then
											return Dictionary.removeKey(p150, userId8)
										end

										return Dictionary.join(p150, {
											[userId8] = v683
										})
									end)
								end
							end

							v55(function(p151) -- line: 588
								-- upvalues: List (copy)
								return List.removeIndex(p151, 1)
							end)

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v410] = nil
							end
						end
					end

					if channelNameOverride and #v409 >= t1.messageLimit then
						local v414 = v409[1]

						if v414 then
							v57(function(p152) -- line: 602
								-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
								local v686 = p152[channelNameOverride] or {}
								local v687 = List.removeIndex(v686, 1)

								return Dictionary.join(p152, {
									[channelNameOverride] = v687
								})
							end)

							if v397 and v397[v414] then
								if FFlagExpChatMessagesStoreUseProxy then
									v50[v414] = nil
								else
									v49(function(p153) -- line: 274
										-- upvalues: Dictionary (copy), v414 (copy)
										return Dictionary.removeKey(p153, v414)
									end)
								end
							end

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v414] = nil
							end
						end
					end
				end

				writeByMessageId(v406.messageId, v406)

				if v406.userId then
					local userId9 = v406.userId

					local function v416(p154) -- line: 624
						-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), v406 (copy), List (copy)
						local v690 = p154 or {}
						local v691 = false

						if FFlagExpChatMessagesStoreMemoryCleanup then
							for _, v in ipairs(v690) do
								if v == v406.messageId then
									v691 = true

									break
								end
							end
						else
							for _, v in ipairs(v690) do
								if v.messageId == v406.messageId then
									v691 = true

									break
								end
							end
						end

						if not v691 then
							local v696 = if not FFlagExpChatMessagesStoreMemoryCleanup then v406 else v406.messageId

							return List.append(v690, v696)
						end

						return v690
					end

					if FFlagExpChatMessagesStoreUseProxy then
						v53[userId9] = v416(v53[userId9])
					else
						v52(function(p155) -- line: 358
							-- upvalues: v416 (copy), userId9 (copy), Dictionary (copy)
							local v698 = v416(p155[userId9])

							if v698 == nil then
								return Dictionary.removeKey(p155, userId9)
							end

							return Dictionary.join(p155, {
								[userId9] = v698
							})
						end)
					end
				end

				if v406.isVisibleInChatWindow then
					v55(function(p156) -- line: 657
						-- upvalues: List (copy), v406 (copy)
						return List.append(p156, v406.messageId)
					end)

					if channelNameOverride then
						v57(function(p157) -- line: 663
							-- upvalues: channelNameOverride (ref), List (copy), v406 (copy), Dictionary (copy)
							local v701 = p157[channelNameOverride] or {}
							local v702 = List.append(v701, v406.messageId)

							return Dictionary.join(p157, {
								[channelNameOverride] = v702
							})
						end)
					end

					if FFlagExpChatEnableV2ChatWindow then
						local v417 = v78(false)

						if v417 == nil or v417 == channelNameOverride then
							updateNextMessageComponent(v406.messageId)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(v195)

				return
			end

			v195()
		end,
		handleLegacyBubbleTextUpdated = function(s23: string, s24: string) -- line: 1288
			-- upvalues: Dictionary (copy), FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v49 (copy)
			local function v198(p158) -- line: 1289
				-- upvalues: Dictionary (copy), s24 (copy)
				return Dictionary.join(p158, {
					text = s24
				})
			end

			if FFlagExpChatMessagesStoreUseProxy then
				local v199 = v50[s23]

				if v199 then
					local v200 = Dictionary.join(v199, {
						text = s24
					})

					if v200 then
						v50[s23] = v200

						return
					end
				end
			else
				v49(function(p159) -- line: 291
					-- upvalues: s23 (copy), v198 (copy), Dictionary (copy)
					if not p159 or not p159[s23] then
						return p159 or {}
					end

					local v420 = v198(p159[s23])

					if v420 then
						return Dictionary.join(p159, {
							[s23] = v420
						})
					end

					return p159
				end)
			end
		end,
		handleHiddenMessageReceived = function(p160) -- line: 1040
			-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), FIntExpChatRandomCharChangeLowerBound (copy), FIntExpChatRandomCharChangeUpperBound (copy), Config (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v55 (copy), List (copy), resolveChannelNameForMapOrder (copy), v57 (copy), Dictionary (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v53 (copy), v52 (copy), writeByMessageId (copy), v67 (copy), HttpService (copy), v66 (copy), v68 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v69 (copy), v54 (copy), v56 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v65 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v78 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local v168 = string.len(if not getFFlagExpChatProtectedChatInternalAPIs() then p160.Text else p160.TextInternal)
			local v169 = math.max(FIntExpChatRandomCharChangeLowerBound, -(v168 - 1))
			local v170 = FIntExpChatRandomCharChangeUpperBound
			local v171 = math.random(v169, v170)
			local v172 = string.rep(Config.DOT_TEXT, v168 + v171)
			local t20 = {
				userId = nil,
				isVisibleInBubbleChat = false,
				isVisibleInChatWindow = true,
				isHiddenMessage = true,
				prefixText = Config.LOCK_EMOJI .. " :",
				text = v172,
				textChannel = p160.TextChannel,
				messageId = p160.MessageId,
				status = p160.Status,
				timestamp = p160.Timestamp,
				textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else p160
			}

			local function v174() -- line: 397
				-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), t20 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v55 (copy), List (copy), resolveChannelNameForMapOrder (copy), v57 (copy), Dictionary (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v53 (copy), v52 (copy), writeByMessageId (copy), v67 (copy), HttpService (copy), v66 (copy), v68 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v69 (copy), v54 (copy), v56 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v65 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v78 (copy), updateNextMessageComponent (ref)
				local v353 = if not FFlagExpChatMessagesStoreUseProxy then v48(false) else v50

				if v353 and v353[t20.messageId] then
					if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t20.status == Enum.TextChatMessageStatus.Floodchecked or t20.status == Enum.TextChatMessageStatus.MessageTooLong) then
						v55(function(p161) -- line: 408
							-- upvalues: List (copy), t20 (copy)
							return List.filter(p161, function(p162) -- line: 409
								-- upvalues: t20 (copy)
								return p162 ~= t20.messageId
							end)
						end)

						local v354 = resolveChannelNameForMapOrder(t20, t20.channelNameOverride)

						if v354 then
							v57(function(p163) -- line: 416
								-- upvalues: v354 (copy), List (copy), t20 (copy), Dictionary (copy)
								local v605 = p163[v354]

								if not v605 then
									return p163
								end

								local v606 = List.filter(v605, function(p164) -- line: 421
									-- upvalues: t20 (copy)
									return p164 ~= t20.messageId
								end)

								return Dictionary.join(p163, {
									[v354] = v606
								})
							end)
						end

						local messageId = t20.messageId

						if FFlagExpChatMessagesStoreUseProxy then
							v50[messageId] = nil
						else
							v49(function(p165) -- line: 274
								-- upvalues: Dictionary (copy), messageId (copy)
								return Dictionary.removeKey(p165, messageId)
							end)
						end

						if t20.userId then
							local userId = t20.userId

							local function v357(p166) -- line: 433
								-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), t20 (copy)
								if not p166 then
									return nil
								end

								local v609 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p166, function(p167) -- line: 443
									-- upvalues: t20 (copy)
									return p167.messageId ~= t20.messageId
								end) else List.filter(p166, function(p168) -- line: 439
									-- upvalues: t20 (copy)
									return p168 ~= t20.messageId
								end)

								if #v609 == 0 then
									return nil
								end

								return v609
							end

							if FFlagExpChatMessagesStoreUseProxy then
								v53[userId] = v357(v53[userId])

								return
							end

							v52(function(p169) -- line: 358
								-- upvalues: v357 (copy), userId (copy), Dictionary (copy)
								local v611 = v357(p169[userId])

								if v611 == nil then
									return Dictionary.removeKey(p169, userId)
								end

								return Dictionary.join(p169, {
									[userId] = v611
								})
							end)
						end

						return
					end

					writeByMessageId(t20.messageId, t20)

					if not FFlagExpChatMessagesStoreMemoryCleanup and t20.userId then
						local userId = t20.userId

						local function v359(p170) -- line: 462
							-- upvalues: t20 (copy), List (copy)
							if not p170 then
								return nil
							end

							local v613 = nil

							for i, v in ipairs(p170) do
								if v.messageId == t20.messageId then
									v613 = i

									break
								end
							end

							if v613 then
								return List.set(p170, v613, t20)
							end

							return p170
						end

						if FFlagExpChatMessagesStoreUseProxy then
							v53[userId] = v359(v53[userId])

							return
						end

						v52(function(p171) -- line: 358
							-- upvalues: v359 (copy), userId (copy), Dictionary (copy)
							local v617 = v359(p171[userId])

							if v617 == nil then
								return Dictionary.removeKey(p171, userId)
							end

							return Dictionary.join(p171, {
								[userId] = v617
							})
						end)
					end

					return
				end

				local userId = t20.userId
				local partOrModel = t20.partOrModel

				if not userId and partOrModel then
					userId = v67(false)[partOrModel]

					if not userId then
						userId = HttpService:GenerateGUID(false)
						v66(function(p172) -- line: 497
							-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
							return Dictionary.join(p172, {
								[userId] = partOrModel
							})
						end)
						v68(function(p173) -- line: 504
							-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
							return Dictionary.join(p173, {
								[partOrModel] = userId
							})
						end)
					end
				end

				local v362 = if userId == t20.userId then t20 else Dictionary.join(t20, {
					userId = userId
				})
				local channelNameOverride = nil

				if GetFFlagTextChatEnableUniverseChatTabs() and v362.channelNameOverride then
					channelNameOverride = v362.channelNameOverride
				elseif v362.textChannel then
					channelNameOverride = if v362.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v69(false)) then v362.textChannel.Name else "RBXGeneral"
				end

				if v362.isVisibleInChatWindow then
					local v364 = v54(false)
					local v365 = if not channelNameOverride then {} else v56(false)[channelNameOverride] or {}

					if #v364 >= t1.messageLimit then
						local v366 = v364[1]
						local v367 = v353 and v353[v366]

						if v367 then
							if not FFlagExpChatMessagesStoreKeepInByMessageId then
								if FFlagExpChatMessagesStoreUseProxy then
									v50[v366] = nil
								else
									v49(function(p174) -- line: 274
										-- upvalues: Dictionary (copy), v366 (copy)
										return Dictionary.removeKey(p174, v366)
									end)
								end
							end

							if v367.userId then
								local userId10 = v367.userId

								local function v369(p175) -- line: 551
									-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v366 (copy), v65 (copy), v367 (copy), v68 (copy), Dictionary (copy), v66 (copy)
									if not p175 then
										return nil
									end

									local v622 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p175, function(p176) -- line: 561
										-- upvalues: v366 (copy)
										return p176.messageId ~= v366
									end) else List.filter(p175, function(p177) -- line: 557
										-- upvalues: v366 (copy)
										return p177 ~= v366
									end)

									if #v622 == 0 then
										local v623 = v65(false)

										if v623[v367.userId] then
											local v624 = v623[v367.userId]

											v68(function(p178) -- line: 572
												-- upvalues: Dictionary (copy), v624 (copy)
												return Dictionary.removeKey(p178, v624)
											end)
											v66(function(p179) -- line: 576
												-- upvalues: Dictionary (copy), v367 (copy)
												return Dictionary.removeKey(p179, v367.userId)
											end)
										end

										return nil
									end

									return v622
								end

								if FFlagExpChatMessagesStoreUseProxy then
									v53[userId10] = v369(v53[userId10])
								else
									v52(function(p180) -- line: 358
										-- upvalues: v369 (copy), userId10 (copy), Dictionary (copy)
										local v626 = v369(p180[userId10])

										if v626 == nil then
											return Dictionary.removeKey(p180, userId10)
										end

										return Dictionary.join(p180, {
											[userId10] = v626
										})
									end)
								end
							end

							v55(function(p181) -- line: 588
								-- upvalues: List (copy)
								return List.removeIndex(p181, 1)
							end)

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v366] = nil
							end
						end
					end

					if channelNameOverride and #v365 >= t1.messageLimit then
						local v370 = v365[1]

						if v370 then
							v57(function(p182) -- line: 602
								-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
								local v629 = p182[channelNameOverride] or {}
								local v630 = List.removeIndex(v629, 1)

								return Dictionary.join(p182, {
									[channelNameOverride] = v630
								})
							end)

							if v353 and v353[v370] then
								if FFlagExpChatMessagesStoreUseProxy then
									v50[v370] = nil
								else
									v49(function(p183) -- line: 274
										-- upvalues: Dictionary (copy), v370 (copy)
										return Dictionary.removeKey(p183, v370)
									end)
								end
							end

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v370] = nil
							end
						end
					end
				end

				writeByMessageId(v362.messageId, v362)

				if v362.userId then
					local userId11 = v362.userId

					local function v372(p184) -- line: 624
						-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), v362 (copy), List (copy)
						local v633 = p184 or {}
						local v634 = false

						if FFlagExpChatMessagesStoreMemoryCleanup then
							for _, v in ipairs(v633) do
								if v == v362.messageId then
									v634 = true

									break
								end
							end
						else
							for _, v in ipairs(v633) do
								if v.messageId == v362.messageId then
									v634 = true

									break
								end
							end
						end

						if not v634 then
							local v639 = if not FFlagExpChatMessagesStoreMemoryCleanup then v362 else v362.messageId

							return List.append(v633, v639)
						end

						return v633
					end

					if FFlagExpChatMessagesStoreUseProxy then
						v53[userId11] = v372(v53[userId11])
					else
						v52(function(p185) -- line: 358
							-- upvalues: v372 (copy), userId11 (copy), Dictionary (copy)
							local v641 = v372(p185[userId11])

							if v641 == nil then
								return Dictionary.removeKey(p185, userId11)
							end

							return Dictionary.join(p185, {
								[userId11] = v641
							})
						end)
					end
				end

				if v362.isVisibleInChatWindow then
					v55(function(p186) -- line: 657
						-- upvalues: List (copy), v362 (copy)
						return List.append(p186, v362.messageId)
					end)

					if channelNameOverride then
						v57(function(p187) -- line: 663
							-- upvalues: channelNameOverride (ref), List (copy), v362 (copy), Dictionary (copy)
							local v644 = p187[channelNameOverride] or {}
							local v645 = List.append(v644, v362.messageId)

							return Dictionary.join(p187, {
								[channelNameOverride] = v645
							})
						end)
					end

					if FFlagExpChatEnableV2ChatWindow then
						local v373 = v78(false)

						if v373 == nil or v373 == channelNameOverride then
							updateNextMessageComponent(v362.messageId)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(v174)

				return
			end

			v174()
		end,
		handleHiddenMessagesCleared = function() -- line: 1173
			-- upvalues: FFlagExpChatClearHiddenMessagesPostAgeCheck (copy), forEachByMessageId (copy), Dictionary (copy), FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), v55 (copy), List (copy), v57 (copy)
			if not FFlagExpChatClearHiddenMessagesPostAgeCheck then
				return
			end

			forEachByMessageId(function(_, p189) -- line: 1180
				-- upvalues: Dictionary (copy)
				if p189 and p189.isHiddenMessage then
					return Dictionary.join(p189, {
						isVisibleInChatWindow = false
					})
				end

				return nil
			end)

			local function isNotHidden(s25: string) -- line: 1187
				-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy)
				local v389 = ((if not FFlagExpChatMessagesStoreUseProxy then v48(false) else v50))[s25]

				return v389 and not v389.isHiddenMessage
			end

			v55(function(p190) -- line: 1193
				-- upvalues: List (copy), isNotHidden (copy)
				return List.filter(p190, isNotHidden)
			end)
			v57(function(p191) -- line: 1198
				-- upvalues: Dictionary (copy), List (copy), isNotHidden (copy)
				return Dictionary.map(p191, function(p192) -- line: 1199
					-- upvalues: List (copy), isNotHidden (copy)
					return List.filter(p192, isNotHidden)
				end)
			end)
		end,
		addSystemMessage = function(s26: string, s27: string, s28: string?, p193: ((...any) -> ...any)?, b6: boolean?) -- line: 801
			-- upvalues: sanitizeForRichText (copy), GetFFlagExpChatSyntheticSystemMessageRichText (copy), generateRichSystemMessageTextFormat (copy), FFlagExpChatDictation (copy), HttpService (copy), FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v55 (copy), List (copy), resolveChannelNameForMapOrder (copy), v57 (copy), Dictionary (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v53 (copy), v52 (copy), writeByMessageId (copy), v67 (copy), v66 (copy), v68 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v69 (copy), v54 (copy), v56 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v65 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v78 (copy), updateNextMessageComponent (ref), FFlagExpChatMessagesStoreBatch (copy), SignalsExperimental (copy)
			local v137 = sanitizeForRichText(s26)
			local v138 = if not GetFFlagExpChatSyntheticSystemMessageRichText() then v137 else generateRichSystemMessageTextFormat(v137, if not FFlagExpChatDictation then nil else b6, p193)
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
				text = v138,
				messageId = guid,
				timestamp = DateTime.fromUnixTimestampMillis(workspace:GetServerTimeNow() * 1000),
				status = Enum.TextChatMessageStatus.Success,
				channelNameOverride = s27,
				metadata = s28
			}

			local function v141() -- line: 397
				-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy), v50 (copy), v48 (copy), t21 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v55 (copy), List (copy), resolveChannelNameForMapOrder (copy), v57 (copy), Dictionary (copy), v49 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v53 (copy), v52 (copy), writeByMessageId (copy), v67 (copy), HttpService (copy), v66 (copy), v68 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v69 (copy), v54 (copy), v56 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v65 (copy), t4 (copy), FFlagExpChatEnableV2ChatWindow (copy), v78 (copy), updateNextMessageComponent (ref)
				local v290 = if not FFlagExpChatMessagesStoreUseProxy then v48(false) else v50

				if v290 and v290[t21.messageId] then
					if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t21.status == Enum.TextChatMessageStatus.Floodchecked or t21.status == Enum.TextChatMessageStatus.MessageTooLong) then
						v55(function(p194) -- line: 408
							-- upvalues: List (copy), t21 (copy)
							return List.filter(p194, function(p195) -- line: 409
								-- upvalues: t21 (copy)
								return p195 ~= t21.messageId
							end)
						end)

						local v291 = resolveChannelNameForMapOrder(t21, t21.channelNameOverride)

						if v291 then
							v57(function(p196) -- line: 416
								-- upvalues: v291 (copy), List (copy), t21 (copy), Dictionary (copy)
								local v476 = p196[v291]

								if not v476 then
									return p196
								end

								local v477 = List.filter(v476, function(p197) -- line: 421
									-- upvalues: t21 (copy)
									return p197 ~= t21.messageId
								end)

								return Dictionary.join(p196, {
									[v291] = v477
								})
							end)
						end

						local messageId = t21.messageId

						if FFlagExpChatMessagesStoreUseProxy then
							v50[messageId] = nil
						else
							v49(function(p198) -- line: 274
								-- upvalues: Dictionary (copy), messageId (copy)
								return Dictionary.removeKey(p198, messageId)
							end)
						end

						if t21.userId then
							local userId = t21.userId

							local function v294(p199) -- line: 433
								-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), t21 (copy)
								if not p199 then
									return nil
								end

								local v480 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p199, function(p200) -- line: 443
									-- upvalues: t21 (copy)
									return p200.messageId ~= t21.messageId
								end) else List.filter(p199, function(p201) -- line: 439
									-- upvalues: t21 (copy)
									return p201 ~= t21.messageId
								end)

								if #v480 == 0 then
									return nil
								end

								return v480
							end

							if FFlagExpChatMessagesStoreUseProxy then
								v53[userId] = v294(v53[userId])

								return
							end

							v52(function(p202) -- line: 358
								-- upvalues: v294 (copy), userId (copy), Dictionary (copy)
								local v482 = v294(p202[userId])

								if v482 == nil then
									return Dictionary.removeKey(p202, userId)
								end

								return Dictionary.join(p202, {
									[userId] = v482
								})
							end)
						end

						return
					end

					writeByMessageId(t21.messageId, t21)

					if not FFlagExpChatMessagesStoreMemoryCleanup and t21.userId then
						local userId = t21.userId

						local function v296(p203) -- line: 462
							-- upvalues: t21 (copy), List (copy)
							if not p203 then
								return nil
							end

							local v484 = nil

							for i, v in ipairs(p203) do
								if v.messageId == t21.messageId then
									v484 = i

									break
								end
							end

							if v484 then
								return List.set(p203, v484, t21)
							end

							return p203
						end

						if FFlagExpChatMessagesStoreUseProxy then
							v53[userId] = v296(v53[userId])

							return
						end

						v52(function(p204) -- line: 358
							-- upvalues: v296 (copy), userId (copy), Dictionary (copy)
							local v488 = v296(p204[userId])

							if v488 == nil then
								return Dictionary.removeKey(p204, userId)
							end

							return Dictionary.join(p204, {
								[userId] = v488
							})
						end)
					end

					return
				end

				local userId = t21.userId
				local partOrModel = t21.partOrModel

				if not userId and partOrModel then
					userId = v67(false)[partOrModel]

					if not userId then
						userId = HttpService:GenerateGUID(false)
						v66(function(p205) -- line: 497
							-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
							return Dictionary.join(p205, {
								[userId] = partOrModel
							})
						end)
						v68(function(p206) -- line: 504
							-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
							return Dictionary.join(p206, {
								[partOrModel] = userId
							})
						end)
					end
				end

				local v299 = if userId == t21.userId then t21 else Dictionary.join(t21, {
					userId = userId
				})
				local channelNameOverride = nil

				if GetFFlagTextChatEnableUniverseChatTabs() and v299.channelNameOverride then
					channelNameOverride = v299.channelNameOverride
				elseif v299.textChannel then
					channelNameOverride = if v299.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v69(false)) then v299.textChannel.Name else "RBXGeneral"
				end

				if v299.isVisibleInChatWindow then
					local v301 = v54(false)
					local v302 = if not channelNameOverride then {} else v56(false)[channelNameOverride] or {}

					if #v301 >= t1.messageLimit then
						local v303 = v301[1]
						local v304 = v290 and v290[v303]

						if v304 then
							if not FFlagExpChatMessagesStoreKeepInByMessageId then
								if FFlagExpChatMessagesStoreUseProxy then
									v50[v303] = nil
								else
									v49(function(p207) -- line: 274
										-- upvalues: Dictionary (copy), v303 (copy)
										return Dictionary.removeKey(p207, v303)
									end)
								end
							end

							if v304.userId then
								local userId12 = v304.userId

								local function v306(p208) -- line: 551
									-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v303 (copy), v65 (copy), v304 (copy), v68 (copy), Dictionary (copy), v66 (copy)
									if not p208 then
										return nil
									end

									local v493 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(p208, function(p209) -- line: 561
										-- upvalues: v303 (copy)
										return p209.messageId ~= v303
									end) else List.filter(p208, function(p210) -- line: 557
										-- upvalues: v303 (copy)
										return p210 ~= v303
									end)

									if #v493 == 0 then
										local v494 = v65(false)

										if v494[v304.userId] then
											local v495 = v494[v304.userId]

											v68(function(p211) -- line: 572
												-- upvalues: Dictionary (copy), v495 (copy)
												return Dictionary.removeKey(p211, v495)
											end)
											v66(function(p212) -- line: 576
												-- upvalues: Dictionary (copy), v304 (copy)
												return Dictionary.removeKey(p212, v304.userId)
											end)
										end

										return nil
									end

									return v493
								end

								if FFlagExpChatMessagesStoreUseProxy then
									v53[userId12] = v306(v53[userId12])
								else
									v52(function(p213) -- line: 358
										-- upvalues: v306 (copy), userId12 (copy), Dictionary (copy)
										local v497 = v306(p213[userId12])

										if v497 == nil then
											return Dictionary.removeKey(p213, userId12)
										end

										return Dictionary.join(p213, {
											[userId12] = v497
										})
									end)
								end
							end

							v55(function(p214) -- line: 588
								-- upvalues: List (copy)
								return List.removeIndex(p214, 1)
							end)

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v303] = nil
							end
						end
					end

					if channelNameOverride and #v302 >= t1.messageLimit then
						local v307 = v302[1]

						if v307 then
							v57(function(p215) -- line: 602
								-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
								local v500 = p215[channelNameOverride] or {}
								local v501 = List.removeIndex(v500, 1)

								return Dictionary.join(p215, {
									[channelNameOverride] = v501
								})
							end)

							if v290 and v290[v307] then
								if FFlagExpChatMessagesStoreUseProxy then
									v50[v307] = nil
								else
									v49(function(p216) -- line: 274
										-- upvalues: Dictionary (copy), v307 (copy)
										return Dictionary.removeKey(p216, v307)
									end)
								end
							end

							if FFlagExpChatMessagesStoreMemoryCleanup then
								t4[v307] = nil
							end
						end
					end
				end

				writeByMessageId(v299.messageId, v299)

				if v299.userId then
					local userId13 = v299.userId

					local function v309(p217) -- line: 624
						-- upvalues: FFlagExpChatMessagesStoreMemoryCleanup (copy), v299 (copy), List (copy)
						local v504 = p217 or {}
						local v505 = false

						if FFlagExpChatMessagesStoreMemoryCleanup then
							for _, v in ipairs(v504) do
								if v == v299.messageId then
									v505 = true

									break
								end
							end
						else
							for _, v in ipairs(v504) do
								if v.messageId == v299.messageId then
									v505 = true

									break
								end
							end
						end

						if not v505 then
							local v510 = if not FFlagExpChatMessagesStoreMemoryCleanup then v299 else v299.messageId

							return List.append(v504, v510)
						end

						return v504
					end

					if FFlagExpChatMessagesStoreUseProxy then
						v53[userId13] = v309(v53[userId13])
					else
						v52(function(p218) -- line: 358
							-- upvalues: v309 (copy), userId13 (copy), Dictionary (copy)
							local v512 = v309(p218[userId13])

							if v512 == nil then
								return Dictionary.removeKey(p218, userId13)
							end

							return Dictionary.join(p218, {
								[userId13] = v512
							})
						end)
					end
				end

				if v299.isVisibleInChatWindow then
					v55(function(p219) -- line: 657
						-- upvalues: List (copy), v299 (copy)
						return List.append(p219, v299.messageId)
					end)

					if channelNameOverride then
						v57(function(p220) -- line: 663
							-- upvalues: channelNameOverride (ref), List (copy), v299 (copy), Dictionary (copy)
							local v515 = p220[channelNameOverride] or {}
							local v516 = List.append(v515, v299.messageId)

							return Dictionary.join(p220, {
								[channelNameOverride] = v516
							})
						end)
					end

					if FFlagExpChatEnableV2ChatWindow then
						local v310 = v78(false)

						if v310 == nil or v310 == channelNameOverride then
							updateNextMessageComponent(v299.messageId)
						end
					end
				end
			end

			if FFlagExpChatMessagesStoreBatch then
				SignalsExperimental.batch(v141)

				return
			end

			v141()
		end,
		getChannelTabsConfigurationEnabled = v69,
		setChannelTabsConfigurationEnabled = v70
	}
end

return createMessagesStore
