local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local FFlagBuildExperienceChatImageAttachments = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatImageAttachments")

local fFlagBuildExperienceChatResourceAttachments = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceChatResourceAttachments
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local escapeRichText = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/escapeRichText")

local v5 = if FFlagBuildExperienceChatImageAttachments then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatImagePreviewList") else nil

local v6 = if fFlagBuildExperienceChatResourceAttachments then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatResourceAttachmentList") else nil

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

local v7 = { affordance = stateLayerAffordance.None }

local function useEscapedRichText(p2)
	return React.useMemo(function()
		return escapeRichText(p2)
	end, { p2 })
end

local function UserMessageBubble(props)
	local v8 = useTokens()
	local messageText = props.messageText
	local v9 = React.useMemo(function()
		return escapeRichText(messageText)
	end, { messageText })

	local createElement = React.createElement
	local v11 = {
		LayoutOrder = props.LayoutOrder,
		cornerRadius = UDim.new(0, v8.Size.Size_500),
		onSecondaryActivated = props.onSecondaryActivated,
		stateLayer = 0,
		Text = 0,
		RichText = true,
		tag = "auto-xy padding-medium text-body-medium text-wrap text-align-x-left bg-shift-200 content-emphasis",
		testId = 0
	}
	local v12 = if props.onSecondaryActivated ~= nil then v7 else nil
	v11.stateLayer = v12
	v11.Text = v9

	v11.testId = props.testId
	return createElement(text, v11)
end

local function CopyableUserMessageBubble(p2)
	local v8 = useLocalization({ copyText = LocalizationStrings.CHAT_COPY_TEXT })

	local state, setState = React.useState(false)
	local v9 = useTriggerFeedback()
	local v10 = {
		{ id = "copy-text", icon = iconName.TwoStackedSquares, text = v8.copyText }
	}

	return React.createElement(menu, {
		LayoutOrder = p2.LayoutOrder,
		align = popoverAlign.End,
		isOpen = state,
		items = v10,
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
				v9("Default", "SecondaryActivated")
				setState(true)
			end,
			testId = "ChatUserMessage.Bubble"
		})
	})
end

local function ChatUserMessage(p2)
	local text2 = p2.message.text
	local resourceAttachments = p2.message.resourceAttachments or {}
	local v8 = FFlagBuildExperienceChatImageAttachments

	if v8 then
		v8 = not (p2.message.images == nil) and #p2.message.images > 0
	end

	local v9 = fFlagBuildExperienceChatResourceAttachments and #resourceAttachments > 0

	local createElement = React.createElement
	local v11 = {
		LayoutOrder = p2.LayoutOrder,
		tag = "row gap-small size-full-0 auto-y"
	}

	local v12 = {
		Spacer = React.createElement(view, { LayoutOrder = 1, tag = "fill" }),
		Message = 0
	}

	local createElement2 = React.createElement
	local v14 = {
		LayoutOrder = 2,
		Size = UDim2.new(0.78, 0, 0, 0),
		tag = "col align-x-right gap-xsmall auto-y"
	}

	local v16 = if v9 then React.createElement(v6, {
		alignRight = true,
		LayoutOrder = 1,
		attachments = resourceAttachments,
		testId = "ChatUserMessage.ResourceAttachments"
	}) else nil

	local v17 = if v8 then React.createElement(v5, {
		alignRight = true,
		LayoutOrder = v9 and 2 or 1,
		images = p2.message.images,
		testId = "ChatUserMessage.Images"
	}) else nil

	local v18 = if text2 ~= "" then React.createElement(CopyableUserMessageBubble, {
		LayoutOrder = v9 and v8 and 3 or 2,
		messageText = text2
	}) else nil
	v12.Message = createElement2(view, v14, {
		ResourceAttachments = v16,
		Images = v17,
		Bubble = v18
	})
	return createElement(view, v11, v12)
end

return React.memo(ChatUserMessage)
