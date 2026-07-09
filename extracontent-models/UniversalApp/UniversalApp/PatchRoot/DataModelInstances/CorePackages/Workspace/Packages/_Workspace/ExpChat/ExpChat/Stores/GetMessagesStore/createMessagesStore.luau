local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Signals = require(ExpChatParent.Signals)
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
local FFlagExpChatSupportHiddenMessagesInWindowV2 = require(ExpChat.Flags.FFlagExpChatSupportHiddenMessagesInWindowV2)
local FFlagChatLineReportingGlobalMuteEnabled = SharedFlags.FFlagChatLineReportingGlobalMuteEnabled
local FFlagExpChatEnablePostProcessRichSystemMessageTextFormat = require(ExpChat.Flags.FFlagExpChatEnablePostProcessRichSystemMessageTextFormat)
local FFlagExpChatMessagesStoreKeepInByMessageId = require(ExpChat.Flags.FFlagExpChatMessagesStoreKeepInByMessageId)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation
local FFlagExpChatMessagesStoreMemoryCleanup = require(ExpChat.Flags.FFlagExpChatMessagesStoreMemoryCleanup)
local FFlagExpChatEvictFloodcheckedFromWindowOrder = require(ExpChat.Flags.FFlagExpChatEvictFloodcheckedFromWindowOrder)

function getChatTranslationEnabled() -- line: 54
	-- upvalues: TextChatService (copy)
	return TextChatService.ChatTranslationEnabled
end

local function createMessagesStore() -- line: 174
	-- upvalues: createSignal (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), List (copy), Dictionary (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), HttpService (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), createComputed (copy), Set (copy), sanitizeForRichText (copy), GetFFlagExpChatSyntheticSystemMessageRichText (copy), generateRichSystemMessageTextFormat (copy), FFlagExpChatDictation (copy), FFlagExpChatEnablePostProcessRichSystemMessageTextFormat (copy), FFlagExpChatEnableV2ChatWindow (copy), computeNameColor (copy), Players (copy), FFlagEnableInExpChatRewrite (copy), getTextAndTranslation (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), isWhiteSpaceOnly (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), ExpChatShared (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatDisableUniverseBubbleChat (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), FIntExpChatRandomCharChangeLowerBound (copy), FIntExpChatRandomCharChangeUpperBound (copy), Config (copy), FFlagExpChatSupportHiddenMessagesInWindowV2 (copy), FFlagExpChatClearHiddenMessagesPostAgeCheck (copy)
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
	local v44, v45 = createSignal(t1.byMessageId)
	local v46, v47 = createSignal(t1.messagesBySenderId)
	local v48, v49 = createSignal(t1.windowMessagesInOrder)
	local v50, v51 = createSignal(t1.windowMessagesInOrderByTabId)
	local v52, v53 = createSignal(t1.mutedUserIds)
	local v54, v55 = createSignal(t1.canLocalUserChat)
	local v56, _ = createSignal(t1.isBubbleChatEnabled)
	local v58, v59 = createSignal(t1.mockUserIdToPartOrModel)
	local v60, v61 = createSignal(t1.partOrModelToMockUserId)
	local v62, v63 = createSignal(false)
	local v64, v65 = createSignal(t1.messageComponentRingBuffer)
	local v66, v67 = createSignal(t1.nextMessageComponentPointer)
	local t2 = {}
	local n1 = 0
	local t3 = {}
	local v71, v72 = createSignal(nil)
	local updateNextMessageComponent = nil
	local t4 = {}

	local function resolveChannelNameForMapOrder(t5: {[any]: any}, s1: string?) -- line: 228
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), v62 (copy)
		if GetFFlagTextChatEnableUniverseChatTabs() then
			if s1 then
				return s1
			end

			if t5.textChannel then
				if t5.textChannel.Name == "RBXSystem" or not v62(false) then
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
	local function addMessage(t6: {[any]: any}) -- line: 248
		-- upvalues: v44 (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), v49 (copy), List (copy), resolveChannelNameForMapOrder (copy), v51 (copy), Dictionary (copy), v45 (copy), v47 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), v60 (copy), HttpService (copy), v59 (copy), v61 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v62 (copy), v48 (copy), v50 (copy), t1 (copy), FFlagExpChatMessagesStoreKeepInByMessageId (copy), v58 (copy), t4 (copy)
		local v86 = v44(false)

		if v86 and v86[t6.messageId] then
			if FFlagExpChatEvictFloodcheckedFromWindowOrder and (t6.status == Enum.TextChatMessageStatus.Floodchecked or t6.status == Enum.TextChatMessageStatus.MessageTooLong) then
				v49(function(p1) -- line: 259
					-- upvalues: List (copy), t6 (copy)
					return List.filter(p1, function(p2) -- line: 260
						-- upvalues: t6 (copy)
						return p2 ~= t6.messageId
					end)
				end)

				local v87 = resolveChannelNameForMapOrder(t6, t6.channelNameOverride)

				if v87 then
					v51(function(p3) -- line: 267
						-- upvalues: v87 (copy), List (copy), t6 (copy), Dictionary (copy)
						local v202 = p3[v87]

						if not v202 then
							return p3
						end

						local v203 = List.filter(v202, function(p4) -- line: 272
							-- upvalues: t6 (copy)
							return p4 ~= t6.messageId
						end)

						return Dictionary.join(p3, {
							[v87] = v203
						})
					end)
				end

				v45(function(p5) -- line: 281
					-- upvalues: Dictionary (copy), t6 (copy)
					return Dictionary.removeKey(p5, t6.messageId)
				end)

				if t6.userId then
					v47(function(p6) -- line: 286
						-- upvalues: t6 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
						local v206 = p6[t6.userId]

						if not v206 then
							return p6
						end

						local v207 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v206, function(p7) -- line: 297
							-- upvalues: t6 (copy)
							return p7.messageId ~= t6.messageId
						end) else List.filter(v206, function(p8) -- line: 293
							-- upvalues: t6 (copy)
							return p8 ~= t6.messageId
						end)

						if #v207 == 0 then
							return Dictionary.removeKey(p6, t6.userId)
						end

						return Dictionary.join(p6, {
							[t6.userId] = v207
						})
					end)
				end

				return
			end

			v45(function(p9) -- line: 314
				-- upvalues: Dictionary (copy), t6 (copy)
				return Dictionary.join(p9, {
					[t6.messageId] = t6
				})
			end)

			if not FFlagExpChatMessagesStoreMemoryCleanup and t6.userId then
				v47(function(p10) -- line: 320
					-- upvalues: t6 (copy), List (copy), Dictionary (copy)
					local v210 = p10[t6.userId] or {}
					local v211 = nil

					for i, v in ipairs(v210) do
						if v.messageId == t6.messageId then
							v211 = i

							break
						end
					end

					if v211 then
						local v214 = List.set(v210, v211, t6)

						return Dictionary.join(p10, {
							[t6.userId] = v214
						})
					end

					return p10
				end)
			end

			return
		end

		local userId = t6.userId
		local partOrModel = t6.partOrModel

		if not userId and partOrModel then
			userId = v60(false)[partOrModel]

			if not userId then
				userId = HttpService:GenerateGUID(false)
				v59(function(p11) -- line: 356
					-- upvalues: Dictionary (copy), userId (ref), partOrModel (copy)
					return Dictionary.join(p11, {
						[userId] = partOrModel
					})
				end)
				v61(function(p12) -- line: 363
					-- upvalues: Dictionary (copy), partOrModel (copy), userId (ref)
					return Dictionary.join(p12, {
						[partOrModel] = userId
					})
				end)
			end
		end

		local v90 = if userId == t6.userId then t6 else Dictionary.join(t6, {
			userId = userId
		})
		local channelNameOverride = nil

		if GetFFlagTextChatEnableUniverseChatTabs() and v90.channelNameOverride then
			channelNameOverride = v90.channelNameOverride
		elseif v90.textChannel then
			channelNameOverride = if v90.textChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v62(false)) then v90.textChannel.Name else "RBXGeneral"
		end

		if v90.isVisibleInChatWindow then
			local v92 = v48(false)
			local v93 = if not channelNameOverride then {} else v50(false)[channelNameOverride] or {}

			if #v92 >= t1.messageLimit then
				local v94 = v92[1]
				local v95 = v86 and v86[v94]

				if v95 then
					if not FFlagExpChatMessagesStoreKeepInByMessageId then
						v45(function(p13) -- line: 405
							-- upvalues: Dictionary (copy), v94 (copy)
							return Dictionary.removeKey(p13, v94)
						end)
					end

					if v95.userId then
						v47(function(p14) -- line: 412
							-- upvalues: v95 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), v94 (copy), v58 (copy), v61 (copy), Dictionary (copy), v59 (copy)
							local v219 = p14[v95.userId]

							if v219 then
								local v220 = if not FFlagExpChatMessagesStoreMemoryCleanup then List.filter(v219, function(p15) -- line: 421
									-- upvalues: v94 (copy)
									return p15.messageId ~= v94
								end) else List.filter(v219, function(p16) -- line: 417
									-- upvalues: v94 (copy)
									return p16 ~= v94
								end)

								if #v220 == 0 then
									local v221 = v58(false)

									if v221[v95.userId] then
										local v222 = v221[v95.userId]

										v61(function(p17) -- line: 432
											-- upvalues: Dictionary (copy), v222 (copy)
											return Dictionary.removeKey(p17, v222)
										end)
										v59(function(p18) -- line: 436
											-- upvalues: Dictionary (copy), v95 (copy)
											return Dictionary.removeKey(p18, v95.userId)
										end)
									end

									return Dictionary.removeKey(p14, v95.userId)
								end

								return Dictionary.join(p14, {
									[v95.userId] = v220
								})
							end

							return p14
						end)
					end

					v49(function(p19) -- line: 453
						-- upvalues: List (copy)
						return List.removeIndex(p19, 1)
					end)

					if FFlagExpChatMessagesStoreMemoryCleanup then
						t4[v94] = nil
					end
				end
			end

			if channelNameOverride and #v93 >= t1.messageLimit then
				local v96 = v93[1]

				if v96 then
					v51(function(p20) -- line: 467
						-- upvalues: channelNameOverride (ref), List (copy), Dictionary (copy)
						local v225 = p20[channelNameOverride] or {}
						local v226 = List.removeIndex(v225, 1)

						return Dictionary.join(p20, {
							[channelNameOverride] = v226
						})
					end)

					if v86 and v86[v96] then
						v45(function(p21) -- line: 476
							-- upvalues: Dictionary (copy), v96 (copy)
							return Dictionary.removeKey(p21, v96)
						end)
					end

					if FFlagExpChatMessagesStoreMemoryCleanup then
						t4[v96] = nil
					end
				end
			end
		end

		v45(function(p22) -- line: 488
			-- upvalues: Dictionary (copy), v90 (copy)
			return Dictionary.join(p22, {
				[v90.messageId] = v90
			})
		end)

		if v90.userId then
			v47(function(p23) -- line: 493
				-- upvalues: v90 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), List (copy), Dictionary (copy)
				local v230 = p23[v90.userId] or {}
				local v231 = false

				if FFlagExpChatMessagesStoreMemoryCleanup then
					for _, v in ipairs(v230) do
						if v == v90.messageId then
							v231 = true

							break
						end
					end
				else
					for _, v in ipairs(v230) do
						if v.messageId == v90.messageId then
							v231 = true

							break
						end
					end
				end

				if not v231 then
					local v236 = if not FFlagExpChatMessagesStoreMemoryCleanup then v90 else v90.messageId
					local v237 = List.append(v230, v236)

					return Dictionary.join(p23, {
						[v90.userId] = v237
					})
				end

				return p23
			end)
		end

		if v90.isVisibleInChatWindow then
			v49(function(p24) -- line: 530
				-- upvalues: List (copy), v90 (copy)
				return List.append(p24, v90.messageId)
			end)

			if channelNameOverride then
				v51(function(p25) -- line: 536
					-- upvalues: channelNameOverride (ref), List (copy), v90 (copy), Dictionary (copy)
					local v240 = p25[channelNameOverride] or {}
					local v241 = List.append(v240, v90.messageId)

					return Dictionary.join(p25, {
						[channelNameOverride] = v241
					})
				end)
			end
		end
	end

	local t7 = {}

	local function getUserMessageCache(s2: string) -- line: 569
		-- upvalues: t7 (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), createComputed (copy), v46 (copy), v44 (copy), v52 (copy), Set (copy)
		local str = tostring(s2)

		if not t7[str] then
			t7[str] = {}

			if not FFlagExpChatMessagesStoreMemoryCleanup then
				t7[str].messages = createComputed(function(p26) -- line: 575
					-- upvalues: v46 (copy), str (copy)
					return v46(p26)[str] or {}
				end)
			end

			if FFlagExpChatMessagesStoreMemoryCleanup then
				t7[str].bubbleMessages = createComputed(function(p27) -- line: 583
					-- upvalues: v46 (copy), str (copy), v44 (copy), v52 (copy), Set (copy)
					local v246 = v46(p27)[str] or {}
					local v247 = v44(p27)
					local v248 = v52(p27)
					local t8 = {}

					for _, v in ipairs(v246) do
						local v252 = v247[v]

						if v252 then
							local v253 = not not v252.userId and (Set.has(v248, v252.userId) or false)

							if v252.isVisibleInBubbleChat and not v253 then
								table.insert(t8, v252)
							end
						end
					end

					return t8
				end)
			else
				t7[str].bubbleMessages = createComputed(function(p28) -- line: 601
					-- upvalues: t7 (copy), str (copy), v52 (copy), Set (copy)
					local v255 = t7[str].messages(p28)
					local v256 = v52(p28)
					local t9 = {}

					for _, v in ipairs(v255) do
						local v260 = not not v.userId and (Set.has(v256, v.userId) or false)

						if v.isVisibleInBubbleChat and not v260 then
							table.insert(t9, v)
						end
					end

					return t9
				end)
			end

			if not FFlagExpChatMessagesStoreMemoryCleanup then
				t7[str].lastMessage = createComputed(function(p29) -- line: 616
					-- upvalues: t7 (copy), str (copy)
					local v262 = t7[str].messages(p29)

					if #v262 > 0 then
						return v262[#v262]
					end

					return nil
				end)
			end
		end

		return t7[str]
	end
	local function getUserMessages(s3: string) -- line: 628
		-- upvalues: getUserMessageCache (copy)
		return getUserMessageCache(s3).messages
	end
	local function getUserLastMessage(s4: string) -- line: 638
		-- upvalues: getUserMessageCache (copy)
		return getUserMessageCache(s4).lastMessage
	end
	local function createMessagesArraySignal() -- line: 643
		-- upvalues: createComputed (copy), v44 (copy)
		return createComputed(function(p30) -- line: 644
			-- upvalues: v44 (copy)
			local v264 = v44(p30)
			local t10 = {}

			for _, v in pairs(v264 or {}) do
				table.insert(t10, v)
			end

			return t10
		end)
	end
	local function formatPrefixForUniverseChatTabs(s5: string, s6: string?, p31) -- line: 700
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), computeNameColor (copy), Players (copy)
		if not GetFFlagTextChatEnableUniverseChatTabs() or (not s6 or #s5 == 0) then
			return s5
		end

		return `<font color="#{ ((if not p31.TextSource then computeNameColor(not Players.LocalPlayer and "" or Players.LocalPlayer.Name) else computeNameColor(p31.TextSource.Username))):ToHex() }">{ s5 }</font>`
	end

	function updateNextMessageComponent(s7: string) -- line: 1340
		-- upvalues: v64 (copy), v66 (copy), v67 (copy), t2 (copy), FFlagEnableInExpChatRewrite (copy), n1 (ref), t3 (copy)
		local v181 = v64(false)

		if #v181 == 0 then
			return
		end

		local v182 = v66(false)
		local v183 = v181[v182]

		if not v183 then
			v67(1)

			return
		end

		local v184 = t2[v183]

		if v184 then
			v184.setter(s7)
		end

		local v185 = not FFlagEnableInExpChatRewrite and 1 or 10

		n1 += v185

		local v186 = t3[v183]

		if v186 then
			v186.setter(n1)
		end

		local v187 = v182 % #v181 + 1

		v67(v187)
	end

	return {
		getByMessageId = v44,
		getMessages = if not FFlagExpChatMessagesStoreMemoryCleanup then createComputed(function(p32) -- line: 644
			-- upvalues: v44 (copy)
			local v196 = v44(p32)
			local t11 = {}

			for _, v in pairs(v196 or {}) do
				table.insert(t11, v)
			end

			return t11
		end) else nil,
		getMessagesBySenderId = v46,
		getWindowMessagesInOrder = v48,
		getWindowMessagesInOrderByTabId = v50,
		getMutedUserIds = v52,
		getCanLocalUserChat = v54,
		getIsBubbleChatEnabled = v56,
		getMockUserIdToPartOrModel = v58,
		getPartOrModelToMockUserId = v60,
		getMessage = function(s8: string) -- line: 556
			-- upvalues: t4 (copy), createComputed (copy), v44 (copy)
			if not t4[s8] then
				t4[s8] = createComputed(function(p33) -- line: 558
					-- upvalues: v44 (copy), s8 (copy)
					local v243 = v44(p33)

					if not v243 or not v243[s8] then
						return nil
					end

					return v243[s8]
				end)
			end

			return t4[s8]
		end,
		getUserMessages = if not FFlagExpChatMessagesStoreMemoryCleanup then getUserMessages else nil,
		getUserBubbleMessages = function(s9: string) -- line: 633
			-- upvalues: getUserMessageCache (copy)
			return getUserMessageCache(s9).bubbleMessages
		end,
		getUserLastMessage = if not FFlagExpChatMessagesStoreMemoryCleanup then getUserLastMessage else nil,
		registerMessageComponent = function(s10: string) -- line: 1257
			-- upvalues: t2 (copy), createSignal (copy), t3 (copy), v65 (copy), List (copy)
			if not t2[s10] then
				local v165, v166 = createSignal(nil)

				t2[s10] = {
					getter = v165,
					setter = v166
				}

				local v167, v168 = createSignal(0)

				t3[s10] = {
					getter = v167,
					setter = v168
				}
				v65(function(p34) -- line: 1272
					-- upvalues: List (copy), s10 (copy)
					return List.append(p34, s10)
				end)
			end

			return t2[s10].getter
		end,
		unregisterMessageComponent = function(s11: string) -- line: 1281
			-- upvalues: v64 (copy), t2 (copy), t3 (copy), v65 (copy), List (copy), v66 (copy), v67 (copy)
			local v170 = v64(false)
			local v171 = nil

			for i, v in ipairs(v170) do
				if v == s11 then
					v171 = i

					break
				end
			end

			if t2[s11] then
				t2[s11] = nil
			end

			if t3[s11] then
				t3[s11] = nil
			end

			if v171 then
				v65(function(p35) -- line: 1304
					-- upvalues: List (copy), s11 (copy)
					return List.filter(p35, function(p36) -- line: 1305
						-- upvalues: s11 (copy)
						return p36 ~= s11
					end)
				end)

				local v174 = v64(false)
				local v175 = v66(false)

				if #v174 == 0 then
					v67(1)

					return
				end

				if v171 < v175 then
					v67(v175 - 1)

					return
				end

				if v175 > #v174 then
					v67(1)
				end
			end
		end,
		repopulateMessageComponents = function() -- line: 1377
			-- upvalues: v71 (copy), v50 (copy), v48 (copy), v67 (copy), n1 (ref), updateNextMessageComponent (ref), v64 (copy), v66 (copy), t2 (copy)
			local v188 = v71(false)
			local v189 = if not v188 then v48(false) else v50(false)[v188] or {}

			v67(1)
			n1 = 0

			for _, v in ipairs(v189) do
				updateNextMessageComponent(v)
			end

			local v192 = v64(false)

			if #v189 < #v192 then
				for i = v66(false), #v192 do
					local v194 = t2[v192[i]]

					if v194 then
						v194.setter(nil)
					end
				end
			end
		end,
		getMessageComponentSignal = function(s12: string) -- line: 1328
			-- upvalues: t2 (copy)
			local v177 = t2[s12]

			if v177 then
				return v177.getter
			end

			return nil
		end,
		getLayoutOrderSignal = function(s13: string) -- line: 1334
			-- upvalues: t3 (copy)
			local v179 = t3[s13]

			if v179 then
				return v179.getter
			end

			return nil
		end,
		updateNextMessageComponent = updateNextMessageComponent,
		getMessageComponentRingBuffer = v64,
		getNextMessageComponentPointer = v66,
		setActiveChannelFilter = v72,
		getActiveChannelFilter = v71,
		setCanLocalUserChat = v55,
		muteUser = function(s14: string) -- line: 1000
			-- upvalues: v53 (copy), Set (copy)
			v53(function(p37) -- line: 1001
				-- upvalues: Set (copy), s14 (copy)
				if not p37 then
					return {}
				end

				return (Set.add(p37, s14))
			end)
		end,
		unmuteUser = function(s15: string) -- line: 1010
			-- upvalues: v53 (copy), Set (copy)
			v53(function(p38) -- line: 1011
				-- upvalues: Set (copy), s15 (copy)
				if not p38 then
					return {}
				end

				return (Set.subtract(p38, s15))
			end)
		end,
		handlePlayerRemoved = function(s16: string) -- line: 960
			-- upvalues: v47 (copy), Dictionary (copy), FFlagExpChatMessagesStoreMemoryCleanup (copy), t7 (copy), v53 (copy), Set (copy), v46 (copy), v58 (copy), v61 (copy), v59 (copy)
			local str = tostring(s16)

			v47(function(p39) -- line: 964
				-- upvalues: Dictionary (copy), str (copy)
				return Dictionary.removeKey(p39, str)
			end)

			if FFlagExpChatMessagesStoreMemoryCleanup then
				t7[str] = nil
			end

			v53(function(p40) -- line: 972
				-- upvalues: Set (copy), str (copy), v46 (copy), v58 (copy), v61 (copy), Dictionary (copy), v59 (copy)
				if not p40 then
					return {}
				end

				local v270 = Set.has(p40, str)

				if #(v46(false)[str] or {}) == 0 and not v270 then
					return p40
				end

				local v271 = v58(false)

				if v271[str] then
					local v272 = v271[str]

					v61(function(p41) -- line: 987
						-- upvalues: Dictionary (copy), v272 (copy)
						return Dictionary.removeKey(p41, v272)
					end)
					v59(function(p42) -- line: 991
						-- upvalues: Dictionary (copy), str (copy)
						return Dictionary.removeKey(p42, str)
					end)
				end

				return Set.subtract(p40, str)
			end)
		end,
		clearWindowMessages = function() -- line: 1020
			-- upvalues: v45 (copy), Dictionary (copy), v49 (copy), v51 (copy), FFlagExpChatEnableV2ChatWindow (copy), v67 (copy), n1 (ref), v64 (copy), t2 (copy)
			v45(function(p43) -- line: 1021
				-- upvalues: Dictionary (copy)
				if not p43 then
					return {}
				end

				return (Dictionary.map(p43, function(p44) -- line: 1026
					-- upvalues: Dictionary (copy)
					return Dictionary.join(p44, {
						isVisibleInChatWindow = false
					})
				end))
			end)
			v49(function(_) -- line: 1036
				return {}
			end)
			v51(function(_) -- line: 1041
				return {}
			end)

			if FFlagExpChatEnableV2ChatWindow then
				v67(1)
				n1 = 0

				local v151 = v64(false)

				for _, v in ipairs(v151) do
					local v154 = t2[v]

					if v154 then
						v154.setter(nil)
					end
				end
			end
		end,
		toggleGlobalTranslation = function(b1: boolean) -- line: 1099
			-- upvalues: v45 (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
			v45(function(p47) -- line: 1100
				-- upvalues: b1 (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
				if not p47 then
					return {}
				end

				local t12 = {}

				for k, _ in pairs(p47) do
					local v285 = p47[k]

					if v285 ~= nil then
						t12[k] = {
							prefixText = v285.prefixText,
							text = v285.text,
							translation = v285.translation,
							useTranslation = b1,
							messageId = v285.messageId,
							status = v285.status,
							timestamp = v285.timestamp,
							isVisibleInBubbleChat = v285.isVisibleInBubbleChat,
							isVisibleInChatWindow = v285.isVisibleInChatWindow,
							partOrModel = v285.partOrModel,
							shouldOverrideBubbleChatSettings = v285.shouldOverrideBubbleChatSettings,
							bubbleChatMessageProperties = v285.bubbleChatMessageProperties,
							chatWindowMessageProperties = v285.chatWindowMessageProperties,
							textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else v285.textChatMessageInstance,
							userId = v285.userId,
							textChannel = v285.textChannel,
							wasRewritten = if not FFlagEnableInExpChatRewrite then nil else v285.wasRewritten,
							originalText = if not FFlagEnableInExpChatRewrite then nil else v285.originalText,
							chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else v285.chatActionType,
							presetId = if not FFlagExpChatPresetChatEnabled then nil else v285.presetId,
							presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else v285.presetChatVersion
						}
					end
				end

				return t12
			end)
		end,
		toggleMessageTranslation = function(b2: boolean, s17: string) -- line: 1148
			-- upvalues: v45 (copy), Dictionary (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
			v45(function(p48) -- line: 1149
				-- upvalues: s17 (copy), Dictionary (copy), b2 (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
				if not p48 then
					return {}
				end

				local v287 = p48[s17]

				if v287 ~= nil then
					return Dictionary.join(p48, {
						[s17] = {
							prefixText = v287.prefixText,
							text = v287.text,
							translation = v287.translation,
							useTranslation = b2,
							messageId = v287.messageId,
							status = v287.status,
							timestamp = v287.timestamp,
							isVisibleInBubbleChat = v287.isVisibleInBubbleChat,
							isVisibleInChatWindow = v287.isVisibleInChatWindow,
							partOrModel = v287.partOrModel,
							shouldOverrideBubbleChatSettings = v287.shouldOverrideBubbleChatSettings,
							bubbleChatMessageProperties = v287.bubbleChatMessageProperties,
							chatWindowMessageProperties = v287.chatWindowMessageProperties,
							textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else v287.textChatMessageInstance,
							userId = v287.userId,
							textChannel = v287.textChannel,
							wasRewritten = if not FFlagEnableInExpChatRewrite then nil else v287.wasRewritten,
							originalText = if not FFlagEnableInExpChatRewrite then nil else v287.originalText,
							chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else v287.chatActionType,
							presetId = if not FFlagExpChatPresetChatEnabled then nil else v287.presetId,
							presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else v287.presetChatVersion
						}
					})
				end

				return p48
			end)
		end,
		handleIncomingOrOutgoingMessage = function(p49, _: boolean, s18: string?, b4: boolean?) -- line: 723
			-- upvalues: FFlagEnableInExpChatRewrite (copy), getTextAndTranslation (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), isWhiteSpaceOnly (copy), v44 (copy), v54 (copy), FFlagExpChatPresetChatEnabled (copy), v52 (copy), Set (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), ExpChatShared (copy), v56 (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatDisableUniverseBubbleChat (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v62 (copy), formatPrefixForUniverseChatTabs (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), addMessage (copy), FFlagExpChatEnableV2ChatWindow (copy), v71 (copy), updateNextMessageComponent (ref)
			local v120, v121

			if FFlagEnableInExpChatRewrite then
				v120, v121 = getTextAndTranslation(p49)
			else
				v120 = if not getFFlagExpChatProtectedChatInternalAPIs() then p49.Text else p49.TextInternal
				v121 = if not getFFlagExpChatProtectedChatInternalAPIs() then p49.Translation else p49.TranslationInternal
			end

			if isWhiteSpaceOnly(v120) and p49.Status ~= Enum.TextChatMessageStatus.Floodchecked and p49.Status ~= Enum.TextChatMessageStatus.MessageTooLong then
				return
			end

			local v122 = if not p49.TextSource then nil else tostring(p49.TextSource.UserId)

			if not v44(false) then
				return
			end

			local v123 = v54(false)
			local v124 = v122 == nil or (v123 or not not FFlagExpChatPresetChatEnabled and (p49.PresetId or "") ~= "") and (p49.Status == Enum.TextChatMessageStatus.Success or p49.Status == Enum.TextChatMessageStatus.Sending)
			local v125 = not not v122 and (not not v52(false) and Set.has(v52(false), v122))
			local v126 = v124 and not v125
			local v127 = false
			local v128

			if FFlagExpChatUseChatConfigStore then
				v128 = GetChatConfigurationStore(false).getIsBubbleChatEnabled(false)
			else
				local v129 = ExpChatShared.context and ExpChatShared.context.store

				v128 = if not v129 then v56(false) else v129:getState().Messages.isBubbleChatEnabled
			end

			if v128 and v126 and (not FFlagEnableInExpChatSummaryOnLua or v122 ~= nil) and (p49.Status == Enum.TextChatMessageStatus.Success or p49.Status == Enum.TextChatMessageStatus.Sending) then
				v127 = true
			end

			if FFlagExpChatDisableUniverseBubbleChat and GetFFlagTextChatEnableUniverseChatTabs() and b4 == true then
				v127 = false
			end

			if p49.Status ~= Enum.TextChatMessageStatus.Success and p49.Status ~= Enum.TextChatMessageStatus.Sending then
				v126 = false
				v127 = false
			end

			local v130 = nil

			if GetFFlagTextChatEnableUniverseChatTabs() and s18 then
				v130 = s18
			elseif p49.TextChannel then
				v130 = if p49.TextChannel.Name ~= "RBXSystem" and (not GetFFlagTextChatEnableUniverseChatTabs() or v62(false)) then p49.TextChannel.Name else "RBXGeneral"
			end

			local v131 = formatPrefixForUniverseChatTabs(if not getFFlagExpChatProtectedChatInternalAPIs() then p49.PrefixText else p49.PrefixTextInternal, s18, p49)
			local t13 = {
				shouldOverrideBubbleChatSettings = false,
				userId = v122,
				prefixText = v131,
				text = v120,
				translation = v121,
				useTranslation = getChatTranslationEnabled() and v121 ~= nil,
				messageId = p49.MessageId,
				status = p49.Status,
				timestamp = p49.Timestamp,
				isVisibleInBubbleChat = v127,
				isVisibleInChatWindow = v126,
				textChannel = p49.TextChannel,
				bubbleChatMessageProperties = p49.BubbleChatMessageProperties,
				chatWindowMessageProperties = p49.ChatWindowMessageProperties,
				textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else p49,
				partOrModel = p49.TextSource and p49.TextSource.Parent or nil,
				wasRewritten = if not FFlagEnableInExpChatRewrite then nil else p49.WasRewritten,
				originalText = if not FFlagEnableInExpChatRewrite then nil else p49.OriginalText,
				channelNameOverride = GetFFlagTextChatEnableUniverseChatTabs() and s18 or nil,
				chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else p49.ChatActionType,
				isUniverseChat = if not FFlagChatLineReportingGlobalMuteEnabled then nil else b4,
				presetId = if not FFlagExpChatPresetChatEnabled then nil else p49.PresetId,
				presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else p49.PresetChatVersion
			}
			local v133 = v44(false)
			local v134 = v133 and v133[t13.messageId] ~= nil

			if t13.isVisibleInChatWindow or t13.isVisibleInBubbleChat or v134 then
				addMessage(t13)

				if FFlagExpChatEnableV2ChatWindow and t13.isVisibleInChatWindow and not v134 then
					local v135 = v71(false)

					if v135 == nil or v130 == v135 then
						updateNextMessageComponent(t13.messageId)
					end
				end
			end
		end,
		handleIncomingBubbleChatMessage = function(t14: {[any]: any}) -- line: 895
			-- upvalues: addMessage (copy)
			local t15 = {
				prefixText = "",
				textChannel = nil,
				shouldOverrideBubbleChatSettings = true,
				isVisibleInBubbleChat = true,
				isVisibleInChatWindow = false,
				chatWindowMessageProperties = nil,
				userId = t14.bubbleChatMessageUserId,
				text = t14.message,
				translation = t14.translation,
				useTranslation = getChatTranslationEnabled(),
				messageId = t14.bubbleChatMessageId,
				status = Enum.TextChatMessageStatus.Success,
				timestamp = t14.timestamp,
				partOrModel = t14.partOrModel,
				bubbleChatMessageProperties = t14.bubbleChatMessageProperties
			}

			addMessage(t15)
		end,
		handleLegacyBubbleCreated = function(t16: {[any]: any}) -- line: 1194
			-- upvalues: addMessage (copy)
			local timestamp = t16.timestamp
			local v160 = if not timestamp then DateTime.now() else DateTime.fromUnixTimestampMillis(timestamp)
			local t17 = {
				prefixText = "",
				shouldOverrideBubbleChatSettings = true,
				isVisibleInBubbleChat = true,
				isVisibleInChatWindow = false,
				translation = nil,
				useTranslation = false,
				textChannel = nil,
				bubbleChatMessageProperties = nil,
				chatWindowMessageProperties = nil,
				userId = t16.userId,
				text = t16.text,
				messageId = t16.id,
				status = Enum.TextChatMessageStatus.Success,
				timestamp = v160,
				partOrModel = t16.adornee
			}

			addMessage(t17)
		end,
		handleLegacyBubbleTextUpdated = function(s19: string, s20: string) -- line: 1231
			-- upvalues: v45 (copy), Dictionary (copy)
			v45(function(p50) -- line: 1232
				-- upvalues: s19 (copy), Dictionary (copy), s20 (copy)
				if not p50 then
					return {}
				end

				if p50[s19] then
					local v289 = p50[s19]
					local v290 = Dictionary.join(v289, {
						text = s20
					})

					return Dictionary.join(p50, {
						[s19] = v290
					})
				end

				return p50
			end)
		end,
		handleHiddenMessageReceived = function(p51) -- line: 918
			-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), FIntExpChatRandomCharChangeLowerBound (copy), FIntExpChatRandomCharChangeUpperBound (copy), Config (copy), getFFlagExpChatTelemetryEventTrigger (copy), addMessage (copy), FFlagExpChatEnableV2ChatWindow (copy), FFlagExpChatSupportHiddenMessagesInWindowV2 (copy), resolveChannelNameForMapOrder (copy), v71 (copy), updateNextMessageComponent (ref)
			local v139 = string.len(if not getFFlagExpChatProtectedChatInternalAPIs() then p51.Text else p51.TextInternal)
			local v140 = math.max(FIntExpChatRandomCharChangeLowerBound, -(v139 - 1))
			local v141 = FIntExpChatRandomCharChangeUpperBound
			local v142 = math.random(v140, v141)
			local v143 = string.rep(Config.DOT_TEXT, v139 + v142)
			local t18 = {
				userId = nil,
				isVisibleInBubbleChat = false,
				isVisibleInChatWindow = true,
				isHiddenMessage = true,
				prefixText = Config.LOCK_EMOJI .. " :",
				text = v143,
				textChannel = p51.TextChannel,
				messageId = p51.MessageId,
				status = p51.Status,
				timestamp = p51.Timestamp,
				textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else p51
			}

			addMessage(t18)

			if FFlagExpChatEnableV2ChatWindow and FFlagExpChatSupportHiddenMessagesInWindowV2 then
				local v145 = resolveChannelNameForMapOrder(t18)
				local v146 = v71(false)

				if v146 == nil or v145 == v146 then
					updateNextMessageComponent(t18.messageId)
				end
			end
		end,
		handleHiddenMessagesCleared = function() -- line: 1061
			-- upvalues: FFlagExpChatClearHiddenMessagesPostAgeCheck (copy), v45 (copy), Dictionary (copy), v49 (copy), List (copy), v44 (copy), v51 (copy)
			if not FFlagExpChatClearHiddenMessagesPostAgeCheck then
				return
			end

			v45(function(p52) -- line: 1068
				-- upvalues: Dictionary (copy)
				return Dictionary.map(p52, function(p53) -- line: 1069
					-- upvalues: Dictionary (copy)
					if p53.isHiddenMessage then
						return Dictionary.join(p53, {
							isVisibleInChatWindow = false
						})
					end

					return p53
				end)
			end)
			v49(function(p54) -- line: 1081
				-- upvalues: List (copy), v44 (copy)
				return List.filter(p54, function(p55) -- line: 1082
					-- upvalues: v44 (copy)
					local v306 = v44(false)[p55]

					return v306 and not v306.isHiddenMessage
				end)
			end)
			v51(function(p56) -- line: 1089
				-- upvalues: Dictionary (copy), List (copy), v44 (copy)
				return Dictionary.map(p56, function(p57) -- line: 1090
					-- upvalues: List (copy), v44 (copy)
					return List.filter(p57, function(p58) -- line: 1091
						-- upvalues: v44 (copy)
						local v310 = v44(false)[p58]

						return v310 and not v310.isHiddenMessage
					end)
				end)
			end)
		end,
		addSystemMessage = function(s21: string, s22: string, s23: string?, p59: ((...any) -> ...any)?, b5: boolean?) -- line: 654
			-- upvalues: sanitizeForRichText (copy), GetFFlagExpChatSyntheticSystemMessageRichText (copy), generateRichSystemMessageTextFormat (copy), FFlagExpChatDictation (copy), FFlagExpChatEnablePostProcessRichSystemMessageTextFormat (copy), HttpService (copy), addMessage (copy), FFlagExpChatEnableV2ChatWindow (copy), v71 (copy), updateNextMessageComponent (ref)
			local v108 = sanitizeForRichText(s21)
			local v109 = if not GetFFlagExpChatSyntheticSystemMessageRichText() then v108 else generateRichSystemMessageTextFormat(v108, if not FFlagExpChatDictation then nil else b5, if not FFlagExpChatEnablePostProcessRichSystemMessageTextFormat then nil else p59)
			local guid = HttpService:GenerateGUID(false)
			local t19 = {
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

			addMessage(t19)

			if FFlagExpChatEnableV2ChatWindow then
				local v112 = v71(false)

				if v112 == nil or s22 == v112 then
					updateNextMessageComponent(guid)
				end
			end
		end,
		getChannelTabsConfigurationEnabled = v62,
		setChannelTabsConfigurationEnabled = v63
	}
end

return createMessagesStore
