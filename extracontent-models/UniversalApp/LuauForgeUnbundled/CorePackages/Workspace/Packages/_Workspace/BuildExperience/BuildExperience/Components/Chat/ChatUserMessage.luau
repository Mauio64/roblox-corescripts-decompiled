local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local escapeRichText = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/escapeRichText")
local ChatImagePreviewList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatImagePreviewList")
local ChatResourceAttachmentList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatResourceAttachmentList")
local useTriggerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/InteractionFeedback").useTriggerFeedback

local menu = Foundation.Menu
local text = Foundation.Text
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local useTokens = Foundation.Hooks.useTokens

local v5 = { affordance = stateLayerAffordance.None }

local function useEscapedRichText(p2)
	return React.useMemo(function()
		return escapeRichText(p2)
	end, { p2 })
end

local function UserMessageBubble(props)
	local v6 = useTokens()
	local messageText = props.messageText
	local v7 = React.useMemo(function()
		return escapeRichText(messageText)
	end, { messageText })

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = props.LayoutOrder,
		cornerRadius = UDim.new(0, v6.Size.Size_500),
		onSecondaryActivated = props.onSecondaryActivated,
		stateLayer = 0,
		Text = 0,
		RichText = true,
		tag = "auto-xy padding-medium text-body-medium text-wrap text-align-x-left bg-shift-200 content-emphasis",
		testId = 0
	}
	local v10 = if props.onSecondaryActivated ~= nil then v5 else nil
	v9.stateLayer = v10
	v9.Text = v7

	v9.testId = props.testId
	return createElement(text, v9)
end

local function CopyableUserMessageBubble(p2)
	local v6 = useLocalization({ copyText = LocalizationStrings.CHAT_COPY_TEXT })

	local state, setState = React.useState(false)
	local v7 = useTriggerFeedback()
	local v8 = {
		{ id = "copy-text", icon = iconName.TwoStackedSquares, text = v6.copyText }
	}

	return React.createElement(menu, {
		LayoutOrder = p2.LayoutOrder,
		align = popoverAlign.End,
		isOpen = state,
		items = v8,
		onActivated = function(p3)
			if p3 == "copy-text" then
				default:setClipboardText({
					context = "Build-UserMessage",
					text = p2.messageText
				})
			end

			setState(false)
		end,
		onPressedOutside = function()
			setState(false)
		end,
		side = popoverSide.Bottom,
		size = inputSize.Medium
	}, {
		Bubble = React.createElement(UserMessageBubble, {
			LayoutOrder = 1,
			messageText = p2.messageText,
			onSecondaryActivated = function()
				v7("Default", "SecondaryActivated")
				setState(true)
			end,
			testId = "ChatUserMessage.Bubble"
		})
	})
end

local function ChatUserMessage(p2)
	local text2 = p2.message.text
	local resourceAttachments = p2.message.resourceAttachments or {}
	local v6 = not (p2.message.images == nil) and #p2.message.images > 0
	local v7 = #resourceAttachments > 0

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = p2.LayoutOrder,
		tag = "row gap-small size-full-0 auto-y"
	}

	local v10 = {
		Spacer = React.createElement(view, { LayoutOrder = 1, tag = "fill" }),
		Message = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		LayoutOrder = 2,
		Size = UDim2.new(0.78, 0, 0, 0),
		tag = "col align-x-right gap-xsmall auto-y"
	}

	local v14 = if v7 then React.createElement(ChatResourceAttachmentList, {
		alignRight = true,
		LayoutOrder = 1,
		attachments = resourceAttachments,
		testId = "ChatUserMessage.ResourceAttachments"
	}) else nil

	local v15 = if v6 then React.createElement(ChatImagePreviewList, {
		alignRight = true,
		LayoutOrder = v7 and 2 or 1,
		images = p2.message.images,
		testId = "ChatUserMessage.Images"
	}) else nil

	local v16 = if text2 ~= "" then React.createElement(CopyableUserMessageBubble, {
		LayoutOrder = v7 and v6 and 3 or 2,
		messageText = text2
	}) else nil
	v10.Message = createElement2(view, v12, {
		ResourceAttachments = v14,
		Images = v15,
		Bubble = v16
	})
	return createElement(view, v9, v10)
end

return React.memo(ChatUserMessage)
