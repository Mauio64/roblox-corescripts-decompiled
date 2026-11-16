local ExpChat = script:FindFirstAncestor("ExpChat")

local parent = ExpChat.Parent
local Roact = require(parent.Roact)
local llama = require(parent.llama)
local list = llama.List
local ExpChatShared = require(parent.ExpChatShared)
local ChatBubble = require(ExpChat.BubbleChat.ChatBubble)
local BorderlessBubbleChat = require(ExpChat.BubbleChat.BorderlessBubbleChat)
local isBorderlessBubbleChatMessage = require(ExpChat.BubbleChat.Helpers.isBorderlessBubbleChatMessage)
local getBubbleChatDisplayText = require(ExpChat.BubbleChat.Helpers.getBubbleChatDisplayText)
local getBubbleChatStartTimeMillis = require(ExpChat.BubbleChat.Helpers.getBubbleChatStartTimeMillis)

local applyBubbleChatMessagePropertiesText = require(ExpChat.BubbleChat.Helpers.applyBubbleChatMessagePropertiesText)

local GlobalFlags = require(ExpChat.GlobalFlags)

local extended = Roact.PureComponent:extend("BubbleChatList")

local getFFlagChatTranslationUIEnabledBubbleChat = require(ExpChat.Flags.getFFlagChatTranslationUIEnabledBubbleChat)
local getFFlagExpChatUseUpdatedMessageRendered = require(ExpChat.Flags.getFFlagExpChatUseUpdatedMessageRendered)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local isBorderlessBubbleChatEnabled = require(ExpChat.isBorderlessBubbleChatEnabled)

function extended.getDerivedStateFromProps(p, p2)
	local bubbles = {}
	local v

	if isBorderlessBubbleChatEnabled() then
		v = p.messages[#p.messages]
	end

	if p2.bubbles then
		for _, bubble in ipairs(p2.bubbles) do
			if list.findWhere(p.messages, function(p3, _): boolean
				return p3.messageId == bubble.messageId
			end) then
				continue
			end

			local v2 = isBorderlessBubbleChatEnabled()

			if v2 then
				if v == nil then
					v2 = false
				else
					v2 = bubble.isBorderless or isBorderlessBubbleChatMessage(v)
				end
			end

			if v2 then
				continue
			end

			local v3 = {
				messageId = bubble.messageId,
				fadingOut = true,
				isBorderless = 0,
				borderlessText = 0,
				borderlessReceivedAtMillis = 0
			}
			local isBorderless

			if isBorderlessBubbleChatEnabled() then
				isBorderless = bubble.isBorderless
			end

			v3.isBorderless = isBorderless
			local borderlessText

			if isBorderlessBubbleChatEnabled() and bubble.isBorderless then
				borderlessText = bubble.borderlessText
			end

			v3.borderlessText = borderlessText
			local borderlessReceivedAtMillis

			if isBorderlessBubbleChatEnabled() and bubble.isBorderless then
				borderlessReceivedAtMillis = bubble.borderlessReceivedAtMillis
			end

			v3.borderlessReceivedAtMillis = borderlessReceivedAtMillis
			table.insert(bubbles, v3)
		end
	end

	for _, message in ipairs(p.messages) do
		local v2 = tonumber(tostring(message.timestamp):sub(-9))
		local isBorderless

		if isBorderlessBubbleChatEnabled() then
			isBorderless = isBorderlessBubbleChatMessage(message)
		end

		local v3 = {
			messageId = message.messageId,
			fadingOut = false,
			text = message.text,
			translation = 0,
			useTranslation = 0,
			timestamp = 0,
			bubbleChatMessageProperties = 0,
			presetId = 0,
			textChatMessageInstance = 0,
			isBorderless = 0,
			borderlessText = 0,
			borderlessReceivedAtMillis = 0
		}
		local translation

		if getFFlagChatTranslationUIEnabledBubbleChat() then
			translation = message.translation
		end

		v3.translation = translation
		local useTranslation

		if getFFlagChatTranslationUIEnabledBubbleChat() then
			useTranslation = message.useTranslation
		end

		v3.useTranslation = useTranslation
		v3.timestamp = v2 or message.timestamp
		v3.bubbleChatMessageProperties = message.bubbleChatMessageProperties
		local presetId

		if FFlagExpChatPresetChatEnabled then
			presetId = message.presetId
		end

		v3.presetId = presetId
		local textChatMessageInstance

		if getFFlagExpChatUseUpdatedMessageRendered() then
			textChatMessageInstance = message.textChatMessageInstance
		end

		v3.textChatMessageInstance = textChatMessageInstance

		v3.isBorderless = isBorderless
		local borderlessText

		if isBorderless then
			borderlessText = getBubbleChatDisplayText(message)
		end

		v3.borderlessText = borderlessText
		local borderlessReceivedAtMillis

		if isBorderless then
			borderlessReceivedAtMillis = getBubbleChatStartTimeMillis(message)
		end

		v3.borderlessReceivedAtMillis = borderlessReceivedAtMillis
		table.insert(bubbles, v3)
	end

	return { bubbles = bubbles }
end

function extended:init(p)
	self.state = {}

	if (not p.messages or #p.messages == 0) and p.onLastBubbleFadeOut then
		p.onLastBubbleFadeOut()
	end

	function self.onBubbleFadeOut(p2)
		local filtered = list.filter(self.state.bubbles, function(p3): boolean
			return p3.messageId ~= p2
		end)

		if #filtered == 0 and self.props.onLastBubbleFadeOut then
			self.props.onLastBubbleFadeOut()
		else
			self:setState({ bubbles = filtered })
		end
	end
end

function extended.render(props)
	local chatSettings = props.props.chatSettings
	local children = {
		["Layout"] = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, chatSettings.BubblesSpacing)
		}),
		CaretPadding = props.props.chatSettings.TailVisible and (not GlobalFlags.AvatarChatEnabled or props.props.showCaret) and Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 8)
		})
	}

	for i, bubble in ipairs(props.state.bubbles) do
		local isMostRecent = i == #props.state.bubbles
		local renderFirstInsert

		if isMostRecent then
			renderFirstInsert = props.props.renderFirstInsert or nil
		end

		local insertSize = props.props.insertSize

		local text = bubble.text
		local translation = bubble.translation

		if isBorderlessBubbleChatEnabled() then
			text, translation = applyBubbleChatMessagePropertiesText(
				text,
				translation,
				bubble.bubbleChatMessageProperties
			)
		elseif bubble.bubbleChatMessageProperties then
			local bubbleChatMessageProperties = bubble.bubbleChatMessageProperties

			if bubbleChatMessageProperties:IsA("TextChatMessageProperties") then
				if bubbleChatMessageProperties.Text ~= "" then
					text = bubbleChatMessageProperties.Text
				end

				if bubbleChatMessageProperties.Translation ~= "" then
					translation = bubbleChatMessageProperties.Translation
				end
			end
		end

		if isBorderlessBubbleChatEnabled() and bubble.isBorderless then
			children["Bubble" .. bubble.messageId] = Roact.createElement(BorderlessBubbleChat, {
				messageId = bubble.messageId,
				text = bubble.borderlessText or "",
				timestamp = bubble.timestamp or 0,
				receivedAtMillis = bubble.borderlessReceivedAtMillis,
				isDistant = props.props.isDistant,
				distanceTransparency = props.props.borderlessDistanceTransparency,
				fadingOut = bubble.fadingOut,
				onFadeOut = props.onBubbleFadeOut,
				chatSettings = chatSettings,
				textChatMessageInstance = bubble.textChatMessageInstance
			})
		else
			local v = "Bubble" .. bubble.messageId
			local createElement = Roact.createElement
			local v2 = {
				messageId = bubble.messageId,
				text = text or "",
				translation = 0,
				useTranslation = 0,
				timestamp = 0,
				isMostRecent = 0,
				theme = 0,
				fadingOut = 0,
				onFadeOut = 0,
				chatSettings = 0,
				renderInsert = 0,
				insertSize = 0,
				showCaret = 0,
				clientSettings = 0,
				bubbleChatMessageProperties = 0,
				presetId = 0,
				isTextChatServiceOn = 0,
				textChatMessageInstance = 0
			}

			if not getFFlagChatTranslationUIEnabledBubbleChat() then
				translation = nil
			end

			v2.translation = translation
			local useTranslation

			if getFFlagChatTranslationUIEnabledBubbleChat() then
				useTranslation = bubble.useTranslation
			end

			v2.useTranslation = useTranslation
			v2.timestamp = bubble.timestamp or 0
			v2.isMostRecent = isMostRecent
			v2.theme = props.props.theme
			v2.fadingOut = bubble.fadingOut
			v2.onFadeOut = props.onBubbleFadeOut
			v2.chatSettings = chatSettings
			v2.renderInsert = renderFirstInsert
			v2.insertSize = insertSize
			v2.showCaret = props.props.showCaret
			v2.clientSettings = props.props.clientSettings
			v2.bubbleChatMessageProperties = bubble.bubbleChatMessageProperties
			local presetId

			if FFlagExpChatPresetChatEnabled then
				presetId = bubble.presetId
			end

			v2.presetId = presetId
			v2.isTextChatServiceOn = props.props.isTextChatServiceOn
			local textChatMessageInstance

			if getFFlagExpChatUseUpdatedMessageRendered() then
				textChatMessageInstance = bubble.textChatMessageInstance
			end

			v2.textChatMessageInstance = textChatMessageInstance
			children[v] = createElement(ChatBubble, v2)
		end
	end

	return Roact.createElement(
		"Frame",
		{
			Visible = props.props.isVisible,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1
		},
		children
	)
end

return extended
