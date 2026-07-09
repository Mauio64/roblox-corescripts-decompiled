local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Roact = require(ExpChatParent.Roact)
local List = require(ExpChatParent.llama).List
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local ChatBubble = require(ExpChat.BubbleChat.ChatBubble)
local GlobalFlags = require(ExpChat.GlobalFlags)
local v8 = Roact.PureComponent:extend("BubbleChatList")
local getFFlagChatTranslationUIEnabledBubbleChat = require(ExpChat.Flags.getFFlagChatTranslationUIEnabledBubbleChat)
local getFFlagExpChatUseUpdatedMessageRendered = require(ExpChat.Flags.getFFlagExpChatUseUpdatedMessageRendered)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled

function v8.getDerivedStateFromProps(p1, p2) -- line: 18
	-- upvalues: List (copy), getFFlagChatTranslationUIEnabledBubbleChat (copy), FFlagExpChatPresetChatEnabled (copy), getFFlagExpChatUseUpdatedMessageRendered (copy)
	local t1 = {}

	if p2.bubbles then
		for _, v in ipairs(p2.bubbles) do
			if not List.findWhere(p1.messages, function(p3, _) -- line: 25
				-- upvalues: v (copy)
				return p3.messageId == v.messageId
			end) then
				table.insert(t1, {
					fadingOut = true,
					messageId = v.messageId
				})
			end
		end
	end

	for _, v in ipairs(p1.messages) do
		local num = tonumber(tostring(v.timestamp):sub(-9))

		table.insert(t1, {
			fadingOut = false,
			messageId = v.messageId,
			text = v.text,
			translation = if not getFFlagChatTranslationUIEnabledBubbleChat() then nil else v.translation,
			useTranslation = if not getFFlagChatTranslationUIEnabledBubbleChat() then nil else v.useTranslation,
			timestamp = num or v.timestamp,
			bubbleChatMessageProperties = v.bubbleChatMessageProperties,
			presetId = if not FFlagExpChatPresetChatEnabled then nil else v.presetId,
			textChatMessageInstance = if not getFFlagExpChatUseUpdatedMessageRendered() then nil else v.textChatMessageInstance
		})
	end

	return {
		bubbles = t1
	}
end
function v8.init(p5, p6) -- line: 61
	-- upvalues: List (copy)
	p5.state = {}

	if (not p6.messages or #p6.messages == 0) and p6.onLastBubbleFadeOut then
		p6.onLastBubbleFadeOut()
	end

	function p5.onBubbleFadeOut(p7) -- line: 70
		-- upvalues: List (copy), p5 (copy)
		local v36 = List.filter(p5.state.bubbles, function(p8) -- line: 71
			-- upvalues: p7 (copy)
			return p8.messageId ~= p7
		end)

		if #v36 == 0 and p5.props.onLastBubbleFadeOut then
			p5.props.onLastBubbleFadeOut()

			return
		end

		p5:setState({
			bubbles = v36
		})
	end
end
function v8.render(p9) -- line: 86
	-- upvalues: Roact (copy), GlobalFlags (copy), ChatBubble (copy), getFFlagChatTranslationUIEnabledBubbleChat (copy), FFlagExpChatPresetChatEnabled (copy), getFFlagExpChatUseUpdatedMessageRendered (copy)
	local t2 = {}
	local chatSettings = p9.props.chatSettings

	t2.Layout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		Padding = UDim.new(0, chatSettings.BubblesSpacing)
	})
	t2.CaretPadding = p9.props.chatSettings.TailVisible and ((not GlobalFlags.AvatarChatEnabled or p9.props.showCaret) and Roact.createElement("UIPadding", {
		PaddingBottom = UDim.new(0, 8)
	}))

	for i, v in ipairs(p9.state.bubbles) do
		local v27 = i == #p9.state.bubbles
		local v28 = v27 and p9.props.renderFirstInsert or nil
		local insertSize = p9.props.insertSize
		local text = v.text
		local translation = v.translation

		if v.bubbleChatMessageProperties then
			local bubbleChatMessageProperties = v.bubbleChatMessageProperties

			if bubbleChatMessageProperties:IsA("TextChatMessageProperties") then
				if bubbleChatMessageProperties.Text ~= "" then
					text = bubbleChatMessageProperties.Text
				end

				if bubbleChatMessageProperties.Translation ~= "" then
					translation = bubbleChatMessageProperties.Translation
				end
			end
		end

		t2["Bubble" .. v.messageId] = Roact.createElement(ChatBubble, {
			messageId = v.messageId,
			text = text or "",
			translation = if not getFFlagChatTranslationUIEnabledBubbleChat() then nil else translation,
			useTranslation = if not getFFlagChatTranslationUIEnabledBubbleChat() then nil else v.useTranslation,
			timestamp = v.timestamp or 0,
			isMostRecent = v27,
			theme = p9.props.theme,
			fadingOut = v.fadingOut,
			onFadeOut = p9.onBubbleFadeOut,
			chatSettings = chatSettings,
			renderInsert = v28,
			insertSize = insertSize,
			showCaret = p9.props.showCaret,
			clientSettings = p9.props.clientSettings,
			bubbleChatMessageProperties = v.bubbleChatMessageProperties,
			presetId = if not FFlagExpChatPresetChatEnabled then nil else v.presetId,
			isTextChatServiceOn = p9.props.isTextChatServiceOn,
			textChatMessageInstance = if not getFFlagExpChatUseUpdatedMessageRendered() then nil else v.textChatMessageInstance
		})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Visible = p9.props.isVisible,
		Size = UDim2.fromScale(1, 1)
	}, t2)
end

return v8
