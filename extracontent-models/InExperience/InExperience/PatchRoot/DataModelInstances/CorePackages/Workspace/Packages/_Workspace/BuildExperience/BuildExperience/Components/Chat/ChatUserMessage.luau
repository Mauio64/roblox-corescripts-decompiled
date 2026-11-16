local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default

require(BuildExperience.Chat.chatTypes)
local FFlagBuildExperienceChatImageAttachments = require(BuildExperience.Flags.FFlagBuildExperienceChatImageAttachments)

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceChatResourceAttachments = SharedFlags.FFlagBuildExperienceChatResourceAttachments
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local escapeRichText = require(BuildExperience.utils.escapeRichText)
local ChatImagePreviewList

if FFlagBuildExperienceChatImageAttachments then
	ChatImagePreviewList = require(script.Parent.ChatImagePreviewList)
else
	ChatImagePreviewList = nil
end

local ChatResourceAttachmentList

if FFlagBuildExperienceChatResourceAttachments then
	ChatResourceAttachmentList = require(script.Parent.ChatResourceAttachmentList)
else
	ChatResourceAttachmentList = nil
end

local InteractionFeedback = require(parent.InteractionFeedback)
local useTriggerFeedback = InteractionFeedback.useTriggerFeedback

local Menu = Foundation.Menu
local Text = Foundation.Text
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local useTokens = Foundation.Hooks.useTokens

local v = { affordance = StateLayerAffordance.None }

local function useEscapedRichText(messageText: string) -- 1 equivalent call inferred from this helper
	return React.useMemo(function()
		return escapeRichText(messageText)
	end, { messageText })
end

local function UserMessageBubble(props)
	local v2 = useTokens()
	local text = useEscapedRichText(props.messageText) -- inferred equivalent call

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.LayoutOrder,
		cornerRadius = UDim.new(0, v2.Size.Size_500),
		onSecondaryActivated = props.onSecondaryActivated,
		stateLayer = 0,
		Text = 0,
		RichText = true,
		tag = "auto-xy padding-medium text-body-medium text-wrap text-align-x-left bg-shift-200 content-emphasis",
		testId = 0
	}
	local stateLayer

	if props.onSecondaryActivated ~= nil then
		stateLayer = v
	end

	v3.stateLayer = stateLayer
	v3.Text = text

	v3.testId = props.testId
	return createElement(Text, v3)
end

local function CopyableUserMessageBubble(p)
	local v2 = useLocalization({ copyText = LocalizationStrings.CHAT_COPY_TEXT })

	local state, setState = React.useState(false)
	local v3 = useTriggerFeedback()
	local items = {
		{ id = "copy-text", icon = IconName.TwoStackedSquares, text = v2.copyText }
	}

	return React.createElement(Menu, {
		LayoutOrder = p.LayoutOrder,
		align = PopoverAlign.End,
		isOpen = state,
		items = items,
		onActivated = function(p2)
			if p2 == "copy-text" then
				default:setClipboardText({ context = "Build-UserMessage", text = p.messageText })
			end

			setState(false)
		end,
		onPressedOutside = function()
			setState(false)
		end,
		side = PopoverSide.Bottom,
		size = InputSize.Medium
	}, {
		Bubble = React.createElement(UserMessageBubble, {
			LayoutOrder = 1,
			messageText = p.messageText,
			onSecondaryActivated = function()
				v3("Default", "SecondaryActivated")
				setState(true)
			end,
			testId = "ChatUserMessage.Bubble"
		})
	})
end

local function ChatUserMessage(p)
	local text = p.message.text
	local resourceAttachments = p.message.resourceAttachments or {}
	local v2 = FFlagBuildExperienceChatImageAttachments

	if v2 then
		if p.message.images == nil then
			v2 = false
		else
			v2 = #p.message.images > 0
		end
	end

	local v3 = FFlagBuildExperienceChatResourceAttachments and #resourceAttachments > 0

	local createElement = React.createElement
	local v4 = { LayoutOrder = p.LayoutOrder, tag = "row gap-small size-full-0 auto-y" }

	local v5 = {
		Spacer = React.createElement(View, { LayoutOrder = 1, tag = "fill" }),
		Message = 0
	}

	local createElement2 = React.createElement
	local v6 = {
		LayoutOrder = 2,
		Size = UDim2.new(0.78, 0, 0, 0),
		tag = "col align-x-right gap-xsmall auto-y"
	}
	local resourceAttachments2

	if v3 then
		resourceAttachments2 = React.createElement(ChatResourceAttachmentList, {
			alignRight = true,
			LayoutOrder = 1,
			attachments = resourceAttachments,
			testId = "ChatUserMessage.ResourceAttachments"
		})
	end

	local images

	if v2 then
		images = React.createElement(ChatImagePreviewList, {
			alignRight = true,
			LayoutOrder = v3 and 2 or 1,
			images = p.message.images,
			testId = "ChatUserMessage.Images"
		})
	end

	local bubble

	if text ~= "" then
		bubble = React.createElement(CopyableUserMessageBubble, {
			LayoutOrder = v3 and v2 and 3 or 2,
			messageText = text
		})
	end

	v5.Message = createElement2(View, v6, {
		ResourceAttachments = resourceAttachments2,
		Images = images,
		Bubble = bubble
	})
	return createElement(View, v4, v5)
end

return React.memo(ChatUserMessage)
