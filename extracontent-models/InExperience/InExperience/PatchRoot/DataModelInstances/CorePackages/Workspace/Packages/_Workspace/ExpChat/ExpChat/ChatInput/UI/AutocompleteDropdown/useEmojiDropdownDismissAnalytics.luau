local HttpService = game:GetService("HttpService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local React = require(parent.React)
local EmojiList = require(parent.EmojiList)
local ExpChatShared = require(parent.ExpChatShared)
local Constants = require(ExpChat.PresetChat.Constants)
local emojiUnicodeToId = require(ExpChat.PresetChat.emojiUnicodeToId)

local function useEmojiDropdownDismissAnalytics(flag: boolean, items, p)
	local ref = React.useRef(nil)

	local v = React.useCallback(function()
		local current = ref.current

		if current == nil then
			return
		end

		local v = {}

		for k, lastVisibleResult in current.lastVisibleResults do
			v[lastVisibleResult] = k - 1
		end

		local current2

		if p then
			current2 = p.current
		end

		local v2 = {}

		for _, v3 in current.seenOrder do
			table.insert(v2, {
				emoji_id = emojiUnicodeToId(EmojiList[v3].base),
				index = v[v3] or -1,
				click = v3 == current2 and 1 or 0
			})
		end

		ref.current = nil

		if p then
			p.current = nil
		end

		ExpChatShared.Analytics:TelemetryLogEvent(
			ExpChatShared.Analytics.ExpChatPresetActionConfig,
			{
				event_type = Constants.Analytics.EventTypes.Dismiss,
				component = Constants.Analytics.Components.EmojiDropdown,
				preset_items = HttpService:JSONEncode(v2)
			},
			Constants.Analytics.ExtendedStandardizedFields
		)
	end, { p })

	React.useEffect(function()
		if not flag then
			v()
			return
		end

		local current = ref.current

		if current == nil then
			current = { seenOrder = {}, seenSet = {}, lastVisibleResults = {} }
			ref.current = current

			if p then
				p.current = nil
			end
		end

		for _, item in items do
			if current.seenSet[item] then
				continue
			end

			current.seenSet[item] = true
			table.insert(current.seenOrder, item)
		end

		current.lastVisibleResults = table.clone(items)
	end, { flag, items, p, v })

	React.useEffect(function()
		return v
	end, { v })
end

return useEmojiDropdownDismissAnalytics
