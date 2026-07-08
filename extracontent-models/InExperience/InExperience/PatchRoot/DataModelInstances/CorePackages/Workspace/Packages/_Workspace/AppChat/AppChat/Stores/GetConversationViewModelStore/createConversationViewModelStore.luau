local LocalizationService = game:GetService("LocalizationService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Signals = require(AppChatParent.Signals)
local DomLocators = require(AppChat.Utils.DomLocators)
local getConversationTitle = require(AppChat.Conversations.getConversationTitle)
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local shouldShowOSAForConversation = require(AppChat.Utils.shouldShowOSAForConversation)
local shouldShowU13ChatOptInForConversation = require(AppChat.Utils.shouldShowU13ChatOptInForConversation)

require(AppChat.Stores.GetConversationStore.createConversationStore)
require(AppChat.Stores.GetConversationMessageStore.createConversationMessageStore)

local Enums = require(AppChat.MessageData.Enums)

require(AppChat.MessageData.Types)

local Localization = require(AppChatParent.RobloxAppLocales).Localization
local MessageType = Enums.MessageType
local MessageVisibility = Enums.MessageVisibility

local function getFirstCardAltText(p1) -- line: 28
	if type(p1) ~= "table" or type(p1[1]) ~= "table" then
		return nil
	end

	if type(p1[1].alt_text) == "string" then
		return p1[1].alt_text
	end

	return nil
end
local function getContentFirstLine(s1: string?) -- line: 49
	if type(s1) ~= "string" then
		return ""
	end

	local parts = s1:split("\n")

	return parts and parts[1] or ""
end
local function getHiddenMessageText() -- line: 57
	-- upvalues: Localization (copy), LocalizationService (copy)
	return Localization.new(LocalizationService.RobloxLocaleId):Format("Feature.Chat.Label.MessageNotAvailable")
end
local function getUnixTime(p2) -- line: 61
	if p2 == nil then
		return nil
	end

	if typeof(p2) == "DateTime" then
		return p2.UnixTimestamp
	end

	if type(p2) == "table" and p2.GetUnixTimestamp ~= nil then
		return p2:GetUnixTimestamp()
	end

	return nil
end
local function getSubtitle(p3, p4) -- line: 74
	-- upvalues: MessageVisibility (copy), Localization (copy), LocalizationService (copy), MessageType (copy)
	if p4 ~= nil then
		local v29 = if p4.visibility ~= MessageVisibility.Hidden then p4.preview_content or (p4.content_to_display or p4.content) else Localization.new(LocalizationService.RobloxLocaleId):Format("Feature.Chat.Label.MessageNotAvailable")

		if v29 == nil and p4.type == MessageType.System then
			local cards = p4.cards

			v29 = if type(cards) == "table" and type(cards[1]) == "table" then if type(cards[1].alt_text) ~= "string" then nil else cards[1].alt_text else nil
		end

		if type(v29) ~= "string" then
			return ""
		end

		local parts = v29:split("\n")

		return parts and parts[1] or ""
	end

	local previewContent = p3.previewContent

	if type(previewContent) ~= "string" then
		return ""
	end

	local parts = previewContent:split("\n")

	return parts and parts[1] or ""
end
local function getTitle(p5) -- line: 88
	-- upvalues: getConversationTitle (copy)
	return getConversationTitle(p5) or ""
end
local function getLocatorTitle(p6) -- line: 92
	-- upvalues: getConversationTitle (copy)
	return p6.title or (getConversationTitle(p6) or "")
end
local function getCachedGetter(t1: {[any]: any}, s2: string, s3: string, p7: ((...any) -> ...any)) -- line: 98
	-- upvalues: Signals (copy)
	local v40 = t1[s2]

	if v40 then
		local v41 = v40[s3]

		if v41 ~= nil then
			return v41
		end
	else
		v40 = {}
		t1[s2] = v40
	end

	local v42 = Signals.createComputed(p7)

	v40[s3] = v42

	return v42
end
local function createConversationViewModelStore(p8, p9) -- line: 120
	-- upvalues: getConversationTitle (copy), Signals (copy), getSubtitle (copy), useIsUserPending (copy), shouldShowOSAForConversation (copy), shouldShowU13ChatOptInForConversation (copy), DomLocators (copy)
	local t2 = {}

	local function getTitleGetter(s4: string) -- line: 126
		-- upvalues: t2 (copy), p8 (copy), getConversationTitle (copy), Signals (copy)
		local v51 = t2
		local v52 = v51[s4]

		if v52 then
			local title = v52.title

			if title ~= nil then
				return title
			end
		else
			v52 = {}
			v51[s4] = v52
		end

		local v54 = Signals.createComputed(function(p10) -- line: 127
			-- upvalues: p8 (copy), s4 (copy), getConversationTitle (copy)
			local v106 = p8.getConversation(s4, p10)

			if v106 ~= nil then
				return getConversationTitle(v106) or ""
			end

			return nil
		end)

		v52.title = v54

		return v54
	end
	local function getSubtitleGetter(s5: string) -- line: 133
		-- upvalues: t2 (copy), p8 (copy), p9 (copy), getSubtitle (copy), Signals (copy)
		local v56 = t2
		local v57 = v56[s5]

		if v57 then
			local subtitle = v57.subtitle

			if subtitle ~= nil then
				return subtitle
			end
		else
			v57 = {}
			v56[s5] = v57
		end

		local v59 = Signals.createComputed(function(p11) -- line: 134
			-- upvalues: p8 (copy), s5 (copy), p9 (copy), getSubtitle (copy)
			local v108 = p8.getConversation(s5, p11)

			if v108 == nil then
				return ""
			end

			local v109 = if v108.previewMessageId == nil then nil else p9.getMessage(v108.previewMessageId, p11)

			return (getSubtitle(v108, v109))
		end)

		v57.subtitle = v59

		return v59
	end
	local function getUnixTimeGetter(s6: string) -- line: 189
		-- upvalues: t2 (copy), p8 (copy), Signals (copy)
		local v91 = t2
		local v92 = v91[s6]

		if v92 then
			local unixTime = v92.unixTime

			if unixTime ~= nil then
				return unixTime
			end
		else
			v92 = {}
			v91[s6] = v92
		end

		local v94 = Signals.createComputed(function(p12) -- line: 190
			-- upvalues: p8 (copy), s6 (copy)
			local v123 = p8.getConversation(s6, p12)

			if v123 ~= nil then
				local lastUpdated = v123.lastUpdated

				if lastUpdated == nil then
					return nil
				end

				if typeof(lastUpdated) == "DateTime" then
					return lastUpdated.UnixTimestamp
				end

				if type(lastUpdated) == "table" and lastUpdated.GetUnixTimestamp ~= nil then
					return (lastUpdated:GetUnixTimestamp())
				end

				return nil
			end

			return nil
		end)

		v92.unixTime = v94

		return v94
	end
	local function getLocatorTitleGetter(s7: string) -- line: 206
		-- upvalues: t2 (copy), p8 (copy), getConversationTitle (copy), Signals (copy)
		local v101 = t2
		local v102 = v101[s7]

		if v102 then
			local locatorTitle = v102.locatorTitle

			if locatorTitle ~= nil then
				return locatorTitle
			end
		else
			v102 = {}
			v101[s7] = v102
		end

		local v104 = Signals.createComputed(function(p13) -- line: 207
			-- upvalues: p8 (copy), s7 (copy), getConversationTitle (copy)
			local v128 = p8.getConversation(s7, p13)
			local title

			if v128 ~= nil then
				title = v128.title

				if not title then
					return getConversationTitle(v128) or ""
				end
			else
				title = nil
			end

			return title
		end)

		v102.locatorTitle = v104

		return v104
	end

	return {
		getTitle = getTitleGetter,
		getSubtitle = getSubtitleGetter,
		getIsSubtitlePending = function(s8: string) -- line: 147
			-- upvalues: t2 (copy), p8 (copy), useIsUserPending (copy), Signals (copy)
			local v61 = t2
			local v62 = v61[s8]

			if v62 then
				local isSubtitlePending = v62.isSubtitlePending

				if isSubtitlePending ~= nil then
					return isSubtitlePending
				end
			else
				v62 = {}
				v61[s8] = v62
			end

			local v64 = Signals.createComputed(function(p14) -- line: 148
				-- upvalues: p8 (copy), s8 (copy), useIsUserPending (copy)
				local v111 = p8.getConversation(s8, p14)

				if v111 ~= nil then
					return (useIsUserPending(v111))
				end

				return false
			end)

			v62.isSubtitlePending = v64

			return v64
		end,
		getHasUnreadMessages = function(s9: string) -- line: 154
			-- upvalues: t2 (copy), p8 (copy), Signals (copy)
			local v66 = t2
			local v67 = v66[s9]

			if v67 then
				local hasUnreadMessages = v67.hasUnreadMessages

				if hasUnreadMessages ~= nil then
					return hasUnreadMessages
				end
			else
				v67 = {}
				v66[s9] = v67
			end

			local v69 = Signals.createComputed(function(p15) -- line: 155
				-- upvalues: p8 (copy), s9 (copy)
				local v113 = p8.getConversation(s9, p15)

				return v113 ~= nil and v113.hasUnreadMessages == true
			end)

			v67.hasUnreadMessages = v69

			return v69
		end,
		getHasGroupUp = function(s10: string) -- line: 161
			-- upvalues: t2 (copy), p8 (copy), Signals (copy)
			local v71 = t2
			local v72 = v71[s10]

			if v72 then
				local hasGroupUp = v72.hasGroupUp

				if hasGroupUp ~= nil then
					return hasGroupUp
				end
			else
				v72 = {}
				v71[s10] = v72
			end

			local v74 = Signals.createComputed(function(p16) -- line: 162
				-- upvalues: p8 (copy), s10 (copy)
				local v115 = p8.getConversation(s10, p16)

				return v115 ~= nil and v115.hasGroupUp == true
			end)

			v72.hasGroupUp = v74

			return v74
		end,
		getShouldShowOSA = function(s11: string) -- line: 168
			-- upvalues: t2 (copy), p8 (copy), shouldShowOSAForConversation (copy), Signals (copy)
			local v76 = t2
			local v77 = v76[s11]

			if v77 then
				local shouldShowOSA = v77.shouldShowOSA

				if shouldShowOSA ~= nil then
					return shouldShowOSA
				end
			else
				v77 = {}
				v76[s11] = v77
			end

			local v79 = Signals.createComputed(function(p17) -- line: 169
				-- upvalues: p8 (copy), s11 (copy), shouldShowOSAForConversation (copy)
				local v117 = p8.getConversation(s11, p17)

				return v117 ~= nil and shouldShowOSAForConversation(v117) == true
			end)

			v77.shouldShowOSA = v79

			return v79
		end,
		getShouldShowU13ChatOptIn = function(s12: string) -- line: 175
			-- upvalues: t2 (copy), p8 (copy), shouldShowU13ChatOptInForConversation (copy), Signals (copy)
			local v81 = t2
			local v82 = v81[s12]

			if v82 then
				local shouldShowU13ChatOptIn = v82.shouldShowU13ChatOptIn

				if shouldShowU13ChatOptIn ~= nil then
					return shouldShowU13ChatOptIn
				end
			else
				v82 = {}
				v81[s12] = v82
			end

			local v84 = Signals.createComputed(function(p18) -- line: 176
				-- upvalues: p8 (copy), s12 (copy), shouldShowU13ChatOptInForConversation (copy)
				local v119 = p8.getConversation(s12, p18)

				return v119 ~= nil and shouldShowU13ChatOptInForConversation(v119) == true
			end)

			v82.shouldShowU13ChatOptIn = v84

			return v84
		end,
		getConversationType = function(s13: string) -- line: 182
			-- upvalues: t2 (copy), p8 (copy), Signals (copy)
			local v86 = t2
			local v87 = v86[s13]

			if v87 then
				local conversationType = v87.conversationType

				if conversationType ~= nil then
					return conversationType
				end
			else
				v87 = {}
				v86[s13] = v87
			end

			local v89 = Signals.createComputed(function(p19) -- line: 183
				-- upvalues: p8 (copy), s13 (copy)
				local v121 = p8.getConversation(s13, p19)

				if v121 ~= nil then
					return v121.conversationType
				end

				return nil
			end)

			v87.conversationType = v89

			return v89
		end,
		getUnixTime = getUnixTimeGetter,
		getTestId = function(s14: string) -- line: 196
			-- upvalues: t2 (copy), p8 (copy), DomLocators (copy), getConversationTitle (copy), Signals (copy)
			local v96 = t2
			local v97 = v96[s14]

			if v97 then
				local testId = v97.testId

				if testId ~= nil then
					return testId
				end
			else
				v97 = {}
				v96[s14] = v97
			end

			local v99 = Signals.createComputed(function(p20) -- line: 197
				-- upvalues: p8 (copy), s14 (copy), DomLocators (copy), getConversationTitle (copy)
				local v126 = p8.getConversation(s14, p20)

				if v126 == nil then
					return nil
				end

				return DomLocators.chatLandingConversationEntry(v126.title or (getConversationTitle(v126) or ""))
			end)

			v97.testId = v99

			return v99
		end,
		getLocatorTitle = getLocatorTitleGetter
	}
end

return createConversationViewModelStore
