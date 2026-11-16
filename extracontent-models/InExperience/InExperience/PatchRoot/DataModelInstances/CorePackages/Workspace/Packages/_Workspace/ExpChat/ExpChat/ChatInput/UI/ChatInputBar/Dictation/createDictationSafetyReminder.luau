local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local SharedFlags = require(parent.SharedFlags)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs

local getTextAndTranslation = require(ExpChat.getTextAndTranslation)
local isFullyFilteredText = require(script.Parent.isFullyFilteredText)

local function getMessageText(p) -- 1 equivalent call inferred from this helper
	local v

	if getFFlagExpChatProtectedChatInternalAPIs() then
		v = p.TextInternal
	else
		v = p.Text
	end

	return v or ""
end

local function getDisplayedText(p) -- 1 equivalent call inferred from this helper
	return getTextAndTranslation(p) or ""
end

local function trim(value: string) -- 3 equivalent calls inferred from this helper
	return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
end

local function createDictationSafetyReminder(p)
	local clock = p.clock or os.clock
	local flag = false
	local v = {}
	local v2 = {}

	local function prune(p2: number)
		for i = #v, 1, -1 do
			if p2 - v[i].at > 30 then
				table.remove(v, i)
			end
		end

		for k, v3 in v2 do
			if p2 - v3.at > 30 then
				v2[k] = nil
			end
		end
	end

	return {
		trackContinuousSend = function(value: string)
			if flag then
				return
			end

			local at = clock()
			prune(at)
			table.insert(v, { text = trim(value), at = at }) -- inferred equivalent call
		end,
		onOutgoingMessage = function(p2)
			if flag or #v == 0 then
				return
			end

			local v3 = trim(getMessageText(p2)) -- inferred equivalent call

			for k, v4 in v do
				if v4.text == v3 then
					table.remove(v, k)
					v2[p2.MessageId] = v4
					break
				end
			end
		end,
		onIncomingMessage = function(p2)
			local v3 = v2[p2.MessageId]

			if not (v3 ~= nil and p2.Status ~= Enum.TextChatMessageStatus.Sending) then
				return
			end

			v2[p2.MessageId] = nil

			if flag or p2.Status ~= Enum.TextChatMessageStatus.Success then
				return
			end

			if isFullyFilteredText(v3.text, trim(getDisplayedText(p2))) then -- inferred equivalent call
				flag = true
				table.clear(v)
				table.clear(v2)
				p.onTriggered()
			end
		end
	}
end

return createDictationSafetyReminder
